extends CharacterBody2D

signal died

const GROUND_Y := 560.0
const SPEED := 220.0
const GRAVITY := 1200.0
const JUMP_FORCE := -520.0

var health := 100
var facing := 1
var fire_timer := 0.0
var invuln_timer := 0.0

func _ready() -> void:
    add_to_group("player")
    global_position = Vector2(170, GROUND_Y)

func _physics_process(delta: float) -> void:
    if health <= 0:
        return

    fire_timer = max(0.0, fire_timer - delta)
    invuln_timer = max(0.0, invuln_timer - delta)

    var move_dir := 0.0
    if Input.is_action_pressed("ui_left"):
        move_dir -= 1.0
    if Input.is_action_pressed("ui_right"):
        move_dir += 1.0
    if Input.is_action_just_pressed("ui_up") and global_position.y >= GROUND_Y - 2.0:
        velocity.y = JUMP_FORCE

    velocity.x = move_dir * SPEED
    velocity.y += GRAVITY * delta

    if global_position.y >= GROUND_Y:
        global_position.y = GROUND_Y
        velocity.y = 0.0

    if move_dir != 0.0:
        facing = 1 if move_dir > 0 else -1
        scale.x = facing

    if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
        shoot()

    move_and_slide()

func shoot() -> void:
    if fire_timer > 0.0:
        return
    fire_timer = 0.18

    var bullet_scene: PackedScene = preload("res://scenes/Bullet.tscn")
    var bullet = bullet_scene.instantiate()
    bullet.position = global_position + Vector2(24 * facing, -4)
    bullet.direction = Vector2(facing, 0)
    bullet.damage = 10
    get_parent().add_child(bullet)

func take_damage(amount: int) -> void:
    if health <= 0:
        return
    if invuln_timer > 0.0:
        return

    health -= amount
    invuln_timer = 0.35
    if health <= 0:
        health = 0
        emit_signal("died")
        queue_free()

func _draw() -> void:
    var cloak_dark := Color(0.22, 0.17, 0.12)
    var cloak_mid := Color(0.36, 0.30, 0.24)
    var cloak_shadow := Color(0.10, 0.09, 0.08)
    var tunic := Color(0.20, 0.39, 0.26)
    var tunic_dark := Color(0.10, 0.20, 0.14)
    var skin := Color(0.82, 0.62, 0.46)
    var hair := Color(0.21, 0.14, 0.08)
    var belt := Color(0.34, 0.22, 0.12)
    var pants := Color(0.51, 0.35, 0.21)
    var boots := Color(0.10, 0.08, 0.07)
    var accent := Color(0.87, 0.56, 0.22)

    draw_rect(Rect2(-20, -54, 40, 18), cloak_dark)
    draw_rect(Rect2(-30, -44, 60, 12), cloak_mid)
    draw_rect(Rect2(-34, -62, 68, 30), cloak_dark)
    draw_rect(Rect2(-14, -54, 28, 10), cloak_shadow)

    draw_rect(Rect2(-18, -40, 36, 28), tunic)
    draw_rect(Rect2(-18, -34, 36, 10), tunic_dark)
    draw_rect(Rect2(-10, -48, 20, 14), skin)
    draw_rect(Rect2(-12, -50, 24, 14), hair)

    draw_rect(Rect2(-6, -46, 12, 8), skin)
    draw_rect(Rect2(-8, -24, 6, 26), pants)
    draw_rect(Rect2(2, -24, 6, 26), pants)
    draw_rect(Rect2(-12, 2, 10, 18), boots)
    draw_rect(Rect2(2, 2, 10, 18), boots)

    draw_rect(Rect2(-8, -18, 16, 6), belt)
    draw_rect(Rect2(-18, -12, 6, 18), cloak_shadow)
    draw_rect(Rect2(12, -12, 6, 18), cloak_shadow)

    draw_rect(Rect2(-16, -42, 32, 2), accent)
    draw_rect(Rect2(-12, -52, 24, 2), accent)

    draw_rect(Rect2(-6, -50, 2, 8), Color(0.10, 0.08, 0.07))
    draw_rect(Rect2(4, -50, 2, 8), Color(0.10, 0.08, 0.07))
    draw_rect(Rect2(-14, -44, 28, 6), cloak_shadow)

    draw_rect(Rect2(-18, -18, 6, 20), cloak_dark)
    draw_rect(Rect2(12, -18, 6, 20), cloak_dark)
