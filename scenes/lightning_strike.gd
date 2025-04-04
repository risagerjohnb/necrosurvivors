extends Area2D

var level : int = 1
var hp : int = 1
var damage : int = 10
var speed : int = 50
var knock_amount : int = 100
var attack_size : float = 1.0

var target = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knock_amount = 100
			attack_size = 1.0
		2:
			hp = 1
			speed = 110
			damage = 7
			knock_amount = 110
			attack_size = 1.0

func _physics_process(delta: float) -> void:
	pass

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()


func _on_lightning_strike_spawn_timer_timeout() -> void:
	queue_free()
