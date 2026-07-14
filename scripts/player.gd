extends Sprite2D

@onready var cursor: Sprite2D = $"cursor"
@onready var attack_1: Node2D = $"attack-arc"
@onready var attack_2: Node2D = $"attack-line"

@onready var actions_display: VFlowContainer = $"actions display"
@onready var movement_display: VFlowContainer = $"movement display"
@export var actions_pip_sprite: PackedScene
@export var movement_pip_sprite: PackedScene


@onready var gamemaster = $"%gamemaster"
@onready var map = $"%map"
var current_map_pos: Vector2i

@export var TURN_ID = 1

@export var SPEED: int = 5 # hexes per turn
@export var ACTIONS: int = 2 # attacks per turn
@export var HEALTH: int = 1 # max health

var current_health: int
var remaining_speed: int
var remaining_actions: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set up trackers
	current_health = HEALTH
	remaining_speed = SPEED
	remaining_actions = ACTIONS
	
	# set up being hittable
	current_map_pos = map.local_to_map(global_position)
	map.hittable_objects[current_map_pos] = _on_hit
	
	# set up movement and action pips
	_reset_pips()
	
	# set up turn changed watcher
	gamemaster.turn_changed.connect(func(turn): if (turn == TURN_ID): remaining_speed = SPEED; remaining_actions = ACTIONS; _reset_pips()) # on turn changed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_input()
	
	if attack_1.attacking:
		attack_1.attack_angle = to_local(get_global_mouse_position()).angle()
	if attack_2.attacking:
		attack_2.attack_angle = to_local(get_global_mouse_position()).angle()
	

func handle_input():
	if Input.is_action_just_pressed("click"):
		if attack_1.attacking:
			attack_1.attack()
			cursor.visible = true
			remaining_actions -= 1
			actions_display.get_child(0).queue_free()
		elif attack_2.attacking:
			attack_2.attack()
			cursor.visible = true
			remaining_actions -= 1
			actions_display.get_child(0).queue_free()
		else:
			_move()
	
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

func _reset_pips():
	for node in actions_display.get_children():
		node.queue_free()
	
	for node in movement_display.get_children():
		node.queue_free()
	
	for i in range(remaining_actions):
		var sprite = actions_pip_sprite.instantiate()
		actions_display.add_child(sprite)
		
	for i in range(remaining_speed):
		var sprite = movement_pip_sprite.instantiate()
		movement_display.add_child(sprite)

func _move():
	map.hittable_objects.erase(current_map_pos) # get rid of last one
	current_map_pos = map.local_to_map(global_position) # calculate new position
	map.hittable_objects[current_map_pos] = _on_hit # add it to hittable objects
	position = cursor.global_position 
	var distance = cursor.path_map_coords.size() - 1
	for i in range(distance):
		movement_display.get_child(i).queue_free()
	remaining_speed -= distance

func _on_hit(attacker_groups: Array[StringName]):
	if (!attacker_groups.has("enemies")): return
	current_health -= 1
	if current_health <= 0:
		_die()

func _die():
	print("i'm dead :skull:")
	
