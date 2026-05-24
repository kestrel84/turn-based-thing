extends TileMapLayer

# a list of IDs of tile atlases in which the tiles are solid (mountains or whatever)
@export var solid_blocks: Array[int] = [4]

var astar_hex_grid: AStar2D = AStar2D.new()
var astar_dict: Dictionary[int, Vector2i] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#region set up the astar2d with the hexagon grid
	var id_counter: int = 0
	
	# add all the points in consideration (at the moment, just those between -10 and 10) to a dict, giving each one a unique id, then add it to the astar2d.
	# this is also a future reference for converting tilemap coordinates into astar2d ids.
	for x in range(-50, 50):
		for y in range(-50, 50):
			var tile_coords = Vector2i(x, y)
			astar_dict[id_counter] = tile_coords
			astar_hex_grid.add_point(id_counter, tile_coords);
			# immediately disable if it's a solid tile
			if solid_blocks.has(get_cell_source_id(tile_coords)): 
				astar_hex_grid.set_point_disabled(id_counter, true)
			id_counter += 1
	
	
	
	
	# the heavy lifting. for each coordinate in the previously assigned dictionary, connect it to its neighbours, where they are present.
	for id in astar_dict:
		var current_point = astar_dict[id]
		
		# all hex tiles are always neighbours with what would be their normal orthogonal neighbours
		var next_point_id = astar_dict.find_key(Vector2i(current_point.x + 1, current_point.y))
		if next_point_id:
			astar_hex_grid.connect_points(id, next_point_id)
		
		next_point_id = astar_dict.find_key(Vector2i(current_point.x - 1, current_point.y))
		if next_point_id:
			astar_hex_grid.connect_points(id, next_point_id)
	
		next_point_id = astar_dict.find_key(Vector2i(current_point.x, current_point.y + 1))
		if next_point_id:
			astar_hex_grid.connect_points(id, next_point_id)
			
		next_point_id = astar_dict.find_key(Vector2i(current_point.x, current_point.y -1))
		if next_point_id:
			astar_hex_grid.connect_points(id, next_point_id)

		if current_point.y % 2 == 0:
			# if the Y is even, then they are also neigbours with the above and below hexagons one x-coordinate left
			next_point_id = astar_dict.find_key(Vector2i(current_point.x - 1, current_point.y + 1))
			if next_point_id:
				astar_hex_grid.connect_points(id, next_point_id)
				
			next_point_id = astar_dict.find_key(Vector2i(current_point.x - 1, current_point.y - 1))
			if next_point_id:
				astar_hex_grid.connect_points(id, next_point_id)
		else: 
			# and if odd, then with the above and below hexagons one x-coordiante right.
			next_point_id = astar_dict.find_key(Vector2i(current_point.x + 1, current_point.y + 1))
			if next_point_id:
				astar_hex_grid.connect_points(id, next_point_id)
				
			next_point_id = astar_dict.find_key(Vector2i(current_point.x + 1, current_point.y - 1))
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
