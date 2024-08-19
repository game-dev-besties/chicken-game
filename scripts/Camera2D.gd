
extends Camera2D
var chicken
var base = 0.5
var smooth_zoom = 0.5
var desiredFov: float
var target_zoom: float 
# Called when the node enters the scene tree for the first time.
func _ready():
	chicken = get_tree().get_root().get_node("game").get_node("Chicken")
	smooth_zoom = base / (pow((chicken.mass / 10.0), 1.0/3.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target_zoom = base / (pow((chicken.mass / 10.0), 1.0/3.0))
	smooth_zoom = lerp(smooth_zoom, target_zoom, 0.5*delta)
	zoom = Vector2(smooth_zoom, smooth_zoom)
	var particles = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("particles")
	
	particles.position.y = 540 + chicken.mass * 2 * cos(chicken.rotation) * zoom.length() * sqrt(zoom.length())
	particles.position.x = 960 - chicken.mass * 2 * sin(chicken.rotation) * zoom.length() * sqrt(zoom.length())

