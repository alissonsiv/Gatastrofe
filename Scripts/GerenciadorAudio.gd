extends Node

const EFEITOS_SONOROS = {
	"BALOON_ESTOURO": preload("res://audio/pop.wav"),
	"TIRO": preload("res://audio/tiro.mp3"),
	"TROMBETA_TRISTE": preload("res://audio/trombeta_triste.mp3")
}

var pool_de_audio: Array[AudioStreamPlayer] = []

func _ready() -> void:
	_inicializar_pool()

func _inicializar_pool() -> void:
	var grupo_de_audio = Node.new()
	for i in range(5):
		var player_audio = AudioStreamPlayer.new()
		player_audio.stream = EFEITOS_SONOROS["BALOON_ESTOURO"]
		pool_de_audio.append(player_audio)
		grupo_de_audio.add_child(player_audio)
	add_child(grupo_de_audio)

func tocar_som(audio: AudioStream) -> void:
	var player_audio = pool_de_audio.pop_back()
	player_audio.stream = audio
	player_audio.play()
	pool_de_audio.insert(0, player_audio)
