extends CanvasLayer

@onready var chicken = %Chicken
@onready var stats = $Stats

func _process(delta):
	stats.text = "Velocity: " + str(chicken.getVelo()) + "\n" + "Angle: " + str(chicken.getAngle())

