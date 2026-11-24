extends CharacterBody2D
@onready var health_bar: ProgressBar = $HealthBar

var max_hp=100
var hp=max_hp
var speed=100
const road=[Vector2(85,110),Vector2(85,355),Vector2(120,355),
Vector2(120,425),Vector2(225,425),Vector2(225,390),Vector2(260,390),
Vector2(260,145),Vector2(260,145),Vector2(295,145),Vector2(295,110),
Vector2(400,110),Vector2(400,180),Vector2(435,180),Vector2(435,460),
Vector2(470,460),Vector2(470,495),Vector2(575,495),Vector2(575,425),
Vector2(610,425),Vector2(610,110),Vector2(715,110),Vector2(715,320),
Vector2()]

func _process(delta: float) -> void:
	health_bar.value=hp
	
	
