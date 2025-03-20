extends Control

@onready var card = $Card

func _execute():
	print(1)
	pass

func _on_card_option_clicked() -> void:
	_execute()
