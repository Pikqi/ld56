extends Camera2D
@export var randomStrength = 30.0

var shake_strenght = 0.0
var shake_fade = 5.0

func apply_shake():
	shake_strenght = randomStrength

func _process(delta):
	if shake_strenght > 0:
		shake_strenght = lerpf(shake_strenght, 0, shake_fade * delta)
	offset=randomOffset()
func randomOffset():
	return Vector2(randf_range(-shake_strenght, shake_strenght),randf_range(-shake_strenght, shake_strenght))
