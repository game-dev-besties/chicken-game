class_name Character
extends RigidBody2D

@export var velo : float
@export var angle : int


@onready var main = get_tree().get_root().get_node("game")
@onready var anim_sprite = $AnimationPlayer
@onready var warning = load("res://scenes/warning.tscn")
#var arrow = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("arrow")

@export var projectile: PackedScene
@export var min_mass: float = 10
@export var minimum_mass_for_medium_sprite: float = 5
@export var minimum_mass_for_fat_sprite: float = 10
@export var minimum_charge_time_for_lay_sprite: float = 2
@export var max_charge_time: float = 2.0
@export var gravitational_constant: float = 5e6

const MASS_WHEN_TOO_SMALL = 2

#chicken
var can_lay = true
var is_eating = false
var has_clicked = false
var mass_to_scale = 0.4
var eat_cooldown_start = false
#egg
@export var charging: bool = false
@export var charge_time: float = 0.0

# Cooldown timer:
var lay_timer = 0.4

var asteroids = []
var eating = []
var touching = []
var smooth_mass = mass
var target_mass = mass

func _ready():
	# Zero the velocity when the chicken starts
	velo = 0
	linear_velocity = Vector2(0,0)
	
	
#Shoot Egg
func _input(event):
	if Input.is_action_just_pressed("eat"):
		attempt_to_eat()
	if mass < MASS_WHEN_TOO_SMALL:
		if Input.is_action_just_pressed("click"):
			var warning_instance = warning.instantiate()
			warning_instance.initialize_warning(position, linear_velocity)
			main.add_child(warning_instance)
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

	smooth_mass = lerp(smooth_mass, target_mass, 8 * delta)
	mass = smooth_mass

	# Update the charge time if we are currently charging a new egg
	if charging:
		charge_time += delta
		charge_time = min(charge_time, max_charge_time)
		
	#
	#if charging:
		##print(charge_time)
		#if charge_time <= 0.5:
			#arrow.self_modulate.a = 0.25
		##if charge_time <= 0.25:
			##arrow.self_modulate.a = 0.125
		##elif charge_time <= 0.5:
			##arrow.self_modulate.a = 0.25
		##elif charge_time <= 0.75:
			##arrow.self_modulate.a = 0.375
		#elif charge_time <= 1:
			#arrow.self_modulate.a = 0.5
		##elif charge_time <= 1.25:
			##arrow.self_modulate.a = 0.625
		#elif charge_time <= 1.5:
			#arrow.self_modulate.a = 0.75
		##elif charge_time <= 1.75:
			##arrow.self_modulate.a = 0.875
		#elif charge_time <= 2:
			#arrow.self_modulate.a = 1

	# Choose the sprite to use based on the chicken's current mass, whether or not it is charging, and the charge time
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
		#arrow.show()
		#arrow.self_modulate.a = charge_time / 2
	elif is_eating:
		if mass < minimum_mass_for_medium_sprite:
			anim_sprite.play("small_wing_start")
		elif mass < minimum_mass_for_fat_sprite:
			anim_sprite.play("med_wing_start")
		else:
			anim_sprite.play("fat_wing_start")
	else: 
		if mass < minimum_mass_for_medium_sprite:
			anim_sprite.play("small_idle")
		elif mass < minimum_mass_for_fat_sprite:
			anim_sprite.play("med_idle")
		else:
			anim_sprite.play("fat_idle")
		#arrow.hide()

	lay_timer += delta


func shoot_projectile():
	# Create and initialize a new egg projectile
	var instance = projectile.instantiate()
	var charge_ratio = charge_time / max_charge_time
	charge_time = lay_timer - 0.4
	instance.initialize_egg(charge_ratio, self)
	main.add_child(instance)

	# Decrease the mass of the chicken to account for the new egg
	#print(str("Chicken: " + str(mass)))
	target_mass -= instance.mass
	var eggparticles = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("particlesSprite").get_node("particles")
	var delta = mass * 2
	
	#eggparticles.position.y = 540 + delta * cos(rotation)
	#eggparticles.position.x = 960 - delta * sin(rotation)
	#eggparticles.rotation = rotation
	eggparticles.emitting = true
	
	#print(instance.scale)
	
	#print("Chicken: " + str(mass) + ", Egg: " +  str(instance.mass))

	
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
	var temp = linear_velocity.angle() * 180 / PI
	angle = int(temp) % 360
	if angle < 0:
		angle = 360 + angle
	

func getVelo():
	return velo

func getAngle():
	return angle;


func _on_cooldown_timeout():
	is_eating = false # Replace with function body.
	eat_cooldown_start = false

func scale_by_mass():
	$AnimatedSprite2D.scale = Vector2(mass_to_scale * pow(mass, 1.0/3.0), mass_to_scale * pow(mass, 1.0/3.0))
	$CollisionPolygon2D.scale = Vector2(mass_to_scale * pow(mass, 1.0/3.0), mass_to_scale * pow(mass, 1.0/3.0))
	$Area2D/CollisionShape2D.scale = Vector2(4 / pow(mass, 1.0/5.0), 4 / pow(mass, 1.0/5.0))
	$"Eating Circle".scale = Vector2(mass_to_scale * pow(mass, 1.0/3.0),mass_to_scale * pow(mass, 1.0/3.0))
	$"Area2D".scale = Vector2(mass_to_scale * pow(mass, 1.0/3.0),mass_to_scale * pow(mass, 1.0/3.0))
#messy gravity

func _on_area_2d_body_entered(body):
	#print(asteroids)
	#print("min", get_closest_asteroid())
	asteroids.append(body)
	#print("added")
	
func _on_area_2d_body_exited(body):
	asteroids.erase(body)
	
func _on_eating_circle_body_entered(body):
	eating.append(body)

func _on_eating_circle_body_exited(body):
	eating.erase(body)

	
func get_closest_asteroid():
	var closest_asteroid = null
	var min_distance = INF
	for asteroid in asteroids:
		var distance = global_position.distance_to(asteroid.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_asteroid = asteroid
	return closest_asteroid
	
func get_closest_eating():
	var closest_asteroid = null
	var min_distance = INF
	for asteroid in eating:
		var distance = global_position.distance_to(asteroid.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_asteroid = asteroid
	return closest_asteroid
	
func gravity(target: RigidBody2D, delta: float):
	if not target:
		return
	var direction = (target.global_position - global_position).normalized()
	var distance = (target.global_position - global_position).length() # Replace with function body.global_position).length()
	var force_magnitude = (gravitational_constant * target.mass * self.mass) / (pow(distance, 2))
	var force = force_magnitude * direction
	#print("Force ", force)
	target.linear_velocity *= (1/target.mass)
	if target.mass >= self.mass/3:
		self.apply_force(force)
		if touching.size() > 0:
			self.apply_force(-force)
	elif target.mass < self.mass/3:
		#print("im bigger")
		#if eating.size() > 0:
			#target.linear_velocity *= 0.2
			#target.angular_velocity *= 0.2
		#else:
		target.apply_force((force)/2)
		#target.angular_velocity *= 0.99
	
 #Eating Asteroid code


func attempt_to_eat():
	if eating.size() == 0:
		is_eating = false
		return
	is_eating = true
	if not eat_cooldown_start:
		$Cooldown.start()
		eat_cooldown_start = true
	var eating_asteroid = get_closest_eating()
	var eating_distance = global_position.distance_to(eating_asteroid.global_position)
	# Can only eat an asteroid inside our eating circle
	# Our chicken is insane and eats half of it's own body weight with each bite
	var mass_to_eat = mass * 0.1
	if eating_asteroid.mass > mass_to_eat:
		target_mass += mass_to_eat
		eating_asteroid.mass -= mass_to_eat
		var asteroid_particles = eating_asteroid.get_node("AsteroidParticles")
		asteroid_particles.emitting = true
		eating_asteroid.get_node("AnimationPlayer").play("eat_asteroid")
	else:
		target_mass += eating_asteroid.mass
		eating_asteroid.queue_free()
	
	

func _on_normal_force_body_entered(body):
	#print(touching)
	touching.append(body) # Replace with function body.

func _on_normal_force_body_exited(body):
	touching.erase(body) # Replace with function body.
