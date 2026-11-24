extends Node2D
var enemy=preload('res://scenes/enemy.tscn')
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("spawn"):
		spawn_enemy()
func spawn_enemy():
	var e=enemy.instantiate()
	get_parent().add_child(e)
