extends CanvasLayer

@onready var chicken = %Chicken
@onready var stats = $Stats

func round_to_tenth(value: float) -> float:
	return round(value * 10) / 10.0

func _process(delta):
	stats.text = "Velocity: " + str(int(chicken.getVelo())) + "\n" + "Mass: " + str(round_to_tenth(chicken.mass))

