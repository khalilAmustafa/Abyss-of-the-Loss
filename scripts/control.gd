extends Control

@onready var start_button = $StartButton
@onready var quit_button = $QuitButton

func _ready():
	start_button.connect("pressed", Callable(self, "_on_start_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_quit_pressed():
	get_tree().quit()
