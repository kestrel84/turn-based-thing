extends Sprite2D

@onready var map: TileMapLayer = $"../../map"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousepos = get_global_mouse_position()
	#print(map.local_to_map(Vector2(mousepos.x, mousepos.y - 24)))
	global_position = map.map_to_local(map.local_to_map(Vector2(mousepos.x, mousepos.y)))
	pass
