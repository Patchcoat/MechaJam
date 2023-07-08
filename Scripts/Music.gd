extends Node

@export var menu = false
@export var start_music : Node = null

var state_machine: AnimationNodeStateMachinePlayback

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	if !menu:
		for music in get_tree().get_nodes_in_group("Music"):
			music.volume_db = -80
			music.play()
		if start_music != null:
			start_music.volume_db = 0

func transition(to_song):
	state_machine.travel(to_song)
