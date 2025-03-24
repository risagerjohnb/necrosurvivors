extends Resource
class_name Spawn_Info

@export var time_start : int
@export var time_end : int
@export var enemy : Resource
@export var enemy_num : int
@export var enemy_spawn_delay : int

var spawn_delay_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
