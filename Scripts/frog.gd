class_name Frog

extends Node3D
var _collider: Area3D

@export var death_mat: StandardMaterial3D = StandardMaterial3D.new()
@export var lives: int = 7
@export var score: int = 0
@export var color: Color

var controls: Dictionary = {
	"up": "p1_up",
	"down": "p1_down",
	"left": "p1_left",
	"right": "p1_right",
}

var immobile: bool = false

var homes: int = 0

var _orig_parent: Node3D
var _moving: bool = false
var riding: bool = false

signal player_death()
signal player_home()
signal player_game_over()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_collider = $Area3D as Area3D
	_orig_parent = get_parent()

var _timer: float = 0.7
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if immobile: return
	var _move
	_timer -= _delta
	if Input.is_action_just_pressed(controls.get("up")):
		$JumpSound.play()
		reparent(_orig_parent)
		riding = false
		score += 10
		rotation_degrees = Vector3(0, 0, 0)
		_moving = true
		_move = create_tween()
		_move.tween_property(self, "position:z", position.z - 1, 0.1)
		_move.tween_callback(func(): _moving = false)
		$Model.jump()
	if Input.is_action_just_pressed(controls.get("down")):
		$JumpSound.play()
		reparent(_orig_parent)
		riding = false
		rotation_degrees = Vector3(0, 180, 0)
		_moving = true
		_move = create_tween()
		_move.tween_property(self, "position:z", position.z + 1, 0.1)
		_move.tween_callback(func(): _moving = false)
		$Model.jump()
	if Input.is_action_just_pressed(controls.get("left")):
		$JumpSound.play()
		reparent(_orig_parent)
		riding = false
		rotation_degrees = Vector3(0, 90, 0)
		_moving = true
		_move = create_tween()
		_move.tween_property(self, "position:x", position.x - 1, 0.1)
		_move.tween_callback(func(): _moving = false)
		$Model.jump()
	if Input.is_action_just_pressed(controls.get("right")):
		$JumpSound.play()
		reparent(_orig_parent)
		riding = false
		rotation_degrees = Vector3(0, 270, 0)
		_moving = true
		_move = create_tween()
		_move.tween_property(self, "position:x", position.x + 1, 0.1)
		_move.tween_callback(func(): _moving = false)
		$Model.jump()
	#move.tween_property(self, "position", new_pos, 0.875)
	if !_moving:
		struck()

func die(_reason: String):
	immobile = true
	$Model/AnimationPlayer.play("Frog_Death")
	lives -= 1
	emit_signal("player_death")
	if lives <= 0:
		emit_signal("player_game_over")
	for c in player_death.get_connections():
		player_death.disconnect(c["callable"])
	for c in player_home.get_connections():
		player_home.disconnect(c["callable"])
	for c in player_game_over.get_connections():
		player_game_over.disconnect(c["callable"])

func struck():
	var in_water: bool = false
	var overlapping = _collider.get_overlapping_areas()
	for o in overlapping:
		var area_parent = o.get_parent()
		if area_parent is Home:
			reparent(area_parent)
			position = Vector3(0,0,0)
			immobile = true
			homes += 1
			print("Homes: " + str(homes))
			score += 50
			o.queue_free()
			emit_signal("player_home")
		if area_parent is NotHome:
			die("NOT HOME")
		if area_parent is Car:
			die("STRUCK BY VEHICLE")
			return
		if area_parent is Ridable and area_parent != get_parent():
			area_parent.hitch(self)
			riding = true
		if area_parent is Water:
			in_water = true
	if in_water and !riding:
		die("DROWNED")

func exited(area: Area3D):
	var possible = $Area3D.get_overlapping_areas()
	print("old: " + str(area.get_parent()) + "possible: " + str(possible))
	var new_parent = _orig_parent
	for p in possible:
		if p is Ridable and p != area:
			new_parent = p.get_parent()
	print(new_parent)
	new_parent.hitch(self)

func collider() -> Area3D:
	return self._collider
	
func set_p2_controls():
	controls = {
		"up": "p2_up",
		"down": "p2_down",
		"left": "p2_left",
		"right": "p2_right",
	}
