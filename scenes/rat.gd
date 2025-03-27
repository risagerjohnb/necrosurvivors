extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
var move_speed : int = 25
var damage : int = 3
var hp : int = 10
var exp_drop = 4
@onready var exp_scroll = preload("res://scenes/Drops/experience_scroll.tscn")
var exp = null
@onready var coin = preload("res://scenes/coin.tscn")
@onready var blood_animation: AnimatedSprite2D = $BloodAnimation

func _ready() -> void:
	blood_animation.visible = false
	exp = exp_scroll.instantiate()
	exp.experience = exp_drop

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
	print("rat has taken damage")
	if hp <= 0:
		spawn_coin()
		blood_animation.visible = true
		blood_animation.play("death")
		await blood_animation.animation_finished
		exp.global_position = position
		get_parent().add_child(exp)
		self.queue_free()

func spawn_coin():
	print("coin spawned")
	var coin_instantiate = coin.instantiate()
	coin_instantiate.position = position
	get_parent().add_child(coin_instantiate)
