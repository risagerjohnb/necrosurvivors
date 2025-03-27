extends Area2D

var level : int = 1
var hp : int = 50
var damage : int = 10
var speed : int = 50
var knock_amount : int = 100
var attack_size : float = 1.0

var target = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	match level:
		1:
			hp = 100
			speed = 100
			damage = 1
			knock_amount = 100
			attack_size = 1.0
		2:
			hp = 100
			speed = 110
			damage = 2
			knock_amount = 110
			attack_size = 1.2

func _physics_process(delta: float) -> void:
	pass

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
