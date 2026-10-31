extends CharacterBody2D

@export var enemy_type := "Grunt"

var health := 8
var speed := 80.0
var damage := 8
var attack_range := 180.0
var attack_cooldown := 1.2
var current_cooldown := 0.0

func _ready() -> void:
    add_to_group("enemies")
    _apply_enemy_type(enemy_type)
    $Body.color = _type_color(enemy_type)
    $Body.scale.x = -1.0

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

func _type_color(type_name: String) -> Color:
    match type_name:
        "Grunt":
            return Color(0.85, 0.45, 0.35)
        "Scout":
            return Color(0.82, 0.78, 0.20)
        "Heavy":
            return Color(0.52, 0.72, 0.96)
        "Sniper":
            return Color(0.95, 0.70, 0.18)
        "Runner":
            return Color(0.34, 0.82, 0.52)
        _:
            return Color(0.95, 0.95, 0.95)

func _physics_process(delta: float) -> void:
    if health <= 0:
        return

    var player = get_tree().get_first_node_in_group("player")
    if player == null or not is_instance_valid(player):
        return

    current_cooldown = max(0.0, current_cooldown - delta)

    var direction := sign(player.global_position.x - global_position.x)
    var player_distance := abs(player.global_position.x - global_position.x)

    if player_distance > 35.0:
        velocity.x = direction * speed
    else:
        velocity.x = 0.0

    if player_distance < attack_range and abs(player.global_position.y - global_position.y) < 90.0:
        if current_cooldown <= 0.0:
            attack_player(player)
            current_cooldown = attack_cooldown
    else:
        velocity.y = 0.0

    if direction != 0:
        $Body.scale.x = -1.0 if direction < 0 else 1.0

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
