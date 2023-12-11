extends Node3D

var anim: AnimationPlayer;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim = $AnimationPlayer as AnimationPlayer
	anim.play("Frog_Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func jump():
	anim.play("Frog_Jump", -1,3.5)
	if !anim.animation_finished.is_connected(idle):
		anim.animation_finished.connect(idle)

func idle(_anim_name):
	anim.animation_finished.disconnect(idle)
	anim.play("Frog_Idle")

func death():
	anim.animation_finished.disconnect(idle)
	anim.stop()
	anim.play("Frog_Death")
	await anim.animation_finished.connect(func():
		anim.play("Frog_Death")
		anim.pause()
		anim.seek(0.8333)
	)
