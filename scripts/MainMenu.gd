extends Control

@onready var name_input: LineEdit = $Panel/NameInput
@onready var start_button: Button = $Panel/StartButton

func _ready() -> void:
    name_input.text = Global.player_name
    start_button.pressed.connect(_start_game)
    name_input.text_submitted.connect(_start_game)

func _start_game(_text: String = "") -> void:
    var chosen_name := name_input.text.strip_edges()
    if chosen_name == "":
        chosen_name = "Ta-feo"
    Global.player_name = chosen_name
    get_tree().change_scene_to_file("res://scenes/Game.tscn")
