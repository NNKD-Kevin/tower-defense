extends CharacterBody2D
class_name Tower
@onready var base: AnimatedSprite2D = $Base
@onready var weapon: AnimatedSprite2D = $Weapon
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var menu: Panel = $CanvasLayer/Menu
@onready var upgrade_button: Button = $CanvasLayer/Menu/UpgradeButton
@onready var sell_button: Button = $CanvasLayer/Menu/SellButton
@onready var priority_button: Button = $CanvasLayer/Menu/PriorityButton
@onready var tower_name: Label = $CanvasLayer/Menu/TowerName
@onready var stats_label: Label = $CanvasLayer/Menu/Stats
@onready var upgrade_stats: Label = $CanvasLayer/Menu/UpgradeStats
@onready var tower_icon: AnimatedSprite2D = $"CanvasLayer/Menu/Tower Icon"


const top=5
const bottom=85
const left=20
const right=20
const move_speed=2000
var road:Node2D
var exclusion:TileMap
var type='1'
var level=1

var arrow=preload("res://scenes/arrow.tscn")
var lightning=preload("res://scenes/lightning.tscn")
var explode_ball=preload("res://scenes/explode_ball.tscn")
var light_ray=preload("res://scenes/light_ray.tscn")
var speed_arrow=preload("res://scenes/speedarrow.tscn")
var fire_bomb=preload("res://scenes/fire.tscn")
var damages=[]
var speeds=[]
var ranges=[]
var damage:float
var speed:float
var range:float
var cooldown_finished=true
var cooldown_time=1
var bullet=null
var menu_on=false
var mouse_on=true
var dragging=true
var overlapping_tower=false
var title=''
var costs=[100,150,300]
var priorities=['first','last','strongest','weakest','nearest','furthest']
var priority_index=0
var priority='first'
var stats:Dictionary
var spent=0
var durations=[]
var radiuses=[]
var distances=[]
var a=0
var check=false
var target=null

func _ready():
	if road:
		exclusion = road.get_node('TowerExclusion') as TileMap
	global_position=Vector2(600,-100)
	title = TowerData.STATS[type].name
	tower_name.text=title
	costs= TowerData.STATS[type].costs
	spent+=costs[0]
	stats=TowerData.STATS[type].stats
	damages=stats.damage
	speeds=stats.speed
	ranges=stats.range
	match type:
		'2': durations=stats.duration
		'3': radiuses=stats.radius
		'5': distances=stats.distance
	update()

func fire():
	match type:
		"1":
			bullet=arrow.instantiate()
		"2":
			bullet=lightning.instantiate()
		"3":
			bullet=explode_ball.instantiate()
		"5":
			bullet=light_ray.instantiate()
		"6":
			bullet=speed_arrow.instantiate()
		"7":
			bullet=fire_bomb.instantiate()
	bullet.range=range
	bullet.level=level
	bullet.target=target
	bullet.add_collision_exception_with(self)
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	
func _input(event: InputEvent) -> void:
	if dragging and event.is_action_pressed("drag"):
		if Global.build_valid:
			dragging = false
			Global.coins-=costs[0]
		else:
			queue_free()
		Global.building_mode = false
		get_viewport().set_input_as_handled()
		queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if dragging or not event.is_action_pressed("drag"):
		return
	menu_on = mouse_on
	queue_redraw()

func _draw() -> void:
	if dragging or menu_on:
		draw_circle(weapon.position,range,Color.WHITE,false,3)
	if mouse_on and not dragging:
		var size:Vector2=collision_shape_2d.shape.size
		var rect=Rect2(collision_shape_2d.position-size/2.0,size)
		draw_rect(rect,Color.WHITE,false,2)

func check_valid_build():
	if exclusion == null:
		Global.build_valid = false
		return
	var mouse_pos = get_global_mouse_position()
	var cell = exclusion.local_to_map(exclusion.to_local(mouse_pos))
	global_position=exclusion.to_global(exclusion.map_to_local(cell))
	Global.build_valid = area_free(global_position) and not overlapping_tower

func area_free(center):
	var top_left=exclusion.local_to_map(exclusion.to_local(center + Vector2(-left, -top)))
	var bottom_right=exclusion.local_to_map(exclusion.to_local(center + Vector2(right, bottom)))
	for x in range(top_left.x,bottom_right.x+1):
		for y in range(top_left.y,bottom_right.y+1):
			if exclusion.get_cell_source_id(0, Vector2i(x, y)) != -1:
				return false
	return true
func is_mouse_over() -> bool:
	var size: Vector2 = collision_shape_2d.shape.size
	var rect = Rect2(collision_shape_2d.position - size / 2.0, size)
	return rect.has_point(to_local(get_global_mouse_position()))

func update():
	base.play(type+'_'+str(level))
	weapon.play(type+'_'+str(level))
	damage=damages[level-1]
	range=ranges[level-1]
	queue_redraw()
	speed=speeds[level-1]
	tower_icon.play(str(type)+'_'+str(level))
	sell_button.text=str(int(spent/2))
	upgrade_button.text=str(costs[level]) if level<3 else 'MAX'
	stats_label.text='Level '+ str(level)
	stats_label.text+='\nDmg: '+str(damage)
	stats_label.text+='\nspeed: '+str(speed)
	stats_label.text+='\nrange: '+str(range)
	match type:
		'2':stats_label.text+='\nDuration: '+str(durations[level-1])
		'3':stats_label.text+='\nRadius: '+str(radiuses[level-1])
		'5':stats_label.text+='\nDistance: '+str(distances[level-1])
	if level<3:
		upgrade_stats.text='Level '+str(level+1)
		upgrade_stats.text+='\nDmg: '+str(damages[level])
		upgrade_stats.text+='\nspeed: '+str(speeds[level])
		upgrade_stats.text+='\nrange: '+str(ranges[level])
		match type:
			'2':upgrade_stats.text+='\nDuration: '+str(durations[level])
			'3':upgrade_stats.text+='\nRadius: '+str(radiuses[level])
			'5':upgrade_stats.text+='\nDistance: '+str(distances[level])
func _process(delta: float) -> void:
	target=null
	var over = is_mouse_over()
	if over != mouse_on:
		mouse_on = over
		queue_redraw()
	menu.visible=menu_on
	menu.global_position=global_position+Vector2(30,-100)
	weapon.global_position=global_position-Vector2(0,-(3-level)*9)
	base.global_position=global_position-Vector2(0,-26)
	if dragging:
		check_valid_build()
	else:
		check=false
		if len(Global.enemies)>0:
			for e in Global.enemies:
				if not is_instance_valid(e):
					return
				if weapon.global_position.distance_to(e.global_position)<=range:
					check=true
					break
			if check:
				if weapon.animation!=type+'_'+str(level)+'fire':
					weapon.play(type+'_'+str(level)+'fire')
	if weapon.animation==type+'_'+str(level)+'fire' and check:
		match priority:
			'first':check_first()
			'last':check_last()
			'strongest':check_strong()
			'weakest':check_weak()
			'nearest':check_near()
			'furthest':check_far()
		var direction=(Global.enemies[a].global_position-weapon.global_position).normalized()
		if type=='1' or type=='7' or type=='6': weapon.rotation=direction.angle()-TAU*3/4
		target=Global.enemies[a]
func check_first():
	a=0
	while (weapon.global_position.distance_to(Global.enemies[a].global_position)>range):
		if a<len(Global.enemies)-1:
			a+=1
func check_last():
	a=len(Global.enemies)-1
	while (weapon.global_position.distance_to(Global.enemies[a].global_position)>range):
		if a>0:
			a-=1
func check_weak():
	var b=1000000000000000
	for i in Global.enemies:
		if i in Global.enemies:
			if i.hp<b and weapon.global_position.distance_to(i.global_position)<=range:
				b=i.hp
				a=Global.enemies.find(i)
func check_strong():
	var b=0
	for i in Global.enemies:
		if i in Global.enemies:
			if i.hp>b and weapon.global_position.distance_to(i.global_position)<=range:
				b=i.hp
				a=Global.enemies.find(i)
func check_far():
	var b=0
	for i in Global.enemies:
		var c=weapon.global_position.distance_to(i.global_position)
		if c>b and c<=range:
			b=c
			a=Global.enemies.find(i)
func check_near():
	var b=1000000
	for i in Global.enemies:
		var c=weapon.global_position.distance_to(i.global_position)
		if c<b and c<=range:
			b=c
			a=Global.enemies.find(i)
					
func _physics_process(delta: float) -> void:
	if not dragging:
		return
	overlapping_tower=false
	var mouse_pos=get_global_mouse_position()
	var direction=(mouse_pos-position).normalized()
	velocity=direction*move_speed
	var collision=move_and_collide(velocity*delta)
	if global_position.distance_to(mouse_pos)<50:
		global_position=mouse_pos
	if collision and collision.get_collider() is Tower:
		overlapping_tower=true
		



func _on_weapon_animation_finished() -> void:
	if weapon.animation==(type+'_'+str(level)+'fire'):
		if target!=null: fire()
		weapon.play(type+'_'+str(level))


func _on_upgrade_pressed() -> void:
	if level<3 and Global.coins>=costs[level]:
		Global.coins-=costs[level]
		spent+=costs[level]
		level+=1
		update()

func _on_sell_pressed() -> void:
	Global.coins+=int(0.5*spent)
	queue_free()

func _on_priority_pressed() -> void:
	priority_index+=1
	priority=priorities[priority_index%6]
	priority_button.text=priority
