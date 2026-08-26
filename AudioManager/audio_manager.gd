extends Node

var active_music_stream: AudioStreamPlayer

@export var clips: Node
@export var one_shots: Node
@export var one_shot_audio_scene: PackedScene


func play_audio(audio_name: String, from_position: float = 0.0) -> void:
	active_music_stream = clips.get_node(audio_name)
	active_music_stream.play(from_position)

func play_one_shot_audio(audio_stream: AudioStream, volume_db: float = 0.0, from_position: float = 0.0) -> OneShotAudio:
	var one_shot_audio: OneShotAudio = one_shot_audio_scene.instantiate()
	one_shot_audio.stream = audio_stream
	one_shot_audio.volume_db = volume_db
	one_shot_audio.from_position = from_position

	one_shots.add_child(one_shot_audio)
	return one_shot_audio
