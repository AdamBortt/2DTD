extends Node

func _ready():
	get_node("MainMenu/MarginContainer/VBoxContainer/NewGame").pressed.connect(on_new_game_pressed)
	get_node("MainMenu/MarginContainer/VBoxContainer/Quit").pressed.connect(on_quit_pressed)
	
	
func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/game_scene.tscn").instantiate()
	add_child(game_scene)
	pass
	
func on_quit_pressed():
	get_tree().quit()
	
