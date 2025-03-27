extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
var move_speed : int = 200
var damage : int = 40
var hp : int = 1000

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * move_speed
		move_and_slide()
	
		if direction.x > 0.1:
			sprite_2d.flip_h = true
		elif direction.x < -0.1:
			sprite_2d.flip_h = false


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	velocity = Vector2.ZERO
	if hp <= 0:
		self.queue_free()
