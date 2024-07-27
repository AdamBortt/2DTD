extends Node2D

var map_node
var purchase_panel
var money_value = 100
var health_value = 5
var money_label
var health_label

var current_wave = 0
var enemies_in_wave = 0
var build_location
var build_tile
var build_state = false

var break_state = true

# Called when the node enters the scene tree for the first time.
func _ready():
	map_node = get_node("Level1")
	map_node.connect("lose_hp", Callable(self, "take_damage"))	
	purchase_panel = get_node("Purchase")
	money_label = get_node("UI/LivesMoney/VBoxContainer/Money")
	health_label = get_node("UI/LivesMoney/VBoxContainer/Health")
	health_label.text = str(health_value)
	money_label.text = str(money_value)	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", Callable(self, "build_tower_request").bind(i.get_name()))

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
	
func build_tower_request(tower_name):
	if check_cost(tower_name):
		build_tower(tower_name)
		
func check_cost(tower_name):
	var tower_cost = GameData.tower_data[tower_name]["cost"]
	if tower_cost <= money_value:
		money_value = money_value - tower_cost
		money_label.text = str(money_value)
		return true
	else:
		print("NOT ENOUGH MONEY!")
		return false
	
func build_tower(tower_name):
	var new_tower = load("res://Scenes/Turrets/" + tower_name + ".tscn").instantiate()
	new_tower.set_position(build_location)
	new_tower.type = tower_name
	new_tower.category = GameData.tower_data[tower_name]["category"]
	new_tower.projectile_type = GameData.tower_data[tower_name]["projectile_type"]
	map_node.get_node("Turrets").add_child(new_tower, true)
	map_node.get_node("TileMap").set_cell(0, build_tile, 2, Vector2(2,0))	
	print("build tower triggered ", tower_name)
	hide_ui()

func start_next_wave():
	var wave_data = reterieve_wave_data()
	await(get_tree().create_timer(0.2).timeout)
	spawn_enemies(wave_data)
	
func reterieve_wave_data():
	var wave_data = [["Normal_1", 0.7], ["Normal_1", 0.7], ["Normal_1", 0.7], ["Normal_1", 0.7]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("enemy_destroyed_signal", Callable(self, "enemy_destroyed"))
		map_node.get_node("Path2D").add_child(new_enemy, true)
		await(get_tree().create_timer(i[1]).timeout)
		
func enemy_destroyed(value):
	add_money(value)
	enemies_in_wave = enemies_in_wave - 1
	if enemies_in_wave == 0:
		wave_completed()
		
func add_money(value):
	money_value = money_value + value
	money_label.text = str(money_value)
	print("money added: ", value)
	
func take_damage(damage):
	health_value = health_value - damage
	health_label.text = str(health_value)
	enemies_in_wave = enemies_in_wave - 1
	print("damage taken: ", damage)
	
func wave_completed():
	break_state = true
	get_node("UI/GameControls/PausePlay").set_pressed(false)
	print("wave_destroyed")
