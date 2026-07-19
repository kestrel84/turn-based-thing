extends Node2D

signal turn_changed # emitted whenever the turn changes.

var turn: int = 1: # the current turn. numbers above zero indicate player turns, numbers below zero indicate enemy turns, and 0 indicates neither. each player and enemy has a unique number.
	set(val):
		turn = val
		print("turn changed to ", val)
		turn_changed.emit(val)
		

@export var NUM_PLAYERS: int = 1
@export var NUM_ENEMIES: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# when all players have taken their turn, shift it to enemies, and vice versa
	#print("turn: %d, NUM_PLAYERS: %d" % [turn, NUM_PLAYERS]) 
	if turn > NUM_PLAYERS:
		print("switching to enemies")
		turn = -1
	if turn < -NUM_ENEMIES:
		print("switching to players")
		turn = 1
