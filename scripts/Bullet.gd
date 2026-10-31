extends Area2D

var speed := 700.0
var direction := Vector2.RIGHT
var damage := 12

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    monitoring = true
    monitorable = true

func _process(delta: float) -> void:
    position += direction * speed * delta
    if abs(position.x) > 2000 or abs(position.y) > 2000:
        queue_free()

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and body.has_method("take_damage"):
        body.take_damage(damage)
    if body.is_in_group("enemies") or body.is_in_group("boss"):
        return
    queue_free()
