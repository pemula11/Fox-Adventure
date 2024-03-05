extends Camera2D

@onready var shaker_timer = $ShakerTimer
@export var shake_amount:float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	SignalManager.on_player_hit.connect(on_playert_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset = get_random_offset()

func  shake():
	set_process(true)
	shaker_timer.start()
	

func get_random_offset():
	return Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)

func _on_shaker_timer_timeout():
	set_process(false)
	offset = Vector2.ZERO

func on_playert_hit(_lives: int):
	shake()
