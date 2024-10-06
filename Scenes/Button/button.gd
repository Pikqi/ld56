extends Node2D

@export var input_name = ""
@export var color_mix:Color = Color(1,1,1)
const ENEMY = preload("res://Scenes/Worm/enemy.tscn")
const DISTANCE = 40
var red_button = false
var should_move = false
signal enemy_killed

var trans = false

func _unhandled_input(event: InputEvent) -> void:
	if !get_parent().game_active:
		return
	if(event.is_action_pressed(input_name)):
		print_debug(input_name)
		$AnimatedSprite2D.play("pressed")
		$Splash.play("splash")
		var children = get_children(false)
		var was_valid_input = false
		if(red_button):
			get_parent().red_button_press()
		for a in children:
			if(a.has_method("button_pressed")):
				a.button_pressed()
				enemy_killed.emit()
				was_valid_input = true
		if(!was_valid_input):
			if get_parent().has_method("bad_press"):
				get_parent().bad_press()

func get_has_enemy():
	return get_children().any(func (a:Node):return a.has_method("button_pressed"))

func set_red_button(is_red: bool):
	red_button = is_red
	if is_red:
		$AnimatedSprite2D.play("red")
	else:
		$AnimatedSprite2D.play("default")

func red_in():
	red_button = true
	trans = true
	$AnimatedSprite2D.play("red_in")

func red_out():
	red_button = true
	trans = true
	$AnimatedSprite2D.play("red_out")

func _process(delta: float) -> void:
	match $AnimatedSprite2D.animation:
		"default", "pressed":
			$AnimatedSprite2D.modulate = color_mix
		_:
			$AnimatedSprite2D.modulate = Color(1,1,1)

func spawn_enemy():
	if(trans):
		return
	if get_has_enemy():
		return
	if(randi_range(0,1)==1):
		var enemy = ENEMY.instantiate()
		add_child(enemy)
		enemy.global_position = global_position
		var rotated = randi_range(0, 1)
		if(rotated == 1):
			enemy.mirror()
		#enemy.global_rotation=rotated*PI
		enemy.enemy_attacked.connect(enemy_attacked)

func enemy_attacked():
	#TODO: check for collisions
	if red_button:
		get_parent().change_red_button()
		return
	#move_button()
	get_parent().ate()


#func move_button():
	#should_move = true
	#global_position = get_random_position()


func get_random_position():
	var area2d:CollisionShape2D = get_parent().get_node(^"SpawnArea/CollisionShape2D")
	var xa = area2d.shape.get_rect().position.x
	var ya = area2d.global_position.y

	# collison shape position is in the center of the shape :(( it took me too long to figure that out
	var x = randi_range(area2d.global_position.x + area2d.shape.get_rect().position.x, area2d.global_position.x + area2d.shape.get_rect().end.x)
	var y = randi_range(area2d.global_position.y + area2d.shape.get_rect().position.y, area2d.global_position.y + area2d.shape.get_rect().end.y)
	return Vector2(x,y)

var should_really_move = false

#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if should_really_move:
		#move_button()
	#if should_move:
		#move_button()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if should_move:
		should_really_move = true
	should_move = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if(trans):
		if($AnimatedSprite2D.animation == "red_out"):
			red_button = false
			$AnimatedSprite2D.play("default")
		trans = false
