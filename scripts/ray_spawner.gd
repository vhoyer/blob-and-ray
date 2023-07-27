extends Node2D
class_name RaySpawner

@export var ray_scene: PackedScene
var axis_dict = { 'x': [], 'y': [] }

func stop_spawn():
	$Timer.stop()

func _ready():
	_on_timer_timeout()

func _on_timer_timeout():
	var timer = $Timer
	timer.wait_time = max(0.5, timer.wait_time - 0.5)
	
	var ray = ray_scene.instantiate() as Ray
	var is_vertical = randf() > 0.5
	var axis = 'x' if is_vertical else 'y'
	var axis_offset = 0 if axis == 'x' else 1
	
	var ray_size = ray.get_rect()
	var screen = get_viewport_rect()
	
	var max = screen.size[axis] / ray_size.x
	var step = screen.size[axis] / max
	var index = get_available_index(axis, max)
	ray.global_position[axis] = step * (index + axis_offset)
	
	if (axis == 'y'):
		ray.global_rotation_degrees = -90.0
		pass
	
	ray.connect("finished", ray_end)
	ray.start(index, axis)
	axis_dict[axis].append(index)
	
	add_child(ray)

func get_available_index(axis, max):
	var candidates = range(0, max)
	candidates.shuffle()
	
	for i in candidates:
		if (axis_dict[axis].has(i)): continue
		return i
	return -1;

func ray_end(ray, axis, index):
	axis_dict[axis].erase(index)
	remove_child(ray)
