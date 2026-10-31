extends CharacterBody2D

@export var enemy_type := "Grunt"

var health := 8
var speed := 85.0
var damage := 8
var attack_range := 170.0
var attack_cooldown := 1.2
var current_cooldown := 0.0

func _ready() -> void:
    add_to_group("enemies")
    _apply_enemy_type(enemy_type)

func _apply_enemy_type(type_name: String) -> void:
    match type_name:
        "Grunt":
            health = 8
            speed = 85.0
            damage = 8
            attack_range = 170.0
            attack_cooldown = 1.3
        "Scout":
            health = 5
            speed = 130.0
            damage = 6
            attack_range = 150.0
            attack_cooldown = 0.9
        "Heavy":
            health = 14
            speed = 55.0
            damage = 14
            attack_range = 200.0
            attack_cooldown = 1.7
        "Sniper":
            health = 7
            speed = 60.0
            damage = 12
            attack_range = 300.0
            attack_cooldown = 2.0
        "Runner":
            health = 6
            speed = 160.0
            damage = 7
            attack_range = 150.0
            attack_cooldown = 0.8
        _:
            health = 8
            speed = 85.0
            damage = 8
            attack_range = 170.0
            attack_cooldown = 1.3

func _physics_process(delta: float) -> void:
    if health <= 0:
        return

    var player = get_tree().get_first_node_in_group("player")
    if player == null or not is_instance_valid(player):
        return

    current_cooldown = max(0.0, current_cooldown - delta)
    var direction := sign(player.global_position.x - global_position.x)
    var player_dist := abs(player.global_position.x - global_position.x)

    if player_dist > 30.0:
        velocity.x = direction * speed
    else:
        velocity.x = 0.0

    if player_dist < attack_range and abs(player.global_position.y - global_position.y) < 90.0:
        if current_cooldown <= 0.0:
            attack_player(player)
            current_cooldown = attack_cooldown

    if direction != 0:
        scale.x = -1.0 if direction < 0 else 1.0

    move_and_slide()

func attack_player(player: Node) -> void:
    if player.has_method("take_damage"):
        player.take_damage(damage)

func take_damage(amount: int) -> void:
    if health <= 0:
        return
    health -= amount
    if health <= 0:
        health = 0
        queue_free()

func _draw() -> void:
    var skin := Color(0.82, 0.60, 0.46)
    var jacket := Color(0.20, 0.24, 0.28)
    var jacket_dark := Color(0.09, 0.11, 0.14)
    var red := Color(0.90, 0.17, 0.17)
    var hair := Color(0.30, 0.18, 0.11)
    var pants := Color(0.14, 0.16, 0.18)
    var shoes := Color(0.08, 0.08, 0.08)

    draw_rect(Rect2(-18, -46, 36, 48), jacket)
    draw_rect(Rect2(-22, -28, 44, 22), jacket_dark)
    draw_rect(Rect2(-8, -54, 16, 14), skin)
    draw_rect(Rect2(-12, -56, 24, 10), hair)
    draw_rect(Rect2(-10, -67, 20, 12), hair)
    draw_rect(Rect2(-18, -32, 10, 34), red)
    draw_rect(Rect2(8, -32, 10, 34), red)
    draw_rect(Rect2(-10, -10, 8, 34), pants)
    draw_rect(Rect2(2, -10, 8, 34), pants)
    draw_rect(Rect2(-12, 22, 10, 14), shoes)
    draw_rect(Rect2(2, 22, 10, 14), shoes)
