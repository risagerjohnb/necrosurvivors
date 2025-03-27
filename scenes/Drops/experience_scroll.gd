extends Area2D

@export var experience = 1

@onready var tier_1_scroll: Sprite2D = $Tier1Scroll
@onready var tier_2_scroll: Sprite2D = $Tier2Scroll
@onready var tier_3_scroll: Sprite2D = $Tier3Scroll
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var snd_collected: AudioStreamPlayer = $snd_collected

@onready var player = get_tree().get_first_node_in_group("player")

var target = null
var speed = 0

var player_close = []

func _ready() -> void:
	player
	tier_1_scroll.visible = false
	tier_2_scroll.visible = false
	tier_3_scroll.visible = false
	
	if experience < 5:
		tier_1_scroll.visible = true
	elif experience < 25:
		tier_2_scroll.visible = true
	else:
		tier_3_scroll.visible = true

func _physics_process(delta: float) -> void:
	if player:
		target = player.global_position
		global_position = global_position.move_toward(target, speed)
		speed += 2*delta

func collect():
	snd_collected.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_close.append(body)
		if experience < 5:
			body.collected_experience += 6
		elif experience < 25:
			body.collected_experience += 4
		else:
			body.collected_experience += 2
		body.is_received_xp = true
		self.queue_free()
		collect()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_close.erase(body)
