extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var video_player = $ColorRect/VideoStreamPlayer

func _ready() -> void:
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.color = Color(0, 0, 0, 1)
	
	color_rect.modulate.a = 0.0
	hide()

func play(video_name: String = "") -> void:
	show()
	if video_name != "":
		AudioManager.mute_music()
		video_player.stream = load("res://Assets/Videos/" + video_name + ".ogv")
	else:
		video_player.stream = null
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	if video_player.stream:
		video_player.play()
		await video_player.finished
		video_player.stream = null
	else:
		var wait_tween = create_tween()
		wait_tween.tween_interval(2.0)
		await wait_tween.finished
	if video_name != "":
		AudioManager.unmute_music()
	var out_tween = create_tween()
	out_tween.tween_property(color_rect, "modulate:a", 0.0, 1.0)
	await out_tween.finished
	hide()

func transition_with_cutscene(video_name: String, next_scene_path: String) -> void:
	show()
	if video_name != "":
		AudioManager.mute_music()
		video_player.stream = load("res://Assets/Videos/" + video_name + ".ogv")
	else:
		video_player.stream = null
		
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	if video_player.stream:
		video_player.play()
		await video_player.finished
		video_player.stream = null
	else:
		var wait_tween = create_tween()
		wait_tween.tween_interval(2.0)
		await wait_tween.finished
		
	if video_name != "":
		AudioManager.unmute_music()

	TravelTransition.change_scene(next_scene_path)
	
	await get_tree().create_timer(0.55).timeout
	

	color_rect.modulate.a = 0.0
	hide()
