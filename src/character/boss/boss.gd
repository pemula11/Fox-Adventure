extends Node2D

const TRIGGER_CONDITION : String = "parameters/conditions/on_trigger"
const HIT_CONDITION : String = "parameters/conditions/on_hit"

@onready var visual = $Visual
@onready var animation_tree = $AnimationTree

@export var lifes: int = 3
@export var points: int = 5

var _invisible : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func tween_hit():
	var tween = get_tree().create_tween()
	tween.tween_property(visual, "position", Vector2.ZERO, 1.0)

func  reduce_lifes():
	lifes -= 1
	if lifes <= 0 :
		SignalManager.on_boss_kill.emit(points)
		set_process(false)
		queue_free()

func  set_invisibility(v : bool):
	_invisible = v
	animation_tree[HIT_CONDITION] = v

func  take_damage():
	if _invisible == true:
		return
	
	set_invisibility(true)
	tween_hit()
	reduce_lifes()

func _on_trigger_area_entered(area):
	if animation_tree[TRIGGER_CONDITION] != true:
		animation_tree[TRIGGER_CONDITION] = true


func _on_hit_box_area_entered(area):
	take_damage()
