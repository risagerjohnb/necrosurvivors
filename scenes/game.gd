extends Node2D

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Player/TimerLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_label and timer:
		var simplified_time = ceil(timer.time_left)
		timer_label.text = str(simplified_time)


func _on_timer_timeout() -> void:
	pass
