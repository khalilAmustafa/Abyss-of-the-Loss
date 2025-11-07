extends Area2D

@export var target_scene: String = "res://house.tscn"  # change path if needed

var player_inside = false

func _ready():
	print("Door ready")

func _on_body_entered(body):
	if body.name == "player":
		player_inside = true
		print("Player entered door area")

func _on_body_exited(body):
	if body.name == "player":
		player_inside = false
		print("Player left door area")

func _process(delta):
	if player_inside and Input.is_action_just_pressed("ui_accept"):
		print("Loading next scene...")
		get_tree().change_scene_to_file(target_scene)
