extends Control

@onready var sprite = $range_overlay

func _ready():
	sprite.visible = false

func _on_t_1_basic_mouse_entered():
	var range_texture = sprite
	var scaling = GameData.tower_data["T1_basic"]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	range_texture.visible = true

func _on_t_1_basic_mouse_exited():
	sprite.visible = false

func _on_t_1_sniper_mouse_entered():
	var range_texture = sprite
	var scaling = GameData.tower_data["T1_sniper"]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	range_texture.visible = true

func _on_t_1_sniper_mouse_exited():
	sprite.visible = false
