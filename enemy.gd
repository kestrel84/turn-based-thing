extends Area2D

@onready var map = $"../map"

@export var MAX_HEALTH: int = 4

var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	map.disable_tile_global(global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_hit():
	print("I got hit aah")
	health -= 1
	if health <= 0:
		die()
		
func die():
	print("woe, I am slain")
	map.enable_tile_global(global_position)
	self.queue_free()
