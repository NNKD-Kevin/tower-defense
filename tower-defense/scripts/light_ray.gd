extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var a=0
var range=150
var collider=null
var teleport=false
var priority='first'
var level=1
var damage=10
func _ready() -> void:
	animate.animation='default'
	damage=TowerData.STATS['5'].stats.damage[level-1]
func _process(delta: float) -> void:
	if len(Global.enemies)>0 and animate.animation=='default':
		match priority:
			'first':check_first()
			'last':check_last()
			'strongest':check_strong()
			'weakest':check_weak()
		var direction=(Global.enemies[a].position-position).normalized()
		rotation=direction.angle()
		velocity= direction*speed
		animate.play('default')
		var collision=move_and_collide(velocity*delta)
		if collision:
			collider=collision.get_collider()
			if collider is Enemy:
				animate.play('explode')
	else:
		if animate.animation=='explode':
			animate.play('explode')
			global_position=collider.global_position
		else:
			queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animate.animation=='explode' and teleport:
		collider.hp-=25
		collider.animation.play(collider.type+'hurt')
		queue_free()
		return
	else:
		collider.reverse=true
		animate.play('explode')
		teleport=true

func check_first():
	a=0
	while (position.distance_to(Global.enemies[a].position)>range):
		if a<len(Global.enemies)-1:
			a+=1
		else:
			queue_free()
			break
func check_last():
	a=len(Global.enemies)-1
	while (position.distance_to(Global.enemies[a].position)>range):
		if a>0:
			a-=1
		else:
			queue_free()
			break
func check_weak():
	var b=1000000000000000
	for i in Global.enemies:
		if i.hp<b:
			b=i.hp
			a=Global.enemies.find(i)
func check_strong():
	var b=0
	for i in Global.enemies:
		if i.hp>b:
			b=i.hp
			a=Global.enemies.find(i)
