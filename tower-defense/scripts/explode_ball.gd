extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var a=0
var range=150
var collider=null

func _ready() -> void:
	animate.animation='default'
func _process(delta: float) -> void:
	if len(Global.enemies)>0 and animate.animation=='default':
		while (position.distance_to(Global.enemies[a].position)>range):
			if a<len(Global.enemies)-1:
				a+=1
			else:
				a=0
				if (position.distance_to(Global.enemies[a].position)>range):
					queue_free()
				break
		if a<len(Global.enemies):
			var direction=(Global.enemies[a].position-position).normalized()
			rotation=direction.angle()
			velocity= direction*speed
			var collision=move_and_collide(velocity*delta)
			if collision:
				collider=collision.get_collider()
				if collider is Enemy:
					animate.play('explode')
					for i in Global.enemies:
						if collider.position.distance_to(i.position)<=40:
							i.hp-=25
							i.animation.play(collider.type+'hurt')
	else:
		if animate.animation=='explode':
			animate.play('explode')
		else:
			queue_free()



func _on_animated_sprite_2d_animation_finished() -> void:
	if animate.animation=='explode':
		queue_free()
		return
