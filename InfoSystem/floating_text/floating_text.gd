extends RichTextLabel
class_name FloatingText

var floating_duration: float = 0.8

func initialize(new_text: String, new_color: String, new_font_size: int = 40, new_duration: float = 0.8) -> void:
	add_theme_font_size_override("normal_font_size", new_font_size)
	floating_duration = new_duration
	text = "[color=%s]%s[/color]" % [new_color, new_text]

func animate() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -40), floating_duration) # move up
	tween.tween_property(self, "modulate:a", 0.0, floating_duration) # fade out
	tween.chain().tween_callback(queue_free)
