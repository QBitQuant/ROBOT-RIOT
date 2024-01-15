extends Area2D

@export var damage = 1
@onready var Collision = $CollisionShape2D
@onready var Disable_Timer = $Disable_HitHox_Timer

func tempDisable():
	Collision.call_deferred("set", "disabled", true)
	Disable_Timer.start()
	

func _on_disable_hit_hox_timer_timeout():
	Collision.call_deferred("set", "disabled", false)
