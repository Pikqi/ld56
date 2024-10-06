extends CanvasLayer
@export_file("*.json") var d_file

var dialogue = []
var dialog_step = 0
var is_dialog_active = false
signal dialogue_over

func start():
	visible = true
	is_dialog_active = true
	dialogue = load_dialogue()
	handle_dialog_change()

func _unhandled_input(event: InputEvent) -> void:
	if !is_dialog_active:
		return
	if event.is_action_pressed("A"):
		if(dialog_step >= dialogue.size()-1):
			visible = false
			is_dialog_active = false
			dialogue_over.emit()
			return
		dialog_step +=1
		handle_dialog_change()

func handle_dialog_change():
	$NinePatchRect/Name.text = dialogue[dialog_step].name
	$NinePatchRect/Text.text = dialogue[dialog_step].text


func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
