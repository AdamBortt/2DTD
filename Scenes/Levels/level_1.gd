extends Node2D

var scaled_normal_hp = GameData.enemy_data["normal_1"]["hp"]
var scaled_normal_number
signal lose_hp()

func wave_setup(wave_number):
	var wave_data = []
	match wave_number:
		1:
			scaled_normal_hp = 40
			scaled_normal_number = 7
		2:
			scaled_normal_hp = 60
			scaled_normal_number = 10
		3:
			scaled_normal_hp = 70
			scaled_normal_number = 11
		4:
			scaled_normal_hp = 100
			scaled_normal_number = 12
		5:
			scaled_normal_hp = 140
			scaled_normal_number = 15
		_:
			scaled_normal_hp = 140
			scaled_normal_number = 15
			
	GameData.enemy_data["normal_1"]["hp"] = scaled_normal_hp
	for i in range(scaled_normal_number):
		wave_data.append(["Normal_1", 0.7])
	return wave_data
	
func _on_base_body_entered(body):
	if body is CharacterBody2D:
		var damage = body.get_parent().damage
		emit_signal("lose_hp", damage)
		body.get_parent().queue_free()
