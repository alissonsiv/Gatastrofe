class_name Balao
extends Area2D

var velocidade : float = 50

func definir_tipo(tipos_balao: Target.TargetType) -> void:
	$AnimatedSprite2D.modulate = tipos_balao.color
	velocidade = tipos_balao.velocidade

func _physics_process(delta: float) -> void:
	position += gravity_direction.normalized() * velocidade * delta

func destroy() -> void:
	$AnimatedSprite2D.play("Burst")
	gravity_direction = -gravity_direction
	$CollisionShape2D.queue_free()
	$Timer.connect("timeout", queue_free)
	$Timer.start()
