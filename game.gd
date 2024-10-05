extends Node2D

const MAX_HEALTH = 100.0
const RECOVERY_RATE = 10.0
const BAD_PRESS_DAMAGE = 20.0

const INIT_COLOR = Color(1,0,0,0)
var health = MAX_HEALTH

func _process(delta: float) -> void:
	health = minf(health + RECOVERY_RATE * delta ,MAX_HEALTH)

	var new_color = Color(INIT_COLOR)
	new_color.a = 1 - health / MAX_HEALTH
	%DamageColorOverlay.color = new_color


func bad_press():
	health = maxf(health - BAD_PRESS_DAMAGE, 0)
	if(health == 0):
		print_debug("GAME OVER")
