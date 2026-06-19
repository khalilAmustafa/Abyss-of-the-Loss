extends CharacterBody2D

@export var follow_speed := 80.0
@export var run_speed := 200.0
@export var follow_duration := 10.0
@export var player: NodePath

var follow_time := 0.0
var running := false
var player_ref: Node2D

func _ready():
	if player != null:
		player_ref = get_node(player)
	else:
		print("⚠️ Dog error: assign the player in Inspector")

func _physics_process(delta: float) -> void:
	if player_ref == null:
		return

	# Timer
	follow_time += delta

	# Start running away
	if follow_time >= follow_duration and !running:
		running = true

	# RUN AWAY
	if running:
		velocity.x = run_speed
		move_and_slide()

		# delete dog when off screen
		if global_position.x > player_ref.global_position.x + 600:
			queue_free()
		return

	# FOLLOW PLAYER
	var direction = sign(player_ref.global_position.x - global_position.x)
	velocity.x = direction * follow_speed
	velocity.y = 0
	move_and_slide()

	# Flip sprite
	if direction != 0:
		$Sprite2D.flip_h = direction < 0
