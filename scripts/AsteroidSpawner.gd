extends Node2D

@export var min_radius: float
@export var max_radius: float 
@export var max_drift_velocity: float
@export var max_angular_velocity: float
@export var desired_number_of_asteroids: int
@onready var asteroids = %Asteroids
@onready var chicken = get_tree().get_root().get_node("game").get_node("Chicken")

var rng = RandomNumberGenerator.new()

@export var asteroid_scene: PackedScene

var num_asteroids = 0

func spawn_asteroid():
	if not asteroids:
		print("Asteroid Spawning: Couldn't find container node for asteroids")
		return
	# Randomly choose where to generate the asteroid
	#min_radius = get_viewport_rect().size.x
	var radius: float = rng.randf_range(min_radius, max_radius)
	print(radius)
	var angle: float = rng.randf_range(0, 2*PI)
	
	var drift_velocity_x: float = rng.randf_range(-max_drift_velocity, max_drift_velocity)
	var drift_velocity_y: float = rng.randf_range(-max_drift_velocity, max_drift_velocity)
	var angular_velocity: float = rng.randf_range(-max_angular_velocity, max_angular_velocity) 
	
	# Instantiate a new asteroid and give it a random drift velocity/angular velocity
	var new_asteroid = asteroid_scene.instantiate()
	new_asteroid.initialize(Vector2(chicken.position.x + radius * cos(angle), chicken.position.y + radius * sin(angle)), Vector2(drift_velocity_x, drift_velocity_y), angular_velocity)
	asteroids.add_child(new_asteroid)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale_asteroids()
	if num_asteroids < desired_number_of_asteroids:
		for i in range(desired_number_of_asteroids-num_asteroids):
			num_asteroids += 1
			spawn_asteroid()
			


func _on_asteroid_live_zone_body_exited(body: Node2D):
	min_radius = 1000
	num_asteroids -= 1
	body.queue_free()
	
func scale_asteroids():
	for asteroid in asteroids.get_children():
		asteroid.get_node("Sprite2D").scale = Vector2(1.0 * asteroid.mass, 1.0 * asteroid.mass)
		asteroid.get_node("CollisionPolygon2D").scale = Vector2(asteroid.mass, asteroid.mass)
		asteroid.get_node("CollisionPolygon2D2").scale = Vector2(asteroid.mass, asteroid.mass)
		#asteroid.CollisionShape2D.scale = Vector2(1.0 / Global.scale, 1.0 / Global.scale)
		#create new collision shape of correct size
		#var collision_shape = asteroid.get_node("CollisionPoly2D") as CollisionShape2D
		#
		#(collision_shape.shape as CircleShape2D).radius = 40/Global.scale
		
		
		
		# print("Collision Shape", collision_shape.shape)
		#STEPHEN, PROBLEM IS HERE.
		#i have two theories, 1. this code messes with the astroid live box node
		#2. the collisions for each individual asteroid is messed up and cannot detect if it is touching the live box
	
