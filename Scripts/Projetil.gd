extends Area2D

class_name Projectile

@export var speed := 50

var posicao_inicial := Vector2.ZERO
var velocidade_projeteis := Vector2.ZERO
var OFF_SCREEN := 1000

signal balloon_hit

func _ready():
	connect("balloon_hit", GameData.ao_acertar_balao)

func start(_transform: Transform2D):
	global_transform = _transform
	velocidade_projeteis = transform.x * speed
	posicao_inicial = position

func _physics_process(_delta: float):
	rotation = velocidade_projeteis.angle()
	position += velocidade_projeteis

	if position.distance_to(posicao_inicial) > OFF_SCREEN:
		queue_free()

func _on_Arrow_area_entered(area: Area2D):
	if area.is_in_group("Target"):
		area.destroy()
		emit_signal("balloon_hit")
		queue_free()
