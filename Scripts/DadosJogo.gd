extends Node

enum FAIXAS { FIRST = 285, SECOND = 335, THIRD = 385, FOURTH = 435 }

const FAIXA_INICIAL: Array[FAIXAS] = [FAIXAS.THIRD]
const FAIXA_INTERMEDIARIA: Array[FAIXAS] = [FAIXAS.SECOND, FAIXAS.THIRD]
const FAIXA_COMPLETA: Array[FAIXAS] = [FAIXAS.FIRST, FAIXAS.SECOND, FAIXAS.THIRD, FAIXAS.FOURTH]

var TARGET_TYPES: Array[Target.TargetType] = [
	Target.TargetType.new(Color("73cd7a"), 30),
	Target.TargetType.new(Color("fb4631"), 40),
	Target.TargetType.new(Color("c9a400"), 50),
	Target.TargetType.new(Color("2f2f2f"), 60),
	Target.TargetType.new(Color("ffffff"), 70),
]

class LevelMetadata:
	var faixas: Array[FAIXAS]
	var tempo_spawm: float
	var num_baloes: int
	var tipo_balao: Array[Target.TargetType]

	func _init(_faixas: Array[FAIXAS], _tempo_spawm: float, _num_baloes: int, _tipo_balao: Array[Target.TargetType]):
		faixas = _faixas
		tempo_spawm = _tempo_spawm
		num_baloes = _num_baloes
		tipo_balao = _tipo_balao

	func to_dict() -> Dictionary:
		var tipo_balao_dicts: Array[Dictionary] = []
		for tipo in tipo_balao:
			tipo_balao_dicts.append(tipo.to_dict())
		return {
			faixas = faixas,
			tempo_spawm = tempo_spawm,
			num_baloes = num_baloes,
			tipo_balao = tipo_balao_dicts,
		}

	static func from_dict(dict: Dictionary) -> LevelMetadata:
		var tipo_balao_objs: Array[Target.TargetType] = []
		for tipo_balao_dict in dict["tipo_balao"] as Array:
			tipo_balao_objs.append(Target.TargetType.from_dict(tipo_balao_dict))

		var _faixas: Array[FAIXAS] = []
		for faixa in dict["faixas"] as Array:
			_faixas.append(faixa as FAIXAS)
		
		return LevelMetadata.new(
			_faixas,
			dict["tempo_spawm"] as float,
			dict["num_baloes"] as int,
			tipo_balao_objs,
		)


enum ESTADOS {
	JOGANDO,
	VITORIA,
	DERROTA,
}

var estado_atual := ESTADOS.JOGANDO
var level_atual := 0
var level_desbloqueado := 0
var pontuacao := 0
var fases: Array[LevelMetadata]

signal finalizar_level
signal atualizar_pontuacao

func _init() -> void:
	fases = [
		LevelMetadata.new(FAIXA_INICIAL, 2, 10, [TARGET_TYPES[0]]),
		LevelMetadata.new(FAIXA_INTERMEDIARIA, 2, 20, [TARGET_TYPES[0], TARGET_TYPES[1]]),
		LevelMetadata.new(FAIXA_COMPLETA, 1.5, 30, TARGET_TYPES),
		LevelMetadata.new(FAIXA_COMPLETA, 1.5, 40, TARGET_TYPES),
		LevelMetadata.new(FAIXA_COMPLETA, 1.5, 50, TARGET_TYPES),
		LevelMetadata.new(FAIXA_COMPLETA, 1, 60, TARGET_TYPES),
	]

func ao_acertar_balao() -> void:
	tocar_som_balao()
	atualizacao_pontuacao()
	verificar_vitoria()

func verificar_vitoria() -> void:
	if pontuacao == fases[level_atual].num_baloes:
		estado_atual = ESTADOS.VITORIA
		level_atual += 1
		level_desbloqueado = max(level_desbloqueado, level_atual)
		finalizar_level.emit()

func tocar_som_balao() -> void:
	AudioManager.tocar_som(AudioManager.EFEITOS_SONOROS["BALOON_ESTOURO"])

func atualizacao_pontuacao() -> void:
	pontuacao += 1
	atualizar_pontuacao.emit()
