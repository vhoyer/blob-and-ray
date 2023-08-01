extends AudioStreamPlayer
# Heavily based on https://github.com/LegionGames/Conductor-Example/blob/master/Scripts/Conductor.gd
class_name AudioPiece

## bpm of the audio
@export var bpm: int = 120
## how many measures exist in a bar
@export var measures: int = 4


# Tracking the beat and song position
@onready var sec_per_beat = 60.0 / bpm
var song_position = 0.0
var song_position_in_beats = 1
var last_reported_beat = 0
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat_event(position)
signal measure_event(position)

func _process(_delta):
	if !playing: return
	
	song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
	song_position -= AudioServer.get_output_latency()
	song_position_in_beats = int(floor(song_position / sec_per_beat))
	_report_beat()

func _report_beat():
	if last_reported_beat == song_position_in_beats: return
	
	if measure > measures: measure = 1
	
	beat_event.emit(song_position_in_beats)
	measure_event.emit(measure)
	
	last_reported_beat = song_position_in_beats
	measure += 1
