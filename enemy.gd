extends Area2D

@onready var map = $"../map"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map.disable_tile_global(global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_hit():
	print("I got hit aah")
