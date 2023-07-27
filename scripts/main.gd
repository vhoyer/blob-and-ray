extends Node2D

@onready var ray_spawner = $ray_spawner as RaySpawner
@onready var points = $points_display as Points

func _on_player_game_over():
	ray_spawner.stop_spawn()
	var score = points.stop_and_return()
	
	var menu = get_parent() as Menu
	menu.end_screen(score)
	
	call_deferred("free")
