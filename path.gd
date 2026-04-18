extends Line2D

@onready var map: TileMapLayer = $"../../map"
@onready var player: Sprite2D = $"../../player"
@onready var cursor: Sprite2D = $".."

var astar_grid: AStarGrid2D = AStarGrid2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_grid.region = Rect2i(-32, -32, 64, 64)
	astar_grid.cell_size = Vector2(1, 1)
	astar_grid.update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_map_coords = Vector2i(map.local_to_map(player.position))
	var cursor_map_coords = Vector2i(map.local_to_map(cursor.position))
	
	var path_map_coords = astar_grid.get_point_path(player_map_coords, cursor_map_coords)
	
	var path_global_coords = Array(path_map_coords).map(map.map_to_local).map(to_local)
	
	points = PackedVector2Array(path_global_coords)
	pass

func to_grid(pos: Vector2) -> Vector2:
	return map.map_to_local(map.local_to_map(pos))
