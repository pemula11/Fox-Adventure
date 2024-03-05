extends CharacterBody2D
class_name  Player

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var sound = $sound
@onready var shooter = $Shooter
@onready var animation_player_invisible = $AnimationPlayerInvisible
@onready var invisible_timer = $InvisibleTimer
@onready var hurt_timer = $HurtTimer


const GRAVITY: float = 1000.0
const RUN_SPEED: float = 320.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -400.0
const HURT_JUMP_VELOCITY : Vector2 = Vector2(0, -150.0)

enum PLAYER_STATE { IDLE, RUN, JUMP, FALL, HURT }

var _state: PLAYER_STATE = PLAYER_STATE.IDLE
var _invisible :bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y  += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_states()
	update_debug_label()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func  shoot():
	if sprite.flip_h == true:
		shooter.shoot(Vector2.LEFT)
	else:
		shooter.shoot(Vector2.RIGHT)


func update_debug_label():
	debug_label.text = "floor: %s\n %s \n %s\n%.0f,%.0f" % [
		is_on_floor(), _invisible,
		PLAYER_STATE.keys()[_state],
		velocity.x, velocity.y
	]

func get_input():
	velocity.x = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = - RUN_SPEED
		sprite.flip_h = true
		
	elif Input.is_action_pressed("right"):
		velocity.x =  RUN_SPEED
		sprite.flip_h = false
		
	if Input.is_action_just_pressed("jump") == true and is_on_floor() == true:
		velocity.y = JUMP_VELOCITY
		SoundManager.play_clip(sound, SoundManager.SOUND_JUMP)
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)


func calculate_states():
	if _state == PLAYER_STATE.HURT:
		return
	
	if is_on_floor() == true:
		if velocity.x == 0 :
			set_state(PLAYER_STATE.IDLE)
		else: 
			set_state(PLAYER_STATE.RUN)
	else :
		if  velocity.y > 0:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)
	
func set_state(new_state: PLAYER_STATE):
	
	if _state == new_state:
		return
	
	if _state == PLAYER_STATE.FALL:
		if new_state == PLAYER_STATE.IDLE or new_state == PLAYER_STATE.RUN:
			SoundManager.play_clip(sound, SoundManager.SOUND_LAND)
	
	_state = new_state
	match _state:
		PLAYER_STATE.IDLE:
			animation_player.play("idle")
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.HURT:
			apply_hurt_jump()
		PLAYER_STATE.FALL:
			animation_player.play("fall")
		PLAYER_STATE.RUN:
			animation_player.play("run")


func  apply_hurt_jump():
	
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()
	SignalManager.on_player_hit.emit(0)

func go_invisible():
	_invisible = true
	animation_player_invisible.play("invisible")
	invisible_timer.start()

func  apply_hit():
	if _invisible == true:
		return
	go_invisible()
	set_state(PLAYER_STATE.HURT)
	SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)

func _on_invisible_timer_timeout():
	_invisible = false
	animation_player_invisible.stop()

func _on_hitbox_area_entered(area):
	apply_hit()


func _on_hurt_timer_timeout():
	set_state(PLAYER_STATE.IDLE)
