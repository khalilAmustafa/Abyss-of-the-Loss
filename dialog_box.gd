extends CanvasLayer

# Reusable modern bottom-bar dialog box with a typewriter reveal.
# Call show_text(speaker, body) to display, hide_box() to dismiss.
# Pass auto_hide_seconds > 0 to dismiss automatically after the line finishes.

@onready var box: Panel = $Box
@onready var speaker_label: Label = $Box/Margin/VBox/Speaker
@onready var body_label: Label = $Box/Margin/VBox/Body
@onready var arrow: Label = $Box/Arrow
@onready var typing_sound: AudioStreamPlayer = $TypingSound

@export var chars_per_second := 35.0

var _typing := false
var _char_progress := 0.0
var _auto_hide := 0.0
var _hide_token := 0

func _ready() -> void:
	hide_box()

func show_text(speaker: String, body: String, auto_hide_seconds := 0.0) -> void:
	box.visible = true
	speaker_label.text = speaker
	speaker_label.visible = speaker != ""
	body_label.text = body
	body_label.visible_characters = 0
	_char_progress = 0.0
	_typing = true
	_auto_hide = auto_hide_seconds
	arrow.visible = false
	_hide_token += 1  # cancel any pending auto-hide from a previous line
	if typing_sound.stream:
		typing_sound.stream.loop = true
		typing_sound.play()

func hide_box() -> void:
	box.visible = false
	_typing = false
	arrow.visible = false
	_hide_token += 1
	typing_sound.stop()

func _process(delta: float) -> void:
	if _typing:
		_char_progress += chars_per_second * delta
		body_label.visible_characters = int(_char_progress)
		if body_label.visible_characters >= body_label.get_total_character_count():
			body_label.visible_characters = -1  # reveal all
			_typing = false
			typing_sound.stop()
			arrow.visible = true
			if _auto_hide > 0.0:
				_start_auto_hide(_auto_hide)

	# blink the continue arrow once the line is fully shown
	if arrow.visible:
		arrow.modulate.a = 0.35 + 0.45 * (0.5 + 0.5 * sin(Time.get_ticks_msec() / 250.0))

func _start_auto_hide(seconds: float) -> void:
	var token := _hide_token
	await get_tree().create_timer(seconds).timeout
	if token == _hide_token:  # not superseded by a newer line
		hide_box()
