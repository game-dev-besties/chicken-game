class_name Character
extends RigidBody2D

@export var velo : float
@export var angle : int


@onready var main = get_tree().get_root().get_node("game")
@onready var anim_sprite = $AnimatedSprite2D

@export var projectile: PackedScene
@export var min_mass: float = 10
@export var minimum_mass_for_medium_sprite: float = 5
@export var minimum_mass_for_fat_sprite: float = 10
@export var minimum_charge_time_for_lay_sprite: float = 2
@export var max_charge_time: float = 2.0


#chicken
var can_lay = true
var has_clicked = false
var mass_to_scale = 0.3
#egg
var charging = false
var charge_time = 0.0

# Cooldown timer:
var lay_timer = 0.4

func _ready():
	# Zero the velocity when the chicken starts
	velo = 0
	linear_velocity = Vector2(0,0)
	
	
#Shoot Egg
func _input(event):
	if Input.is_action_just_pressed("click"):
		charging = true
		if lay_timer <= 0.4:
			charge_time = lay_timer - 0.4
		else:
			charge_time = 0
	elif Input.is_action_just_released("click"):
		if charge_time >= 0:
			lay_timer = 0
			charging = false
			shoot_projectile()
		else:
			charging = false

func _process(delta):
	
	# Update the charge time if we are currently charging a new egg
	if charging:
		charge_time += delta
		charge_time = clamp(charge_time, 0, max_charge_time)

	# Choose the sprite to use based on the chicken's current mass, whether or not it is charging, and the charge time
	if charging:
		if mass < minimum_mass_for_medium_sprite:
			if charge_time >= minimum_charge_time_for_lay_sprite: 
				anim_sprite.play("small_max")
			else: 
				anim_sprite.play("small_lay")
		else:
			if charge_time >= minimum_charge_time_for_lay_sprite: 
				anim_sprite.play("fat_max")
			else: 
				anim_sprite.play("fat_lay")
	else: 
		if mass < minimum_mass_for_medium_sprite:
			anim_sprite.play("small_idle")
		elif mass < minimum_mass_for_fat_sprite:
			anim_sprite.play("med_idle")
		else:
			anim_sprite.play("fat_idle")

	lay_timer += delta


func shoot_projectile():
	# Create and initialize a new egg projectile
	var instance = projectile.instantiate()
	var charge_ratio = charge_time / max_charge_time
	instance.initialize_egg(charge_ratio, self)
	main.add_child(instance)

	# Decrease the mass of the chicken to account for the new egg
	mass -= instance.mass

	
 #Physics for chicken
func _physics_process(delta): 

	# Have chicken's rotation follow the mouse cursor
	var dir = position.direction_to(get_global_mouse_position())
	rotation = lerp_angle(rotation, dir.angle()+PI/2, 5 * delta)

	# Scale the chicken visually based on the mass
	scale_by_mass()
	
	# Set velo to the magnitude of the velocity to be used by the HUD
	# Same for angle
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

func scale_by_mass():
	scale = Vector2(mass_to_scale * sqrt(mass), mass_to_scale * sqrt(mass))
