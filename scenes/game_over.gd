extends Control

@onready var label: Label = $Panel/Label
@onready var label_2: Label = $Panel/Label2
@onready var label_3: Label = $Panel/Label3
@onready var label_4: Label = $Panel/Label4
@onready var label_5: Label = $Panel/Label5

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var button: Button = $Panel/Button
@onready var button_2: Button = $Panel/Button2
@onready var button_3: Button = $Panel/Button3
@onready var _restart_btn: Button = $Panel/_restart_btn
@onready var timer: Timer = $Timer

func _on_button_pressed() -> void:
	label_2.visible = true
	button_2.visible = true
	audio_stream_player.play()


func _on_button_2_pressed() -> void:
	label_3.visible = true
	button_3.visible = true
	audio_stream_player.play()

func _on_button_3_pressed() -> void:
	label_4.visible = true
	timer.start()
	audio_stream_player.play()


func _on__restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_timer_timeout() -> void:
	label_5.visible = true
	_restart_btn.visible = true
