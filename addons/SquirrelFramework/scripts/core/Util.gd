extends Node


func get_res_path(path: String) -> String:
	var res_path: String = "res://" + path
	if ResourceLoader.exists(res_path):
		return res_path

	res_path = "res://addons/SquirrelFramework/" + path
	if ResourceLoader.exists(res_path):
		return res_path

	return ""
