extends CharacterBody2D

@export var walk_speed := 120.0
@export var run_speed := 400.0
@export var follow_time := 4.0
@export var stop_distance := 60.0  # stop at 60px on X axis
@export var player_path: NodePath

var player
var timer := 0.0
var running := false

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	if !player: 
		return

	timer += delta

	# After time, run away
	if timer > follow_time:
		running = true

	# RUN AWAY BEHAVIOR
	if running:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false  # Always face right when escaping
		velocity.x = run_speed
		move_and_slide()

		# Remove cat when far enough
		if global_position.x > player.global_position.x + 600:
			queue_free()
		return

	# -- FOLLOW LOGIC --
	var distance_x = abs(player.global_position.x - global_position.x)
	var direction = sign(player.global_position.x - global_position.x)

	if distance_x > stop_distance:  # FOLLOW until 60px away
		velocity.x = direction * walk_speed
		$AnimatedSprite2D.play("walk")

		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, 200 * delta)
		$AnimatedSprite2D.play("idle")

	move_and_slide()
