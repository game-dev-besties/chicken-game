
extends Camera2D
var chicken
var base = 0.5
var smooth_zoom = 0.5
var desiredFov: float
var target_zoom: float
# Called when the node enters the scene tree for the first time.
func _ready():
	chicken = get_tree().get_root().get_node("game").get_node("Chicken")
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target_zoom = 1.0 / (pow((chicken.mass / 10.0), 1.0/3.0))
	#zoom = Vector2(target_zoom, target_zoom)
	smooth_zoom = lerp(smooth_zoom, target_zoom, 5*delta)
	zoom = Vector2(smooth_zoom, smooth_zoom)
