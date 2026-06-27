extends Node2D

@onready var map = $"%map"

@export var MAX_HEALTH: int = 4
@export var TURN_ID: int = -1

var health: int

var current_map_pos: Vector2i # the current position of the enemy in map coords

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	map.disable_tile_global(global_position)
	current_map_pos = map.local_to_map(global_position)
	map.hittable_objects[current_map_pos] = on_hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_hit(attacker_groups: Array[StringName]):
	print("I got hit attacker groups:")
	print(attacker_groups)
	health -= 1
	if health <= 0:
		die()
		
func die():
	print("woe, I am slain")
	map.enable_tile_global(global_position)
	map.hittable_objects.erase(current_map_pos)
	self.queue_free()
