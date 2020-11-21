extends Node

export (PackedScene) var mob_scene


func _ready():
	randomize()
	$Music.play()


func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	var player_position = $Player.transform.origin

	add_child(mob)
	mob.initialize(mob_spawn_location.translation, player_position)


func _on_Player_hit():
	$MobTimer.stop()
