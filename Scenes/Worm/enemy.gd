extends Node2D

signal enemy_attacked
@export var color:Color
func button_pressed():
	$AnimatedSprite2D.play("defeated_3")

func _on_first_timer_timeout() -> void:
	scale = Vector2(1.2,1.2)

func _process(delta: float) -> void:
	$AnimatedSprite2D.modulate=color
func _on_second_timer_timeout() -> void:
	scale = Vector2(1.4,1.4)

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func flip_animation():
	scale.y = -scale.y

func _on_animated_sprite_2d_animation_finished() -> void:
	if($AnimatedSprite2D.animation == "attack"):
		enemy_attacked.emit()
	queue_free()
