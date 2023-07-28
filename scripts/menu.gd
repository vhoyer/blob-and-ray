extends Node2D
class_name Menu

var best_score: int = 0
var last_score: int = 0

func _on_button_pressed():
	$CanvasLayer.visible = false
	var scene = preload("res://scenes/game.tscn").instantiate()
	add_child(scene)

func end_screen(score):
	best_score = max(score, best_score)
	last_score = score
	$CanvasLayer.visible = true

func _process(delta):
	if (last_score == 0): pass
	
	$CanvasLayer/VBoxContainer/scores.text = """
	Last Score: {last}
	Best Score: {best}
	""".format({ "best": best_score, "last": last_score })
