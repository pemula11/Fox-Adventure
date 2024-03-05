extends Area2D

var _direction: Vector2 = Vector2.RIGHT
var _life_span: float = 20.0
var _life_time: float =  0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_expired(delta)
	position += _direction * delta 

func  setup(dir : Vector2, lifespan: float, speed: float):
	_direction = dir.normalized() * speed
	_life_span = lifespan

func check_expired(delta):
	_life_time += delta
	if _life_time > _life_span:
		queue_free()

func _on_area_entered(area):
	queue_free()

