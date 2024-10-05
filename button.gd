extends Node2D

@export var input_name = ""
const ENEMY = preload("res://enemy.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed(input_name)):
		print_debug(input_name)
		$AnimatedSprite2D.play("pressed")
		var children = get_children(false)
		for a in children:
			if(a.has_method("button_pressed")):
				a.button_pressed()


func _on_spawn_tick_timeout() -> void:
	if(randi_range(0,1)==1):
		var enemy = ENEMY.instantiate()
		enemy.global_position = global_position
		add_child(enemy)
