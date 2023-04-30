extends Area3D


@onready var player = get_node("../Player")
var dead_sprite = preload("res://nodes/enemy/ded.png")
var health = 5

var enemy = true

var SPEED = 0.05

var hit_flash = 0.0

func _ready():
	$AnimationPlayer.current_animation = "move"
	$AnimationPlayer.play()

var time = 0
var last_time = 0

func _physics_process(delta):
	if not is_instance_valid(player):
		return
	time += delta
	if time > last_time + 0.2:
		last_time = time
#		$StepNoise.play()
	position.x = move_toward(position.x, player.position.x, SPEED / 2)
	position.y = move_toward(position.y, player.position.y, SPEED / 2)
	
	$Sprite.modulate = Color(1.0, (1.0 - hit_flash), (1.0 - hit_flash))
	hit_flash = lerp(hit_flash, 0.0, 0.25)

func ded():
	$AnimationPlayer.stop()
	$Sprite.texture = dead_sprite
	SPEED = 0
	health = -1
	$DeadNoise.play()
	enemy = false


func _on_area_entered(area):
	if not area.get("damage"):
		return
	if health < 0:
		return
	if health == 0:
		ded()
		return
	health -= 1
	hit_flash = 1.0
	$HitNoise.play()
	
