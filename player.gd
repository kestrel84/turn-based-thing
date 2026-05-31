extends Sprite2D

@onready var map: TileMapLayer = $"../map"
@onready var cursor: Sprite2D = $"cursor"

@export var attack_sprite: Sprite2D

var sprites: Array[Sprite2D] = []

# TODO: A better system for handling different kinds of attacks
var attacking: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousepos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		if attacking:
			attack()
		else:
			position = cursor.global_position
	
	if Input.is_action_just_pressed("attack one"):
		if attacking:
			cancel_attack()
		else:
			trigger_attack(3)
	
	if Input.is_action_just_pressed("right click"):
		if attacking:
			cancel_attack()
	
	if attacking:
		var local_mouse_pos = to_local(mousepos)
		# tilemap stuff
		var attack_angle = local_mouse_pos.angle() # the angle of the mouse relative to the player
		var player_map_pos = map.local_to_map(global_position) # the map coordinates of the player
		var attack_neighbour = map.angle_to_tileset_neighbour(attack_angle) # the neighbour being attacked
		var attacked_tile = map.get_neighbor_cell(player_map_pos, attack_neighbour) # the map coordinates of the tile being attacked
		var attacked_pos = map.map_to_local(attacked_tile) # the global coordinates of the tile being attacked
		
		var neighbour_index = map.neighbours.find(attack_neighbour)
		var neighbour_1 = map.neighbours[(neighbour_index - 1) % 6]
		var neighbour_2 = map.neighbours[(neighbour_index + 1) % 6]
		
		# calcualte the attacks either side of the direction (+1 and -1 radians = ~60 degrees either side)
		var attacked_pos_2 = map.map_to_local(map.get_neighbor_cell(player_map_pos, neighbour_1))
		var attacked_pos_3 = map.map_to_local(map.get_neighbor_cell(player_map_pos, neighbour_2))
		
		var attack_positions = [attacked_pos, attacked_pos_2, attacked_pos_3]
		
		for i in range(3):
			if sprites[i]:
				sprites[i].global_position = attack_positions[i] 
			else:
				print("no sprite???")

func trigger_attack(area: int):
	print("triggering attack")
	attacking = true
	cursor.visible = false
	#attack_sprite.visible = true
	for i in range(area):
		var dupe = attack_sprite.duplicate()
		dupe.visible = true
		add_child(dupe)
		sprites.push_back(dupe)

func cancel_attack():
	print("cancel attack")
	attacking = false
	cursor.visible = true
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()

func attack():
	print("attacking")
	print("enemies hit: ")
	#var enemies = attack_hitbox.get_overlapping_areas()
	#if len(enemies) > 0 && enemies[0].get_script():
		#enemies[0].on_hit()
	#print(enemies)
	attacking = false
	cursor.visible = true
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()
