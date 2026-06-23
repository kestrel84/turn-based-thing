extends Sprite2D

@onready var cursor: Sprite2D = $"cursor"
@onready var attack_1: Node2D = $"attack-arc"
@onready var attack_2: Node2D = $"attack-line"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if attack_1.attacking:
			attack_1.attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.attack()
			cursor.visible = true
		else:
			position = cursor.global_position
	
	if Input.is_action_just_pressed("attack one"):
		if attack_1.attacking:
			attack_1.cancel_attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.cancel_attack()
			cursor.visible = true
		else:
			cursor.visible = false
			attack_1.start_attacking()
	
	if Input.is_action_just_pressed("attack two"):
		if attack_1.attacking:
			attack_1.cancel_attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.cancel_attack()
			cursor.visible = true
		else:
			cursor.visible = false
			attack_2.start_attacking()
	
	if Input.is_action_just_pressed("right click"):
		if attack_1.attacking:
			attack_1.cancel_attack()
			cursor.visible = true
		elif attack_2.attacking:
			attack_2.cancel_attack()
			cursor.visible = true
	
	if attack_1.attacking:
		attack_1.attack_angle = to_local(get_global_mouse_position()).angle()
	if attack_2.attacking:
		attack_2.attack_angle = to_local(get_global_mouse_position()).angle()
