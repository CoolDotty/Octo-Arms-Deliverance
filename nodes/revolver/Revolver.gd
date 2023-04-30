extends Node3D


var bullet = preload("res://nodes/bullet/Bullet.tscn")
@onready var shoot_sound = $Bang
@onready var BulletSpawn = $BulletSpawn
@onready var anim = $AnimationPlayer

var reloading = false
var ammo = 6

func shoot():
	if anim.is_playing() and anim.current_animation == "shoot":
		return
	ammo -= 1
	shoot_sound.play()
	
	var cam = get_viewport().get_camera_3d()
	if is_instance_valid(cam):
		cam.add_shake(0.1)
	
	var bang = bullet.instantiate()
	bang.rotation = global_rotation
	bang.rotation.z += randf_range(-deg_to_rad(10), deg_to_rad(10))
	bang.position = BulletSpawn.global_position
	find_parent("Game").add_child(bang)
	
	if ammo <= 0:
		reloading = true
		anim.play("reload")
	else:
		anim.play("shoot")


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "reload"):
		reloading = false
		ammo = 6
	if (anim_name == "shoot"):
		shoot()

