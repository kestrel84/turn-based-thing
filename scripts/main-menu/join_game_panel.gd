extends Panel

signal join_game

@onready var join_code_entry: LineEdit = $"./VBoxContainer/LineEdit"
@onready var join_button: Button = $"./VBoxContainer/Button"

@export var solo_button: Button
@export var host_button: Button
@export var show_join_button: Button



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false;
	join_button.pressed.connect(_on_join_button_pressed)
	show_join_button.pressed.connect(_on_show_join_button_pressed)
	
func _on_join_button_pressed():
	var join_code = join_code_entry.text
	print("ignoring join code ", join_code, " and joining default lobby")
	Lobby.join_game()
	visible = false;
	join_game.emit()

func _on_show_join_button_pressed() -> void:
	visible = true;
	solo_button.disabled = true
	host_button.disabled = true
	show_join_button.disabled = true
