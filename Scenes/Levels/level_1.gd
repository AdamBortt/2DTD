extends Node2D

signal lose_hp()

func _on_base_body_entered(body):
	if body is CharacterBody2D:
		var damage = body.get_parent().damage
		emit_signal("lose_hp", damage)
		body.get_parent().queue_free()
