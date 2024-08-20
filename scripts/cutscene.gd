extends Node2D

@onready var game = preload("res://scenes/game.tscn") as PackedScene

var timer = 0
var ship_shake1 = false
var ship_shake2 = false
var chicken_died = false
var fade_to_ship = false
var loaded_out = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true
	$Title.modulate.a = 0
	$Subtitle.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer < 2 && timer > 1:
		$Title.modulate.a += 1*delta
	elif timer > 4 && timer < 6:
		$Title.modulate.a -= 1*delta
	elif timer > 4.2 && not fade_to_ship:
		$ColorRect.visible = false
		$transition.transition("fade_to_normal")
		fade_to_ship = true
	elif timer > 7 && not ship_shake1:
		$AnimationPlayer.play("ship_shake")
		$glass.play()
		ship_shake1 = true
	elif timer > 9 && not ship_shake2:
		$AnimationPlayer.play("ship_shake")
		$glass.play()
		ship_shake2 = true
	elif timer > 11 && not chicken_died:
		$AnimationPlayer.play("chicken_die")
		$chicken.play()
		chicken_died = true
	elif timer > 12:
		$Subtitle.modulate.a += 1*delta
	elif timer > 14 && not loaded_out:
		$transition.transition("fade_to_black")
		loaded_out = true
	elif timer > 15 && loaded_out:
		get_tree().change_scene_to_packed(game)

func _on_button_pressed():
	get_tree().change_scene_to_packed(game)
