extends Node

var game_viewport: Viewport
var game_layer: CanvasLayer

var black_bg: ColorRect
var aspect_ratio_container: AspectRatioContainer
var main_vc: ViewportContainer

var root: Viewport

var initialized: bool = false


func _ready() -> void:
	if initialized:
		return

	root = get_tree().root

	var game_size: Vector2 = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))

	game_layer = CanvasLayer.new()
	game_layer.name = "GameLayer"
	root.call_deferred("add_child", game_layer)

	black_bg = ColorRect.new()
	black_bg.name = "BlackBG"
	black_bg.color = Color.black
	game_layer.call_deferred("add_child", black_bg)
	black_bg.set_anchors_preset(Control.PRESET_WIDE, true)

	aspect_ratio_container = AspectRatioContainer.new()
	aspect_ratio_container.name = "AspectRatioContainer"
	aspect_ratio_container.ratio = game_size.x / game_size.y
	game_layer.call_deferred("add_child", aspect_ratio_container)
	aspect_ratio_container.set_anchors_preset(Control.PRESET_WIDE, true)

	main_vc = MainViewportContainer.new()
	main_vc.name = "MainVC"
	main_vc.stretch = true
	main_vc.viewport_size = game_size
	aspect_ratio_container.call_deferred("add_child", main_vc)

	game_viewport = Viewport.new()
	game_viewport.name = "GameViewport"
	game_viewport.size = game_size
	game_viewport.set_size_override(true, game_size)
	game_viewport.size_override_stretch = true
	main_vc.call_deferred("add_child", game_viewport)

	var current_scene: Node = get_tree().current_scene
	get_tree().set_deferred("current_scene", game_layer)
	root.call_deferred("remove_child", current_scene)
	game_viewport.call_deferred("add_child", current_scene)

	initialized = true
