extends CharacterBody2D
@onready var health_bar: ProgressBar = $HealthBar

var max_hp=100
var hp=max_hp
var speed=100
var go=0

func _process(delta: float) -> void:
	health_bar.value=hp
	if position.distance_to(Mapdata.road_map1[go+1])<velocity.length()*delta:
		position=Mapdata.road_map1[go+1]
	if go==0:
		position=Mapdata.road_map1[go]
	var direction=Mapdata.road_map1[go+1]-Mapdata.road_map1[go]
	direction.normalized()
	velocity= direction*speed
	var collision=move_and_collide(velocity*delta)
	
	
