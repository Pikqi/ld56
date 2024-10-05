extends Node2D

func button_pressed():
	queue_free()

func _on_first_timer_timeout() -> void:
	scale = Vector2(1.2,1.2)


func _on_second_timer_timeout() -> void:
	scale = Vector2(1.4,1.4)
