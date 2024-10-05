extends Node2D

const MAX_HEALTH = 100.0
const RECOVERY_RATE = 10.0
const BAD_PRESS_DAMAGE = 20.0
const MAX_ENEMIES = 3

const INIT_COLOR = Color(1,0,0,0)
var health = MAX_HEALTH

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$SpawnTimer.paused = false


func _ready() -> void:
	change_red_button()

func _process(delta: float) -> void:
	health = minf(health + RECOVERY_RATE * delta ,MAX_HEALTH)

	var new_color = Color(INIT_COLOR)
	new_color.a = 1 - health / MAX_HEALTH
	%DamageColorOverlay.color = new_color
	if health < 5:
		$SpawnTimer.paused =true



func bad_press():
	health = maxf(health - BAD_PRESS_DAMAGE, 0)

func red_button_press():
	health = 0

func change_red_button():
	var buttons = get_tree().get_nodes_in_group("button_group")
	var index = -1
	if buttons.filter(func (n: Node): return n.red_button).size() > 0:
		var old_red_button = buttons.filter(func (n: Node): return n.red_button)[0]
		old_red_button.set_red_button(false)
		index = buttons.find(old_red_button)
	var r = randi_range(0, buttons.size()-1)

	while (r == index):
		r= randi_range(0, buttons.size()-1)
	buttons[r].set_red_button(true)

func _on_spawn_timer_timeout() -> void:
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
