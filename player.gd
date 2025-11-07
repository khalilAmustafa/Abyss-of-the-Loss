extends CharacterBody2D

@export var speed := 160

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO

	# --- Movement input ---
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# --- Apply velocity ---
	velocity = direction * speed
	move_and_slide()

	# --- Animation logic ---
	if direction.x != 0:
		anim.play("walk")
		anim.flip_h = direction.x > 0  # flip when moving right (invert if wrong)
	else:
		anim.stop()
		anim.frame = 0  # freeze on first frame
