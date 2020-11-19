extends Area

signal hit

# How fast the player moves in meters per second.
export var speed = 12


func _process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1

	if direction.length() > 0:
		direction = direction.normalized()
		look_at(translation + direction, Vector3.UP)

	var velocity = direction * speed
	translation += velocity * delta


func start():
	translation = Vector3.ZERO
	show()
	$CollisionShape.disabled = false


func _on_Player_body_entered(_body):
	emit_signal("hit")
	queue_free()
