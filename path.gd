extends Line2D

@onready var map: TileMapLayer = $"../../../map"
@onready var player: Sprite2D = $"../../../player"
@onready var cursor: Sprite2D = $".."

var astar_hex_grid: AStar2D = AStar2D.new()
var astar_dict: Dictionary[int, Vector2i] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#region set up the astar2d with the hexagon grid
	var id_counter: int = 0
	
	# add all the points in consideration (at the moment, just those between -10 and 10) to a dict, giving each one a unique id.
	# this is also a future reference for converting tilemap coordinates into astar2d ids.
	for x in range(-10, 10):
		for y in range(-10, 10):
			astar_dict[id_counter] = Vector2i(x, y)
			id_counter += 1
	
	# the heavy lifting. for each coordinate in the previously assigned dictionary, add it to the astar2d, then connect it to its neighbours, where they are present.
	for id in astar_dict:
		var current_point = astar_dict[id]
		# add the curent point to the astar2d with its id
		astar_hex_grid.add_point(id, current_point)
		
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# temp for debug
	if Input.is_action_just_pressed("click"):
		var mousepos = get_global_mouse_position()
		#print(map.local_to_map(Vector2(mousepos.x, mousepos.y)))
	
	
	var player_map_coords = Vector2i(map.local_to_map(player.global_position))
	var cursor_map_coords = Vector2i(map.local_to_map(cursor.global_position))
	
	var path_map_coords = astar_hex_grid.get_point_path(astar_dict.find_key(player_map_coords), astar_dict.find_key(cursor_map_coords))
	
	var path_global_coords = Array(path_map_coords).map(map.map_to_local).map(to_local)
	
	points = PackedVector2Array(path_global_coords)
	pass

func to_grid(pos: Vector2) -> Vector2:
	return map.map_to_local(map.local_to_map(pos))
