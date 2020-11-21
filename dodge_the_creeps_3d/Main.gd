extends Node

export(PackedScene) var mob_scene


func _ready():
	randomize()
	$Music.play()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	add_child(mob)

	# Set the mob's position to a random location.
	mob_spawn_location.unit_offset = randf()
	mob.translation = mob_spawn_location.translation

	var player_position = $Player.transform.origin
	mob.look_at(player_position, Vector3.UP)
	mob.rotate_y(rand_range(-PI/4, PI/4))

	# Choose the velocity.
	var velocity = Vector3.FORWARD * rand_range(mob.min_speed, mob.max_speed)
	mob.linear_velocity = velocity.rotated(Vector3.UP, mob.rotation.y)


func _on_Player_hit() -> void:
	$MobTimer.stop()
