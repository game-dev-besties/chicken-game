extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = false

func transition(anim_name):
	color_rect.visible = true
	anim_player.play(anim_name)


func _on_animation_player_animation_finished(anim_name):
	on_transition_finished.emit()
	#if anim_name == "fade_to_black":
		#anim_player.play("fade_to_normal")
		#on_transition_finished.emit()
	#elif anim_name == "fade_to_normal":
		#color_rect.visible = false
