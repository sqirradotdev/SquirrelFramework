extends State
class_name MainMenuState


func _ready() -> void:
    yield(get_tree().create_timer(1.0), "timeout")
    ResourceQueue.queue_resource(Util.get_res_path("assets/textures/dummy0.png"))
    ResourceQueue.connect("done_loading", self, "_on_done_loading")


func _on_done_loading(path: String) -> void:
    if path.ends_with("dummy0.png"):
        randomize()

        var res: StreamTexture = ResourceQueue.get_resource(path)
        for i in 10:
            var sprite: Sprite = Sprite.new()
            sprite.position = Vector2(rand_range(0, 1280), rand_range(0, 720))
            sprite.texture = res
            sprite.scale = Vector2(0.2, 0.2)
            add_child(sprite)

            yield(get_tree().create_timer(0.05), "timeout")
