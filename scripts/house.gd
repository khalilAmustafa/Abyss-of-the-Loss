extends Node2D

# --- Node references ---
@onready var bg_dark: Sprite2D = $background_dark
@onready var bg_light: Sprite2D = $background_light
@onready var lamp_area: Area2D = $CeilingLamp
@onready var closet_area: Area2D = $closet
@onready var math_ui: CanvasLayer = $mathUI
@onready var question_label: Label = $mathUI/Panel/Margin/VBox/Label
@onready var answer_edit: LineEdit = $mathUI/Panel/Margin/VBox/answer
@onready var code_sprite: Sprite2D = $code
@onready var closet_sprite: Sprite2D = $closet/Sprite2D
@onready var lamp_label: Label = $CeilingLamp/Label
@onready var closet_label: Label = $closet/Label
@onready var dialog = get_node_or_null("DialogBox")

# --- Variables ---
var puzzle_shown := false
var puzzle_done := false
var correct_answer := 10     # from 3x - 15 = 0
var correct_code := "432"    # final code to open closet
var code_stage := false      # becomes true after light-up

var closed_texture = preload("res://assets/images/props/closet_closed.png")
var open_texture   = preload("res://assets/images/props/closet_open.png")

var player_near_lamp := false
var player_near_closet := false

# Raises the in-house view above the player (negative = camera looks higher up).
const HOUSE_CAM_OFFSET_Y := -80.0


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

	# keep the camera inside the room background (no gray void)
	_clamp_camera_to(bg_dark)

	# raise the view a bit so more of the room above the player shows
	var cam := get_node_or_null("player/Camera2D") as Camera2D
	if cam:
		cam.offset.y = HOUSE_CAM_OFFSET_Y

	# looping house ambience
	var amb := get_node_or_null("HouseAmbience")
	if amb and amb.stream:
		amb.stream.loop = true
		amb.play()

	# one-shot "entering the house" sound (survives the scene change since it
	# plays once the house scene has loaded)
	var enter := get_node_or_null("EnterSound")
	if enter:
		enter.play()

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
		if !puzzle_done and dialog:
			dialog.show_text("GUY", "The light's off...\nPress SPACE to fix it.")

func _on_lamp_area_exited(body):
	if body.name == "player":
		player_near_lamp = false
		if dialog:
			dialog.hide_box()


# --- Closet area ---
func _on_closet_entered(body):
	if body.name == "player":
		player_near_closet = true
		if code_stage and dialog:
			dialog.show_text("GUY", "A locked closet...\nPress SPACE to open it.")

func _on_closet_exited(body):
	if body.name == "player":
		player_near_closet = false
		if dialog:
			dialog.hide_box()


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
	if dialog:
		dialog.hide_box()

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
	_clamp_camera_to(bg_light)  # light bg has slightly different bounds
	var switch_sfx := get_node_or_null("LightSwitchSound")
	if switch_sfx:
		switch_sfx.play()
	print("✅ Correct! Room lit up — code '432' revealed.")


# --- Closet code ---
func _show_code_prompt():
	math_ui.visible = true
	if dialog:
		dialog.hide_box()

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
	_play_closet_sounds()
	print("Closet opened... the truth is revealed.")
	# --- Closing-scene transition ---
	await get_tree().create_timer(5.0).timeout       # wait 5 seconds
	var fade := get_node_or_null("ClosingFade/FadeRect") as ColorRect
	if fade:
		fade.visible = true
		var tw := create_tween()
		tw.tween_property(fade, "color:a", 1.0, 2.0)  # fade to black over 2 s
		await tw.finished
	get_tree().change_scene_to_file("res://scenes/closing.tscn")


func _play_closet_sounds() -> void:
	# Closet creaks open, then shock, then scream.
	var opening := get_node_or_null("OpenClosetSound")
	if opening:
		opening.play()
	var shock := get_node_or_null("ShockSound")
	if shock:
		await get_tree().create_timer(0.35).timeout
		shock.play()
	var scream := get_node_or_null("ScreamSound")
	if scream:
		await get_tree().create_timer(0.45).timeout
		scream.play()


# Limit the player camera to a background sprite's bounds so the gray void
# outside the room image is never visible.
func _clamp_camera_to(sprite: Sprite2D) -> void:
	var cam := get_node_or_null("player/Camera2D") as Camera2D
	if not (cam and sprite and sprite.texture):
		return
	var tex_size: Vector2 = sprite.texture.get_size() * sprite.scale.abs()
	var top_left: Vector2 = sprite.global_position - tex_size * 0.5  # Sprite2D is centered
	cam.limit_left = int(ceil(top_left.x))
	cam.limit_top = int(ceil(top_left.y))
	cam.limit_right = int(floor(top_left.x + tex_size.x))
	cam.limit_bottom = int(floor(top_left.y + tex_size.y))
	cam.reset_smoothing()
