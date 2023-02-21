extends Node

var version: String = "0.1"


func get_framework_version_string() -> String:
	return "SquirrelFramework v%s by gedehari" % version


func get_project_version_string() -> String:
	return "%s v%s" % [ProjectSettings.get("application/config/name"), ProjectSettings.get("application/config/project_version")]


func _ready() -> void:
	print(get_framework_version_string() + "\n")
