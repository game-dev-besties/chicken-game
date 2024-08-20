extends AudioStreamPlayer

var last_pitch = 1.0

func random_play(from_position=0.0):
	randomize()
	pitch_scale = randf_range(0.8, 1.1)

	while abs(pitch_scale - last_pitch) < 0.1:
		pitch_scale = randf_range(0.8, 1.1)

	last_pitch = pitch_scale
	#print(pitch_scale)
	self.play(from_position)
