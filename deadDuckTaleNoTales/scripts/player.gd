extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		anim.animation = "jump"
		velocity += get_gravity() * delta
	elif velocity.x != 0:
		anim.animation = "run"
	else:
		anim.animation = "idle"

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if direction == 1.0:
		anim.flip_h = false
	if direction == -1.0:
		anim.flip_h = true
