extends RigidBody2D


func initialize(position: Vector2, drift_velocity: Vector2, angular_velocity: float):
	self.position = position
	self.linear_velocity = drift_velocity
	self.angular_velocity = angular_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var animations = ["asteroid1", "asteroid2", "asteroid3", "asteroid4", "asteroid5", "asteroid6", "asteroid7", "asteroid8"]
	var kinds = animations[randi()% animations.size()]
#	$Sprite2D.play(kinds)11



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
