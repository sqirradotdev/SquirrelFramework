extends Node

var overlay_level: int = 0 setget _set_overlay_level

var _debug_overlay: DebugOverlay

var _debug_properties: Dictionary = {}
var _root: Viewport

var _vram_peak: int = 0


func toggle_debug_overlay() -> void:
	if overlay_level >= 2:
		overlay_level = 0
	else:
		overlay_level += 1

	_set_overlay_level(overlay_level)


func add_debug_property(key: String, object: Object, prop: String, label: String) -> void:
	_debug_properties[key] = {
		"object": object,
		"property": prop,
		"label": label
	}


func remove_debug_property(key: String) -> void:
	_debug_properties.erase(key)


func _ready() -> void:
	var node: Node = ResourceLoader.load(Util.get_res_path("scenes/ui/DebugOverlay.tscn")).instance()
	add_child(node)
	_debug_overlay = node as DebugOverlay

	_root = get_tree().root
	_root.connect("size_changed", self, "_on_size_changed")

	_debug_overlay.version_label.text = "%s\n%s" % [Global.get_project_version_string(), Global.get_framework_version_string()]

	if OS.is_debug_build():
		_set_overlay_level(2)

	_on_size_changed()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		toggle_debug_overlay()

	if _debug_overlay.visible:
		var fps: float = Engine.get_frames_per_second()
		var mem: int = OS.get_static_memory_usage()
		var mem_peak: int = OS.get_static_memory_peak_usage()

		var vram: int = VisualServer.get_render_info(VisualServer.INFO_VIDEO_MEM_USED)
		if vram > _vram_peak:
			_vram_peak = vram

		_debug_overlay.stats_label.text = _debug_overlay.stats_template % [ \
			str(fps), \
			String.humanize_size(mem), String.humanize_size(mem_peak), \
			String.humanize_size(vram), String.humanize_size(_vram_peak) \
		]

		_update_debug_properties()


func _update_debug_properties() -> void:
	if _debug_properties.empty():
		_debug_overlay.properties_label.text = "No debug properties."
		return

	_debug_overlay.properties_label.text = ""

	for key in _debug_properties.keys():
		var dict: Dictionary = _debug_properties[key]
		if is_instance_valid(dict["object"]):
			var object: Object = dict["object"]
			var prop = object.get(dict["property"])
			_debug_overlay.properties_label.text += dict["label"] + ": " + ("null" if prop == null else str(prop))
		else:
			remove_debug_property(key)


func _set_overlay_level(value: int) -> void:
	overlay_level = value
	match overlay_level:
		0:
			_debug_overlay.visible = false
		1:
			_debug_overlay.visible = true
			_debug_overlay.stats_label.visible = true
			_debug_overlay.properties_label.visible = false
			_debug_overlay.version_label.visible = true
		2:
			_debug_overlay.visible = true
			_debug_overlay.stats_label.visible = true
			_debug_overlay.properties_label.visible = true
			_debug_overlay.version_label.visible = true


func _on_size_changed() -> void:
	_debug_overlay.show_resolution(_root.size)
