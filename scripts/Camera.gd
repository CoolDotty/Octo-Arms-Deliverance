extends Camera3D

var player = null

var shake = 0.0

var time = 0.0

func add_shake(value):
	if value < shake:
		return
	shake = clamp(value, 0.0, 1.0);


func _ready():
	size = get_viewport().size.y / 100.0
	player = get_parent().find_child("Player")


func _physics_process(delta):
	time += delta
	rotation.z = sin(time * 5) / 20
	
	h_offset = randf_range(-shake, shake)
	v_offset = randf_range(-shake, shake)
	shake = lerp(shake, 0.0, 0.25)
	
	if not is_instance_valid(player):
		return
	var herp = lerp(position, player.position, 0.1)
	position = Vector3(herp.x, herp.y, 2)
