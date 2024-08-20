extends Control

# References to Buttons
@onready var main_menu_button = $MarginContainer/VBoxContainer/MainMenu
@onready var replay_game_button = $MarginContainer/VBoxContainer/PlayAgain

# Scenes that we need to redirect to
@onready var main_menu_scene = preload("res://scenes/main_menu.tscn") as PackedScene
@onready var game_scene = preload("res://scenes/game.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_button.button_up.connect(on_main_menu_up)
	replay_game_button.button_up.connect(on_replay_up)
	$transition.transition("fade_to_normal")

func on_main_menu_up() -> void:
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().change_scene_to_packed(main_menu_scene)


func on_replay_up() -> void:
	$transition.transition("fade_to_black")
	await $transition.on_transition_finished
	get_tree().change_scene_to_packed(game_scene)
