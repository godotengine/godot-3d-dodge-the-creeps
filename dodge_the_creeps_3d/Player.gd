extends KinematicBody

signal hit

# How fast the player moves in meters per second.
export var speed = 14
# Vertical impulse applied to the character upon jumping in meters per second.
export var jump_impulse = 20
# The downward acceleration when in the air, in meters per second per second.
export var fall_acceleration = 75
export var bounce_impulse = 16

var velocity = Vector3.ZERO


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
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
	
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	$Pivot.rotation.x = PI/6 * velocity.y / jump_impulse


func bounce():
	velocity.y = bounce_impulse


func die():
	emit_signal("hit")
	queue_free()
