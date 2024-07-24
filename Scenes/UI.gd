extends CanvasLayer


func _on_pause_play_pressed():
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().break_state == true:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
		get_parent().break_state = false
	else:
		get_tree().paused = true


func _on_speed_up_pressed():
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
