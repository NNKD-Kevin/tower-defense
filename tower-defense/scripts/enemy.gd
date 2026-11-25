extends CharacterBody2D
class_name Enemy
@onready var health_bar: ProgressBar = $HealthBar
@onready var animation: AnimatedSprite2D = $animation
@onready var timer: Timer = $Timer


var type='goblin'
var max_hp=100
var hp=max_hp
var speed=100
var go=0
var damage=10
var moving=true


func _ready() -> void:
	animation.animation_finished.connect(_on_animation_finished)
	var stats=EnemyData.STATS[type]
	position=Mapdata.road_map1[go]+Vector2(30,0)
	go+=1
	max_hp=stats.max_hp
	hp=max_hp
	speed=stats.speed
	damage=stats.damage
	animation.play(type+'walk')
	health_bar.max_value=max_hp

func _process(delta: float) -> void:
	health_bar.value=hp
	if hp<=0:
		Global.enemies.erase(self)
		moving=false
		animation.play(type+'death')
	elif not moving and timer.is_stopped():
		timer.start()
		

func _physics_process(delta: float) -> void:
	if velocity.x>0:
		animation.flip_h=false
	elif velocity.x<0:
		animation.flip_h=true
	
	var direction=(Mapdata.road_map1[go]-position).normalized()
	velocity= direction*speed
	if moving:
		var collision=move_and_collide(velocity*delta)
	for i in Global.enemies:
		if i!=self and position.distance_to(i.position)<=(velocity*delta).length():
			var index1=Global.enemies.find(i)
			var index2=Global.enemies.find(self)
			Global.enemies[index1]=self
			Global.enemies[index2]=i
			print('duy gay')
			break
	if position.distance_to(Mapdata.road_map1[go])<velocity.length()*delta:
		position=Mapdata.road_map1[go]
		if go<len(Mapdata.road_map1)-1:
			go+=1





func _on_animation_finished() -> void:
	if animation.animation==type+'death':
		
		queue_free()
		return
	if animation.animation!=type+'walk':
		animation.play(type+'walk')


func _on_timer_timeout() -> void:
	moving=true
