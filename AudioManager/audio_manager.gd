extends Node

var music_volume: float = 1.0 : set = set_music_volume
var sfx_volume: float = 1.0

var sfx_player_scene: PackedScene = preload("res://AudioManager/sfx_player.tscn")
var sfx_players: Node
var duck_tween: Tween
var fade_tween: Tween
# Internal state
var active_music_player: AudioStreamPlayer
var music_player_1: AudioStreamPlayer
var music_player_2: AudioStreamPlayer

var sfx_cache: Dictionary = {}
var music_cache: Dictionary = {}

const MUSIC_PATH = "res://Assets/Audio/Music/"
const SFX_PATH = "res://Assets/Audio/SFX/"

func _ready() -> void:
	for bus_name in ["Music", "SFX"]:
		if AudioServer.get_bus_index(bus_name) == -1:
			AudioServer.add_bus()
			var new_idx = AudioServer.get_bus_count() - 1
			AudioServer.set_bus_name(new_idx, bus_name)
			AudioServer.set_bus_send(new_idx, "Master")
	sfx_players = Node.new()
	sfx_players.name = "SFXPlayers"
	add_child(sfx_players)
	
	music_player_1 = AudioStreamPlayer.new()
	music_player_1.bus = "Music"
	music_player_2 = AudioStreamPlayer.new()
	music_player_2.bus = "Music"
	add_child(music_player_1)
	add_child(music_player_2)
	
	active_music_player = music_player_1

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	if active_music_player and active_music_player.playing:
		active_music_player.volume_db = linear_to_db(music_volume)

func _get_audio_stream(track_name: String, is_music: bool) -> AudioStream:
	var cache = music_cache if is_music else sfx_cache
	var folder_path = MUSIC_PATH if is_music else SFX_PATH
	
	if cache.has(track_name):
		return cache[track_name]
		
	var extensions = [".mp3"]
	for ext in extensions:
		var file_path = folder_path + track_name + ext
		if ResourceLoader.exists(file_path):
			var stream = load(file_path)
			cache[track_name] = stream
			return stream
			
	push_error("Audio file not found for: " + track_name)
	return null

func play_music(track_name: String, transition_duration: float = 1.0, from_position: float = 0.0) -> void:
	var stream = _get_audio_stream(track_name, true)
	if not stream:
		return
		
	if active_music_player.stream == stream and active_music_player.playing:
		return
		
	var next_player = music_player_2 if active_music_player == music_player_1 else music_player_1
	
	var tween = create_tween().set_parallel(true)
	if active_music_player.playing:
		var prev_player = active_music_player
		tween.tween_property(prev_player, "volume_db", -80.0, transition_duration)
		tween.tween_callback(prev_player.stop).set_delay(transition_duration)
		
	# Start and fade in the new track
	active_music_player = next_player
	active_music_player.stream = stream
	active_music_player.volume_db = -80.0
	active_music_player.play(from_position)
	tween.tween_property(active_music_player, "volume_db", linear_to_db(music_volume), transition_duration)

func play_sfx(sfx_name: String, volume_multiplier: float = 1.0, from_position: float = 0.0) -> SFXPlayer:
	var stream = _get_audio_stream(sfx_name, false)
	if not stream:
		return null

	var sfx_player: SFXPlayer = sfx_player_scene.instantiate()
	sfx_player.stream = stream
	sfx_player.bus = "SFX"
	var final_volume = clamp(sfx_volume * volume_multiplier, 0.0, 1.0)
	sfx_player.volume_db = linear_to_db(final_volume)
	sfx_player.from_position = from_position
	sfx_players.add_child(sfx_player)
	return sfx_player

func play_sfx_random_pitch(sfx_name: String, min_pitch: float = 0.8, max_pitch: float = 1.2, volume_multiplier: float = 1.0) -> SFXPlayer:
	var sfx_player = play_sfx(sfx_name, volume_multiplier)
	if sfx_player:
		sfx_player.pitch_scale = randf_range(min_pitch, max_pitch)
	return sfx_player

func play_ringtone(sfx_name: String, volume_multiplier: float = 1.0) -> SFXPlayer:
	var sfx_player = play_sfx(sfx_name, volume_multiplier)
	if sfx_player:
		_duck_music_for_sfx(sfx_player)
	return sfx_player

func _duck_music_for_sfx(sfx_player: SFXPlayer) -> void:
	if not active_music_player or not active_music_player.playing:
		return
		
	if duck_tween and duck_tween.is_valid():
		duck_tween.kill()
		
	duck_tween = create_tween()
	var target_db = linear_to_db(music_volume * 0.1) 
	duck_tween.tween_property(active_music_player, "volume_db", target_db, 0.4) # Fades out over 0.4s
	
	sfx_player.finished.connect(_unduck_music)

func _unduck_music() -> void:
	if not active_music_player or not active_music_player.playing:
		return
		
	if duck_tween and duck_tween.is_valid():
		duck_tween.kill()
		
	duck_tween = create_tween()
	var target_db = linear_to_db(music_volume) 
	duck_tween.tween_property(active_music_player, "volume_db", target_db, 1.0)


func mute_music(transition_duration: float = 1.0) -> void:
	if active_music_player and active_music_player.playing:
		if fade_tween and fade_tween.is_valid():
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(active_music_player, "volume_db", -80.0, transition_duration)

func unmute_music(transition_duration: float = 1.0) -> void:
	if active_music_player and active_music_player.playing:
		if fade_tween and fade_tween.is_valid():
			fade_tween.kill()
		fade_tween = create_tween()
		var target_db = linear_to_db(music_volume)
		fade_tween.tween_property(active_music_player, "volume_db", target_db, transition_duration)
