extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var range=150
var collider=null
var priority='first'
var level=1
var damage=10
var target=null
var radius=0

func _ready() -> void:
	animate.play(str(level))
	damage=TowerData.STATS['3'].stats.damage[level-1]
	radius=TowerData.STATS['3'].stats.radius[level-1]
	match level:
		1: scale=Vector2(radius/40.0, radius/40.0)
		2: scale=Vector2(radius/40.0, radius/40.0)
		3: scale=Vector2(radius/40.0, radius/40.0)
	

func _process(delta: float) -> void:
	if len(Global.enemies)>0 and animate.animation==str(level):
		if target not in Global.enemies:
			queue_free()
			return
		var direction=(target.position-position).normalized()
		rotation=direction.angle()
		velocity= direction*speed
		var collision=move_and_collide(velocity*delta)
		if collision:
			collider=collision.get_collider()
			if collider is Enemy:
				animate.play(str(level)+'_explode')
				for i in Global.enemies:
					if collider.position.distance_to(i.position)<=radius:
						i.hp-=damage
						i.animation.play(collider.type+'hurt')
	else:
		if animate.animation==(str(level)+'_explode'):
			animate.play(str(level)+'_explode')
		else:
			queue_free()



func _on_animated_sprite_2d_animation_finished() -> void:
	if animate.animation==(str(level)+'_explode'):
		queue_free()
		return
