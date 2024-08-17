class_name Character
extends CharacterBody2D

@export var velo : float
@export var angle : int


@onready var main = get_tree().get_root().get_node("game")
@onready var projectile = load("res://scenes/egg.tscn")

#chicken
const SPEED = 10000.0
#egg
const egg_speed = 100
var charging = false
var charge_time = 0.0
var max_charge_time = 2.0 # Time in seconds to fully charge
var power = 0.0

func _ready():
	velo = 0
	pass
#Shoot Egg
func _input(event):
	if Input.is_action_just_pressed("click"):
		print("charging")
		charging = true
		charge_time = 0.0
	elif Input.is_action_just_released("click"):
		print("hello mommy")
		charging = false
		shoot_projectile()        
			
func _process(delta):
	if charging:
		charge_time += delta
		charge_time = clamp(charge_time, 0, max_charge_time)
func shoot_projectile():
	var instance = projectile.instantiate()
	instance.dir = rotation + PI / 2
	instance.spawnPos = position
	var charge_ratio = charge_time / max_charge_time
	print("Power: ",charge_ratio)
	instance.scale = Vector2(1 + charge_ratio, 1 + charge_ratio)
	main.add_child(instance)
	
 #Physics for chicken
func _physics_process(delta): 
	var dir = position.direction_to(get_global_mouse_position())
	rotation = lerp_angle(rotation, dir.angle()-PI/2, 5 * delta)
	if Input.is_action_just_released("click"):
		velocity +=  dir * SPEED * delta
	position += velocity * delta
	velo = velocity.length()
	var temp = rotation * 180 / PI
	angle = int(temp) % 360
	if angle < 0:
		angle = 360 + angle

func getVelo():
	return velo

func getAngle():
	return angle;
