extends Area2D

@export var speed: int = 325

@onready var color_rect: ColorRect = $ColorRect

@onready var player_offset = color_rect.size.x / 2
@onready var player_height = color_rect.size.y
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var ball: Area2D = %Ball

var _direction

func _ready() -> void:
	# Set player position at the start of the game
	if position != Vector2(25 + player_offset, get_viewport_rect().size.y):
		position.x = 25.0 + player_offset
		position.y = get_viewport_rect().size.y / 2

func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		position.y -= speed * delta
		_direction = Vector2.UP
	elif Input.is_action_pressed("down"):
		position.y += speed * delta
		_direction = Vector2.DOWN
	else:
		_direction = Vector2.ZERO
	position.y = clamp(position.y, 0 + (player_height / 2), get_viewport_rect().size.y - (player_height / 2))

func _on_area_entered(area: Area2D) -> void:
	var ball = get_tree().get_first_node_in_group("ball")
	
	if area == ball:
		area.direction = Vector2.RIGHT
		while _direction == Vector2.ZERO:
			_direction.y = randi_range(-1, 1)
			
		area.change_direction(_direction)
