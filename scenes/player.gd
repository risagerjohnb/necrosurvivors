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

var lightning = preload("res://scenes/lightning_strike.tscn")

@onready var lightning_timer: Timer = $Attack/LightningTimer
@onready var lightning_timer_attack_timer: Timer = $Attack/LightningTimer/LightningTimerAttackTimer

var lightning_ammo : int = 0
var lightning_baseammo : int = 1
var lightning_attackspeed : float = 1.5
var lightning_level : int = 1

var enemy_close = []

var count : int = 0
@onready var money_label: Label = $MoneyLabel


func _ready() -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	attack()

func add_coin():
	count += 1
	if money_label:
		money_label.text = "Coins: " + str(count)

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

func attack():
	if magicSword_level > 0:
		magic_sword_timer.wait_time = magicSword_attackspeed
		if magic_sword_timer.is_stopped():
			magic_sword_timer.start()
	
	if lightning_level > 0:
		lightning_timer.wait_time = lightning_attackspeed
		if lightning_timer.is_stopped():
			lightning_timer.start()

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



func _on_lightning_timer_timeout() -> void:
	lightning_ammo += lightning_baseammo
	lightning_timer_attack_timer.start()


func _on_lightning_timer_attack_timer_timeout() -> void:
	if lightning_ammo > 0:
		var lightning_attack = lightning.instantiate()
		lightning_attack.position = get_random_target()
		lightning_attack.target = get_random_target()
		lightning_attack.level = lightning_level
		add_child(lightning_attack)
		print("strike!")
		lightning_ammo -= 1
		if lightning_ammo > 0:
			lightning_timer_attack_timer.start()
		else:
			lightning_timer_attack_timer.stop()
