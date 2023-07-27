extends Area2D
class_name Ray

signal finished

var index = 0
var axis = 'x'

func start(index, axis):
	$Animator.play("ray")
	self.index = index
	self.axis = axis

func get_rect():
	var sprite = $Sprite2D
	var rect = sprite.get_rect()
	var scale = (sprite as Node2D).scale
	var size = rect.size * scale
	
	return size

func _on_animator_animation_finished(anim_name):
	finished.emit(self, axis, index)


func _on_body_entered(body):
	if not body is Player: pass
	var player = body as Player
	player.damage()
