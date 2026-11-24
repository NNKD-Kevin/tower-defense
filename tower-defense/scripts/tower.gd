extends Node2D
@onready var cooldown: Timer = $Node/cooldown
var type=null
var arrow=preload("res://scenes/arrow.tscn")
var range=150
func _ready():
	cooldown.start()
func fire():
	match type:
		"1":
			var bullet=arrow.instantiate()
			get_parent().add_child(bullet)
func _draw() -> void:
	draw_circle(Vector2.ZERO,range,Color.WHITE,false,3)

func _on_cooldown_timeout() -> void:
	pass # Replace with function body.
