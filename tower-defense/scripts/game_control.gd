extends Node2D
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_count: Label = $CanvasLayer/WaveCount

var spawning=false
var enemy=preload('res://scenes/enemy.tscn')
var index=0
var to_spawn=[]

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("spawn"):
		spawn_enemy('blood')
func spawn_enemy(type:String):
	var e=enemy.instantiate()
	e.add_to_group('enemies')
	e.type=type
	add_child(e)
func _process(delta: float) -> void:
	wave_count.text='Wave '+str(Global.wave)
	


func _on_start_pressed() -> void:
	index=0
	to_spawn=EnemyData.WAVES[str(Global.wave)]
	spawn_timer.start()
	spawning=true
	Global.wave+=1



func _on_spawn_timer_timeout() -> void:
	if not spawning:
		return
	spawn_enemy(to_spawn[index])
	index += 1
	if index >= len(to_spawn):
		spawning = false
		spawn_timer.stop()
