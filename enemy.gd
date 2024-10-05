extends Node2D

signal enemy_attacked

func button_pressed():
	queue_free()

func _on_first_timer_timeout() -> void:
	scale = Vector2(1.2,1.2)


func _on_second_timer_timeout() -> void:
	scale = Vector2(1.4,1.4)

func _ready() -> void:
	$AnimatedSprite2D.play("new_animation")


func _on_animated_sprite_2d_animation_finished() -> void:
	enemy_attacked.emit()
	queue_free()
