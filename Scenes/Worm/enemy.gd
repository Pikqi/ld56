extends Node2D

signal enemy_attacked
@export var color:Color
func button_pressed():
	$AnimatedSprite2D.play("defeated_3")

func _process(delta: float) -> void:
	$AnimatedSprite2D.modulate=color


func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func mirror():
	scale.x = -scale.x

func _on_animated_sprite_2d_animation_finished() -> void:
	if($AnimatedSprite2D.animation == "attack"):
		enemy_attacked.emit()
		$AnimatedSprite2D.play("attack_2")
		return
	print_debug($AnimatedSprite2D.animation)
	match $AnimatedSprite2D.animation:
		"defeated_3", "defeated_2", "defeated_4", "attack_2":
			queue_free()
			return
