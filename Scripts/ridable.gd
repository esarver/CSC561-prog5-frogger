class_name Ridable

extends Spawnable

var hitched: Array[Node3D]
var prev_pos: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func hitch(node: Node3D):
	node.reparent(self)
	node.position.z = 0.0
	
	
func unhitch(node: Node3D):
	for i in range(hitched.size() -1, -1, -1):
		if hitched[i] == node:
			hitched.remove_at(i)
