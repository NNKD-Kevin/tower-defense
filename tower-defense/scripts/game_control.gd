extends Node2D
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_count: Label = $CanvasLayer/WaveCount
@onready var coin_count: Label = $CanvasLayer/CoinCount/Label
@onready var panel: Panel = $CanvasLayer/Panel
@onready var map_1: Node2D = $Map1

var shop_on=false
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
	Global.enemies.append(e)
	add_child(e)
func _process(delta: float) -> void:
	wave_count.text='Wave '+str(Global.wave)
	coin_count.text=':'+str(Global.coins)
	panel.visible=shop_on
	
	


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


func _on_shop_pressed() -> void:
	shop_on= not shop_on
	
	
	
#Buy tower
var tower=preload('res://scenes/tower.tscn')

func buy_tower(type):
	var e=tower.instantiate()
	e.add_to_group('towers')
	e.type=type
	e.road=map_1
	add_child(e)
	shop_on= not shop_on
func _on_tower_1_pressed() -> void:
	buy_tower('1')
	
func _on_tower_2_pressed() -> void:
	buy_tower('2')

func _on_tower_3_pressed() -> void:
	buy_tower('3')
	
func _on_tower_5_pressed() -> void:
	buy_tower('5')

func _on_tower_6_pressed() -> void:
	buy_tower('6')

func _on_tower_7_pressed() -> void:
	buy_tower('7')

func _on_tower_8_pressed() -> void:
	buy_tower('8')
