extends Node2D

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Player/Camera2D/TimerLabel
@onready var player = get_tree().get_first_node_in_group("player")
@onready var upgrade = preload("res://scenes/upgrade.tscn")
var upgrade_instance = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_label and timer:
		var simplified_time = ceil(timer.time_left)
		timer_label.text = str(simplified_time)
	if player.xp_bar.max_value == player.xp_bar.value:
		Engine.time_scale = 0
		upgrade_instance = upgrade.instantiate()
		upgrade_instance.global_position = player.global_position
		add_child(upgrade_instance)


func _on_timer_timeout() -> void:
	pass
