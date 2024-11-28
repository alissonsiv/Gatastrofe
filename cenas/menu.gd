extends Control

var jogar_button
var sair_button

func _ready():
	jogar_button = $Jogar
	sair_button = $Sair

	jogar_button.connect("pressed", self, "_on_jogar_button_pressed")
	sair_button.connect("pressed", self, "_on_sair_button_pressed")

func _on_jogar_button_pressed():
	print("Jogar pressionado")

func _on_sair_button_pressed():
	print("Sair pressionado")
