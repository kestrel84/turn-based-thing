extends Sprite2D

@onready var map = $"../../map"
@onready var player: Sprite2D = $".."
@onready var path: Line2D = $"path"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousepos = get_global_mouse_position() 
	
	# temp for debug
	if Input.is_action_just_pressed("click"):
		print("mouse position in map coords: ", map.local_to_map(mousepos))
		print("mouse neighbours: ", map.get_neighbours(map.local_to_map(mousepos)))
	
	# get the map coords of the player and the mouse cursor
	var player_map_coords = Vector2i(map.local_to_map(player.global_position))
	var cursor_map_coords = Vector2i(map.local_to_map(Vector2(mousepos.x, mousepos.y)))
	
	# calculate the path between them, with calculation of partial paths for when the cursor is e.g. out of the map
	var path_map_coords = Array(map.astar_hex_grid.get_point_path(
		map.astar_dict.find_key(player_map_coords), 
		map.astar_dict.find_key(cursor_map_coords),
		true
	))
	
	# update position of cursor image and path line
	global_position = map.map_to_local(path_map_coords.back())
	
	var path_coords = path_map_coords.map(map.map_to_local).map(to_local)
	path.points = PackedVector2Array(path_coords)
	
	
	
	
