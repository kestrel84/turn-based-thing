extends Node2D

# the map
@onready var map: TileMapLayer = $"%map"
# the base sprite to use for attacked areas
@export var attack_sprite: Sprite2D
# the animated sprite to play when an attack goes off 
@export var attack_anim: AnimatedSprite2D

# an array to hold the current sprites in use
var sprites: Array[Sprite2D] = []

# whether this attack is currently attacking (i.e., the attack sprites are being displayed to preview the area)
var attacking: bool = false;

# the angle at which to attack, in radians, relative to the parent entity. must be set by the parent.
var attack_angle: float = 0;

# the coordinates of the currently targeted map tiles.
var current_targets: Array[Vector2i] = []

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if attacking:
		
		# calculate the position of the primary attack tile, based on the angle of attack, set by the parent.
		var player_map_pos = map.local_to_map(global_position) # the map coordinates of the attacking entity (which should be the same as the map coordinates of this node)
		var attack_neighbour = map.angle_to_tileset_neighbour(attack_angle) # the neighbour being attacked
		var attacked_tile = map.get_neighbor_cell(player_map_pos, attack_neighbour) # the map coordinates of the tile being attacked
		#var attacked_pos = map.map_to_local(attacked_tile) # the global coordinates of the tile being attacked
		
		# get the appropriate neighbour directions for the side two hitboxes
		var neighbour_index = map.neighbours.find(attack_neighbour)
		var neighbour_1 = map.neighbours[(neighbour_index - 1) % 6]
		var neighbour_2 = map.neighbours[(neighbour_index + 1) % 6]
		
		# assemble the map coordinates of the attacked tile and the two either side.
		current_targets = [attacked_tile, map.get_neighbor_cell(player_map_pos, neighbour_1), map.get_neighbor_cell(player_map_pos, neighbour_2)]
		
		
		# get the actual positions of said side two hitboxes
		#var attacked_pos_2 = map.map_to_local(map.get_neighbor_cell(player_map_pos, neighbour_1))
		#var attacked_pos_3 = map.map_to_local(map.get_neighbor_cell(player_map_pos, neighbour_2))
		
		# assign them
		#var attack_positions = [attacked_pos, attacked_pos_2, attacked_pos_3]
		
		# convert the attacked map coords to global coords
		var attack_positions = current_targets.map(func (coord): return map.map_to_local(coord))
		
		
		# move the sprites
		for i in range(3):
			if sprites[i]:
				sprites[i].global_position = attack_positions[i] 
			else:
				print("no sprite???")


"""
Triggers the begginning of an attack, showing the hitbox.
"""
func start_attacking():
	if (attacking): return
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
	if (!attacking): return
	print("resolving attack")
	
	# TODO: resolve which enemies/players/whatever are in the hitbox, probably according to the map.
	for tile in current_targets:
		var dupe = attack_anim.duplicate()
		dupe.visible = true
		dupe.connect("animation_finished", func (): dupe.queue_free()) # self-destruct on animation finished
		get_tree().root.add_child(dupe) # add to scene root to prevent moving with the player
		dupe.global_position = map.map_to_local(tile)
		dupe.play()
		
		var callback = map.hittable_objects.get(tile)
		if callback:
			callback.call(get_parent().get_groups())
		
	
	attacking = false
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()


"""
Deactivates the hitboxes without resolving the attack.
"""
func cancel_attack():
	if (!attacking): return
	print("cancelling attack")
	attacking = false
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()
