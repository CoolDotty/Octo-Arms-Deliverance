extends Node3D


var enemy = preload("res://nodes/enemy/Enemy.tscn")
var cowboy = preload("res://nodes/cowboy/Cowboy.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var player = $Player

var travel = 0.0
var next_boy = 0.0

func _physics_process(delta):
	if not is_instance_valid(player):
		return
	
	travel = max(travel, player.position.x)
	if travel > next_boy:
		var c = cowboy.instantiate()
		c.position = player.position
		c.position.x += 8.0
		c.position.y = [-2.0, 2.0].pick_random()
		add_child(c)
		next_boy += 10.0
	
	if player.guns.get_child_count() > 1 and spawn_timer.is_stopped():
		_on_spawn_timer_timeout()
		spawn_timer.start()
	
	if player.guns.get_child_count() > 1:
		spawn_timer.wait_time = 5.0 / player.guns.get_child_count()
	else:
		spawn_timer.wait_time = 5.0
		spawn_timer.stop()


func _on_spawn_timer_timeout():
	if not is_instance_valid(player):
		return
	
	var e = enemy.instantiate()
	e.position = player.position
	e.position.x += [8.0, -8.0].pick_random()
	e.position.y += randf_range(-8.0, 8.0)
	add_child(e)



func _on_tunes_finished():
	$Tunes.play()
