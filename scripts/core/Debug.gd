extends Node

const DEBUG_OVERLAY_SCENE = preload("res://scenes/ui/DebugOverlay.tscn")

var debug_overlay: DebugOverlay

var _root: Viewport


func _ready() -> void:
	var node: Node = DEBUG_OVERLAY_SCENE.instance()
	add_child(node)
	debug_overlay = node as DebugOverlay

	_root = get_tree().root
	_root.connect("size_changed", self, "_on_size_changed")

	_on_size_changed()


func _process(delta: float) -> void:
	var fps: float = Engine.get_frames_per_second()
	var mem: int = OS.get_static_memory_usage()
	var mem_peak: int = OS.get_static_memory_peak_usage()

	debug_overlay.stats_label.text = debug_overlay.stats_template % [str(fps), String.humanize_size(mem), String.humanize_size(mem_peak)]
	debug_overlay.version_label.text = Global.get_framework_version_string()


func _on_size_changed() -> void:
	debug_overlay.show_resolution(_root.size)
