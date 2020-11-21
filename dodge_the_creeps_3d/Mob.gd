extends RigidBody

#warning-ignore-all:unused_class_variable
export var min_speed = 10
export var max_speed = 18



func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _on_Mob_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.translation.y > translation.y:
			body.bounce()
			queue_free()
		else:
			body.die()
