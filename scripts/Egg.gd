extends RigidBody2D

@export var SPEED = 1000

var dir : float
var spawnPos : Vector2
var spawnRot : float
const mass_to_scale = 1.5
const min_size = 1
var mass_multiplicative_constant = 0.3

@onready var timer = $Timer

func _ready():
	var chicken = get_tree().get_root().get_node("game").get_node("Chicken")
	global_position = spawnPos
	#global_position += Vector2(0,chicken.mass*35).rotated(spawnRot)
	var chicken_offset = chicken.mass_to_scale*pow(chicken.mass, 1.0/3.0)
	#print(chicken_offset)
	global_position += Vector2(0,chicken_offset*250).rotated(spawnRot)
	var chicken_velocity = chicken.linear_velocity
	rotation = spawnRot
	var relative_angle = PI - acos(Vector2(sin(rotation), cos(rotation)).dot(Vector2(chicken_velocity.normalized())))
	var angle_multiplier = (1.25 * cos(0.5 * relative_angle) + .75)
	var direction_vector = -1 * Vector2(cos(dir), sin(dir))
	var egg_speed_mult = 1 + chicken.getVelo()/1000 
	linear_velocity = chicken_velocity + direction_vector * SPEED * angle_multiplier * egg_speed_mult
	chicken.apply_impulse(-direction_vector * SPEED * mass * angle_multiplier * egg_speed_mult)
	var particles = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("particlesSprite").get_node("particles")
	var camera = get_tree().get_root().get_node("game").get_node("Chicken").get_node("Camera2D")
	particles.scale_amount_max = sqrt(mass) / 13 * camera.zoom.length()
	particles.scale_amount_min = sqrt(mass) / 25 * camera.zoom.length()
	
	timer.start()


func initialize_egg(charge_ratio, chicken):
	dir = chicken.rotation - PI / 2
	spawnPos = chicken.position
	spawnRot = chicken.rotation
	mass = chicken.mass * charge_ratio * mass_multiplicative_constant
	mass *= 1/pow(chicken.mass,0.1)



func _process(delta):
	scale = Vector2(mass_to_scale * sqrt(mass) + min_size, mass_to_scale * sqrt(mass) + min_size)


func _on_timer_timeout():
	self.queue_free()
