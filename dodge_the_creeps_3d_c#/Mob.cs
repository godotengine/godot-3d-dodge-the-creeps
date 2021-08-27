using Godot;
using System;

public class Mob : KinematicBody
{
    // Emitted when the player jumped on the mob.
    [Signal]
    public delegate void Squashed();

    // Minimum speed of the mob in meters per second
    [Export]
    public int MinSpeed = 10;
    // Maximum speed of the mob in meters per second
    [Export]
    public int MaxSpeed = 18;

    private Vector3 _velocity = Vector3.Zero;

    public override void _PhysicsProcess(float delta)
    {
        MoveAndSlide(_velocity);
    }

    public void Initialize(Vector3 startPosition, Vector3 playerPosition)
    {
        Translation = startPosition;
        LookAt(playerPosition, Vector3.Up);
        RotateY((float)GD.RandRange(-Mathf.Pi / 4.0, Mathf.Pi / 4.0));

        float randomSpeed = (float)GD.RandRange(MinSpeed, MaxSpeed);
        _velocity = Vector3.Forward * randomSpeed;
        _velocity = _velocity.Rotated(Vector3.Up, Rotation.y);

        GetNode<AnimationPlayer>("AnimationPlayer").PlaybackSpeed = randomSpeed / MinSpeed;
    }

    public void Squash()
    {
        EmitSignal(nameof(Squashed));
        QueueFree();
    }

    public void OnVisibilityNotifierScreenExited()
    {
        QueueFree();
    }
}
