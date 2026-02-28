extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var load_data: Dictionary = {}
var count = 0

func _ready():
	# Grab the data directly from the Autoload
	load_data = Recorder.saved_recording

func _physics_process(delta: float) -> void:
	get_recording()


func get_recording():
	count += 1
	var test = load_data.get(count) 
	
	if test != null:
		anim.play(test[0])
		global_position = test[1] 
		anim.flip_h = test[2]
	else:
		queue_free()
