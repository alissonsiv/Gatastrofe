extends Node2D

class_name Jogo

const POSICAO_Y_SPAWN_BALOES = 290

var total_baloes := 0
var dados_level: GameData.LevelMetadata

@onready var Balao_Cena := preload("res://cenas/Balao.tscn")
@onready var Menu_Cena := preload("res://cenas/Menu.tscn")
@onready var pontuacao := $HUD/Info/Pontuacao
@onready var progresso := $HUD/Info/Progresso
@onready var mostrar_level := $HUD/Level
@onready var fim_jogo := $"%FimJogo"
@onready var vitoria := $"%Vitoria"
@onready var botao := $"%Botao"
@onready var pausar := $"%Pausar"
@onready var tela_pausa := $"%Tela_Pausa"

func _ready():
	set_game_data()
	resetar_dados_level()
	resetar_ui()
	GameData.atualizar_pontuacao.connect(atualizar_pontuacao)
	GameData.finalizar_level.connect(finalizar_level)

func set_game_data():
	dados_level = GameData.fases[GameData.level_atual]
	resetar_dados_level()

func resetar_dados_level():
	GameData.pontuacao = 0
	pontuacao.text = str(GameData.pontuacao)
	mostrar_level.text = "Level " + str(GameData.level_atual + 1)
	progresso.value = 0
	GameData.estado_atual = GameData.ESTADOS.JOGANDO
	resetar_tempo_spawn()
	dados_level.num_baloes = 10 * (GameData.level_atual + 1)

func resetar_ui():
	pausar.disabled = false
	get_tree().paused = false

func resetar_tempo_spawn():
	$TempoSpawn.wait_time = dados_level.tempo_spawm

func on_balloon_timer_timeout():
	criar_balao()
	verificar_fim()
	atualizar_progresso()

func criar_balao():
	var balao = Balao_Cena.instantiate()
	balao.definir_tipo(dados_level.tipo_balao.pick_random())
	balao.global_position = Vector2(dados_level.faixas.pick_random(), POSICAO_Y_SPAWN_BALOES)
	$".".add_child(balao)
	total_baloes += 1

func atualizar_progresso():
	progresso.value = (total_baloes / dados_level.num_baloes) * 100

func atualizar_pontuacao():
	pontuacao.text = str(GameData.pontuacao)

func verificar_fim():
	if total_baloes == dados_level.num_baloes:
		parar_spawn()

func parar_spawn():
	$TempoSpawn.stop()

func finalizar_level():
	verificar_fim()
	parar_spawn()
	fim_jogo.show()
	pausar.disabled = true
	match GameData.estado_atual:
		GameData.ESTADOS.VITORIA:
			definir_vitoria()
		GameData.ESTADOS.DERROTA:
			definir_derrota()
		_:
			print("Unexpected state")

func definir_vitoria():
	vitoria.text = "Você ganhou!"
	if GameData.level_atual < GameData.fases.size():
		botao.text = "Próximo Level"
		botao.pressed.connect(reload_level)
	else:
		vitoria.text = "Parabéns, você salvou os ratos!"
		botao.text = "Menu"
		botao.pressed.connect(voltar_menu)

func definir_derrota():
	vitoria.text = "Os gatos alcançaram o balão!"
	botao.text = "Jogar Novamente"
	botao.pressed.connect(reload_level)

	AudioManager.tocar_som(AudioManager.EFEITOS_SONOROS["TROMBETA_TRISTE"])

func reload_level():
	get_tree().reload_current_scene()

func voltar_menu():
	get_tree().change_scene_to_packed(Menu_Cena)

func _on_Destroy_area_entered(area: Area2D):
	area.queue_free()

func on_target_reach_ship(area: Area2D):
	if area.is_in_group("Target"):
		area.queue_free()
		if GameData.estado_atual == GameData.ESTADOS.JOGANDO:
			GameData.estado_atual = GameData.ESTADOS.DERROTA
			GameData.finalizar_level.emit()

func pause_game():
	get_tree().paused = true
	tela_pausa.show()

func _on_keep_playing_button_pressed():
	get_tree().paused = false
	tela_pausa.hide()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(Menu_Cena)
