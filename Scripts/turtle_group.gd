class_name TurtleGroup

## A grouping of turtles

extends Ridable

var turtle_scene: PackedScene = preload("res://Scenes/turtle.tscn")
var num_turtles: int = 0;

@export var spacing:float = 0.1
@export var dive_time: float = 1.0
@export var cooldown: float = 5.0

var _cooldown = 0.0

var turtles: Array[Turtle] = []
var _width: float = 0;

var diving: bool = false
var dove: bool = false

func _init() -> void:
	turtles = []
	num_turtles = (randi() % 2) + 2 # grouping of 2 or 3
	
	for i in range(num_turtles):
		var new_turtle = turtle_scene.instantiate() as Turtle
		turtles.push_back(new_turtle)
		_width += new_turtle.width()
		new_turtle.show()
		add_child(new_turtle)
		#TODO: this could be generalized
		match num_turtles:
			2:
				match i:
					0: new_turtle.position.x = new_turtle.width()/2 + spacing/2
					1: new_turtle.position.x = -(new_turtle.width()/2 + spacing/2)
			3:
				match i:
					0: new_turtle.position.x = new_turtle.width() + spacing
					1: new_turtle.position.x = 0.0
					2: new_turtle.position.x = -new_turtle.width() - spacing
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.scale = Vector3(_width, 1.0, 1.0)
	diving = randi()%6 == 3

func dive():
	if dove:
		return
	dove = true
	for t in turtles:
		t.dive()
		$Area3D/CollisionShape3D.disabled = true
		for c in get_children():
			if c is Frog:
				c.die("SUNK")
		
	await get_tree().create_timer(dive_time).timeout
	for t in turtles:
		t.resurface()
		$Area3D/CollisionShape3D.disabled = false
	dove = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= _delta
		return
	if diving and get_tree() != null:
		if randi()%6 == 1 and !dove:
			dive()
			_cooldown = cooldown

func width() -> float:
	return _width
