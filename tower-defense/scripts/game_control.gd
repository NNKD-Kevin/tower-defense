extends Node2D
var enemy=preload('res://scenes/enemy.tscn')
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("spawn"):
		spawn_enemy()
func spawn_enemy():
	var e=enemy.instantiate()
	e.add_collision_exception_with(self)
	e.add_collision_exception_with(e)
	e.add_to_group('enemies')
	Global.enemies.append(e)
	add_child(e)
	
