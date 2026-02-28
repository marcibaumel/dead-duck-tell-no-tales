extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var current_recording: Dictionary = {}
var count = 0
var is_recording = false

func do_record():
	count += 1
	current_recording[count] = [anim.animation, global_position, anim.flip_h]    
	
	if Input.is_action_just_pressed("ui_down"):
		Recorder.saved_recording = current_recording.duplicate(true)
		print("Saved recording to memory!")

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_left")):
		print("Recording")
		is_recording = true
	
	if(is_recording):
		print("Recording")
		if current_recording.size() > 0:
			var keys = current_recording.keys()
			var last_key = keys[-1]
			var last_value = current_recording[last_key]
			print(last_value)
		do_record()
	
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
		
	if Input.is_action_just_pressed("ui_up"):
		if not Recorder.saved_recording.is_empty():
			get_tree().call_group("ghosts", "queue_free")
			
			var ghost = preload("res://scenes/Ghost.tscn")
			var load_ghost = ghost.instantiate()
			
			load_ghost.add_to_group("ghosts")
			get_parent().call_deferred("add_child", load_ghost)
