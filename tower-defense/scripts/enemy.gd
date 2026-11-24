extends CharacterBody2D
class_name Enemy
@onready var health_bar: ProgressBar = $HealthBar

var max_hp=100
var hp=max_hp
var speed=100
var go=0
func _ready() -> void:
	position=Mapdata.road_map1[go]
	go+=1
func _process(delta: float) -> void:
	health_bar.value=hp
func _physics_process(delta: float) -> void:
	var direction=(Mapdata.road_map1[go]-position).normalized()
	velocity= direction*speed
	var collision=move_and_collide(velocity*delta)
	if position.distance_to(Mapdata.road_map1[go])<velocity.length()*delta:
		position=Mapdata.road_map1[go]
		go+=1
	print(go)
	print(direction)
	print(velocity)
	
	
