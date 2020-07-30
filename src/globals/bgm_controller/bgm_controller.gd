extends Node

onready var player = $AudioStreamPlayer 

func play_new_track(track_url: String) -> void:
	var new_track = load(track_url) 
	player.stream = new_track 
	player.play() 

func stop_current_track() -> void:
	player.stop()