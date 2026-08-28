extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var video_player = $ColorRect/VideoStreamPlayer

func _ready() -> void:
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.color = Color(0, 0, 0, 1)
	
	color_rect.modulate.a = 0.0
	hide()

func play(video_path: String = "") -> void:
	show()
	
	if video_path != "":
		video_player.stream = load(video_path)
	
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	if video_player.stream:
		video_player.play()
		await video_player.finished
	else:
		var wait_tween = create_tween()
		wait_tween.tween_interval(2.0)
		await wait_tween.finished
		
	var out_tween = create_tween()
	out_tween.tween_property(color_rect, "modulate:a", 0.0, 1.0)
	await out_tween.finished
	
	hide()
