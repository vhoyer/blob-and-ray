extends Node2D
class_name Menu

var best_score: int = 0
var last_score: int = 0

@onready var canvas = $CanvasLayer
var loaded_scene;

func _on_button_pressed():
	game_start()

func end_screen(score):
	best_score = max(score, best_score)
	last_score = score
	$CanvasLayer.visible = true
	
	loaded_scene.call_deferred("free")

func _process(_delta):
	game_restart()
	score_update()

func game_start():
	$CanvasLayer.visible = false
	loaded_scene = preload("res://scenes/game.tscn").instantiate()
	loaded_scene.connect("end_game", end_screen)
	add_child(loaded_scene)

func game_restart():
	if (!canvas.visible): return
	if (Input.is_action_just_pressed("start_game")):
		game_start()

func score_update():
	if (last_score == 0): return
	
	$CanvasLayer/VBoxContainer/scores.text = """
	Last Score: {last}
	Best Score: {best}
	""".format({ "best": best_score, "last": last_score })
