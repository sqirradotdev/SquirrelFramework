extends State
class_name EntryState


func _ready() -> void:
	StateManager.change_state(StateManager.STATE_MAINMENU)
