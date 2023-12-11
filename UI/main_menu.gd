class_name MainMenu
extends Control

var one_player_button: Button
var two_player_button: Button
var keymap: Button
var credits: Button

var level: PackedScene = preload("res://Levels/Level0.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	one_player_button = $TitleContainer/ModeSelection/OnePlayer
	two_player_button = $TitleContainer/ModeSelection/TwoPlayer
	keymap = $TitleContainer/Keymap
	credits = $CreditsButton
	keymap.connect("button_up", show_keymap)
	one_player_button.connect("button_up", start_game_1p)
	two_player_button.connect("button_up", start_game_2p)
	credits.button_up.connect(show_credits)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_keymap():
	$Keymap.show()

func show_credits():
	$Credits.show()

func start_game_1p():
	var new_level = level.instantiate() as Level0
	get_tree().root.add_child(new_level)
	new_level.show()
	hide()
	get_tree().root.remove_child(self.get_parent())
	queue_free()

func start_game_2p():	
	var new_level = level.instantiate() as Level0
	var p2: Frog = load("res://Scenes/frog.tscn").instantiate()
	p2.name = "Player2"
	p2.set_p2_controls()
	new_level.add_child(p2)
	get_tree().root.add_child(new_level)
	new_level.show()
	hide()
	get_tree().root.remove_child(self.get_parent())
	queue_free()

