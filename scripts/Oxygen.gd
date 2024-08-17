extends TextureProgressBar

@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100

func decrease():
	value -= 1


func _on_timer_timeout():
	decrease()
