extends CanvasLayer
class_name DebugOverlay

onready var stats_label: Label = get_node("%StatsLabel")
onready var resolution_label: Label = get_node("%ResolutionLabel")
onready var properties_label: Label = get_node("%PropertiesLabel")
onready var version_label: Label = get_node("%VersionLabel")

var stats_template: String
var resolution_template: String

var _resolution_label_timer: Timer


func show_resolution(resolution: Vector2) -> void:
	resolution_label.text = resolution_template % [resolution.x, resolution.y]
	resolution_label.visible = true
	_resolution_label_timer.start()


func _ready() -> void:
	stats_template = stats_label.text
	resolution_template = resolution_label.text

	resolution_label.visible = false

	_resolution_label_timer = Timer.new()
	_resolution_label_timer.one_shot = true
	_resolution_label_timer.wait_time = 2
	_resolution_label_timer.connect("timeout", self, "_on_resolution_label_timer_timeout")
	add_child(_resolution_label_timer)


func _on_resolution_label_timer_timeout() -> void:
	resolution_label.visible = false
