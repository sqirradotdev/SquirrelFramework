extends Node

var main_viewport: Viewport

var _viewports: CanvasLayer

var _black_bg: ColorRect
var _aspect_ratio_container: AspectRatioContainer
var _main_vc: ViewportContainer

var _root: Viewport


func get_framework_version_string() -> String:
	return "SquirrelFramework v" + ProjectSettings.get("application/config/framework_version")


func get_project_version_string() -> String:
	return ProjectSettings.get("application/config/name") + " v" + ProjectSettings.get("application/config/project_version")


func _ready() -> void:
	print(get_framework_version_string() + "\n")

	_setup_viewport()


func _setup_viewport() -> void:
	_root = get_tree().root

	_viewports = CanvasLayer.new()
	_viewports.name = "Viewports"
	_root.call_deferred("add_child", _viewports)

	_black_bg = ColorRect.new()
	_black_bg.color = Color.black
	_viewports.call_deferred("add_child", _black_bg)
	_black_bg.set_anchors_preset(Control.PRESET_WIDE, true)

	_aspect_ratio_container = AspectRatioContainer.new()
	_aspect_ratio_container.name = "AspectRatioContainer"
	_aspect_ratio_container.ratio = _root.size.x / _root.size.y
	_viewports.call_deferred("add_child", _aspect_ratio_container)
	_aspect_ratio_container.set_anchors_preset(Control.PRESET_WIDE, true)

	_main_vc = MainViewportContainer.new()
	_main_vc.name = "MainViewportContainer"
	_main_vc.stretch = true
	_main_vc.viewport_size = _root.size
	_aspect_ratio_container.call_deferred("add_child", _main_vc)

	main_viewport = Viewport.new()
	main_viewport.name = "MainViewport"
	main_viewport.size = _root.size
	main_viewport.set_size_override(true, _root.size)
	main_viewport.size_override_stretch = true
	_main_vc.call_deferred("add_child", main_viewport)

	var current_scene: Node = get_tree().current_scene
	get_tree().set_deferred("current_scene", _viewports)
	_root.call_deferred("remove_child", current_scene)
	main_viewport.call_deferred("add_child", current_scene)
