
extends Camera2D
var chicken
var base = 0.05
var smooth_zoom = 0.4
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
	var particles = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("particlesSprite")
	var arrow = get_tree().get_root().get_node("game").get_node("particleLayer").get_node("arrow")
	arrow.rotation = chicken.rotation - PI / 2
	particles.rotation = chicken.rotation
	if chicken.charging:
		#print(charge_time)
		if chicken.charge_time <= 0.5:
			arrow.self_modulate.a = 0.25
		#if charge_time <= 0.25:
			#arrow.self_modulate.a = 0.125
		#elif charge_time <= 0.5:
			#arrow.self_modulate.a = 0.25
		#elif charge_time <= 0.75:
			#arrow.self_modulate.a = 0.375
		elif chicken.charge_time <= 1:
			arrow.self_modulate.a = 0.5
		#elif charge_time <= 1.25:
			#arrow.self_modulate.a = 0.625
		elif chicken.charge_time <= 1.5:
			arrow.self_modulate.a = 0.75
		#elif charge_time <= 1.75:
			#arrow.self_modulate.a = 0.875
		elif chicken.charge_time <= 2:
			arrow.self_modulate.a = 1
		arrow.show()
	else:
		arrow.hide()

