extends Node

@export var menu = false
@export var start_music : Node = null

var state_machine

func _ready():
	if !menu:
		for music in get_tree().get_nodes_in_group("Music"):
			music.volume_db = -80
			music.play()
		if start_music != null:
			start_music.volume_db = 0
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.travel("some_state")

func transition(to_song):
	state_machine.travel(to_song)
