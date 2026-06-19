extends Area2D

@export var target_scene: String = "res://scenes/house.tscn"  # change path if needed

var player_inside = false

@onready var dialog = get_node_or_null("../DialogBox")

func _on_body_entered(body):
	if body.name == "player":
		player_inside = true
		if dialog:
			dialog.show_text("GUY", "the cat slipped inside the house...\nPress SPACE to follow.")

func _on_body_exited(body):
	if body.name == "player":
		player_inside = false
		if dialog:
			dialog.hide_box()

func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(target_scene)
