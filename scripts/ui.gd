extends Control

@onready var turn_indicator = $"turn indicator"
@onready var gamemaster = $"%gamemaster"
@onready var end_turn_button = $"end turn button"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if gamemaster.turn == 0:
		turn_indicator.text = "NEITHER SIDE'S TURN (%d)" % gamemaster.turn
	elif gamemaster.turn > 0:
		turn_indicator.text = "CURRENT TURN: PLAYER (%d)" % gamemaster.turn
	elif gamemaster.turn < 0:
		turn_indicator.text = "CURRENT TURN: ENEMY (%d)" % gamemaster.turn
	
	gamemaster.turn_changed.connect(func (turn):
		if turn == 0:
			turn_indicator.text = "NEITHER SIDE'S TURN (%d)" % turn
		elif turn > 0:
			turn_indicator.text = "CURRENT TURN: PLAYER (%d)" % turn
		elif turn < 0:
			turn_indicator.text = "CURRENT TURN: ENEMY (%d)" % turn
	)
	end_turn_button.pressed.connect(func ():
		print("ending turn")
		gamemaster.turn += 1 # go to next player on turn end
	)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
