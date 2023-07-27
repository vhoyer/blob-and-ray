extends CanvasLayer
class_name Points

var points = 0

func _process(delta):
	$Label.text = str(points)

func _on_timer_timeout():
	points += 1

func stop_and_return():
	$Timer.stop()
	return points
