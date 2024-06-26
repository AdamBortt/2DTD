extends Node2D

var speed
var target
var turret_name
		
func _process(delta):
	if target && target.is_inside_tree():
		var direction = (target.position - position).normalized()
		position += direction * speed * delta
		if position.distance_to(target.position) < target.size:
			target.on_hit(GameData.tower_data[turret_name]["damage"])
			queue_free()
	else:
		queue_free()
