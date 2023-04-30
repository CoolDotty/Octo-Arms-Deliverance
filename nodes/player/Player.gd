extends CharacterBody3D


const SPEED = 5.0
const ACCEL = 0.5

@onready var sprite = $Sprite
@onready var anim = $Sprite/AnimationPlayer
@onready var guns = $Guns
@onready var gun_swap_timer = $Gun_swap_timer
@onready var step_noise = $StepNoise
@onready var equip_sound = $EquipNoise
@onready var iframes = $IFrames

var last_step = 0
var time = 0

var health: float = 5

var current_gun = 0

var gun_angle_diff = 0.0

var pistol = preload("res://nodes/pistol/Pistol.tscn")

var is_player = true

var last_guns_count = 0

func _physics_process(delta):
	if last_guns_count != guns.get_child_count():
		equip_sound.play()
		last_guns_count = guns.get_child_count()
	
	if not iframes.is_stopped():
		if sprite.modulate == Color.BLACK:
			sprite.modulate = Color.WHITE
		else:
			sprite.modulate = Color.BLACK
	else:
		sprite.modulate = Color.WHITE

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y, 0)).normalized()
	velocity.x = move_toward(velocity.x, SPEED * direction.x, ACCEL)
	velocity.y = move_toward(velocity.y, (-SPEED / 2) * direction.y, ACCEL / 2)

	move_and_slide()
	
	position.x = max(-1.0, position.x)
	position.y = clamp(position.y, -2.0, 2.0)
	
	var mouse_angle = (Vector2(1280, 720) * 0.5).angle_to_point(get_viewport().get_mouse_position()) * -1
	guns.rotation.z = lerp(guns.rotation.z, mouse_angle - gun_angle_diff * current_gun, 0.5)
	
	var gun_count = guns.get_child_count()
	gun_angle_diff = lerp(gun_angle_diff, 2 * PI / gun_count, 0.1)
	for i in range(0, gun_count):
		var gun = guns.get_child(i)
		gun.rotation.z = gun_angle_diff * i
	
	if guns.get_child_count() == 0:
		return
	var gun = guns.get_child(current_gun)
	if Input.is_action_pressed("shoot") and is_instance_valid(gun) and gun_swap_timer.is_stopped():
		gun.shoot()
	if gun.ammo <= 0:
		current_gun = wrap(current_gun + 1, 0, guns.get_child_count())
		gun_swap_timer.start()
		


func _process(delta):
	time += delta
	if abs(velocity.length()) > 0:
		anim.current_animation = "move"
		anim.speed_scale = 1.0 + velocity.length_squared() / (SPEED * 1.5)
		if time > last_step + 50 / abs(velocity.length()) * delta:
			step_noise.play()
			last_step = time
	else:
		anim.current_animation = "breath"
		anim.speed_scale = 1.0

var dead_guy = preload("res://nodes/player/DeadPlayer.tscn")

func dead():
	var dg = dead_guy.instantiate()
	dg.position = position
	find_parent("Game").add_child(dg)
	queue_free()


func _on_hitbox_area_entered(area):
	if area.get("enemy") and iframes.is_stopped():
		health -= 1.0
		if health <= 0:
			dead()
			return
		iframes.start()
		velocity.x += randf_range(-10.0, 10.0)
		velocity.y += randf_range(-10.0, 10.0)
		$HitNoise.play()
