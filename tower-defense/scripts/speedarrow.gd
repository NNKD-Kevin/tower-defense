extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var range=150
var level=1
var priority='first'
var damage=10
var target=null

func _ready() -> void:
	animated_sprite_2d.play(str(level))
	damage=TowerData.STATS['6'].stats.damage[level-1]
	visible=false

func _process(delta: float) -> void:
	if len(Global.enemies)>0:
		var direction=(target.position-position).normalized()
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
