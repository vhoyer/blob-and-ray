extends Node2D

@onready var ray_spawner = $ray_spawner as RaySpawner
@onready var points = $points_display as Points

signal end_game

func _on_player_game_over():
	ray_spawner.stop_spawn()
	var score = points.stop_and_return()
	
	end_game.emit(score)
