extends Control

const cprefix = "Carrying"
const sprefix = "Storage"

var carrying: Label
var storage: Label

func _ready():
	carrying = $VBoxContainer/Carrying
	storage = $VBoxContainer/Storage

	set_carrying(0)
	set_storage(0)

func set_carrying(x: int) -> void:
	carrying.text = cprefix + ": " + str(x)

func set_storage(x):
	storage.text = sprefix + ": " + str(x)

func _on_Player_collected_nut(player):
	set_carrying(player.nuts())

func _on_Player_deposited_nuts(base):
	set_storage(base.nuts)
