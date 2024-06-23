extends Node2D

var type
var category
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
		fire_gun()
	elif category == "Laser":
		pass
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	turret_ready = true
	
func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	
func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
