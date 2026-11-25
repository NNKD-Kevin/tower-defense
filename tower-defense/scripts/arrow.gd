extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var a=0
var range=150
var level=1
func _ready() -> void:
	animated_sprite_2d.play(str(level))
	visible=false

func _process(delta: float) -> void:
	if len(Global.enemies)>0:
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
			visible=true
			var collision=move_and_collide(velocity*delta)
			if collision:
				var collider=collision.get_collider()
				if collider is Enemy:
					collider.hp-=25
					collider.animation.play(collider.type+'hurt')
				queue_free()
	else:
		queue_free()
