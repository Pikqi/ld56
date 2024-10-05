extends StaticBody2D

@export var input_name = ""
const ENEMY = preload("res://enemy.tscn")
const DISTANCE = 40
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed(input_name)):
		print_debug(input_name)
		$AnimatedSprite2D.play("pressed")
		var children = get_children(false)
		var was_valid_input = false
		for a in children:
			if(a.has_method("button_pressed")):
				a.button_pressed()
				was_valid_input = true
		if(!was_valid_input):
			if get_parent().has_method("bad_press"):
				get_parent().bad_press()


func _on_spawn_tick_timeout() -> void:
	spawn_enemy()

func spawn_enemy():
	if get_children().any(func (a:Node):return a.has_method("button_pressed")):
		return
	elif(randi_range(0,1)==1):
		var enemy = ENEMY.instantiate()
		print_debug(randf_range(0.0, 2.0) * PI)
		add_child(enemy)
		enemy.global_position = global_position
		enemy.global_rotation=randf_range(0, 2 * PI)
		enemy.look_at(global_position)
		enemy.enemy_attacked.connect(enemy_attacked)

func enemy_attacked():
	#TODO: check for collisions
	global_position = get_random_position()


func get_random_position():
	var area2d:CollisionShape2D = get_parent().get_node(^"SpawnArea/CollisionShape2D")
	var xa = area2d.shape.get_rect().position.x
	var ya = area2d.global_position.y

	# collison shape position is in the center of the shape :(( it took me too long to figure that out
	var x = randi_range(area2d.global_position.x + area2d.shape.get_rect().position.x, area2d.global_position.x + area2d.shape.get_rect().end.x)
	var y = randi_range(area2d.global_position.y + area2d.shape.get_rect().position.y, area2d.global_position.y + area2d.shape.get_rect().end.y)
	return Vector2(x,y)
