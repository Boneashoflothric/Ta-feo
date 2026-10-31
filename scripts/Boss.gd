extends CharacterBody2D

signal boss_defeated

const GROUND_Y := 470.0

var health := 220
var max_health := 220
var speed := 110.0
var attack_timer := 0.0
var phase := 1

func _ready() -> void:
    add_to_group("boss")
    attack_timer = 0.6

func _physics_process(delta: float) -> void:
    if health <= 0:
        return

    var player = get_tree().get_first_node_in_group("player")
    if player == null or not is_instance_valid(player):
        return

    attack_timer -= delta
    if attack_timer <= 0.0:
        do_attack(player)
        attack_timer = 0.85 if phase == 1 else 0.55

    var direction := sign(player.global_position.x - global_position.x)
    var distance := abs(player.global_position.x - global_position.x)

    if distance > 160.0:
        velocity.x = direction * speed
    else:
        velocity.x = 0.0

    if global_position.y < GROUND_Y:
        velocity.y += 1200.0 * delta
    else:
        global_position.y = GROUND_Y
        velocity.y = 0.0

    move_and_slide()

func do_attack(player: Node) -> void:
    if player.has_method("take_damage"):
        player.take_damage(12 if phase == 1 else 16)

    if health < max_health * 0.5:
        phase = 2
        spawn_support()

func spawn_support() -> void:
    var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
    for i in range(2):
        var enemy = enemy_scene.instantiate()
        enemy.enemy_type = "Runner" if i % 2 == 0 else "Scout"
        enemy.position = global_position + Vector2(120 * (i + 1) * (-1 if i == 0 else 1), -30)
        get_parent().add_child(enemy)

func take_damage(amount: int) -> void:
    if health <= 0:
        return
    health -= amount
    if health <= 0:
        health = 0
        emit_signal("boss_defeated")
        queue_free()

func _draw() -> void:
    var jacket := Color(0.18, 0.20, 0.25)
    var jacket_dark := Color(0.09, 0.10, 0.12)
    var red := Color(0.92, 0.18, 0.18)
    var skin := Color(0.82, 0.60, 0.46)
    var hair := Color(0.29, 0.17, 0.10)
    var pants := Color(0.15, 0.17, 0.20)
    var shoes := Color(0.09, 0.08, 0.08)

    draw_rect(Rect2(-58, -52, 116, 96), jacket)
    draw_rect(Rect2(-62, -36, 124, 26), jacket_dark)
    draw_rect(Rect2(-14, -62, 28, 18), skin)
    draw_rect(Rect2(-18, -66, 36, 14), hair)
    draw_rect(Rect2(-22, -34, 12, 38), red)
    draw_rect(Rect2(10, -34, 12, 38), red)
    draw_rect(Rect2(-22, -8, 44, 8), red)
    draw_rect(Rect2(-18, 2, 14, 46), pants)
    draw_rect(Rect2(4, 2, 14, 46), pants)
    draw_rect(Rect2(-22, 48, 18, 14), shoes)
    draw_rect(Rect2(4, 48, 18, 14), shoes)
