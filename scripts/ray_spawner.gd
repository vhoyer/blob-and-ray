extends Node2D
class_name RaySpawner

@export var ray_scene: PackedScene
var axis_dict = { 'x': [], 'y': [] }

@onready var timer = $Timer

func stop_spawn():
	timer.stop()

func _ready():
	spawn_ray()

func inverse_axis(axis):
	return 'x' if axis == 'y' else 'y'

func _on_timer_timeout():
	timer.wait_time = max(0.5, timer.wait_time - 0.5)
	spawn_ray()

func spawn_ray():
	var ray = ray_scene.instantiate() as Ray
	
	var ray_size = ray.get_rect()
	var screen = get_viewport_rect()
	
	# the screen is square, so any axis is fine
	# the ray will always be positioned vertically, so only the x matters
	var max_index = screen.size.x / ray_size.x
	var step = screen.size.x / max_index
	
	var spawn = get_available_index(max_index)
	
	var axis_offset = 0 if spawn.axis == 'x' else 1
	ray.global_position[spawn.axis] = step * (spawn.index + axis_offset)
	
	if (spawn.axis == 'y'):
		ray.global_rotation_degrees = -90.0
	
	ray.connect("finished", ray_end)
	ray.start(spawn.index, spawn.axis)
	axis_dict[spawn.axis].append(spawn.index)
	
	add_child(ray)
	# make old children appear on top (not layering the flash part of the animation)
	move_child(ray, 0)
	

func get_available_index(max_index):
	var candidates = range(0, max_index)
	candidates.shuffle()
	
	var axis_list = ['x', 'y']
	axis_list.shuffle()
	
	for axis in axis_list:
		for index in candidates:
			if (!axis_dict[axis].has(index)):
				return SpawnLocation.new(index, axis)
	
	push_error("fuck, no index avaiable")
	return

func ray_end(ray, axis, index):
	axis_dict[axis].erase(index)
	remove_child(ray)

class SpawnLocation:
	var index: int;
	var axis: String;
	func _init(indexP, axisP):
		self.index = indexP
		self.axis = axisP
