extends Sprite2D

@onready var cursor: Sprite2D = $"cursor"
@onready var attack: Node2D = $"attack-arc"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if attack.attacking:
			attack.attack()
			cursor.visible = true
		else:
			position = cursor.global_position
	
	if Input.is_action_just_pressed("attack one"):
		if attack.attacking:
			attack.cancel_attack()
			cursor.visible = true
		else:
			cursor.visible = false
			attack.start_attacking()
	
	if Input.is_action_just_pressed("right click"):
		if attack.attacking:
			attack.cancel_attack()
			cursor.visible = true
	
	if attack.attacking:
		attack.attack_angle = to_local(get_global_mouse_position()).angle()
