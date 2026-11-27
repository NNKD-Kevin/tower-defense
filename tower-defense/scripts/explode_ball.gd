extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var range=150
var collider=null
var priority='first'
var level=1
var damage=10
var target=null

func _ready() -> void:
	animate.animation='default'
	damage=TowerData.STATS['3'].stats.damage[level-1]
	

func _process(delta: float) -> void:
	if len(Global.enemies)>0 and animate.animation=='default':
		var direction=(target.position-position).normalized()
		rotation=direction.angle()
		velocity= direction*speed
		var collision=move_and_collide(velocity*delta)
		if collision:
			collider=collision.get_collider()
			if collider is Enemy:
				animate.play('explode')
				for i in Global.enemies:
					if collider.position.distance_to(i.position)<=40:
						i.hp-=damage
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
