extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var disable_timer: Timer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0:
					collision_shape_2d.call_deferred("set", "disabled", true)
					disable_timer.start()
				1:
					pass
				2:
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit()

func _on_disable_timer_timeout() -> void:
	collision_shape_2d.call_deferred("set", "disabled", false)
