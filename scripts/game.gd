extends Node2D

@onready var pause_menu = $"hud nightmare/HUD/pauseMenu"
var paused = false

func _ready():
	pause_menu.hide()
	pause_menu.showing = false
	$transition.transition("fade_to_normal")
	Global.init_stats()


func _input(event):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.show()
		get_tree().paused = true
	else:
		pause_menu.hide()
		get_tree().paused = false


