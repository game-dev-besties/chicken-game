class_name MainMenu
extends Control

@onready var start_game = $"MarginContainer/HBoxContainer/VBoxContainer/Start Game" as Button
@onready var credits = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Credits as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Exit as Button
# CHANGE THIS PRELOAD
@onready var game = load("res://scenes/game.tscn") as PackedScene
@onready var cutscene = load("res://scenes/cutscene.tscn") as PackedScene
@onready var credit_scene = load("res://scenes/credits.tscn") as PackedScene

# Additional menus go here
# @onready var options_menu = load() as PackedScene
# @onready var credits = load() as PackedScene

func _ready():
	start_game.button_up.connect(on_start_button_up)
	credits.button_up.connect(_on_credits_pressed)
	exit.button_up.connect(_on_exit_pressed)
	print("test")
	$transition.transition("fade_to_normal")
	
func on_start_button_up() -> void:
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().change_scene_to_packed(cutscene)
	#get_tree().change_scene_to_packed(game)
	

func _on_credits_pressed():
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().change_scene_to_packed(credit_scene)


func _on_exit_pressed():
	get_tree().quit()
