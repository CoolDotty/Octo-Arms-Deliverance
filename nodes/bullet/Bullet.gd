extends Node3D

var speed = Vector3(0.5, 0.0, 0.0)
var damage = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += speed.rotated(Vector3(0.0, 0.0, 1.0), rotation.z)
