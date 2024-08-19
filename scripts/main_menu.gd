class_name MainMenu
extends Control

@onready var start_game = $"MarginContainer/HBoxContainer/VBoxContainer/Start Game" as Button
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var credits = $MarginContainer/HBoxContainer/VBoxContainer/Credits as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button
# CHANGE THIS PRELOAD
@onready var game = preload("res://scenes/game.tscn") as PackedScene
# Additional menus go here
# @onready var options_menu = preload() as PackedScene
# @onready var credits = preload() as PackedScene

func _ready():
	start_game.button_up.connect(on_start_button_up)
	options.button_up.connect(on_options_up)
	credits.button_up.connect(on_credits_up)
	exit.button_up.connect(on_exit_up)
	pass
	
func on_start_button_up() -> void:
	get_tree().change_scene_to_packed(game)
	
func on_options_up() -> void:
	pass
	
func on_credits_up() -> void:
	pass
	
func on_exit_up() -> void:
	get_tree().quit()


