using Godot;
using System;

public class Main : Node
{
#pragma warning disable 649
    [Export]
    public PackedScene MobScene;
#pragma warning restore 649

    public override void _Ready()
    {
        GD.Randomize();
        GetNode<Control>("UserInterface/Retry").Hide();
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_accept") && GetNode<Control>("UserInterface/Retry").Visible)
        {
            GetTree().ReloadCurrentScene();
        }
    }

    public void OnMobTimerTimeout()
    {
        Mob mob = (Mob)MobScene.Instance();

        var mobSpawnLocation = GetNode<PathFollow>("SpawnPath/SpawnLocation");
        mobSpawnLocation.UnitOffset = GD.Randf();

        Vector3 playerPosition = GetNode<Player>("Player").Transform.origin;

        AddChild(mob);
        mob.Initialize(mobSpawnLocation.Translation, playerPosition);
        mob.Connect(nameof(Mob.Squashed), GetNode<ScoreLabel>("UserInterface/ScoreLabel"), nameof(ScoreLabel.OnMobSquashed));
    }

    public void OnPlayerHit()
    {
        GetNode<Timer>("MobTimer").Stop();
        GetNode<Control>("UserInterface/Retry").Show();
    }
}
