extends Area2D

@onready var press_label = $"../../PressLabel"
@onready var anim = $"../../PressLabel/AnimationPlayer"

func _ready():
	press_label.visible = true                    # always exists
	press_label.modulate.a = 0.0                 # start invisible

func _on_body_entered(body):
	if body.is_in_group("player"):
		press_label.modulate.a = 1.0           # make visible
		anim.play("pulse")                     # play pulse animation

func _on_body_exited(body):
	if body.is_in_group("player"):
		anim.stop()                            # stop pulsing
		press_label.modulate.a = 0.0           # hide instantly
