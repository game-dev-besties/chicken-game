extends RigidBody2D
var base_scale = 2
@export var scaling = Vector2(pow(mass, 1.0/3.0), pow(mass, 1.0/3.0))/base_scale
var target = mass
var scale_mass = mass

func initialize(position: Vector2, drift_velocity: Vector2, angular_velocity: float):
	self.position = position
	self.linear_velocity = drift_velocity
	self.angular_velocity = angular_velocity
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type","planet")
	randomize()
	var animations = ["earth1", "planet1", "planet2", "planet3", "planet4", "planet5", "planet6", "planet7", "rings1", "rings2", "rings3", "rings4", "rings5", "moon1", "moon2", "moon3", "moon4", "moon5"]
	var kinds = animations[randi()% animations.size()]
	$AnimationPlayer.play(kinds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target = mass
	scale_mass = lerp(scale_mass, target, 10 * delta)
	scaling = Vector2(pow(scale_mass, 1.0/3.0), pow(scale_mass, 1.0/3.0))/base_scale
	scale_by_mass()
	
func modify_mass(amount: float):
	mass += amount

func scale_by_mass():
	$Sprite2D.scale = scaling
	#$RockShape.scale = scaling
	#$ShardShape.scale = scaling
	#$AsteroidShape.scale = scaling
	$Earth.scale = scaling
	$Planet.scale = scaling
	$Moon.scale = scaling
	$Rings.scale = scaling
