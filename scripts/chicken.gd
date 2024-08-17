extends CharacterBody2D


const SPEED = 10000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var main = get_tree().get_root().get_node("game")
@onready var projectile = load("res://scenes/egg.tscn")

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print("Left button was clicked at ", event.position)
			
			var instance = projectile.instantiate()
			instance.dir = rotation
			instance.spawnPos = position
			instance.spawnRot = rotation 
			main.add_child.call_deferred(instance)


func _physics_process(delta): 
	var dir = position.direction_to(get_global_mouse_position())
	rotation = lerp_angle(rotation, dir.angle()-PI/2, 5 * delta)
	if Input.is_action_just_released("click"):
		velocity +=  dir * SPEED * delta
	position += velocity * delta
	#move_and_slide()
	

