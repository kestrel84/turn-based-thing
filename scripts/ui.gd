extends Control

@onready var turn_indicator = $"turn indicator"
@onready var gamemaster = $"%gamemaster"

var turn_comparator # var for holding the current turn, for comparing against the gamemaster's current turn so as to run things when it changes.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_comparator = gamemaster.turn
	if gamemaster.turn == 0:
		turn_indicator.text = "NEITHER SIDE'S TURN"
	elif gamemaster.turn > 0:
		turn_indicator.text = "CURRENT TURN: PLAYER"
	elif gamemaster.turn < 0:
		turn_indicator.text = "CURRENT TURN: ENEMY"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if turn_comparator != gamemaster.turn: # if gamemaster.turn has changed
		if gamemaster.turn == 0:
			turn_indicator.text = "NEITHER SIDE'S TURN"
		elif gamemaster.turn > 0:
			turn_indicator.text = "CURRENT TURN: PLAYER"
		elif gamemaster.turn < 0:
			turn_indicator.text = "CURRENT TURN: ENEMY"
		turn_comparator = gamemaster.turn
