extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
const speed=1000
var range=150
var priority='first'
var level=1
var damage=10
var target=null

func _ready() -> void:
	animate.play(str(level))
	damage=TowerData.STATS['2'].stats.damage[level-1]
func _process(delta: float) -> void:
	if len(Global.enemies)>0:
		var direction=(target.position-position).normalized()
		rotation=direction.angle()
		velocity= direction*speed
		var collision=move_and_collide(velocity*delta)
		if collision:
			var collider=collision.get_collider()
			if collider is Enemy:
				collider.hp-=25
				collider.animation.play(collider.type+'hurt')
				collider.moving=false
			queue_free()
	else:
		queue_free()
