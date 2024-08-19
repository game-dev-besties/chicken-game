extends CanvasLayer

@onready var chicken = %Chicken
@onready var stats = $Stats

func _process(delta):
	stats.text = "Velocity: " + str(int(chicken.getVelo())) + "\n" + "Mass: " + str(chicken.mass)

