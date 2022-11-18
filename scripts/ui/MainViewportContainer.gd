extends ViewportContainer
class_name MainViewportContainer

var viewport_size: Vector2


func _process(delta: float) -> void:
    #rect_min_size = Vector2.ONE
    pass


func _input(event: InputEvent) -> void:
    if event is InputEventMouse:
        _scale_mouse_event(event)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouse:
        _scale_mouse_event(event)


func _scale_mouse_event(event: InputEventMouse) -> void:
    event.position = event.position * (viewport_size / rect_size)
