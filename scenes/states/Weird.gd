extends TextureRect

var _time: float = 0


func _ready() -> void:
	Debug.add_debug_property("test", self, "rect_rotation", "Weird Rotation")


func _process(delta: float) -> void:
	rect_rotation = sin(_time * 2) * 20
	_time += delta

