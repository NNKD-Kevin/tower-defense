extends CharacterBody2D
@onready var health_bar: ProgressBar = $HealthBar

var max_hp=100
var hp=max_hp
var speed=100
var go=0

func _process(delta: float) -> void:
	health_bar.value=hp
	if position.distance_to(Global.road_map[go+1])<velocity.length():
		position=Global.road_map[go+1]
	if go==0:
		position=Global.road_map1[go]
	var direction=Global.road_map[go+1]-Global.road_map[go]
	direction.normalized
	velocity= direction*speed
	move_and_collide()
	
	
