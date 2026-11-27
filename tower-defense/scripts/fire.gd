extends CharacterBody2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var a=0
var range=150
var collider=null
var priority='first'
var level=1
var damage=10
func _ready() -> void:
	animate.animation='default'
func _process(delta: float) -> void:
	if len(Global.enemies)>0 and animate.animation=='default':
		match priority:
			'first':check_first()
			'last':check_last()
			'strongest':check_strong()
			'weakest':check_weak()
			'nearest':check_near()
			'furthest':check_far()
		var direction=(Global.enemies[a].position-position).normalized()
		rotation=direction.angle()
		velocity= direction*speed
		var collision=move_and_collide(velocity*delta)
		if collision:
			collider=collision.get_collider()
			if collider is Enemy:
				animate.play('explode')
				collider.hp-=25
				collider.animation.play(collider.type+'hurt')
	else:
		if animate.animation=='explode':
			animate.play('explode')
		else:
			queue_free()



func _on_animated_sprite_2d_animation_finished() -> void:
	if animate.animation=='explode':
		queue_free()
		return

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
		if i.hp<b and position.distance_to(i.position)<range:
			b=i.hp
			a=Global.enemies.find(i)
func check_strong():
	var b=0
	for i in Global.enemies:
		if i.hp>b and position.distance_to(i.position)<range:
			b=i.hp
			a=Global.enemies.find(i)
func check_far():
	var b=0
	for i in Global.enemies:
		var c=position.distance_to(i.position)
		if c>b and c<range:
			b=c
			a=Global.enemies.find(i)
func check_near():
	var b=1000000
	for i in Global.enemies:
		var c=position.distance_to(i.position)
		if c<b and c<range:
			b=c
			a=Global.enemies.find(i)
