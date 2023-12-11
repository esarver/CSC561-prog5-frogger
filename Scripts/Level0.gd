class_name Level0
extends Ridable

var player1: Frog
var player2: Frog
var num_players: int = 1
var roads: Array[Road]

var player1_spawn: Vector3 = Vector3(0,0,0)
var player2_spawn: Vector3 = Vector3(0,0,0)

var return_to_mm = false

var ui: UI

var player_scene:PackedScene = preload("res://Scenes/frog.tscn")
var MM:PackedScene = load("res://Levels/Menu.tscn")

@export var min_x: float = -5.0
@export var max_x: float = 5
@export var min_z: float = -13
@export var max_z: float = 0.0

var lights_out_light
var lights_out_light_preload: PackedScene = preload("res://Scenes/lights_out_light.tscn")
var lights_off: bool = false


func lights_out():
	lights_off = true
	lights_out_light = lights_out_light_preload.instantiate()
	$DirectionalLight3D.hide()
	player1.add_child(lights_out_light)
	lights_out_light.show()
	$Camera3D.environment = load("res://Shaders/LightsOut.tres")

func lights_on():
	lights_off = false
	$DirectionalLight3D.show()
	player1.remove_child(lights_out_light)
	lights_out_light.hide()
	$Camera3D.environment = load("res://Shaders/DefaultEnvironment.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui = $UI
	roads = [$Road, $Road2, $Road3, $Road4, $Road5, $Road6]
	if get_node_or_null("Player1") == null:
		num_players = 0
		return
	else:
		player1 = $Player1 as Frog
		num_players = 1
	player1.connect("player_death", on_player1_death)
	player1.connect("player_home", on_player1_home)
	player1.connect("player_game_over", on_player1_gameover)
	if get_node_or_null("Player2") != null:
		player1_spawn.x = min_x/2
		player2_spawn.x = max_x/2
		player2 = $Player2
		player2.position = player2_spawn
		player1.position = player1_spawn
		ui.show_player2(true)
		num_players = 2
		player2.connect("player_death", on_player2_death)
		player2.connect("player_home", on_player2_home)
		player2.connect("player_game_over", on_player2_gameover)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if return_to_mm:
		if Input.is_anything_pressed():
			to_main_menu()
		return

	if Input.is_action_just_released("lights_out"):
		if lights_off:
			lights_on()
		else:
			lights_out()
	if Input.is_action_just_released("return_to_main_menu"):
		to_main_menu()

	if num_players == 0:
		return

	if player1 != null:
		check_bounds(player1)
		update_p1_score()
	if player2 != null:
		check_bounds(player2)
		update_p2_score()
		
	if num_players == 1:
		if player1 != null and player1.homes == 5:
			on_single_player_win()
			
	elif num_players == 2:
		if player1.homes + player2.homes == 5:
			if player1.homes > player2.homes:
				on_p1_win()
			else:
				on_p2_win()

func update_p1_score():
	ui.player1_score(player1.score)
	
func update_p2_score():
	ui.player2_score(player2.score)

func check_bounds(player: Frog):
	if player.global_position.x < min_x:
		player.die("OUT OF BOUNDS")
		player.global_position.x = min_x
	if player.global_position.x > max_x:
		player.die("OUT OF BOUNDS")
		player.global_position.x = max_x
	if player.global_position.z < min_z:
		player.global_position.z = min_z
	if player.global_position.z > max_z:
		player.global_position.z = max_z 

func new_player1():
	if player1 == null or player1.lives <= 0:
		return
	var new_player = player_scene.instantiate() as Frog
	#TODO: Figure out how to handle null case, 
	#		or kill the frog if the Ridable goes out of bounds
	# 		or make Ridables work better
	new_player.score = player1.score
	new_player.lives = player1.lives
	new_player.homes = player1.homes
	if lights_off:
		player1.remove_child(lights_out_light)
		lights_out_light = lights_out_light_preload.instantiate()
		new_player.add_child(lights_out_light)
		lights_out_light.show()
	add_child(new_player)
	new_player.show()
	new_player.position = player1_spawn
	player1 = new_player
	player1.connect("player_death", on_player1_death)
	player1.connect("player_home", on_player1_home)
	player1.connect("player_game_over", on_player1_gameover)
	player1.immobile = true
	await get_tree().create_timer(1).timeout
	player1.immobile = false
	

func on_player1_death():
	ui.player1_lives(player1.lives)
	new_player1()

func on_player1_gameover():
	if num_players == 1:
		ui.single_player_game_over(true)
	elif num_players == 2:
		ui.two_player_win(2)
	await get_tree().create_timer(2).timeout
	ui.show_return_to_mm()
	return_to_mm = true

func on_player1_home():
	new_player1()

func to_main_menu():
	var mm: Node3D = MM.instantiate()
	get_tree().root.add_child(mm)
	mm.show()
	hide()
	get_tree().root.remove_child(self.get_parent())
	queue_free()
	
func on_player2_gameover():
	ui.two_player_win(1)
	await get_tree().create_timer(2).timeout
	ui.show_return_to_mm()
	return_to_mm = true

func on_player2_death():
	ui.player2_lives(player2.lives)
	new_player2()

func on_player2_home():
	new_player2()
	
func new_player2():
	if player2 == null or player2.lives <= 0:
		return
	var new_player = player_scene.instantiate() as Frog
	#TODO: Figure out how to handle null case, 
	#		or kill the frog if the Ridable goes out of bounds
	# 		or make Ridables work better
	new_player.score = player2.score
	new_player.lives = player2.lives
	new_player.homes = player2.homes
	add_child(new_player)
	new_player.show()
	new_player.position = player2_spawn
	player2 = new_player
	player2.set_p2_controls()
	player2.connect("player_death", on_player2_death)
	player2.connect("player_home", on_player2_home)
	player2.connect("player_game_over", on_player2_gameover)
	player2.immobile = true
	await get_tree().create_timer(1).timeout
	player2.immobile = false

func on_single_player_win():
	ui.single_player_win(true)
	player1.immobile = true
	await get_tree().create_timer(2).timeout
	ui.show_return_to_mm()
	return_to_mm = true
	
func on_p1_win():
	player1.immobile = true
	player2.immobile = true
	ui.two_player_win(1)
	await get_tree().create_timer(2).timeout
	ui.show_return_to_mm()
	return_to_mm = true
	
func on_p2_win():
	player1.immobile = true
	player2.immobile = true
	ui.two_player_win(2)
	await get_tree().create_timer(2).timeout
	ui.show_return_to_mm()
	return_to_mm = true
