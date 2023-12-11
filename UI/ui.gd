class_name UI
extends Control

@onready var game_over: Label = $SPGameOver
@onready var win: Label = $SPWin

@onready var player1: HBoxContainer = $Player1
@onready var p1_lives: Array[Life] = [$Player1/Life1, $Player1/Life2, $Player1/Life3, $Player1/Life4, $Player1/Life5, $Player1/Life6, $Player1/Life7]
@onready var p1_score: Label = $Score1Container/Player1Score
@onready var p1_win: Label = $TP1Win

@onready var player2: HBoxContainer = $Player2
@onready var p2_lives: Array[Life] = [$Player2/Life1, $Player2/Life2, $Player2/Life3, $Player2/Life4, $Player2/Life5, $Player2/Life6, $Player2/Life7]
@onready var p2_score: Label = $Score2Container/Player2Score
@onready var p2_win: Label = $TP2Win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_return_to_mm() -> void:
	$ReturnToMM.show()

func show_player1(show_stats: bool):
	if show_stats:
		player1.show()
		p1_score.show()
	else:
		player1.hide()
		p1_score.hide()
	
func show_player2(show_stats: bool):
	if show_stats:
		player2.show()
		p2_score.get_parent().show()
	else:
		player2.hide()
		p2_score.hide()

func player1_lives(lives: int):
	for l in p1_lives:
		l.hide()

	for i in range(lives):
		p1_lives[i].show()
		
func player1_score(score: int):
	p1_score.text = str(score)
	
func player2_score(score: int):
	p2_score.text = str(score)

func player2_lives(lives: int):
	for l in p2_lives:
		l.hide()

	for i in range(lives):
		p2_lives[i].show()


func single_player_game_over(_show: bool):
	game_over.show()

func single_player_win(_show: bool):
	win.show()


func two_player_win(player_num: int):
	if player_num == 1:
		p1_win.show()
	if player_num == 2:
		p2_win.show()
