extends Node2D

var map_node
var purchase_panel

var current_wave = 0
var enemies_in_wave = 0
var build_location
var build_tile
var build_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	map_node = get_node("Level1")
	purchase_panel = get_node("Purchase")
	start_next_wave()
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", Callable(self, "build_tower").bind(i.get_name()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#BUDOWA WIEŻ
#kliknięcie w dany tile
func _input(event):
	if Input.is_action_just_pressed("LeftClick"):
		var mouse_position = get_global_mouse_position()
		var current_tile = map_node.get_node("TileMap").local_to_map(mouse_position)
		var tile_position = map_node.get_node("TileMap").map_to_local(current_tile)
		print(map_node.get_node("TileMap").get_cell_source_id(0, current_tile))
		if map_node.get_node("TileMap").get_cell_source_id(0, current_tile) == 1 && build_state == false:
			build_location = tile_position
			build_tile = current_tile
			print(tile_position)
			show_ui(tile_position)
			build_state = true
	else: if Input.is_action_just_pressed("RightClick"):
		hide_ui()

#pokazanie ui
func show_ui(title_position):
	purchase_panel.visible = true
	purchase_panel.set_position(title_position)
	
func hide_ui():
	purchase_panel.visible = false
	build_state = false
	
func build_tower(tower_name):
	var new_tower = load("res://Scenes/Turrets/" + tower_name + ".tscn").instantiate()
	new_tower.set_position(build_location)
	map_node.get_node("Turrets").add_child(new_tower, true)
	map_node.get_node("TileMap").set_cell(0, build_tile, 2, Vector2(2,0))	
	print("build tower triggered ", tower_name)
	hide_ui()

func start_next_wave():
	var wave_data = reterieve_wave_data()
	await(get_tree().create_timer(0.2).timeout)
	spawn_enemies(wave_data)
	
func reterieve_wave_data():
	var wave_data = [["Normal_1", 0.7], ["Normal_1", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		map_node.get_node("Path2D").add_child(new_enemy, true)
		await(get_tree().create_timer(i[1]).timeout)
		
