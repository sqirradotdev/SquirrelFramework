extends Node

const STATE_ENTRY_PATH: String = "res://scenes/states/EntryState.tscn"
const MAINMENU_ENTRY_PATH: String = "res://scenes/states/EntryState.tscn"

enum {
	STATE_ENTRY,
	STATE_MAINMENU
}

var _current_state: State


# Returns the current State instance
func get_state() -> State:
	return _current_state


# Changes the current state. State paths are hardcoded.
func change_state(id: int) -> void:
	var path: String
	match id:
		STATE_ENTRY:
			path = "res://scenes/states/EntryState.tscn"
		STATE_MAINMENU:
			path = "res://scenes/states/MainMenuState.tscn"
		_ :
			push_error("Invalid State id " + str(id) + ". State change aborted.")
			return

	var scene: PackedScene = ResourceLoader.load(path)
	if not scene:
		push_error("Cannot find scene with path " + path + ". State change aborted.")
		return

	var node: Node = scene.instance()
	var state: State = node as State
	if not state:
		push_error("Node is not a valid State!")
		node.free()
		return

	yield(get_tree(), "idle_frame")

	Global.main_viewport.get_child(0).queue_free()
	Global.main_viewport.add_child(node)

	_current_state = state


func _ready() -> void:
	var state: State = get_tree().current_scene as State
	if state:
		_current_state = state
	else:
		push_warning("Current scene is not a valid State!")
