extends Area2D

@export_enum("Cooldown", "Hit_Once", "Disable_Hit_Box") var Hurt_Box_Type = 0

@onready var Collision = $CollisionShape2D
@onready var Disable_Timer = $Disable_Timer

signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match Hurt_Box_Type:
				0: #Cooldown
					Collision.call_deferred("set", "disabled", true)
					Disable_Timer.start()
				1: #Hit_Once
					pass
				2: #Disable_Hit_Box
					if area.has_method("temp_disable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)

func _on_disable_timer_timeout():
	Collision.call_deferred("set", "disabled", false)
