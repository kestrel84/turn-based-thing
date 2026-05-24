extends Sprite2D

@onready var map: TileMapLayer = $"../map"
@onready var attack_hitbox: Area2D = $"attack"
@onready var cursor: Sprite2D = $"cursor"

var attacking: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr = [1,2,3,5]
	print(arr)
	arr.insert(3, 4)
	print(arr)
	
	attack_hitbox.visible = false


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
			trigger_attack()
	
	if Input.is_action_just_pressed("right click"):
		if attacking:
			cancel_attack()
	
	if attacking:
		var local_mouse_pos = to_local(mousepos)
		# tilemap stuff
		var attack_angle = local_mouse_pos.angle()
		var player_map_pos = map.local_to_map(global_position)
		var attacked_tile = map.get_neighbor_cell(player_map_pos, map.angle_to_tileset_neighbour(attack_angle))
		map.set_cell(attacked_tile, 2, Vector2i(0, 0))
		
		
		# sprite stuff
		var attack_pos = local_mouse_pos.normalized() * 222
		var map_attack_pos = map.map_to_local(map.local_to_map(to_global(attack_pos)))
		attack_hitbox.global_position = map_attack_pos
		attack_hitbox.rotation = to_local(map_attack_pos).angle()
	


func trigger_attack():
	print("triggering attack")
	attacking = true
	cursor.visible = false
	attack_hitbox.visible = true

func cancel_attack():
	print("cancel attack")
	attacking = false
	cursor.visible = true
	attack_hitbox.visible = false

func attack():
	print("attacking")
	print("enemies hit: ")
	var enemies = attack_hitbox.get_overlapping_areas()
	if len(enemies) > 0 && enemies[0].get_script():
		enemies[0].on_hit()
	print(enemies)
	attacking = false
	cursor.visible = true
	attack_hitbox.visible = false
