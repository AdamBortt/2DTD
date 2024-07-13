extends PathFollow2D

var speed = GameData.enemy_data["normal_1"]["speed"]
var hp = GameData.enemy_data["normal_1"]["hp"]
var size = GameData.enemy_data["normal_1"]["size"]
var value = GameData.enemy_data["normal_1"]["value"]
var damage = GameData.enemy_data["normal_1"]["damage"]

signal give_money()

@onready var health_bar = get_node("Healthbar")

func _ready():
	health_bar.set_as_top_level(true)	
	health_bar.set_position(position - Vector2(10, 14))
	health_bar.max_value = hp
	health_bar.value = hp

func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.set_position(position - Vector2(10, 14))
	
func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	emit_signal("give_money", value)
	queue_free()
