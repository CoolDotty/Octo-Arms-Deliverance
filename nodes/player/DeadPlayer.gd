extends Node3D

@onready var boom = $Boom
@onready var gameovertext = $GameOverText
@onready var restart = $Restart

func _ready():
	boom.mesh.top_radius = 0.01
	gameovertext.visible = false
	restart.visible = false
	get_viewport().get_camera_3d().add_shake(1.0)

func _physics_process(delta):
	boom.mesh.top_radius += delta * 4
	if boom.mesh.top_radius > 10.0:
		gameovertext.visible = true
	if boom.mesh.top_radius > 15.0:
		restart.visible = true
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
