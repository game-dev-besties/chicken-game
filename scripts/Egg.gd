extends RigidBody2D

@export var SPEED = 1000

var dir : float
var spawnPos : Vector2
var spawnRot : float
const mass_to_scale = 1.5
const min_size = 1
var mass_multiplicative_constant = 0.3


func _ready():
	var chicken = get_tree().get_root().get_node("game").get_node("Chicken")
	global_position = spawnPos
	#global_position += Vector2(0,chicken.mass*35).rotated(spawnRot)
	var chicken_offset = chicken.mass_to_scale*pow(chicken.mass, 1.0/3.0)
	#print(chicken_offset)
	global_position += Vector2(0,chicken_offset*250).rotated(spawnRot)
	var chicken_velocity = chicken.linear_velocity
	rotation = spawnRot
	var direction_vector = -1 * Vector2(cos(dir), sin(dir))
	linear_velocity = chicken_velocity + direction_vector * SPEED
	chicken.apply_impulse(-direction_vector * SPEED * mass)
	var particles = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("particlesSprite").get_node("particles")
	var camera = get_tree().get_root().get_node("game").get_node("Chicken").get_node("Camera2D")
	particles.scale_amount_max = sqrt(mass) / 13 * camera.zoom.length()
	particles.scale_amount_min = sqrt(mass) / 25 * camera.zoom.length()


func initialize_egg(charge_ratio, chicken):
	dir = chicken.rotation - PI / 2
	spawnPos = chicken.position
	spawnRot = chicken.rotation
	mass = chicken.mass * charge_ratio * mass_multiplicative_constant



func _process(delta):
	scale = Vector2(mass_to_scale * sqrt(mass) + min_size, mass_to_scale * sqrt(mass) + min_size)
