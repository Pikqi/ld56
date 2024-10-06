extends Node2D

signal enemy_attacked
@export var color:Color
func button_pressed():
	$AnimatedSprite2D.play("defeated_3")

func _process(delta: float) -> void:
	$AnimatedSprite2D.modulate=color
	#$AnimatedHack.modulate = color

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func mirror():
	scale.x = -scale.x

func _on_animated_sprite_2d_animation_finished() -> void:
	if($AnimatedSprite2D.animation == "attack"):
		enemy_attacked.emit()
		$AnimatedSprite2D.play("attack_2")
		return

	match $AnimatedSprite2D.animation:
		"attack_2":
			$AnimatedHack.play("default")
			$AnimatedHack.visible = true
			$AnimatedSprite2D.visible = false

		"defeated_3", "defeated_2", "defeated_4":
			queue_free()
			return


func _on_animated_hack_animation_finished() -> void:
	queue_free()
