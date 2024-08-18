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

const MASS_WHEN_TOO_SMALL = 2

#chicken
var can_lay = true
var has_clicked = false
var mass_to_scale = 0.3
#egg
var charging = false
var charge_time = 0.0

# Cooldown timer:
var lay_timer = 0.4

var asteroids = []

func _ready():
	# Zero the velocity when the chicken starts
	velo = 0
	linear_velocity = Vector2(0,0)
	
	
#Shoot Egg
func _input(event):
	if mass < MASS_WHEN_TOO_SMALL:
		return
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
		charge_time = min(charge_time, max_charge_time)

	# Choose the sprite to use based on the chicken's current mass, whether or not it is charging, and the charge time
	if charging:
		if mass < minimum_mass_for_medium_sprite:
			if charge_time >= minimum_charge_time_for_lay_sprite: 
				anim_sprite.play("small_max")
			else: 
				anim_sprite.play("small_lay")
		elif mass < minimum_mass_for_fat_sprite:
			if charge_time >= minimum_charge_time_for_lay_sprite: 
				anim_sprite.play("med_max")
			else: 
				anim_sprite.play("med_lay")
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
	print(str("Chicken: " + str(mass)))
	mass -= instance.mass
	print("Chicken: " + str(mass) + ", Egg: " +  str(instance.mass))

	
 #Physics for chicken
func _physics_process(delta): 
	if asteroids.size() > 0:
		gravity(get_closest_asteroid(), delta)
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
	$AnimatedSprite2D.scale = Vector2(mass_to_scale * pow(mass, 1.0/3.0), mass_to_scale * pow(mass, 1.0/3.0))
	$CollisionShape2D.scale = Vector2(mass_to_scale * pow(mass, 1.0/3.0), mass_to_scale * pow(mass, 1.0/3.0))
	$AsteroidSpawning/AsteroidLiveZone/CollisionShape2D.scale= Vector2(pow(mass, 1.0/3.0), pow(mass, 1.0/3.0))
	$Area2D/CollisionShape2D.scale = Vector2(5 / pow(mass, 1.0/5.0), 5 / pow(mass, 1.0/5.0))
#messy gravity

func _on_area_2d_body_entered(body):
	#print(asteroids)
	#print("min", get_closest_asteroid())
	asteroids.append(body)
	#print("added")
func _on_area_2d_body_exited(body):
	asteroids.erase(body)
func get_closest_asteroid():
	var closest_asteroid = null
	var min_distance = INF
	for asteroid in asteroids:
		var distance = global_position.distance_to(asteroid.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_asteroid = asteroid
	return closest_asteroid
func gravity(target: Node2D, delta: float):
	var direction = (target.global_position - global_position).normalized()
	var force = 1.0
	force = (target.mass * self.mass)/(pow(abs(global_position.direction_to(target.global_position).length()),2))
	var gravity_ratio:float = 0.9999-(0.0001*force)
	if(1 == 1):
		#print(force)
		linear_velocity*=gravity_ratio
		position += direction * force * delta
