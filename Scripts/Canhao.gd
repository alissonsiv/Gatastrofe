extends Node2D
class_name Player

const Projetil := preload("res://cenas/Projetil.tscn")

@onready var cronometro := $ReloadTimer
@onready var barra_recarga := $ReloadProgress

var tem_projetil := true

func _ready() -> void:
	cronometro.wait_time = GameData.fases[GameData.level_atual].tempo_spawm / 2.0

func _physics_process(_delta: float) -> void:
	$Canhao.look_at(get_global_mouse_position())
	barra_recarga.value = 100 - (cronometro.time_left / cronometro.wait_time * 100)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("shoot") and GameData.estado_atual == GameData.ESTADOS.JOGANDO and tem_projetil:
		disparar()

func reload() -> void:
	tem_projetil = true
	cronometro.stop()

func disparar() -> void:
	var arrow: Projectile = Projetil.instantiate()
	get_tree().root.add_child(arrow)
	arrow.start($Canhao.get_global_transform())

	tem_projetil = false
	cronometro.start()

	AudioManager.tocar_som(AudioManager.EFEITOS_SONOROS["TIRO"])
