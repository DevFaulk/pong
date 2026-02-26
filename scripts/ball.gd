extends Area2D

@export var speed: float = 300.0

@onready var color_rect: ColorRect = $ColorRect
@onready var ball_height = color_rect.size.y
@onready var ball_sfx: AudioStreamPlayer2D = %BallSFX

@export var paddle_sfx: Array[AudioStreamOggVorbis]
@export var wall_sfx: Array[AudioStreamOggVorbis]

var vertical_speed: float

var direction : Vector2 = Vector2.LEFT

func _process(delta: float) -> void:
	if direction == Vector2.LEFT:
		position.x -= speed * delta
	elif direction == Vector2.RIGHT:
		position.x += speed * delta
	position.y += vertical_speed * delta
	position.y = clamp(position.y, 0 + (ball_height / 2), get_viewport_rect().size.y - (ball_height / 2))
	
	if position.y == 0 + (ball_height / 2) \
	or position.y == get_viewport_rect().size.y - (ball_height / 2):
		play_hit_sfx(wall_sfx.pick_random())
	
	
	if position.y == 0 + (ball_height / 2):
		vertical_speed = -vertical_speed
		
	elif position.y == get_viewport_rect().size.y - (ball_height / 2):
		vertical_speed = -vertical_speed
		

func play_hit_sfx(sfx: AudioStreamOggVorbis) -> void:
	if sfx:
		ball_sfx.stream = sfx
		ball_sfx.play(position.x)
	else:
		printerr("sfx is null")

func change_direction(velocity):
	play_hit_sfx(paddle_sfx.pick_random())
	if velocity == Vector2.UP:
		vertical_speed = randi_range(-50, -250)
	elif velocity == Vector2.ZERO:
		vertical_speed = vertical_speed
	else:
		vertical_speed = randi_range(50, 250)
		
