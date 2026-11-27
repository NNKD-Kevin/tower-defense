extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var range=150
var collider=null
var teleport=false
var priority='first'
var level=1
var damage=10
var distance=50
var target=null

func _ready() -> void:
	animate.animation='default'
	damage=TowerData.STATS['5'].stats.damage[level-1]
	distance=TowerData.STATS['5'].stats.distance[level-1]
func _process(delta: float) -> void:
	if len(Global.enemies)>0 and animate.animation=='default':
		collider=target
		animate.play('explode')
	else:
		if animate.animation=='explode':
			animate.play('explode')
			global_position=collider.global_position
		else:
			queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animate.animation=='explode' and teleport:
		collider.hp-=damage
		collider.animation.play(collider.type+'hurt')
		queue_free()
		return
	else:
		collider.teleport_distance=distance
		collider.reverse=true
		animate.play('explode')
		teleport=true
