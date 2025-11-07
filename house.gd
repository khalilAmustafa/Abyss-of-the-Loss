extends Node2D

# --- Node references ---
@onready var bg_dark: Sprite2D = $background_dark
@onready var bg_light: Sprite2D = $background_light
@onready var lamp_area: Area2D = $CeilingLamp
@onready var closet_area: Area2D = $closet
@onready var math_ui: CanvasLayer = $mathUI
@onready var question_label: Label = $mathUI/Label
@onready var answer_edit: LineEdit = $mathUI/answer
@onready var code_sprite: Sprite2D = $code
@onready var closet_sprite: Sprite2D = $closet/Sprite2D
@onready var lamp_label: Label = $CeilingLamp/Label
@onready var closet_label: Label = $closet/Label

# --- Variables ---
var puzzle_shown := false
var puzzle_done := false
var correct_answer := 10     # from 3x - 15 = 0
var correct_code := "432"    # final code to open closet
var code_stage := false      # becomes true after light-up

var closed_texture = preload("res://closet_closed.png")
var open_texture   = preload("res://closet_open.png")

var player_near_lamp := false
var player_near_closet := false


func _ready() -> void:
	bg_light.visible = false
	math_ui.visible = false
	code_sprite.visible = false
	lamp_label.visible = false
	closet_label.visible = false

	# layering
	if $player:
		$player.z_index = 10
	bg_dark.z_index = -5
	bg_light.z_index = -5
	code_sprite.z_index = 5

	# connect area signals
	lamp_area.connect("body_entered", Callable(self, "_on_lamp_area_entered"))
	lamp_area.connect("body_exited", Callable(self, "_on_lamp_area_exited"))
	closet_area.connect("body_entered", Callable(self, "_on_closet_entered"))
	closet_area.connect("body_exited", Callable(self, "_on_closet_exited"))

	print("House scene ready!")


# --- Lamp area ---
func _on_lamp_area_entered(body):
	if body.name == "player":
		player_near_lamp = true
		if !puzzle_done:
			lamp_label.visible = true

func _on_lamp_area_exited(body):
	if body.name == "player":
		player_near_lamp = false
		lamp_label.visible = false


# --- Closet area ---
func _on_closet_entered(body):
	if body.name == "player":
		player_near_closet = true
		if code_stage:
			closet_label.visible = true

func _on_closet_exited(body):
	if body.name == "player":
		player_near_closet = false
		closet_label.visible = false


# --- Input handling ---
func _process(_delta):
	# Player presses Space near lamp
	if player_near_lamp and !puzzle_shown and !puzzle_done and Input.is_action_just_pressed("ui_accept"):
		_show_math_puzzle()
	
	# Player solving math
	elif puzzle_shown and !puzzle_done and Input.is_action_just_pressed("ui_accept"):
		_on_answer_submitted()

	# Player presses Space near closet (after lamp done)
	elif player_near_closet and code_stage and Input.is_action_just_pressed("ui_accept") and !math_ui.visible:
		_show_code_prompt()

	# Player submitting code
	elif code_stage and math_ui.visible and Input.is_action_just_pressed("ui_accept"):
		_on_code_submitted()


# --- Lamp puzzle ---
func _show_math_puzzle():
	puzzle_shown = true
	math_ui.visible = true

	var screen = get_viewport_rect().size
	question_label.set_position(Vector2(screen.x / 2 - 100, 150))
	answer_edit.set_position(Vector2(screen.x / 2 - 100, 210))
	question_label.text = "answer to turn the light on\n3x -15=0\n20 - 6y=-10\nx + y = ??"
	answer_edit.text = ""
	answer_edit.grab_focus()


func _on_answer_submitted():
	var text = answer_edit.text.strip_edges()
	if text == "":
		return

	if text.is_valid_int():
		var player_answer = int(text)
		if player_answer == correct_answer:
			_light_up_room()
		else:
			question_label.text = "Wrong... Try again."
	else:
		question_label.text = "Enter a number only."


func _light_up_room():
	puzzle_done = true
	math_ui.visible = false
	bg_dark.visible = false
	bg_light.visible = true
	code_sprite.visible = true
	code_stage = true
	lamp_label.visible = false
	print("✅ Correct! Room lit up — code '432' revealed.")


# --- Closet code ---
func _show_code_prompt():
	math_ui.visible = true

	var screen = get_viewport_rect().size
	question_label.set_position(Vector2(screen.x / 2 - 100, 150))
	answer_edit.set_position(Vector2(screen.x / 2 - 100, 210))
	question_label.text = "Enter the code to unlock the closet."
	answer_edit.text = ""
	answer_edit.grab_focus()


func _on_code_submitted():
	var text = answer_edit.text.strip_edges()
	if text == "":
		return

	if text == correct_code:
		_unlock_closet()
	else:
		question_label.text = "Wrong code..."


func _unlock_closet():
	math_ui.visible = false
	closet_sprite.texture = open_texture
	closet_label.visible = false
	print("Closet opened... the truth is revealed.")
