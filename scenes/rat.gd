extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
var move_speed : int = 25
var damage : int = 3
var hp : int = 10
@onready var blood_animation: AnimatedSprite2D = $BloodAnimation

func _ready() -> void:
	blood_animation.visible = false

func take_damage(amount: int):
	print("rat has taken: ", amount)

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
	blood_animation.play("death")
	await blood_animation.animation_finished
	print(hp)
	if hp <= 0:
		blood_animation.visible = true
		blood_animation.play("death")
		await blood_animation.animation_finished
		self.queue_free()
