extends Node

var current_scene = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# autoloads always go before actual scenes, so the current scene will be the last child of root.
	current_scene = get_tree().root.get_child(-1);

func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	# Remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
