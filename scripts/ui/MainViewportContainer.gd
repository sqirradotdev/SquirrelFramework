extends ViewportContainer
class_name MainViewportContainer

var viewport_size: Vector2


func _input(event: InputEvent) -> void:
    if event is InputEventMouse:
        _scale_mouse_event(event)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouse:
        _scale_mouse_event(event)


func _scale_mouse_event(event: InputEventMouse) -> void:
    event.position -= rect_global_position
    event.position = event.position * (viewport_size / rect_size)
    event.position += rect_global_position
