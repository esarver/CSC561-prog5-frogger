class_name Strip

## A strip is a slice of the level that can spawn entities that traverse the 
## width of the level.

extends Node3D

@export var velocity_range: float = 5.0
@export var velocity: float = 0.0
@export var random: bool = true
@export var width: float = 10.0

## The 1/chance chance that an object will be produced
## The lower the number, the greate the chance something will be produced
@export var chance:int = 200

## An array of the possible things that could be spawned.
@export var spawnables: Array[PackedScene] = []



var objects: Array[Spawnable] = []
var home: float = 0.0 #home == origin
var obj_rotation: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if random:
		while abs(velocity) < min(1.0, velocity_range/2): 
			velocity = randf_range(-velocity_range, velocity_range)

	home = width/2
	if velocity > 0:
		home = -home
	else:
		obj_rotation = 180

var wait_time: float = 1.0
var timer: float = wait_time # to make sure we spawn immediately
func _process(delta: float) -> void:
	for i in range(objects.size() - 1, -1, -1):
		var obj = objects[i]
		obj.position.x += (velocity) * delta
		if abs(obj.position.x) > obj.width() + width/2:
			objects.remove_at(i)
			obj.queue_free()
	timer += delta
	# TODO: Select the wait-time for the next item depending on the length of 
	#       the newly spawned item.
	if timer >= wait_time and randi()%chance == 1:
		timer = 0.0
		wait_time = spawn_new() * 2

## spawns a new random entity from `spawnables` and returns it's width
func spawn_new() -> float:
	var selection = randi() % spawnables.size()
	var new_obj: Spawnable = spawnables[selection].instantiate() as Spawnable
	objects.push_back(new_obj)
	add_child(new_obj)
	new_obj.show()
	if home < 0:
		new_obj.position.x = home - new_obj.width()/2
	else:
		new_obj.position.x = home + new_obj.width()/2
	new_obj.rotation_degrees.y = obj_rotation
	return new_obj.width()
