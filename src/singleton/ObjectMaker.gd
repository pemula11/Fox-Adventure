extends Node

enum  BULLET_KEY { PLAYER, ENEMY }
enum  SCENE_KEY { EXPLOSION, PICKUP }

const BULLETS = {
	BULLET_KEY.PLAYER: preload("res://src/bullets/bullet_player/bullet_player.tscn"),
	BULLET_KEY.ENEMY: preload("res://src/bullets/bullet_enemy/bullet_enemy.tscn")
}

const  SIMPLE_SCENE = {
	SCENE_KEY.EXPLOSION : preload("res://src/enemy_explosion/enemy_explosion.tscn"),
	SCENE_KEY.PICKUP : preload("res://src/fruit/fruit_pick_up.tscn")
}


func  add_child_deffered(child_to_add):
	get_tree().root.add_child(child_to_add)

func call_add_child(child_to_add):
	call_deferred("add_child_deffered", child_to_add)

func create_bullet(speed: float, direction: Vector2, start_pos : Vector2,
					lifespan:float, key: BULLET_KEY):
	var new_b = BULLETS[key].instantiate()
	new_b.setup(direction, lifespan, speed)
	new_b.global_position = start_pos
	call_add_child(new_b)

func  create_simple_scene(start_pos: Vector2, key : SCENE_KEY):
	var new_exp = SIMPLE_SCENE[key].instantiate()
	new_exp.global_position = start_pos
	call_add_child(new_exp)


