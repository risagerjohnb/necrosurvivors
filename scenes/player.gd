extends CharacterBody2D

@export var hp : int = 10
@export var max_hp : int = 10
const SPEED : int = 100

var experience = 0
var experience_level = 1
var collected_experience = 0
var max_experience = 500
var is_received_xp = false
var is_leveled_up = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hp_bar: ProgressBar = $Hp_Bar

var magicSword = preload("res://scenes/magic_sword.tscn")

@onready var magic_sword_timer: Timer = $Attack/MagicSwordTimer
@onready var magic_sword_attack_timer: Timer = $Attack/MagicSwordTimer/MagicSwordAttackTimer

var magicSword_ammo : int = 0
@export var magicSword_baseammo : int = 1
var magicSword_attackspeed : float = 1.5
var magicSword_level : int = 1

var lightning = preload("res://scenes/lightning_strike.tscn")

@onready var lightning_timer: Timer = $Attack/LightningTimer
@onready var lightning_timer_attack_timer: Timer = $Attack/LightningTimer/LightningTimerAttackTimer

var lightning_ammo : int = 0
@export var lightning_baseammo : int = 1
var lightning_attackspeed : float = 1.5
var lightning_level : int = 1

var monkey = preload("res://scenes/monkey.tscn")

@onready var monkey_timer: Timer = $Attack/MonkeyTimer
@onready var monkey_attack_timer: Timer = $Attack/MonkeyTimer/MonkeyAttackTimer

var monkey_spawn_amount : int = 0
var monkey_base_spawn_amount : int = 1
var monkey_attackspeed : float = 1.5
var monkey_level : int = 1
var current_monkey = null

@onready var snd_magic_sword: AudioStreamPlayer = $snd_MagicSword
@onready var snd_lightning_strike: AudioStreamPlayer = $snd_LightningStrike
@onready var snd_circling_dagger: AudioStreamPlayer = $snd_CirclingDagger
@onready var snd_player_death: AudioStreamPlayer = $snd_PlayerDeath

var enemy_close = []
@onready var xp_bar: ProgressBar = $Xp_Bar

var count : int = 0
@onready var money_label: Label = $Camera2D/MoneyLabel

var circling_dagger = preload("res://scenes/circling_dagger.tscn")
var circling_dagger_instance = null

func _ready() -> void:
	money_label.text = "Coins: "
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	attack()
	circling_dagger_instance = circling_dagger.instantiate()
	add_child(circling_dagger_instance)
	xp_bar.max_value = max_experience
	xp_bar.value = experience

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

func _process(delta: float) -> void:
	if max_experience == xp_bar.value:
		xp_bar.value = 0
		experience = 0
		experience_level += 1
	if is_received_xp == true:
		xp_bar.value += collected_experience
		is_received_xp = false

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

func circling_dagger_attack():
	pass

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	hp_bar.value = hp
	$snd_PlayerDamage.play()
	$Sprite2D.modulate = "#a30000"
	_on_damage_recovery_timer_timeout()
	if hp <= 0:
		snd_player_death.play()
		await snd_player_death.finished
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

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
		snd_magic_sword.play()
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
		snd_lightning_strike.play()
		lightning_ammo -= 1
		if lightning_ammo > 0:
			lightning_timer_attack_timer.start()
		else:
			lightning_timer_attack_timer.stop()


func _on_damage_recovery_timer_timeout() -> void:
	$Sprite2D.modulate = "#ffffff"
