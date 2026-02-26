extends Area2D

@onready var color_rect: ColorRect = $ColorRect
@onready var enemy_offset = color_rect.size.x / 2
@onready var enemy_height = color_rect.size.y
@onready var ball_height: float = $"../Ball/ColorRect".size.y / 2

@export var speed: int = 100

var _direction

func _ready() -> void:
	if position != Vector2(get_viewport_rect().size.x - (25 + enemy_offset), get_viewport_rect().size.y / 2):
		position.x = get_viewport_rect().size.x - (25 + enemy_offset)
		position.y = get_viewport_rect().size.y / 2

func _process(delta: float) -> void:
	var ball = get_tree().get_first_node_in_group("ball")
	if ball.position.x > get_viewport_rect().size.x / 2:
		move_enemy(ball, delta)
	# TODO else:
		#move_random()
	
	position.y = clamp(position.y, 0 + (enemy_height / 2), get_viewport_rect().size.y - (enemy_height / 2))
	
	#print("Ball Position = ", ball.position.y, "\n Enemy Position = ", position.y)

func move_enemy(ball, delta) -> void:
	if ball.position.y < position.y:
		position.y -= speed * delta
		_direction = Vector2.UP
	elif ball.position.y > position.y:
		position.y += speed * delta
		_direction = Vector2.DOWN
	else:
		_direction = Vector2.ZERO

func _on_area_entered(area: Area2D) -> void:
	var ball = get_tree().get_first_node_in_group("ball")
	
	if area == ball:
		area.direction = Vector2.LEFT
		area.change_direction(_direction)
