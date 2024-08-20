extends Node2D

@onready var main_menu = load("res://scenes/main_menu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$transition.transition("fade_to_normal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().change_scene_to_packed(main_menu)
	
	
