extends RigidBody2D

@export var SPEED = 1000

var dir : float
var spawnPos : Vector2
var spawnRot : float
@onready var chicken = get_tree().get_root().get_node("game").get_node("Chicken")
const mass_to_scale = 1.5
const min_size = 1


func _ready():
	global_position = spawnPos
	var chicken_velocity = chicken.linear_velocity
	rotation = spawnRot
	var direction_vector = -1 * Vector2(cos(dir), sin(dir))
	linear_velocity = chicken_velocity + direction_vector * SPEED
	chicken.apply_impulse(-direction_vector * SPEED * mass)

func _process(delta):
	scale = Vector2(mass_to_scale * sqrt(mass) + min_size, mass_to_scale * sqrt(mass) + min_size)
