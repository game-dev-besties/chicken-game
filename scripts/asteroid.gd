extends RigidBody2D
var base_scale = 10

func initialize(position: Vector2, drift_velocity: Vector2, angular_velocity: float):
	self.position = position
	self.linear_velocity = drift_velocity
	self.angular_velocity = angular_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var animations = ["asteroid1", "asteroid2", "asteroid3", "asteroid4", "asteroid5", "asteroid6", "asteroid7", "asteroid8", "rock1", "rock2", "rock3", "rock4", "rock5", "rock6", "rock7", "rock8", "shard1", "shard2", "shard3", "shard4", "shard5", "shard6"]
	var kinds = animations[randi()% animations.size()]
	$AnimationPlayer.play(kinds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#scale_by_mass()
	scale_asteroids()
	
func modify_mass(amount: float):
	mass += amount

func scale_asteroids():
	$Sprite2D.scale = Vector2(pow(mass, 1.0/3.0), pow(mass, 1.0/3.0))/base_scale
	$CollisionPolygon2D.scale = Vector2(pow(mass, 1.0/3.0),  pow(mass, 1.0/3.0))/base_scale
	$CollisionPolygon2D2.scale = Vector2(pow(mass, 1.0/3.0),  pow(mass, 1.0/3.0))/base_scale
	#self.linear_velocity *= 1-(1/mass)
#func scale_by_mass():
	#$Sprite2D.scale = Vector2(pow(mass, 1.0/3.0), pow(mass, 1.0/3.0))
#	$CollisionShape2D.scale = Vector2(pow(mass, 1.0/3.0), pow(mass, 1.0/3.0))
