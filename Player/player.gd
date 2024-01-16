extends CharacterBody2D

var movement_speed = 100.0
var HP = 100.0
@onready var sprite = $Sprite2D
@onready var Walk_Timer = get_node("Walk_Timer")

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
