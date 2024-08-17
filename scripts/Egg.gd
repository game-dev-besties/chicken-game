extends CharacterBody2D

@export var SPEED = 500

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos

func _physics_process(delta):
	var chicken = get_tree().get_root().get_node("game").get_node("Chicken")
	var chicken_velocity = chicken.velocity
	
	var direction_vector = -1 * Vector2(cos(dir), sin(dir))
	velocity = chicken_velocity + direction_vector * SPEED
	move_and_slide()
