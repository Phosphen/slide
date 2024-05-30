extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _show_menu(show_continue):
	main_menu.visible = true
	main_menu_continue_button.visible = show_continue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("show_game_menu"):
		_show_menu(true)
		

func _on_player_falling_to_death():
	_show_menu(false)
