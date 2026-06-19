extends CanvasLayer

@onready var label = $Label
@onready var timer = $Timer
@onready var dialog = get_node_or_null("../DialogBox")

func _ready():
	label.visible = false  # objective now shown through the DialogBox
	timer.wait_time = 4.0
	timer.one_shot = true
	timer.start()


func _on_timer_timeout():
	if dialog:
		dialog.show_text("GUY", "Doby... where are you going?", 5.0)
