extends Panel

@export var solo_button: Button
@export var host_button: Button
@export var show_join_button: Button

@onready var player_list_container: VBoxContainer = $"./VBoxContainer/player list"

@onready var lobby_start_button: Button = $"./VBoxContainer/HBoxContainer/start"
@onready var lobby_cancel_button: Button = $"./VBoxContainer/HBoxContainer/cancel"
@onready var lobby_leave_button: Button = $"./VBoxContainer/HBoxContainer/leave"


var player_label_list: Dictionary

var is_server: bool # whether the player is currently hosting or has joined another player's game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	# main menu button
	host_button.pressed.connect(_on_host_button_pressed)
	
	# lobby callbacks
	Lobby.player_connected.connect(_on_player_join)
	Lobby.player_disconnected.connect(_on_player_leave)
	Lobby.server_disconnected.connect(_on_server_disconnected)
	
	# lobby buttons
	lobby_start_button.pressed.connect(_on_lobby_start_pressed)
	lobby_cancel_button.pressed.connect(_on_lobby_cancel_pressed)
	lobby_leave_button.pressed.connect(_on_lobby_leave_pressed)

func _on_player_join(peer_id, player_info):
	# when a player joins, add them to the list
	_add_player(peer_id, player_info)

func _on_player_leave(peer_id):
	# when a player leaves, remove them from the list
	player_label_list[peer_id].queue_free()
	player_label_list.erase(peer_id)

func _on_server_disconnected():
	# this should trigger the same thing as leaving
	_on_lobby_leave_pressed()

func _on_host_button_pressed() -> void:
	# create lobby
	Lobby.create_game()
	
	# disable main menu buttons
	solo_button.disabled = true
	host_button.disabled = true
	show_join_button.disabled = true
	
	# set server to true and disable leave button
	is_server = true
	lobby_leave_button.visible = false
	lobby_cancel_button.visible = true
	lobby_start_button.visible = true
	
	# show box
	visible = true

func _on_join_game_panel_join_game() -> void:
	# it already joins the game in the script this is coming from; so don't do that
	
	# get list of players from lobby
	for peer_id in Lobby.players:
		_add_player(peer_id, Lobby.players[peer_id])
	
	# set server to false, enable leave button, disable start and cancel
	is_server = false
	lobby_leave_button.visible = true
	lobby_cancel_button.visible = false
	lobby_start_button.visible = false
	
	# show box
	visible = true
	pass 

func _on_lobby_start_pressed():
	if (!is_server): return
	Lobby.load_game("res://main-scene.tscn")
	
func _on_lobby_cancel_pressed():
	if (!is_server): return
	
	# stop multiplayer
	Lobby.remove_multiplayer_peer()
	
	# re-enable main menu buttons
	solo_button.disabled = false
	host_button.disabled = false
	show_join_button.disabled = false
	
	# remove all players from player list
	_clear_player_list()
	
	# disable this box
	visible = false
	
func _on_lobby_leave_pressed():
	if (is_server): return
	
	# stop multiplayer
	Lobby.remove_multiplayer_peer()
	
	# re-enable main menu buttons
	solo_button.disabled = false
	host_button.disabled = false
	show_join_button.disabled = false
	
	# remove all players from player list
	_clear_player_list()
	
	# disable this box
	visible = false

func _clear_player_list():
	player_label_list.clear()
	for elem in player_list_container.get_children():
		elem.queue_free()

func _add_player(peer_id, player_info):
	var label: Label = Label.new()
	label.text = "%s (%s)" % [player_info["name"], peer_id]
	player_list_container.add_child(label)
	player_label_list[peer_id] = label
