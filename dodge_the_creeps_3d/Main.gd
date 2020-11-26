extends Node

export (PackedScene) var mob_scene


func _ready():
	randomize()
	$UserInterface/Retry.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	var player_position = $Player.transform.origin

	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing a mob.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)


func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
