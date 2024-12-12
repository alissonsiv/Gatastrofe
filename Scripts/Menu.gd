class_name MainMenu
extends CanvasLayer

var qtd_niveis := GameData.fases.size()
const level_button_scn := preload("res://cenas/Level.tscn")

@export var level_selection: GridContainer
@export var play_button: Button

func _ready() -> void:
	carregar_botoes()
	carregar_ui()

func carregar_botoes() -> void:
	for child in level_selection.get_children():
		child.queue_free()

	for i in range(qtd_niveis):
		var botao: Button = level_button_scn.instantiate()
		botao.text = "LEVEL " + str(i + 1)
		botao.disabled = i > GameData.level_desbloqueado
		botao.pressed.connect(carregar_level.bind(i))
		level_selection.add_child(botao)

func carregar_ui() -> void:
	play_button.pressed.connect(_on_play_pressed)

func carregar_level(level_number: int) -> void:
	GameData.level_atual = level_number
	get_tree().change_scene_to_file("res://cenas/Jogo.tscn")

func _on_play_pressed() -> void:
	$Jogar.hide()  
	$Sair.hide()  
	level_selection.show()

func exit_game() -> void:
	get_tree().quit()
