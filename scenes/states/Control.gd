extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	#$test.rect_position = get_viewport().get_mouse_position()
	pass


func _on_Control_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		$test.rect_position = event.position
