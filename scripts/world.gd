extends Node2D

# Camera zoom for this scene (higher = more zoomed in / tighter on the player).
const WORLD_ZOOM := 1.5

func _ready() -> void:
	var cam: Camera2D = $player/Camera2D
	if cam:
		cam.zoom = Vector2(WORLD_ZOOM, WORLD_ZOOM)
		_clamp_camera_to_background(cam)
		cam.reset_smoothing()

	# The old world-space hint is replaced by the DialogBox; hide it if present.
	var floating := get_node_or_null("FloatingLabel")
	if floating:
		floating.visible = false

	# Looping rain ambience.
	var rain := get_node_or_null("RainSound")
	if rain and rain.stream:
		rain.stream.loop = true  # AudioStreamMP3.loop
		rain.play()

# Limit the camera to the Background image bounds so the gray void outside it is
# never visible. Computed from the sprite, so nudging the Background in the editor
# keeps the limits correct.
func _clamp_camera_to_background(cam: Camera2D) -> void:
	var bg := get_node_or_null("Background") as Sprite2D
	if not (bg and bg.texture):
		return
	var tex_size: Vector2 = bg.texture.get_size() * bg.scale.abs()
	var top_left: Vector2 = bg.global_position - tex_size * 0.5  # Sprite2D is centered
	cam.limit_left = int(ceil(top_left.x))
	cam.limit_top = int(ceil(top_left.y))
	cam.limit_right = int(floor(top_left.x + tex_size.x))
	cam.limit_bottom = int(floor(top_left.y + tex_size.y))
