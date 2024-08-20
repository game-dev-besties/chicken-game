extends Node2D

@export var spawn_radius_padding_scalar: float = 5000
@export var distance_from_min_to_max_radius_scalar: float = 5000
@export var max_drift_velocity: float
@export var max_angular_velocity: float
@export var desired_number_of_objects: int
@onready var objects = %Planets
@onready var chicken = get_tree().get_root().get_node("game").get_node("Chicken")

var rng = RandomNumberGenerator.new()
var min_radius: float = 0
var max_radius: float = 20000
var min_mass: float = 500
var max_mass: float = 1000

@export var object_scene: PackedScene = load("res://scenes/planets/planet.tscn")

var num_objects = 0

var live_zone 

func spawn_object():
	if not objects:
		print("Object Spawning: Couldn't find container node for objects")
		return
	# Randomly choose where to generate the asteroid
	var radius: float = rng.randf_range(min_radius, max_radius)
	var angle: float = rng.randf_range(0, 2*PI)
	
	var drift_velocity_x: float = rng.randf_range(-max_drift_velocity, max_drift_velocity)
	var drift_velocity_y: float = rng.randf_range(-max_drift_velocity, max_drift_velocity)
	drift_velocity_x = 5
	drift_velocity_y = 5
	var angular_velocity: float = rng.randf_range(-max_angular_velocity, max_angular_velocity) 
	var spawn_pos = Vector2(chicken.position.x + radius * cos(angle), chicken.position.y + radius * sin(angle))
	var obj_mass = rng.randf_range(min_mass,max_mass)
	#var check_radius = Vector2(pow(obj_mass, 1.0/3.0), pow(obj_mass, 1.0/3.0))/.3
	if(Global.check_collisions(spawn_pos, 10000).size() > 0):
		return
	# Instantiate a new asteroid and give it a random drift velocity/angular velocity
	var new_object = object_scene.instantiate()
	new_object.initialize(Vector2(chicken.position.x + radius * cos(angle), chicken.position.y + radius * sin(angle)), Vector2(drift_velocity_x, drift_velocity_y), angular_velocity)
	new_object.mass=obj_mass
	objects.add_child(new_object)
	num_objects += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	live_zone = $planet_live_zone/CollisionShape2D
	var scalingzone = 1 * pow(chicken.mass, 1.0/3.0)
	var max_radius = live_zone.shape.radius
	live_zone.scale = Vector2(scalingzone,scalingzone*1.8)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scalingzone = 1 * pow(chicken.mass, 1.0/3.0)
	max_radius = scalingzone * 5000
	min_radius = max_radius/3
	desired_number_of_objects = max_radius/3000
	#print(desired_number_of_objects)
	desired_number_of_objects = int(clamp(desired_number_of_objects, 0, 20))
	live_zone.scale = Vector2(scalingzone,scalingzone*1.8)
	if num_objects < desired_number_of_objects:
		for i in range(desired_number_of_objects-num_objects):
			spawn_object()

func _on_planet_live_zone_body_exited(body):
	if body.get_meta("type") == "planet":
		min_radius = 1000
		num_objects -= 1
		body.queue_free()
	#pass # Replace with function body.
