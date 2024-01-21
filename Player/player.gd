extends CharacterBody2D

var movement_speed = 100.0
var HP = 100.0

#Attacks
var Spear = preload("res://Player/Attack/spear.tscn")

#AttackNodes
@onready var SpearTimer = get_node("%SpearTimer")
@onready var SpearAttackTimer = get_node("%SpearAttackTimer")

#SPear
var spear_ammo = 0
var spear_baseammo = 1
var spear_attackspeed = 1.5
var spear_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var Walk_Timer = get_node("Walk_Timer")

func _ready():
	attack()
	

func attack():
	if spear_level > 0:
		SpearTimer.wait_time = spear_attackspeed
		if SpearTimer.is_stopped():
			SpearTimer.start()

func _physics_process(delta):
	movement()

func movement():
	var x_movement = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement = Input.get_action_strength("down") - Input.get_action_strength("up")
	var movement = Vector2(x_movement,y_movement)
	
	if movement.x > 0:
		sprite.flip_h = true
	elif movement.x < 0:
		sprite.flip_h = false
		
	if movement != Vector2.ZERO:
		if Walk_Timer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			Walk_Timer.start()
	
	velocity = movement.normalized()*movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage):
	HP -= damage
	print(HP)


func _on_spear_timer_timeout():
	spear_ammo += spear_baseammo
	SpearAttackTimer.start()

func _on_spear_attack_timer_timeout():
	if spear_ammo > 0:
		var spear_attack = Spear.instantiate()
		spear_attack.position = position
		spear_attack.target = get_random_target()
		spear_attack.level = spear_level
		add_child(spear_attack)
		spear_ammo -= 1
		if spear_ammo > 0:
			SpearAttackTimer.start()
		else:
			SpearAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
