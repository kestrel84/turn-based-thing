extends Button

func _ready() -> void:
	pressed.connect(func (): SceneManager.goto_scene("res://main-scene.tscn"))
