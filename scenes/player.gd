extends CharacterBody2D

@export var hp : int = 80
@export var max_hp : int = 80
const SPEED : int = 100
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hp_bar: ProgressBar = $Hp_Bar

var magicSword = preload("res://scenes/magic_sword.tscn")

@onready var magic_sword_timer: Timer = $Attack/MagicSwordTimer
@onready var magic_sword_attack_timer: Timer = $Attack/MagicSwordTimer/MagicSwordAttackTimer

var magicSword_ammo : int = 0
var magicSword_baseammo : int = 1
var magicSword_attackspeed : float = 1.5
var magicSword_level : int = 1

var enemy_close = []

func _ready() -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	attack()
	
func attack():
	if magicSword_level > 0:
		magic_sword_timer.wait_time = magicSword_attackspeed
		if magic_sword_timer.is_stopped():
			magic_sword_timer.start()

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * SPEED
		move_and_slide()
	
	if direction.x > 0:
		sprite_2d.flip_h = true
	elif direction.x < 0:
		sprite_2d.flip_h = false


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	hp_bar.value = hp
	print(hp)


func _on_magic_sword_timer_timeout() -> void:
	magicSword_ammo += magicSword_baseammo
	magic_sword_attack_timer.start()


func _on_magic_sword_attack_timer_timeout() -> void:
	if magicSword_ammo > 0:
		var magicSword_attack = magicSword.instantiate()
		magicSword_attack.position = position
		magicSword_attack.target = get_random_target()
		magicSword_attack.level = magicSword_level
		add_child(magicSword_attack)
		magicSword_ammo -= 1
		if magicSword_ammo > 0:
			magic_sword_attack_timer.start()
		else:
			magic_sword_attack_timer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
