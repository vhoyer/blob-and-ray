extends Control

var start: Vector2
var end: Vector2
var deadzone_radius: int = 20
## useful only for touch emulation
var is_dragging: bool

func _ready():
	_touch_end()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if (event.pressed):
			_touch_start(event)
		else:
			_touch_end()
	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		_drag(event)
	queue_redraw()

func _touch_start(event):
	start = event.position
	end = start
	is_dragging = true

func _touch_end():
	start = Vector2.ZERO
	is_dragging = false
	Input.action_release("down")
	Input.action_release("up")
	Input.action_release("right")
	Input.action_release("left")

func _drag(event):
	if (!is_dragging): return
	end = event.position
	
	var movement: Vector2 = (end - start)
	
	if movement.length() < deadzone_radius:
		# prevent movement if the diference in distance between the two touches are very small
		Input.action_release("right")
		Input.action_release("left")
		Input.action_release("down")
		Input.action_release("up")
		return
		
	var direction = movement.normalized()
	var sensibility = 0.4
	
	if direction.x > sensibility:
		Input.action_press("right")
		Input.action_release("left")
	elif direction.x < -sensibility:
		Input.action_press("left")
		Input.action_release("right")
	else:
		Input.action_release("right")
		Input.action_release("left")
	
	if direction.y > sensibility:
		Input.action_press("down")
		Input.action_release("up")
	elif direction.y < -sensibility:
		Input.action_press("up")
		Input.action_release("down")
	else:
		Input.action_release("down")
		Input.action_release("up")
	
	pass

func _draw():
	if (!is_dragging): return
	var color = Color("white")
	var width = 0.5
	
	var end_capped = start + start.direction_to(end) * deadzone_radius * 2
	var end_draw = end if end.distance_to(start) < end_capped.distance_to(start) else end_capped
	
	draw_circle(start, 2, color)
	draw_circle(end_draw, 4, color)
	draw_line(start, end_draw, color, width, true)
	draw_arc(start, deadzone_radius, 0, 2*PI, 64, color, width, true)
