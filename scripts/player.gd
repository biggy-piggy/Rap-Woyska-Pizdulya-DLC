extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal defeated(fighter_name: String)

const GRAVITY := 1900.0
const SPEED := 350.0
const JUMP_VELOCITY := -720.0
const FLOOR_Y := 548.0

@export var player_index := 1
@export var fighter_name := "Dolboyob"
@export var body_color := Color("#f05d5e")

var max_health := 100
var health := 100
var facing := 1
var attack_time_left := 0.0
var attack_cooldown := 0.0
var special_cooldown := 0.0
var hit_targets := {}

@onready var visual: ColorRect = $Visual
@onready var name_label: Label = $NameLabel
@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D


func _ready() -> void:
	visual.color = body_color
	name_label.text = fighter_name
	hitbox.monitoring = false
	hitbox_shape.disabled = true
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	health_changed.emit(health, max_health)


func _physics_process(delta: float) -> void:
	_update_timers(delta)
	_read_controls()
	move_and_slide()
	_lock_to_stage()


func _update_timers(delta: float) -> void:
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	special_cooldown = maxf(0.0, special_cooldown - delta)
	attack_time_left = maxf(0.0, attack_time_left - delta)
	if attack_time_left <= 0.0:
		_set_hitbox_enabled(false)


func _read_controls() -> void:
	var left_key := KEY_A if player_index == 1 else KEY_LEFT
	var right_key := KEY_D if player_index == 1 else KEY_RIGHT
	var jump_key := KEY_W if player_index == 1 else KEY_UP
	var attack_key := KEY_F if player_index == 1 else KEY_J
	var special_key := KEY_G if player_index == 1 else KEY_K

	var direction := 0.0
	if Input.is_key_pressed(left_key):
		direction -= 1.0
	if Input.is_key_pressed(right_key):
		direction += 1.0

	velocity.x = direction * SPEED
	if direction != 0.0:
		facing = int(sign(direction))
		scale.x = facing

	if not is_on_floor():
		velocity.y += GRAVITY * get_physics_process_delta_time()
	elif Input.is_key_pressed(jump_key):
		velocity.y = JUMP_VELOCITY

	if Input.is_key_pressed(attack_key) and attack_cooldown <= 0.0:
		_start_attack(10, 0.16, 0.36)
	if Input.is_key_pressed(special_key) and special_cooldown <= 0.0:
		_start_attack(24, 0.26, 1.35)
		special_cooldown = 2.0


func _start_attack(damage: int, active_time: float, cooldown: float) -> void:
	hit_targets.clear()
	hitbox.set_meta("damage", damage)
	attack_time_left = active_time
	attack_cooldown = cooldown
	_set_hitbox_enabled(true)


func _set_hitbox_enabled(enabled: bool) -> void:
	hitbox.monitoring = enabled
	hitbox_shape.disabled = not enabled
	hitbox.visible = enabled


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "Hurtbox":
		return

	var target := area.get_parent()
	if target == self or not target.has_method("take_hit"):
		return
	if hit_targets.has(target):
		return

	hit_targets[target] = true
	target.take_hit(int(hitbox.get_meta("damage", 10)), global_position)


func take_hit(amount: int, source_position: Vector2) -> void:
	if health <= 0:
		return

	health = maxi(0, health - amount)
	velocity.x = sign(global_position.x - source_position.x) * 520.0
	velocity.y = -220.0
	health_changed.emit(health, max_health)

	if health <= 0:
		defeated.emit(fighter_name)


func reset_fighter(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	health = max_health
	health_changed.emit(health, max_health)


func _lock_to_stage() -> void:
	global_position.x = clampf(global_position.x, 88.0, 1192.0)
	if global_position.y > FLOOR_Y:
		global_position.y = FLOOR_Y
		velocity.y = 0.0
