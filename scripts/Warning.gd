extends Label

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Despawn.start # Replace with function body.

	
func _physics_process(delta):
	modulate.a -= 0.01
	
	position += velocity * delta
	position.y -= 200 * delta
	
func initialize_warning(chicken_position, chicken_velocity):
	position = chicken_position
	velocity = chicken_velocity
	

func _on_despawn_timeout():
	queue_free()
