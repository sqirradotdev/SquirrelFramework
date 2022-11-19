extends TextureRect


func _ready() -> void:
	Debug.add_debug_property("test", self, "rect_rotation", "Weird Rotation")


func _process(delta: float) -> void:
	rect_rotation += delta * 90

