extends Node2D

@export var spawn_radius_padding_scalar: float = 5000
@export var distance_from_min_to_max_radius_scalar: float = 5000
@export var max_drift_velocity: float
@export var max_angular_velocity: float
@export var desired_number_of_asteroids: int
@onready var asteroids = %Asteroids
@onready var chicken = get_tree().get_root().get_node("game").get_node("Chicken")

var rng = RandomNumberGenerator.new()
var min_radius: float = 800
var max_radius: float = 1200

@export var asteroid_scene: PackedScene

var num_asteroids = 0

func spawn_asteroid():
	if not asteroids:
		print("Asteroid Spawning: Couldn't find container node for asteroids")
		return
	# Randomly choose where to generate the asteroid
	var radius: float = rng.randf_range(min_radius, max_radius)
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
	update_scale_for_viewport_size()
	scale_asteroids()
	if num_asteroids < desired_number_of_asteroids:
		for i in range(desired_number_of_asteroids-num_asteroids):
			num_asteroids += 1
			spawn_asteroid()
			print("add ", num_asteroids)

# Update the inner/outer radii and live zone size to match the current viewport and ensure asteroid spawning and despawning only happen outside the viewport
func update_scale_for_viewport_size():
	var viewport_to_global: Transform2D = (get_viewport().global_canvas_transform * get_viewport().get_camera_2d().get_canvas_transform()).affine_inverse()
	var global_rect = viewport_to_global * get_viewport_rect()
	
	var width: float = global_rect.size.x
	var height: float = global_rect.size.y

	# Set the inner radius to the maximum viewport dimension (either width or height) with some additive constant added to it
	min_radius = max(width,height) + spawn_radius_padding_scalar * get_viewport().get_camera_2d().zoom.x

	# Set the outer radius to some constant distance away from the inner radius
	max_radius = min_radius + get_viewport().get_camera_2d().zoom.x * distance_from_min_to_max_radius_scalar

	# Set the live zone to be up to the outer radius. We do need to make sure we convert the outer radius (which is in global coordinates) into local coordinates
	($AsteroidLiveZone/CollisionShape2D.shape as CircleShape2D).radius = abs(self.to_local(Vector2(max_radius, max_radius)).length())

func _on_asteroid_live_zone_body_exited(body: Node2D):
	min_radius = 1000
	num_asteroids -= 1
	body.queue_free()
	print("remove ", num_asteroids)
	
func scale_asteroids():
	for asteroid in asteroids.get_children():
		asteroid.get_node("Sprite2D").scale = Vector2(1.0 * asteroid.mass, 1.0 * asteroid.mass)
		asteroid.get_node("AsteroidShape").scale = Vector2(asteroid.mass, asteroid.mass)
		asteroid.get_node("RockShape").scale = Vector2(asteroid.mass, asteroid.mass)
		asteroid.get_node("ShardShape").scale = Vector2(asteroid.mass, asteroid.mass)
		#asteroid.CollisionShape2D.scale = Vector2(1.0 / Global.scale, 1.0 / Global.scale)
		#create new collision shape of correct size
		#var collision_shape = asteroid.get_node("CollisionPoly2D") as CollisionShape2D
		#
		#(collision_shape.shape as CircleShape2D).radius = 40/Global.scale
		
		
		
		# print("Collision Shape", collision_shape.shape)
		#STEPHEN, PROBLEM IS HERE.
		#i have two theories, 1. this code messes with the astroid live box node
		#2. the collisions for each individual asteroid is messed up and cannot detect if it is touching the live box
	
