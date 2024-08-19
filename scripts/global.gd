extends Node


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

var scale = 1.5

func check_collisions(point: Vector2, radius: float) -> Array:
	var space_state = get_tree().get_current_scene().get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()

	query.shape = CircleShape2D.new()
	query.shape.radius = radius
	query.transform.origin = point
	query.exclude = []  # Optionally exclude certain objects from the check

	var result = space_state.intersect_shape(query)

	return result
