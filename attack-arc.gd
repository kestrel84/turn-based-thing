extends Node2D

# the map
@export var map: TileMapLayer
# the base sprite to use for attacked areas
@export var attack_sprite: Sprite2D

# an array to hold the current sprites in use
var sprites: Array[Sprite2D] = []

# whether this attack is currently attacking (i.e., the attack sprites are being displayed to preview the area)
var attacking: bool = false;

# the angle at which to attack, in radians, relative to the parent entity. must be set by the parent.
var attack_angle: float = 0;

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if attacking:
		
		# calculate the position of the primary attack tile, based on the angle of attack, set by the parent.
		var player_map_pos = map.local_to_map(global_position) # the map coordinates of the attacking entity (which should be the same as the coordinates of this object)
		var attack_neighbour = map.angle_to_tileset_neighbour(attack_angle) # the neighbour being attacked
		var attacked_tile = map.get_neighbor_cell(player_map_pos, attack_neighbour) # the map coordinates of the tile being attacked
		var attacked_pos = map.map_to_local(attacked_tile) # the global coordinates of the tile being attacked
		
		# get the appropriate neighbour directions for the side two hitboxes
		var neighbour_index = map.neighbours.find(attack_neighbour)
		var neighbour_1 = map.neighbours[(neighbour_index - 1) % 6]
		var neighbour_2 = map.neighbours[(neighbour_index + 1) % 6]
		
		# get the actual positions of said side two hitboxes
		var attacked_pos_2 = map.map_to_local(map.get_neighbor_cell(player_map_pos, neighbour_1))
		var attacked_pos_3 = map.map_to_local(map.get_neighbor_cell(player_map_pos, neighbour_2))
		
		# assign then
		var attack_positions = [attacked_pos, attacked_pos_2, attacked_pos_3]
		for i in range(3):
			if sprites[i]:
				sprites[i].global_position = attack_positions[i] 
			else:
				print("no sprite???")


"""
Triggers the begginning of an attack, showing the hitbox.
"""
func start_attacking():
	print("starting to attack")
	attacking = true
	
	# this particular attack is a three-sprite arc
	for i in range(3):
		var dupe = attack_sprite.duplicate()
		dupe.visible = true
		add_child(dupe)
		sprites.push_back(dupe)
	
	
"""
Resolves the attack, damaging the appropriate entities in the hitbox.
"""
func attack():
	print("resolving attack (nonfunctional atm)")
	# TODO: resolve which enemies/players/whatever are in the hitbox, probably according to the map.
	attacking = false
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()


"""
Deactivates the hitboxes without doing anything else.
"""
func cancel_attack():
	print("cancelling attack")
	attacking = false
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()
