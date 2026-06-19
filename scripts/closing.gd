extends Control

# Closing scene — shown after the closet event.
# Fades in, then enables buttons. Hover/click match main_menu.gd exactly.

@onready var play_again_btn: TextureButton = $Buttons/PlayAgainButton
@onready var main_menu_btn: TextureButton = $Buttons/MainMenuButton
@onready var quit_btn: TextureButton = $Buttons/QuitButton
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var fade_rect: ColorRect = $FadeRect


func _ready() -> void:
	# Start fully black; buttons disabled until fade-in finishes.
	fade_rect.color = Color(0, 0, 0, 1)
	fade_rect.visible = true
	_set_buttons_enabled(false)

	# Wire button signals.
	play_again_btn.pressed.connect(_on_play_again)
	main_menu_btn.pressed.connect(_on_main_menu)
	quit_btn.pressed.connect(_on_quit)

	# Hover visuals + sounds (same behaviour as main menu).
	for b in [play_again_btn, main_menu_btn, quit_btn]:
		b.mouse_entered.connect(_hover.bind(b, true))
		b.mouse_exited.connect(_hover.bind(b, false))
		b.focus_entered.connect(_hover.bind(b, true))
		b.focus_exited.connect(_hover.bind(b, false))
		b.mouse_entered.connect(_play_hover)

	# On web exports Quit can't close the tab — hide the button.
	if OS.has_feature("web"):
		quit_btn.visible = false

	# Fade in over 1.5 s, then enable buttons.
	var tw := create_tween()
	tw.tween_property(fade_rect, "color:a", 0.0, 1.5)
	tw.tween_callback(_on_fade_in_done)


# ---- Hover / sound helpers (identical to main_menu.gd) ----

func _hover(btn: TextureButton, on: bool) -> void:
	btn.self_modulate = Color(1.18, 1.18, 1.18) if on else Color(1, 1, 1)

func _play_hover() -> void:
	hover_sound.play()

func _play_click() -> void:
	click_sound.play()


# ---- Fade callback ----

func _on_fade_in_done() -> void:
	_set_buttons_enabled(true)
	play_again_btn.grab_focus()


# ---- Button actions ----

func _on_play_again() -> void:
	_play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_main_menu() -> void:
	_play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit() -> void:
	_play_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()


# ---- Helpers ----

func _set_buttons_enabled(enabled: bool) -> void:
	for b in [play_again_btn, main_menu_btn, quit_btn]:
		b.disabled = !enabled
		b.modulate.a = 1.0 if enabled else 0.4
