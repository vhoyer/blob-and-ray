extends Node

@export var trigger_name: String
@export var trigger: bool = false

func _process(_delta):
	if !trigger: return
	Maestrinho.queue_trigger(trigger_name)
	trigger = false
	pass
