using Godot;
using System;

public class ScoreLabel : Label
{
    private int _score = 0;
    
    public void OnMobSquashed()
    {
        _score += 1;
        Text = string.Format("Score: {0}", _score);
    }
}
