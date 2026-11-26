extends CharacterBody2D
class_name Judment
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

var choose=true
var damage=1000

func _process(delta: float) -> void:
	if choose:
		global_position=get_global_mouse_position()
	else:
		animate.play('default')


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
