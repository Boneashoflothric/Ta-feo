extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var boss: CharacterBody2D = $Boss
@onready var player_name_label: Label = $CanvasLayer/HUD/PlayerName
@onready var health_value: Label = $CanvasLayer/HUD/HealthValue
@onready var boss_value: Label = $CanvasLayer/HUD/BossValue
@onready var status_label: Label = $CanvasLayer/HUD/Status

var enemy_types := ["Grunt", "Scout", "Heavy", "Sniper", "Runner"]
var spawn_points := [
    Vector2(420, 560),
    Vector2(580, 560),
    Vector2(770, 560),
    Vector2(970, 560),
    Vector2(1130, 560)
]

func _ready() -> void:
    if Global.player_name.strip_edges() == "":
        Global.player_name = "Ta-feo"

    player_name_label.text = Global.player_name
    health_value.text = str(player.health)
    boss_value.text = str(boss.health)
    status_label.text = "Battle on!"

    _spawn_enemy_wave()
    player.died.connect(_on_player_died)
    boss.boss_defeated.connect(_on_boss_defeated)

func _process(_delta: float) -> void:
    if not is_instance_valid(player):
        return

    health_value.text = str(max(0, player.health))
    if is_instance_valid(boss):
        boss_value.text = str(max(0, boss.health))
    else:
        boss_value.text = "DEFEATED"

    if player.health <= 0:
        status_label.text = "Mission failed."
    elif is_instance_valid(boss) and boss.health < boss.max_health * 0.5:
        status_label.text = "Boss enraged!"
    elif is_instance_valid(boss):
        status_label.text = "Fire on the boss!"
    else:
        status_label.text = "Victory!"

func _spawn_enemy_wave() -> void:
    var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
    for i in range(enemy_types.size()):
        var enemy = enemy_scene.instantiate()
        enemy.enemy_type = enemy_types[i]
        enemy.position = spawn_points[i]
        add_child(enemy)

func _on_player_died() -> void:
    status_label.text = "Mission failed. Ta-feo has fallen."

func _on_boss_defeated() -> void:
    status_label.text = "Victory! The boss is down."
    boss_value.text = "DEFEATED"
