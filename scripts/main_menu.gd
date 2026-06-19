extends Control

# Main menu: Start Game / How to Play / Credits, over the pixel-horror artwork.

const HOW_TO_PLAY := "Move        A  /  D     or     Arrow Keys
Interact     Space

Follow Doby into the dark.
Inspect the house. Solve what waits inside.
Find the signal. Escape the abyss."

const CREDITS := "Abyss of the Lost.

Made with the Godot Engine."

@onready var buttons: Control = $Buttons
@onready var overlay: Control = $Overlay
@onready var overlay_title: Label = $Overlay/Panel/Margin/VBox/Title
@onready var overlay_text: Label = $Overlay/Panel/Margin/VBox/Text
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

func _ready() -> void:
	_close_overlay()
	$Buttons/StartButton.pressed.connect(_on_start)
	$Buttons/HowButton.pressed.connect(_on_how)
	$Buttons/CreditsButton.pressed.connect(_on_credits)
	$Overlay/Panel/Margin/VBox/BackButton.pressed.connect(_close_overlay)
	# Click sound on the buttons that don't change scene (Start handles its own).
	$Buttons/HowButton.pressed.connect(_play_click)
	$Buttons/CreditsButton.pressed.connect(_play_click)
	$Overlay/Panel/Margin/VBox/BackButton.pressed.connect(_play_click)
	# Brighten the image buttons on hover / keyboard focus; hover sound on mouse.
	for b in [$Buttons/StartButton, $Buttons/HowButton, $Buttons/CreditsButton]:
		b.mouse_entered.connect(_hover.bind(b, true))
		b.mouse_exited.connect(_hover.bind(b, false))
		b.focus_entered.connect(_hover.bind(b, true))
		b.focus_exited.connect(_hover.bind(b, false))
		b.mouse_entered.connect(_play_hover)
	$Overlay/Panel/Margin/VBox/BackButton.mouse_entered.connect(_play_hover)
	$Buttons/StartButton.grab_focus()

func _hover(btn: TextureButton, on: bool) -> void:
	btn.self_modulate = Color(1.18, 1.18, 1.18) if on else Color(1, 1, 1)

func _play_hover() -> void:
	hover_sound.play()

func _play_click() -> void:
	click_sound.play()

func _on_start() -> void:
	_play_click()
	await get_tree().create_timer(0.15).timeout  # let the click sound play
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_how() -> void:
	_open_overlay("HOW TO PLAY", HOW_TO_PLAY)

func _on_credits() -> void:
	_open_overlay("CREDITS", CREDITS)

func _open_overlay(title: String, body: String) -> void:
	overlay_title.text = title
	overlay_text.text = body
	overlay.visible = true
	buttons.visible = false

func _close_overlay() -> void:
	overlay.visible = false
	buttons.visible = true
	$Buttons/StartButton.grab_focus()
