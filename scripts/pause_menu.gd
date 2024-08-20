extends Node2D
@onready var main_menu = load("res://scenes/main_menu.tscn") as PackedScene
var showing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_continue_pressed():
	get_tree().paused = false
	hide()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	hide()

func _on_main_menu_pressed():
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
	hide()
