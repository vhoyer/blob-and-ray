extends CharacterBody2D
class_name Player

const SPEED = 500.0
signal game_over

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * SPEED
	move_and_slide()
	
	var sprite = $Sprite2D
	var half_size = sprite.get_rect().size / 2 * sprite.scale
	var screen_size = get_viewport_rect().size
	global_position.x = clamp(global_position.x, half_size.x, screen_size.x - half_size.x)
	global_position.y = clamp(global_position.y, half_size.y, screen_size.y - half_size.y)

func damage():
	game_over.emit()
	pass
