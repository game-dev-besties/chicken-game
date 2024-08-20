extends TextureProgressBar

@onready var timer = $Timer
@onready var death_screen = preload("res://scenes/death_screen.tscn")

# Bad Code that gets the transition from the Game Scene
@onready var transition = get_tree().get_root().get_node("game").get_node("transition")

func _physics_process(delta):
	Global.oxygen = max(Global.oxygen-10, 0)
	value = Global.oxygen
	if Global.oxygen <= 0:
		transition.transition("fade_to_black")
		await transition.on_transition_finished
		# It's possible that physics process gets called during a scene switch
		# In this case, get_tree() will return null (I think this is the issue)
		if get_tree():
			get_tree().change_scene_to_packed(death_screen)

