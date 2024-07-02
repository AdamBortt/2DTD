extends Area2D

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.get_parent().queue_free()
		print("-1 hp")
