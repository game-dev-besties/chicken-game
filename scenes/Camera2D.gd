
extends Camera2D
var chicken
var base = 0.5
var smooth_zoom = 0.0
var desiredFov: float
var target_zoom: float
# Called when the node enters the scene tree for the first time.
func _ready():
	chicken = get_tree().get_root().get_node("game").get_node("Chicken")
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	desiredFov = chicken.mass
	#print(chicken.mass)
	target_zoom = (1/desiredFov)
	smooth_zoom = lerp(smooth_zoom, target_zoom, 0.5*delta)
	if smooth_zoom != target_zoom:
		zoom = Vector2(base+smooth_zoom, base+smooth_zoom)
