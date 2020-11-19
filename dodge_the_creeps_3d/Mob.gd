extends RigidBody

#warning-ignore-all:unused_class_variable
export var min_speed = 6
export var max_speed = 13


func _on_VisibilityNotifier_screen_exited():
	queue_free()
