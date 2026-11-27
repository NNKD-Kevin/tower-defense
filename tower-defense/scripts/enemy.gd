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
var distance=0
var reverse=false
var teleport_distance=0
var coin=0
var burn=0


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
	coin=stats.coin

func _process(delta: float) -> void:
	health_bar.value=hp
	if hp<=0:
		Global.enemies.erase(self)
		moving=false
		Global.coins+=coin
		animation.play(type+'death')
	elif not moving and timer.is_stopped():
		timer.start()

func _physics_process(delta: float) -> void:
	if reverse:
		teleport_back(delta)
	else:
		normal_go(delta)
		

func normal_go(delta: float):
	if velocity.x>0:
		animation.flip_h=false
	elif velocity.x<0:
		animation.flip_h=true
	
	var direction=(Mapdata.road_map1[go]-position).normalized()
	velocity= direction*speed
	if moving:
		var collision=move_and_collide(velocity*delta)
		distance+=(velocity*delta).length()
	for i in Global.enemies:
		if i!=self and i.distance<distance:
			var index1=Global.enemies.find(i)
			var index2=Global.enemies.find(self)
			if index1<index2:
				Global.enemies[index1]=self
				Global.enemies[index2]=i
				
	if position.distance_to(Mapdata.road_map1[go])<velocity.length()*delta:
		position=Mapdata.road_map1[go]
		if go<len(Mapdata.road_map1)-1:
			go+=1
		else:
			Global.health-=damage
			queue_free()

func teleport_back(delta:float):
	go-=1
	var displace=velocity.length()*teleport_distance*delta
	var fake_position=Vector2(position)
	if distance>displace:
		distance-=displace
		while true:
			if fake_position.distance_to(Mapdata.road_map1[go])<=displace:
				displace-=fake_position.distance_to(Mapdata.road_map1[go])
				fake_position=Mapdata.road_map1[go]
				if go>0:
					go-=1
			else:
				var a=Mapdata.road_map1[go]-fake_position
				a=a.normalized()*displace
				fake_position+=a
				displace=0
				go+=1
				
			if displace==0: break
	else: 
		distance=0
		fake_position=Vector2(30,110)
	position=fake_position
	reverse=false

func _on_animation_finished() -> void:
	if animation.animation==type+'death':
		queue_free()
		return
	if animation.animation!=type+'walk':
		animation.play(type+'walk')


func _on_timer_timeout() -> void:
	moving=true
