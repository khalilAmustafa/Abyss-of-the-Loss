extends CharacterBody2D

@export var speed := 160
@export var footstep_sound: AudioStream  # set per scene (outside vs inside)

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var footsteps: AudioStreamPlayer = $Footsteps

func _ready():
	# Camera is top_level (it ignores the player's scale), so snap it onto the
	# player at spawn and clear smoothing to avoid an opening slide.
	camera.global_position = global_position
	camera.reset_smoothing()

	# Per-scene walking sound; loop it so it plays continuously while moving.
	if footstep_sound:
		footsteps.stream = footstep_sound
		if footsteps.stream is AudioStreamMP3:
			footsteps.stream.loop = true

func _physics_process(delta):
	var direction = Vector2.ZERO

	# --- Movement input (project actions: A/D + arrows) ---
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	elif Input.is_action_pressed("move_left"):
		direction.x -= 1

	# --- Apply velocity ---
	velocity = direction * speed
	move_and_slide()

	# --- Camera follow (smoothing eases the motion) ---
	camera.global_position = global_position

	# --- Animation logic ---
	if direction.x != 0:
		anim.play("walk")
		anim.flip_h = direction.x < 0  # sheet faces right; flip when moving left
		if footsteps.stream and not footsteps.playing:
			footsteps.play()
	else:
		anim.play("idle")  # dedicated idle pose (faces last-moved direction)
		footsteps.stop()
