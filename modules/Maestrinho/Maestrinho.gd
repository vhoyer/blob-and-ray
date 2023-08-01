extends Node

var loop: AudioPiece

var trigger_queue: Array[String]

func play_loop(name):
	var lib = $loop
	loop = lib.get_node(name) as AudioPiece
	loop.play()
	loop.connect("finished", _repeat_loop)
	loop.connect("beat_event", _flush_trigger_queue)
	pass

func _repeat_loop():
	loop.play()

## Queue a trigger audio to be played in the next beat
func queue_trigger(name):
	trigger_queue.append(name)
	pass

func _flush_trigger_queue(_beat):
	while trigger_queue.size() > 0:
		var name = trigger_queue.pop_at(0)
		_play_trigger(name)
	pass

func _play_trigger(name):
	var lib = $trigger
	var trigger = lib.get_node(name)
	var offset = AudioServer.get_time_since_last_mix() + AudioServer.get_output_latency()
	trigger.play(offset)
	pass
