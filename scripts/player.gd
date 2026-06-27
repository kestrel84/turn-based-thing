extends Sprite2D

@onready var cursor: Sprite2D = $"cursor"
@onready var attack_1: Node2D = $"attack-arc"
@onready var attack_2: Node2D = $"attack-line"

@onready var gamemaster = $"%gamemaster"

@export var TURN_ID = 1

@export var speed: int = 5 # hexes per turn
@export var actions: int = 2 # attacks per turn

var remaining_speed: int
var remaining_actions: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remaining_speed = speed
	remaining_actions = actions
	gamemaster.turn_changed.connect(func(turn): if (turn == TURN_ID): remaining_speed = speed; remaining_actions = actions) # on turn changed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_input()
	

func handle_input():
	if Input.is_action_just_pressed("click"):
		if attack_1.attacking:
			attack_1.attack()
			cursor.visible = true
			remaining_actions -= 1
		elif attack_2.attacking:
			attack_2.attack()
			cursor.visible = true
			remaining_actions -= 1
		else:
			position = cursor.global_position
			remaining_speed -= cursor.path_map_coords.size() - 1
	
	if Input.is_action_just_pressed("attack one"):
		if attack_1.attacking:
			attack_1.cancel_attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.cancel_attack()
			cursor.visible = true
		else:
			if remaining_actions > 0:
				cursor.visible = false
				attack_1.start_attacking()
	
	if Input.is_action_just_pressed("attack two"):
		if attack_1.attacking:
			attack_1.cancel_attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.cancel_attack()
			cursor.visible = true
		else:
			if remaining_actions > 0:
				cursor.visible = false
				attack_2.start_attacking()
	
	if Input.is_action_just_pressed("right click"):
		if attack_1.attacking:
			attack_1.cancel_attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.cancel_attack()
			cursor.visible = true
	
	if attack_1.attacking:
		attack_1.attack_angle = to_local(get_global_mouse_position()).angle()
	if attack_2.attacking:
		attack_2.attack_angle = to_local(get_global_mouse_position()).angle()
