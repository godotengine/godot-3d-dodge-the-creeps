extends KinematicBody

signal hit

# How fast the player moves in meters per second.
export var speed = 14
# Vertical impulse applied to the character upon jumping in meters per second.
export var jump_impulse = 20
# Vertical impulse applied to the character upon bouncing over a mob in meters per second.
export var bounce_impulse = 16
# The downward acceleration when in the air, in meters per second per second.
export var fall_acceleration = 75

var velocity = Vector3.ZERO


func _physics_process(delta):
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
		# In the lines below, we turn the character when moving and make the animation play faster.
		direction = direction.normalized()
		look_at(translation + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

	# We apply gravity every frame so the character always collides with the ground when moving.
	# This is necessary for the is_on_floor() function to work as a body can always detect
	# the floor, walls, etc. when a collision happens the same frame.
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# This makes the character follow a nice arc when jumping
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	# Here, we check if we landed on top of a mob and if so, we kill it and bounce.
	if get_slide_count() > 0:
		# With move_and_slide(), Godot makes the body move sometimes multiple times in a row to
		# smooth out the character's motion. So we have to loop over all collisions that may have
		# happened.
		for index in range(get_slide_count()):
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("mob"):
				var mob = collision.collider
				if Vector3.UP.dot(collision.normal) > 0.1:
					mob.squash()
					bounce()


func bounce():
	velocity.y = bounce_impulse


func die():
	emit_signal("hit")
	queue_free()


func _on_MobDetector_body_entered(body):
	die()
