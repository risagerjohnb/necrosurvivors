extends Control

@onready var exp_bar: ProgressBar = $EXP_bar
var max_value : int = 5
var min_value : int = 0
var current_max_value : int = 0
var is_leveled_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exp_bar.max_value = max_value
	exp_bar.min_value = min_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_leveled_up:
		max_value += 2
		current_max_value = max_value
		exp_bar.max_value = current_max_value
		is_leveled_up = false
