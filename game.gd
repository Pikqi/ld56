extends Node2D

const MAX_HEALTH = 100.0
const RECOVERY_RATE = 10.0
const BAD_PRESS_DAMAGE = 20.0
const MAX_ENEMIES = 4

@export var INIT_COLOR:Color = Color(1,0,0,0)
var health = MAX_HEALTH

var spawn_interval = 1.4
var interval_step = 0.05
var max_out = 0.7

@export var umiranje: Array[AudioStream]

var player_score = 0
var first_time = true
var game_active = false
var needs_restart = false

func _unhandled_input(event: InputEvent) -> void:
	if game_active == false:
		if event.is_action_pressed("B"):
			%Dialog.skip()
	if needs_restart && !game_active:
		if event.is_action_pressed("A"):
			start_game()


func _ready() -> void:
	%Dialog.start_dialog_1()

func start_game():
	$SpawnTimer.paused = false
	$SpawnTimer.start()
	health = MAX_HEALTH
	player_score = 0
	draw_score()
	%Dialog.visible = false
	change_red_button(true)
	first_time = false
	$SpawnTimer.wait_time = spawn_interval
	for button in get_tree().get_nodes_in_group("button_group"):
		button.enemy_killed.connect(on_enemy_killed)
	game_active = true
	call_deferred("set_game_active",)
	$Intro4Bar.stop()
	$"8bart1".play()


func set_game_active():
	game_active = true

func game_over():
	game_active = false
	$SpawnTimer.paused = true
	%Dialog/Text.text = "GAME OVER, TRY AGAIN ?"
	%Dialog.visible = true
	$"8bart1".stop()
	$Intro4Bar.play()
	needs_restart = true

func _process(delta: float) -> void:
	health = minf(health + RECOVERY_RATE * delta ,MAX_HEALTH)

	if(spawn_interval > max_out):
		spawn_interval -= interval_step*delta

	var new_color = Color(INIT_COLOR)
	new_color.a = 1 - health / MAX_HEALTH
	%DamageColorOverlay.color = new_color
	if health < 5:
		game_over()

func bad_press():
	health = maxf(health - BAD_PRESS_DAMAGE, 0)
	spawn_interval -= interval_step
	$Camera2D.apply_shake()

func ate():
	health = maxf(health - BAD_PRESS_DAMAGE, 0)
	spawn_interval += interval_step
	$Camera2D.apply_shake()

func red_button_press():
	health = 0

func change_red_button(is_first = false):
	var buttons = get_tree().get_nodes_in_group("button_group")
	var old_red_button_index = -1
	if buttons.filter(func (n: Node): return n.red_button).size() > 0:
		var old_red_button = buttons.filter(func (n: Node): return n.red_button)[0]
		old_red_button_index = buttons.find(old_red_button)
	var r = randi_range(0, buttons.size()-1)

	while (r == old_red_button_index || buttons[r].get_has_enemy() || (is_first && buttons[r].input_name=="A")):
		r= randi_range(0, buttons.size()-1)
	if(!first_time):
		buttons[old_red_button_index].red_out()
		buttons[r].red_in()
	else:
		buttons[r].set_red_button(true)

func _on_spawn_timer_timeout() -> void:
	$SpawnTimer.wait_time = spawn_interval
	var buttons = get_tree().get_nodes_in_group("button_group")
	var enemies_to_spawn = randi_range(1, MAX_ENEMIES)
	while (enemies_to_spawn > 0):
		var button = buttons[randi_range(0, buttons.size()-1)]
		if button.has_method("get_has_enemy"):
			if button.get_has_enemy():
				enemies_to_spawn -=1
				continue
			button.spawn_enemy()
			enemies_to_spawn -=1
	return
func on_enemy_killed():
	player_score+=1
	var random_zvuk = randi_range(0, 6)
	$death.stream = umiranje[random_zvuk]
	$death.pitch_scale = 1.5
	$death.seek(0.3)
	$death.play()
	draw_score()

func draw_score():
	$CanvasLayer/Label.text = str(player_score)

func _on_dialog_dialogue_over() -> void:
	start_game()


func _on_bart_1_finished() -> void:
	$"8bart1".stop()
	$Intense.play()
