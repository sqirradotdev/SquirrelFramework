# Modified from: https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html

extends Node
signal done_loading(path)

var _thread: Thread
var _mutex: Mutex
var _semaphore: Semaphore
var _thread_should_exit: bool = false

var _path_queue: Array = []
var _loader_queue: Array = []
var _pending: Dictionary = {}


func queue_resource(path: String, put_in_front: bool = false) -> void:
	_lock("queue_resource")
	_path_queue.push_back({
		"path": path,
		"put_in_front": put_in_front
	})
	_post("queue_resource")
	_unlock("queue_resource")


func cancel_resource(path: String) -> void:
	_lock("queue_resource")
	if path in _pending:
		if _pending[path] is ResourceInteractiveLoader:
			_loader_queue.erase(_pending[path])
		_pending.erase(path)
		_unlock("queue_resource")


func get_resource(path: String) -> Resource:
	_lock("get_resource")
	if path in _pending:
		if _pending[path] is ResourceInteractiveLoader:
			var loader: ResourceInteractiveLoader = _pending[path]

			if loader != _loader_queue[0]:
				var pos: int = _loader_queue.find(loader)
				_loader_queue.remove(pos)
				_loader_queue.insert(0, loader)

			var res: Resource = _wait_for_resource(loader, path)
			_pending.erase(path)
			_unlock("get_resource")
			return res
		else:
			var res: Resource = _pending[path]
			_pending.erase(path)
			_unlock("get_resource")
			return res
	else:
		_unlock("get_resource")
		return ResourceLoader.load(path)


func is_ready(path: String) -> bool:
	var ret: bool
	_lock("is_ready")
	if path in _pending:
		ret = !(_pending[path] is ResourceInteractiveLoader)
	else:
		ret = false
	_unlock("is_ready")
	return ret


func get_progress(path: String) -> float:
	_lock("get_progress")
	var ret: float = -1.0
	if path in _pending:
		if _pending[path] is ResourceInteractiveLoader:
			var loader: ResourceInteractiveLoader = _pending[path]
			ret = float(loader.get_stage()) / float(loader.get_stage_count())
		else:
			ret = 1.0
	_unlock("get_progress")
	return ret


func get_queue_count() -> int:
	_lock("get_queue_count")
	var ret: int = _loader_queue.size()
	_unlock("get_queue_count")

	return ret


func _ready() -> void:
	_mutex = Mutex.new()
	_thread = Thread.new()
	_semaphore = Semaphore.new()
	_thread.start(self, "_thread_func", 0)


func _exit_tree() -> void:
	_mutex.lock()
	_thread_should_exit = true
	_mutex.unlock()

	_semaphore.post()

	_thread.wait_to_finish()


func _lock(caller: String) -> void:
	#print("ResourceQueue: mut lock " + caller)
	_mutex.lock()


func _unlock(caller: String) -> void:
	#print("ResourceQueue: mut unlock " + caller)
	_mutex.unlock()


func _post(caller: String) -> void:
	#print("ResourceQueue: sem post " + caller)
	_semaphore.post()


func _wait(caller: String) -> void:
	#print("ResourceQueue: sem wait " + caller)
	_semaphore.wait()


func _thread_func(args) -> void:
	while true:
		_mutex.lock()
		var should_exit = _thread_should_exit
		_mutex.unlock()

		if should_exit:
			break

		_thread_update_queue()
		_thread_load_resources()


func _thread_update_queue() -> void:
	_wait("_thread_update_queue")
	_lock("_thread_update_queue")

	while _path_queue.size() > 0:
		var dict: Dictionary = _path_queue[0]
		if dict["path"] in _pending:
			break
		elif ResourceLoader.has_cached(dict["path"]):
			var res: Resource = ResourceLoader.load(dict["path"])
			_pending[dict["path"]] = res
			break
		else:
			_unlock("_thread_update_queue")
			var loader: ResourceInteractiveLoader = ResourceLoader.load_interactive(dict["path"])
			loader.set_meta("path", dict["path"])
			_lock("_thread_update_queue")
			if dict["put_in_front"]:
				_loader_queue.insert(0, loader)
			else:
				_loader_queue.push_back(loader)
			_pending[dict["path"]] = loader
			_path_queue.pop_front()
			print("ResourceQueue: queued " + dict["path"])

	_unlock("_thread_update_queue")


func _thread_load_resources() -> void:
	_lock("_thread_load_resources")

	while _loader_queue.size() > 0:
		var loader: ResourceInteractiveLoader = _loader_queue[0]
		_unlock("_thread_load_resources")
		var err: int = loader.poll()
		_lock("_thread_load_resources")
		if err == ERR_FILE_EOF or err != OK:
			var path: String = loader.get_meta("path")
			if path in _pending:
				_pending[path] = loader.get_resource()
			_loader_queue.erase(loader)
			emit_signal("done_loading", path)
			#call_deferred("emit_signal", "done_loading", path)
			print("ResourceQueue: loaded " + path)

	_unlock("_thread_load_resources")


func _wait_for_resource(loader: ResourceInteractiveLoader, path: String) -> Resource:
	_unlock("_wait_for_resource")
	while true:
		OS.delay_usec(16000)
		_lock("_wait_for_resource")
		if _loader_queue.size() == 0 or _loader_queue[0] != loader:
			return _pending[path]
		_unlock("_wait_for_resource")

	return null
