extends CharacterBody2D
@onready var health_bar: ProgressBar = $HealthBar

var max_hp=100
var hp=max_hp
var speed=100
var target=null

func _process(delta: float) -> void:
	health_bar.value=hp
