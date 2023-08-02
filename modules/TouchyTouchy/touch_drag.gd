extends Control

var start: Vector2
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

func _touch_start(event):
	start = event.position
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
	var movement: Vector2 = (event.position - start).normalized()
	
	var deadzone = 0.4
	
	if movement.x > deadzone:
		Input.action_press("right")
		Input.action_release("left")
	elif movement.x < -deadzone:
		Input.action_press("left")
		Input.action_release("right")
	else:
		Input.action_release("right")
		Input.action_release("left")
	
	if movement.y > deadzone:
		Input.action_press("down")
		Input.action_release("up")
	elif movement.y < -deadzone:
		Input.action_press("up")
		Input.action_release("down")
	else:
		Input.action_release("down")
		Input.action_release("up")
	
	pass
