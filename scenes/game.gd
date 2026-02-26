extends Node2D

@onready var ball_starting_position: Vector2 = Vector2(get_viewport_rect().size / 2)
@onready var enemy_score_label: Label = %EnemyScoreLabel
@onready var player_score_label: Label = %PlayerScoreLabel
@onready var ball: Area2D = %Ball
@onready var enemy: Area2D = %Enemy
@onready var player: Area2D = %Player
@onready var game_over_container: VBoxContainer = %GameOverContainer
@onready var winner_text: Label = %WinnerText
# 12.5 is the player and enemy offse (ColorRect size.x / 2)
@onready var player_starting_position: Vector2 = Vector2(25.0 + 12.5, \
		get_viewport_rect().size.y / 2)
@onready var enemy_starting_position: Vector2 = Vector2(get_viewport_rect().size.x - (25 + 12.5), \
		get_viewport_rect().size.y / 2)

@onready var game_sfx: AudioStreamPlayer2D = %GameSFX

@export var score_sfx: AudioStreamOggVorbis
@export var win_sfx: AudioStreamOggVorbis
@export var lose_sfx: AudioStreamOggVorbis
@export var clear_sfx: AudioStreamOggVorbis

var player_score: int = 0
var enemy_score: int = 0


func _ready() -> void:
	print("Viewport (Game Logic) Size: ", get_viewport_rect().size)
	print("Window (Physical Screen) Size: ", DisplayServer.window_get_size())
	var starting_scores: Array[int]
	starting_scores.append(player_score)
	starting_scores.append(enemy_score)

func score_goal(side):
	match side:
		"enemy":
			enemy.position = enemy_starting_position
			player_score += 1
			player_score_label.text = "Player: " + str(player_score)
			play_sfx(score_sfx)
			
		"player":
			enemy_score += 1
			enemy_score_label.text = "Enemy: " + str(enemy_score)
			play_sfx(score_sfx)
		"reset":
			enemy_score = 0
			player_score = 0
			player_score_label.text = "Player: " + str(player_score)
			enemy_score_label.text = "Enemy: " + str(enemy_score)
			play_sfx(clear_sfx)
			
	if player_score + enemy_score == 5 or player_score >= 3 or enemy_score >= 3:
		if player_score > enemy_score:
			end_game("Player")
		if player_score < enemy_score:
			end_game("Enemy")

func reset_positions() -> void:
	enemy.position = enemy_starting_position
	player.position = player_starting_position
	ball.position = ball_starting_position

func _on_game_area_area_exited(area: Area2D) -> void:
	var side: String
	if area == ball and area.global_position.x < get_viewport_rect().size.x / 2:
		side = "player"
		score_goal(side)
	elif area == ball and area.global_position.x > get_viewport_rect().size.x / 2:
		side = "enemy"
		score_goal(side)
	if area == ball:
		reset_positions()
		area.vertical_speed = 0

func end_game(winner: String) -> void:
	ball.position = ball_starting_position
	game_over_container.show()
	ball.hide()
	get_tree().paused = true
	winner_text.text = winner + " Wins!"
	if winner == "Enemy":
		winner_text.label_settings["font_color"] = Color(1, 0, 0)
		play_sfx(lose_sfx)
	elif winner == "Player":
		play_sfx(win_sfx)

func restart_game():
	game_over_container.hide()
	get_tree().paused = false
	reset_positions()
	score_goal("reset")
	ball.direction = Vector2.LEFT
	ball.show()
	if game_sfx.playing:
		game_sfx.stop()

func play_sfx(sfx: AudioStreamOggVorbis) -> void:
	if sfx:
		game_sfx.stream = sfx
		game_sfx.play()
	else:
		printerr("sfx is null")

func _on_button_pressed() -> void:
	restart_game()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
