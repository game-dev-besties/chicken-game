extends TextureProgressBar

@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 18000

func _physics_process(delta):
	value -= 1
