class_name MainMenu
extends Control

@onready var start_game = $"MarginContainer/HBoxContainer/VBoxContainer/Start Game" as Button
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Options as Button
@onready var credits = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Credits as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Exit as Button
# CHANGE THIS PRELOAD
@onready var game = load("res://scenes/game.tscn") as PackedScene
@onready var cutscene = load("res://scenes/cutscene.tscn") as PackedScene

# Additional menus go here
# @onready var options_menu = load() as PackedScene
# @onready var credits = load() as PackedScene

func _ready():
	start_game.button_up.connect(on_start_button_up)
	options.button_up.connect(on_options_up)
	credits.button_up.connect(on_credits_up)
	exit.button_up.connect(on_exit_up)
	print("test")
	$transition.transition("fade_to_normal")
	
func on_start_button_up() -> void:
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().change_scene_to_packed(cutscene)
	#get_tree().change_scene_to_packed(game)
	
func on_options_up() -> void:
	pass
	
func on_credits_up() -> void:
	pass
	
func on_exit_up() -> void:
	get_tree().quit()


