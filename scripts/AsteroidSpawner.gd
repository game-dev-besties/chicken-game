extends Node2D

@export var min_radius: float
@export var max_radius: float
@export var max_drift_velocity: float
@export var max_angular_velocity: float
@export var desired_number_of_asteroids: int
@onready var asteroids = %Asteroids
var rng = RandomNumberGenerator.new()

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
	new_asteroid.initialize(Vector2(radius * cos(angle), radius * sin(angle)), Vector2(drift_velocity_x, drift_velocity_y), angular_velocity)
	
	asteroids.add_child(new_asteroid)
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if num_asteroids < desired_number_of_asteroids:
		for i in range(desired_number_of_asteroids-num_asteroids):
			num_asteroids += 1
			spawn_asteroid()
			scale_asteroids()



func _on_asteroid_live_zone_body_exited(body: Node2D):
	num_asteroids -= 1
	# Delete the asteroid
	body.queue_free()
	
func scale_asteroids():
	for asteroid in asteroids.get_children():
		asteroid.scale = Vector2(1.0 / Global.scale, 1.0 / Global.scale)
