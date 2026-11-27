extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const speed=1000
var a=0
var range=150
var level=1
var priority='first'
func _ready() -> void:
	animated_sprite_2d.play(str(level))
	visible=false

func _process(delta: float) -> void:
	if len(Global.enemies)>0:
		match priority:
			'first':check_first()
			'last':check_last()
			'strongest':check_strong()
			'weakest':check_weak()
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
