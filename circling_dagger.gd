extends Area2D

@export var level : int = 1
var hp : int = 50
var damage : int = 10
var speed : int = 1
var knock_amount : int = 100
var attack_size : float = 1.0

var radius : float = 50.0
var angle : float = 0.0

var enemy_close = []

func _ready() -> void:
	match level:
		1:
			hp = 100
			speed = 1
			damage = 12
			knock_amount = 100
			attack_size = 1.0
		2:
			hp = 100
			speed = 2
			damage = 20
			knock_amount = 110
			attack_size = 1.2

func _process(delta: float) -> void:
	angle += speed * delta
	global_position = get_parent().global_position + Vector2(radius, 0).rotated(angle)

func enemy_hit(charge = 1):
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("entered dagger range")
		enemy_close.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("exited dagger range")
		enemy_close.erase(body)
