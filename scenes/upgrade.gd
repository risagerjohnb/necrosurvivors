extends Control

@onready var player = get_tree().get_first_node_in_group("player")
var ms_instance = null
@onready var upgrade: Control = $"."

func _ready() -> void:
	pass

func _on_ms_upgrade_btn_pressed() -> void:
	player.magicSword_baseammo += 1
	upgrade.visible = false
	Engine.time_scale = 1

func _on_ls_upgrade_btn_pressed() -> void:
	player.lightning_baseammo += 10
	upgrade.visible = false
	Engine.time_scale = 1
