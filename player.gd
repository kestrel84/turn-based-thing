extends Sprite2D

@onready var map: TileMapLayer = $"../map"
@onready var attack_hitbox: Sprite2D = $"attack"
@onready var cursor: Sprite2D = $"cursor"

var attacking: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousepos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		if attacking:
			attack()
		else:
			position = map.map_to_local(map.local_to_map(Vector2(mousepos.x, mousepos.y)))
	
	if Input.is_action_just_pressed("attack one"):
		trigger_attack()
		
	if attacking:
		var local_mouse_pos = to_local(mousepos)
		var attack_pos = local_mouse_pos.normalized() * 222
		var map_attack_pos = map.map_to_local(map.local_to_map(to_global(attack_pos)))
		attack_hitbox.global_position = map_attack_pos
		attack_hitbox.rotation = map_attack_pos.angle()
		print(snappedf(map_attack_pos.angle(), 0.001))
		
		
		
		
		

func trigger_attack():
	print("triggering attack")
	attacking = true
	cursor.visible = false
	attack_hitbox.visible = true

func attack():
	print("attacking")
	attacking = false
	cursor.visible = true
	attack_hitbox.visible = false
