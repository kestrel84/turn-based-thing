extends TileMapLayer

# a list of IDs of tile atlases in which the tiles are solid (mountains or whatever)
@export var solid_blocks: Array[int] = [4]

@export var display_coords: bool = true

var neighbours: Array[TileSet.CellNeighbor] = [
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE, 
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE
]

var astar_hex_grid: AStar2D = AStar2D.new()
var astar_dict: Dictionary[int, Vector2i] = {} # each point in the astar2d has an ID; this is for mapping between said ID and the map coords and back

# a dict for storing all currently active objects which can be hit by an attack. It stores where they are and a callback to call when they get hit.
# said callback should take a single argument, a list of the groups.
# Currently only one hittable object per tile is supported.
var hittable_objects: Dictionary[Vector2i, Callable] 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#region set up the astar2d with the hexagon grid
	var id_counter: int = 0
	
	# add all the points in consideration (at the moment, just those between -20 and 20) to a dict, giving each one a unique id, then add it to the astar2d.
	# this is also a future reference for converting tilemap coordinates into astar2d ids.
	for x in range(-20, 20):
		for y in range(-20, 20):
			var tile_coords = Vector2i(x, y)
			
			# DEBUG: display all tile coords
			if display_coords: 
				var text = Label.new()
				text.set_position(Vector2(map_to_local(tile_coords).x - 20, map_to_local(tile_coords).y - 15))
				text.text = "%s" % tile_coords
				add_child(text)
			# end debug
			
			astar_dict[id_counter] = tile_coords
			astar_hex_grid.add_point(id_counter, tile_coords);
			# immediately disable if it's a solid tile
			if solid_blocks.has(get_cell_source_id(tile_coords)): 
				astar_hex_grid.set_point_disabled(id_counter, true)
			id_counter += 1
	
	#for each coordinate in the previously assigned dictionary, connect it to its neighbours, where they are present.
	for id in astar_dict:
		var current_point = astar_dict[id]
		
		for next_point in get_neighbours(current_point):
			var next_point_id = astar_dict.find_key(next_point)
			if next_point_id:
				astar_hex_grid.connect_points(id, next_point_id)
	#endregion
	
	

# disables the tile at the given global coordinates from pathfinding, effectively marking it as blocked.
func disable_tile_global(pos: Vector2):
	var map_coords = local_to_map(to_local(pos))
	var astar_id = astar_dict.find_key(map_coords)
	astar_hex_grid.set_point_disabled(astar_id, true)

# as above, but enables instead of disables
func enable_tile_global(pos: Vector2):
	var map_coords = local_to_map(to_local(pos))
	var astar_id = astar_dict.find_key(map_coords)
	astar_hex_grid.set_point_disabled(astar_id, false)

# takes a map position and returns all positions adjacent to it; 
# has no interaction with the astar grid and provies no guarantees that all returned coordinates are in the navigable area.
# it returns coordinates in the following order: top right, right, bottom right, bottom left, left, top left.
func get_neighbours(pos: Vector2i) -> Array[Vector2i]:
	return [
		get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE),
		get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_RIGHT_SIDE),
		get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE),
		get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE),
		get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_LEFT_SIDE),
		get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE),
	]

# given an angle (from the +x axis, in radians, as given by the angle() function), it calculates the neighbouring hexagon at that angle.
func angle_to_tileset_neighbour(angle: float) -> TileSet.CellNeighbor:
	angle = rad_to_deg(angle)
	if angle > -90 && angle <= -19.3:
		return TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE
	elif angle > -19.3 && angle <= 19.3:
		return TileSet.CELL_NEIGHBOR_RIGHT_SIDE
	elif angle > 19.3 && angle <= 90:
		return TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE
	elif angle > 90 && angle <= 160:
		return TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
	elif angle > 160 && angle <= 180 || angle > -180 && angle <= -160: # this won't trigger on floats larger than 180 or smaller than -180, which shouldn't ever be passed
		return TileSet.CELL_NEIGHBOR_LEFT_SIDE
	elif angle > -160 && angle <= -90:
		return TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE
	
	# shouldn't happen, so I'll return a neighbour which is invalid on this kind of hex grid
	return TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
