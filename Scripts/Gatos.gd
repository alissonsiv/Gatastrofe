class_name Target

extends Area2D

var speed = 10

class TargetType:
	var color: Color
	var speed: int

	func _init(_color: Color, _speed: int):
		color = _color
		speed = _speed

	func to_dict() -> Dictionary:
		return {"color": color.to_html(), "speed": speed}

	static func from_dict(dict: Dictionary) -> TargetType:
		return TargetType.new(Color(dict["color"]), dict["speed"])

func _ready():
	$Sprite2D.texture = TargetData.GATOS.pick_random()

func definir_tipo(tipo_balao: TargetType):
	$AnimatedSprite2D.modulate = tipo_balao.color
	speed = tipo_balao.speed

func _physics_process(delta: float):
	position += gravity_direction.normalized() * speed * delta

func destroy():
	$AnimatedSprite2D.play("Burst")
	gravity_direction = -gravity_direction
	$CollisionShape2D.queue_free()
	$Timer.connect("timeout", queue_free)
	$Timer.start()
