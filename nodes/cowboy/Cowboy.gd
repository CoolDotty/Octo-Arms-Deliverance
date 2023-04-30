extends Node3D

@onready var anim = $AnimationPlayer

var all_guns = [
	preload("res://nodes/pistol/Pistol.tscn"),
	preload("res://nodes/revolver/Revolver.tscn"),
	preload("res://nodes/shotgun/Shotgun.tscn")
]


var gift_given = false


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.current_animation = "wave"
	anim.play()

func _on_area_entered(area):
	var player_maybe = area.get_parent()
	if player_maybe.get("is_player") and not gift_given:
		player_maybe.guns.add_child(all_guns.pick_random().instantiate())
		gift_given = true
		anim.current_animation = "prize"
