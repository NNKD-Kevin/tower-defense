extends Node2D
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer
@onready var wave_count: Label = $CanvasLayer/WaveCount
@onready var coin_count: Label = $CanvasLayer/CoinCount/Label
@onready var panel: Panel = $CanvasLayer/Panel
@onready var map_1: Node2D = $Map1
@onready var green_overlay: ColorRect = $GreenOverlay
@onready var red_overlay: ColorRect = $RedOverlay
@onready var portal: AnimatedSprite2D = $Portal
@onready var start: Button = $CanvasLayer/Start
@onready var skip_button: Button = $CanvasLayer/SkipButton
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

@onready var label: Label = $CanvasLayer/Panel/tower1/Label
@onready var label_2: Label = $CanvasLayer/Panel/tower2/Label2
@onready var label_3: Label = $CanvasLayer/Panel/tower3/Label3
@onready var label_5: Label = $CanvasLayer/Panel/tower5/Label5
@onready var label_6: Label = $CanvasLayer/Panel/tower6/Label6
@onready var label_7: Label = $CanvasLayer/Panel/tower7/Label7
@onready var label_8: Label = $CanvasLayer/Panel/tower8/Label8
@onready var labels = {
	'1': label, '2': label_2, '3': label_3, '5': label_5,
	'6': label_6, '7': label_7, '8': label_8,
}






var shop_on=false
var spawning=false
var enemy=preload('res://scenes/enemy.tscn')
var index=0
var to_spawn=[]

func _ready() -> void:
	green_overlay.visible=false
	red_overlay.visible=false
	for t in labels:
		labels[t].text = str(TowerData.STATS[t].costs[0])
		
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
	health_bar.value=Global.health
	if wave_timer.time_left<25:
		skip_button.visible=true
	wave_count.text='Wave '+str(Global.wave)
	coin_count.text=':'+str(Global.coins)
	panel.visible=shop_on
	green_overlay.visible=Global.build_valid and Global.building_mode
	red_overlay.visible= not Global.build_valid and Global.building_mode

	
	


func _on_start_pressed() -> void:
	start.visible=false
	skip_button.visible=true
	skip_wave()
	



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
	if Global.coins>=TowerData.STATS[type]['costs'][0]:
		var e=tower.instantiate()
		e.add_to_group('towers')
		e.type=type
		e.road=map_1
		e.add_collision_exception_with(e)	
		add_child(e)
		shop_on= not shop_on
		Global.building_mode=true
	
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

func skip_wave():
	if Global.wave<len(EnemyData.WAVES):
		Global.coins+=110+20*Global.wave
		index=0
		to_spawn=EnemyData.WAVES[str(Global.wave)]
		spawn_timer.start()
		spawning=true
		Global.wave+=1
		wave_timer.start()

func _on_wave_timer_timeout() -> void:
	skip_wave()


func _on_skip_button_pressed() -> void:
	if skip_button.visible:
		skip_wave()
		skip_button.visible=false
