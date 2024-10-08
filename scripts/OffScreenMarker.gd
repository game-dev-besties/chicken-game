extends Node2D

@onready var sprite = $Sprite
@onready var texture_rect = $Sprite/TextureRect
@onready var label = $Sprite/TextureRect/Label
@onready var chicken = %Chicken

var target_position = null
var initial_scale = Vector2(1, 1)

func _ready():
	initial_scale = self.scale

func _process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	#print(canvas.get_scale())
	set_marker_position(Rect2(top_left, size))
	set_marker_rotation()
	set_marker_distance()
	var zoom_factor = get_viewport().get_camera_2d().zoom
	self.scale = initial_scale / zoom_factor
	

func set_marker_position(bounds : Rect2):
	#if target_position == null:
	var canvas = get_canvas_transform()
	sprite.global_position.x = clamp(global_position.x, bounds.position.x + 300, bounds.end.x - 300)
	sprite.global_position.y = clamp(global_position.y, bounds.position.y + 900, bounds.end.y - 300)
	#else:
		#var displacement = global_position - target_position
		#var length
		#
		#var tl = (bounds.position - target_position).angle()
		#var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		#var bl = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
		#var br = (bounds.end - target_position).angle()
		#if (displacement.angle() > tl && displacement.angle() < tr) \
			#|| (displacement.angle() < bl && displacement.angle() > br):
			#var y_length = clamp(displacement.y, bounds.position.y - target_position.y, \
				#bounds.end.y - target_position.y)
			#var angle = displacement.angle() - PI / 2.0
			#length = y_length / cos(angle) if cos(angle) != 0 else y_length
		#else:
			#var x_length = clamp(displacement.x, bounds.position.x - target_position.x, \
				#bounds.end.x - target_position.x)
			#var angle = displacement.angle() - PI / 2.0
			#length = x_length / cos(angle) if cos(angle) != 0 else x_length
			#
		#sprite.global_position = Vector2(length * cos(displacement.angle()), length * sin(displacement.angle())) + target_position
		
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
	


func set_marker_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	texture_rect.rotation= -angle
	#label.text = str(angle)

func set_marker_distance():
	var ship = get_tree().get_root().get_node("game").get_node("Ship").get_node("OffScreenMarker")
	var distance_x = (chicken.global_position.x - ship.global_position.x)
	var distance_y = (chicken.global_position.y - ship.global_position.y)
	var total_distance = ship.global_position.distance_to(chicken.global_position)
	#var total_distance = sqrt(sprite.global_position.x * sprite.global_position.x + sprite.global_position.y * sprite.global_position.y)

	label.text = str(int(total_distance / 100))

