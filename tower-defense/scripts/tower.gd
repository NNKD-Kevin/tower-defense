extends Node2D
@onready var base: AnimatedSprite2D = $Base
@onready var weapon: AnimatedSprite2D = $Weapon
@onready var cooldown: Timer = $Node/cooldown
var type='1'
var arrow=preload("res://scenes/arrow.tscn")
var range=150
var cooldown_finished=true
var cooldown_time=1
func _ready():
	cooldown.start()
func fire():
	match type:
		"1":
			var bullet=arrow.instantiate()
			bullet.range=range
			get_parent().add_child(bullet)
			bullet.global_position = global_position
func _draw() -> void:
	draw_circle(Vector2.ZERO,range,Color.WHITE,false,3)

func _on_cooldown_timeout() -> void:
	cooldown_finished=true

func _process(delta: float) -> void:
	if len(Global.enemies)>0:
		for e in Global.enemies:
			if position.distance_to(e.position)<=range:
				var direction=(e.position-position).normalized()
				weapon.rotation=direction.angle()+TAU/4
				if cooldown_finished:
					fire()
					cooldown_finished=false
					cooldown.wait_time=cooldown_time
					cooldown.start()
				break
