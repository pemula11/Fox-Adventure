extends Node

const GROUP_PLAYER: String = "player"

const TOTAL_LEVELS: int = 3
const MAIN_SCENE: PackedScene = preload("res://src/scene/main/main.tscn")

var _current_level : int = 0
var _level_scene = {}

func _ready():
	init_level_scene()

func init_level_scene():
	for ln in range(1, TOTAL_LEVELS+1):
		_level_scene[ln] = load("res://src/scene/Level/levels/level_%s.tscn" % ln)


func  load_main_scene():
	_current_level = 0 
	get_tree().change_scene_to_packed(MAIN_SCENE)
	

func  load_next_level_scene():
	set_next_level()
	get_tree().change_scene_to_packed(_level_scene[_current_level])

func set_next_level():
	_current_level += 1
	if _current_level > TOTAL_LEVELS:
		_current_level =1
