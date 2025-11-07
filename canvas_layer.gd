extends CanvasLayer

@onready var label = $Label
@onready var timer = $Timer

func _ready():
	label.visible = true
	label.text = "TEST"
	timer.wait_time = 4.0
	timer.one_shot = true
	timer.start()


func _on_Timer_timeout():
	label.visible = true
	label.text = "doby where are you going !!!"
