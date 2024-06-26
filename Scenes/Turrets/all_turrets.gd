extends Node2D

var type
var category
var projectile_type
var enemy_array = []
var enemy
var turret_ready = true

func _ready():
	self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		if turret_ready:
			fire()
	else:
		enemy = null
		
func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
func turn():
	get_node("Turret").look_at(enemy.position)
	
func fire():
	turret_ready = false
	if category == "Projectile":
		fire_gun(projectile_type)
	elif category == "Laser":
		pass
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	turret_ready = true
	
func fire_gun(projectile_type):
	get_node("AnimationPlayer").play("Fire")
	var new_bullet = load("res://Scenes/Projectiles/" + projectile_type + ".tscn").instantiate()
	new_bullet.set_position(get_node("Turret/Muzzle").global_position)
	new_bullet.speed = GameData.tower_data[type]["projectile_speed"]
	new_bullet.target = enemy
	new_bullet.turret_name = type
	get_parent().add_child(new_bullet, true)
	
func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
