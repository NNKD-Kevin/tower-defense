extends CharacterBody2D
class_name Tower
@onready var base: AnimatedSprite2D = $Base
@onready var weapon: AnimatedSprite2D = $Weapon
@onready var cooldown: Timer = $Node/cooldown

const top=10
const bottom=85
const left=20
const right=20
const speed=2000
var road:Node2D
var exclusion:TileMap
var type='1'
var level=1
var arrow=preload("res://scenes/arrow.tscn")
var lightning=preload("res://scenes/lightning.tscn")
var range=150
var cooldown_finished=true
var cooldown_time=1
var bullet=null
var menu_on=false
var mouse_on=true
var dragging=true
var overlapping_tower=false
func _ready():
	weapon.play(type+'_'+str(level))
	if road:
		exclusion = road.get_node('TowerExclusion') as TileMap
	base.play(type+'_1')
	global_position=Vector2(600,-100)
func fire():
	match type:
		"1":
			bullet=arrow.instantiate()
		"2":
			bullet=lightning.instantiate()
	bullet.range=range
	bullet.add_collision_exception_with(self)
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	
func _input(event: InputEvent) -> void:
	if mouse_on and Input.is_action_just_pressed("drag"):
		if dragging and Global.build_valid: 
			dragging=false
		elif dragging and not Global.build_valid:
			queue_free()
		Global.building_mode=false
		queue_redraw()

func _draw() -> void:
	if dragging:
		draw_circle(Vector2.ZERO,range,Color.WHITE,false,3)


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


func _process(delta: float) -> void:
	base.global_position=global_position+Vector2(0,-(3-level)*9+26)
	if dragging:
		check_valid_build()
	else:
		if len(Global.enemies)>0:
			for e in Global.enemies:
				if position.distance_to(e.position)<=range:
					var direction=(e.position-position).normalized()
					if type=='1' or type=='7' or type=='6': weapon.rotation=direction.angle()-TAU*3/4
					if weapon.animation!=type+'_'+str(level)+'fire':
						weapon.play(type+'_'+str(level)+'fire')
					break
func _physics_process(delta: float) -> void:
	if not dragging:
		return
	overlapping_tower=false
	var mouse_pos=get_global_mouse_position()
	var direction=(mouse_pos-position).normalized()
	velocity=direction*speed
	var collision=move_and_collide(velocity*delta)
	if global_position.distance_to(mouse_pos)<50:
		global_position=mouse_pos
	if collision and collision.get_collider() is Tower:
		overlapping_tower=true
		



func _on_weapon_animation_finished() -> void:
	if weapon.animation==(type+'_'+str(level)+'fire'):
		fire()
		weapon.play(type+'_'+str(level))


func _on_mouse_entered() -> void:
	mouse_on=true


func _on_mouse_exited() -> void:
	mouse_on=false
