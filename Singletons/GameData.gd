extends Node

var tower_data = {
	"T1_basic": {
		"cost": 40,
		"damage": 10,
		"rof": 0.4,
		"rotation_speed": 5,
		"range": 150,
		"category": "Projectile",
		"projectile_type": "T1_projectile",
		"projectile_speed": 300},
	"T1_sniper": {
		"cost": 80,
		"damage": 40,
		"rof": 2,
		"rotation_speed": 2,
		"range": 250,
		"category": "Laser",
		"projectile_type": "T1_laser"}
}

var enemy_data = {
	"normal_1": {
		"speed": 50,
		"hp": 40,
		"size": 9,
		"value": 5,
		"damage": 1}
}
