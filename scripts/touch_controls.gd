extends CanvasLayer

# On-screen control overlay — always visible on all platforms.
# Acts as both touch/click buttons AND visual keyboard indicators.
# Visual state is driven by the actual input action state, so it
# reacts identically to touch, mouse click, and keyboard.

@onready var btn_left: TouchScreenButton = $Left
@onready var btn_right: TouchScreenButton = $Right
@onready var btn_space: TouchScreenButton = $Space

# Visual constants — keep pixel-perfect, no glow, no blur.
const NORMAL_SCALE := Vector2(0.25, 0.25)
const PRESSED_SCALE := Vector2(0.24, 0.24)   # 0.25 × 0.96
const NORMAL_COLOR := Color(1, 1, 1)
const PRESSED_COLOR := Color(0.78, 0.78, 0.78)


func _ready() -> void:
	# The Space button natively fires "ui_accept" via its action property.
	# Some scripts also check "interact", so mirror it manually.
	btn_space.pressed.connect(func(): Input.action_press("interact"))
	btn_space.released.connect(func(): Input.action_release("interact"))


func _process(_delta: float) -> void:
	# Update every button's look based on whether its action is active
	# right now — regardless of input source (keyboard, touch, or click).
	_update_visual(btn_left,  Input.is_action_pressed("move_left"))
	_update_visual(btn_right, Input.is_action_pressed("move_right"))
	_update_visual(btn_space, Input.is_action_pressed("ui_accept") or Input.is_action_pressed("interact"))


func _update_visual(btn: TouchScreenButton, active: bool) -> void:
	if active:
		btn.modulate = PRESSED_COLOR
		btn.scale = PRESSED_SCALE
	else:
		btn.modulate = NORMAL_COLOR
		btn.scale = NORMAL_SCALE
