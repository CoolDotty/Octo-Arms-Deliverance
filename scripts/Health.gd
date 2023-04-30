extends MeshInstance3D

@onready var player = $"../../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_instance_valid(player):
		scale.x = lerp(scale.x, 0.0, 0.1)
	else:
		scale.x = lerp(scale.x, (player.health ** 2) / 5, 0.1)
