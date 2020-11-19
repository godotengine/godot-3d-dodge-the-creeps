extends Camera

export (NodePath) var player_path
var player


func _ready():
	player = get_node(player_path)
