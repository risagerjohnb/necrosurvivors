extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
var move_speed : int = 80
var damage : int = 5
var hp : int = 15
@onready var blood_animation: AnimatedSprite2D = $BloodAnimation

func _ready() -> void:
	blood_animation.visible = false

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
	modulate = "red"
	blood_animation.play("death")
	await blood_animation.animation_finished
	print("wolf took damage")
	if hp <= 0:
		blood_animation.visible = true
		blood_animation.play("death")
		await blood_animation.animation_finished
		self.queue_free()
