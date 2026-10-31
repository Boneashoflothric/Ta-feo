extends CharacterBody2D

signal died

const GROUND_Y := 560.0
const SPEED := 260.0
const GRAVITY := 1400.0
const JUMP_FORCE := -560.0

var health := 100
var facing := 1
var fire_timer := 0.0
var invuln_timer := 0.0

func _ready() -> void:
    add_to_group("player")
    global_position = Vector2(170, GROUND_Y)
    $Body.color = Color(0.25, 0.80, 0.95)
    $Muzzle.visible = false

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
        $Body.scale.x = facing
        $Muzzle.scale.x = facing

    if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
        shoot()

    move_and_slide()

func shoot() -> void:
    if fire_timer > 0.0:
        return

    fire_timer = 0.18
    var closest: Node = null
    var closest_dist := INF

    for enemy in get_tree().get_nodes_in_group("enemies"):
        if enemy == null or not is_instance_valid(enemy):
            continue

        var dist := global_position.distance_to(enemy.global_position)
        var in_front := (enemy.global_position.x - global_position.x) * facing > 0.0
        var in_height_range := abs(enemy.global_position.y - global_position.y) < 90.0

        if in_front and in_height_range and dist < 360.0 and dist < closest_dist:
            closest = enemy
            closest_dist = dist

    if closest != null and closest.has_method("take_damage"):
        closest.take_damage(1)

    $Muzzle.visible = true
    $Muzzle.scale.x = facing
    get_tree().create_timer(0.08).timeout.connect(func() -> void:
        $Muzzle.visible = false
    )

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
