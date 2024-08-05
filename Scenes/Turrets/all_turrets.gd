extends Node2D

var type
var category
var projectile_type
var rotation_speed
var enemy_array = []
var enemy
var turret_ready = true
var target_locked = false
var target_locked_tolerance = 0.1

func _ready():
	self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0:
		select_enemy()
		turn(delta)
		if turret_ready and target_locked:
			fire()
	else:
		enemy = null
		target_locked = false
		
func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
	
func turn(delta):
	var turret = get_node("Turret")
	var direction = (enemy.global_position - turret.global_position).normalized()
	var target_rotation = direction.angle()
	var current_rotation = turret.rotation
	var angle_difference = target_rotation - current_rotation
	angle_difference = fmod(angle_difference + PI, 2 * PI) - PI
	var angle_to_rotate = rotation_speed * delta
	if abs(angle_difference) < angle_to_rotate:
		turret.rotation = target_rotation
		if abs(angle_difference) < target_locked_tolerance:
			target_locked = true
	else:
		if angle_difference > 0:
			turret.rotation += angle_to_rotate
		else:
			turret.rotation -= angle_to_rotate
	
func fire():
	turret_ready = false
	if category == "Projectile":
		fire_gun(projectile_type)
	elif category == "Laser":
		fire_laser(projectile_type)
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
	
func fire_laser(projectile_type):
	enemy.on_hit(GameData.tower_data[type]["damage"])
	
func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
