extends Node2D

@onready var player_one = $Players/PlayerOne
@onready var player_two = $Players/PlayerTwo
@onready var p1_health: ProgressBar = $UI/HUD/P1Health
@onready var p2_health: ProgressBar = $UI/HUD/P2Health
@onready var status_label: Label = $UI/HUD/StatusLabel


func _ready() -> void:
	player_one.health_changed.connect(_on_p1_health_changed)
	player_two.health_changed.connect(_on_p2_health_changed)
	player_one.defeated.connect(_on_fighter_defeated)
	player_two.defeated.connect(_on_fighter_defeated)
	_on_p1_health_changed(player_one.health, player_one.max_health)
	_on_p2_health_changed(player_two.health, player_two.max_health)


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		_reset_round()


func _on_p1_health_changed(current: int, maximum: int) -> void:
	p1_health.max_value = maximum
	p1_health.value = current


func _on_p2_health_changed(current: int, maximum: int) -> void:
	p2_health.max_value = maximum
	p2_health.value = current


func _on_fighter_defeated(fighter_name: String) -> void:
	status_label.text = "%s received pizdulya. Press R for revenge." % fighter_name


func _reset_round() -> void:
	player_one.reset_fighter(Vector2(360, 548))
	player_two.reset_fighter(Vector2(920, 548))
	status_label.text = "Friendship ended. Hitbox started."
