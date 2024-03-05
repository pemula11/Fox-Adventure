extends Area2D

const TRIGGER_CONDITION : String = "parameters/conditions/on_trigger"
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sound = $sound


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_boss_kill.connect(on_boss_killed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_boss_killed(_p):
	animation_tree[TRIGGER_CONDITION] = true
	monitoring = true
	SoundManager.play_clip(sound, SoundManager.SOUND_WIN)

func _on_area_entered(area):
	print("level")
