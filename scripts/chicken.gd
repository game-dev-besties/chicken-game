class_name Character
extends RigidBody2D

@export var velo : float
@export var angle : int


@onready var main = get_tree().get_root().get_node("game")
@onready var projectile = load("res://scenes/egg.tscn")
@onready var anim_sprite = $AnimatedSprite2D


#chicken
const SPEED = 10000.0
var can_lay = true
var has_clicked = false
var growth_rate = 0.5
var power = 0
var size = 10
var sohan = 0.1
#egg
var charging = false
var charge_time = 0.0
var max_charge_time = 2.0 # Time in seconds to fully charge
var density = 5

# chicken movement:
var lay_timer = 0.4

func _ready():
	velo = 0
	linear_velocity = Vector2()
	
#Shoot Egg
func _input(event):
	if Input.is_action_just_pressed("click"):
		charging = true
		charge_time = min(0.0,lay_timer - 0.4)
	elif Input.is_action_just_released("click"):
		lay_timer = 0
		charging = false
		$Cooldown.start()
		shoot_projectile()
		
	  

func _process(delta):
	if charging:
		## loading the animations, as of rn animations for med still needed
		if size >=1 && size < 5:
			if charge_time >= 2: 
				anim_sprite.play("small_max")
			else: 
				anim_sprite.play("small_lay")
		elif size >= 5 && size < 10:
			if charge_time >= 2: 
				anim_sprite.play("fat_max")
			else: 
				anim_sprite.play("fat_lay")
		elif size >= 10: 
			if charge_time >= 2: 
				anim_sprite.play("fat_max")
			else: 
				anim_sprite.play("fat_lay")
		charge_time += delta
		charge_time = clamp(charge_time, 0, max_charge_time)
		
	else: 
		if size >=1 && size < 5:
			anim_sprite.play("small_idle")	
		elif size >= 5 && size < 10:
			anim_sprite.play("med_idle")
		elif size >= 10: 
			anim_sprite.play("fat_idle")
	lay_timer += delta
	


func shoot_projectile():
	var instance = projectile.instantiate()
	
	instance.dir = rotation - PI / 2
	instance.spawnPos = position
	instance.spawnRot = rotation
	var charge_ratio = charge_time / max_charge_time
	instance.scale = Vector2(1 + charge_ratio, 1 + charge_ratio)
	instance.mass = density * charge_ratio
	
	main.add_child(instance)
	mass -= instance.mass

	
 #Physics for chicken
func _physics_process(delta): 
	var dir = position.direction_to(get_global_mouse_position())
	rotation = lerp_angle(rotation, dir.angle()+PI/2, 5 * delta)
	
	
	velo = linear_velocity.length()
	var temp = rotation * 180 / PI
	angle = int(temp) % 360
	if angle < 0:
		angle = 360 + angle
	

func getVelo():
	return velo

func getAngle():
	return angle;


func _on_cooldown_timeout():
	can_lay = true # Replace with function body.
