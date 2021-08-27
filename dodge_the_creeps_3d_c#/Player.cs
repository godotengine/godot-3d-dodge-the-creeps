using Godot;
using System;

public class Player : KinematicBody
{
    // Emitted when the player was hit by a mob.
    [Signal]
    public delegate void Hit();

    // How fast the player moves in meters per second.
    [Export]
    public int Speed = 14;
    // The downward acceleration when in the air, in meters per second squared.
    [Export]
    public int FallAcceleration = 75;
    // Vertical impulse applied to the character upon jumping in meters per second.
    [Export]
    public int JumpImpulse = 20;
    // Vertical impulse applied to the character upon bouncing over a mob in meters per second.
    [Export]
    public int BounceImpulse = 16;

    private Vector3 _velocity = Vector3.Zero;

    public override void _PhysicsProcess(float delta)
    {
        var direction = Vector3.Zero;

        if (Input.IsActionPressed("move_right"))
        {
            direction.x += 1f;
        }
        if (Input.IsActionPressed("move_left"))
        {
            direction.x -= 1f;
        }
        if (Input.IsActionPressed("move_back"))
        {
            direction.z += 1f;
        }
        if (Input.IsActionPressed("move_forward"))
        {
            direction.z -= 1f;
        }

        if (direction != Vector3.Zero)
        {
            direction = direction.Normalized();
            GetNode<Spatial>("Pivot").LookAt(Translation + direction, Vector3.Up);
            GetNode<AnimationPlayer>("AnimationPlayer").PlaybackSpeed = 4;
        }
        else
        {
            GetNode<AnimationPlayer>("AnimationPlayer").PlaybackSpeed = 1;
        }

        _velocity.x = direction.x * Speed;
        _velocity.z = direction.z * Speed;

        // Jumping.
        if (IsOnFloor() && Input.IsActionJustPressed("jump"))
        {
            _velocity.y += JumpImpulse;
        }

        _velocity.y -= FallAcceleration * delta;
        _velocity = MoveAndSlide(_velocity, Vector3.Up);

        for (int index = 0; index < GetSlideCount(); index++)
        {
            KinematicCollision collision = GetSlideCollision(index);
            if (collision.Collider is Mob mob && mob.IsInGroup("mob"))
            {
                if (Vector3.Up.Dot(collision.Normal) > 0.1f)
                {
                    mob.Squash();
                    _velocity.y = BounceImpulse;
                }
            }
        }

        var pivot = GetNode<Spatial>("Pivot");
        pivot.Rotation = new Vector3(Mathf.Pi / 6f * _velocity.y / JumpImpulse, pivot.Rotation.y, pivot.Rotation.z);
    }

    private void Die()
    {
        EmitSignal(nameof(Hit));
        QueueFree();
    }

    public void OnMobDetectorBodyEntered(Node body)
    {
        Die();
    }
}
