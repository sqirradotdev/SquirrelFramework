extends Node

var _current_state: State


# Returns the current State instance
func get_state() -> State:
	return _current_state


# Changes the current state. State paths are hardcoded.
func change_state(state_name: String) -> void:
	var path: String = Util.get_res_path("scenes/states/" + state_name + ".tscn")
	if path.empty():
		push_error("StateManager: Cannot find state with name " + state_name + ".")
		return

	var scene: PackedScene = ResourceLoader.load(path)
	if not scene:
		push_error("StateManager: Cannot find scene with path " + path + ".")
		return

	var node: Node = scene.instance()
	var state: State = node as State
	if not state:
		push_error("StateManager: Node is not a valid State!")
		node.free()
		return

	yield(get_tree(), "idle_frame")

	Global.main_viewport.get_child(0).queue_free()
	Global.main_viewport.add_child(node)

	_current_state = state


func _ready() -> void:
	var current_scene: Node = get_tree().current_scene 
	print("StateManager: Current scene: " + str(current_scene))

	var state: State = current_scene as State
	if state:
		_current_state = state
	else:
		push_warning("StateManager: Current scene is not a valid State!")
