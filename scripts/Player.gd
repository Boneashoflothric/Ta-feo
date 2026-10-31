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
    var skin := Color(0.82, 0.60, 0.46)
    var jacket := Color(0.18, 0.20, 0.25)
    var jacket_dark := Color(0.09, 0.10, 0.12)
    var red := Color(0.92, 0.18, 0.18)
    var hair := Color(0.29, 0.17, 0.10)
    var pants := Color(0.16, 0.17, 0.20)
    var shoes := Color(0.10, 0.09, 0.09)

    draw_rect(Rect2(-18, -46, 36, 48), jacket)
    draw_rect(Rect2(-20, -28, 40, 24), jacket_dark)
    draw_rect(Rect2(-8, -56, 16, 14), skin)
    draw_rect(Rect2(-12, -58, 24, 12), hair)
    draw_rect(Rect2(-18, -30, 10, 34), red)
    draw_rect(Rect2(8, -30, 10, 34), red)
    draw_rect(Rect2(-10, -10, 8, 34), pants)
    draw_rect(Rect2(2, -10, 8, 34), pants)
    draw_rect(Rect2(-12, 22, 10, 14), shoes)
    draw_rect(Rect2(2, 22, 10, 14), shoes)
    draw_rect(Rect2(-22, -18, 6, 16), jacket_dark)
    draw_rect(Rect2(16, -18, 6, 16), jacket_dark)
    draw_rect(Rect2(-4, -46, 8, 12), skin)
    draw_rect(Rect2(-12, -6, 24, 8), red)
