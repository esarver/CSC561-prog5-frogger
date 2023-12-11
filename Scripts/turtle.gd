class_name Turtle

extends Spawnable

@export var _width = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func width() -> float:
	return _width

func dive():
	#$AnimationPlayer.play("Turtle_Dive")
	position.y = -0.482
	
func resurface():
	#$AnimationPlayer.play("Turtle_Resurface")
	position.y = 0.0
