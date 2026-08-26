extends RichTextLabel
class_name FloatingText

func initialize(new_text: String, new_color: String) -> void:
	text = "[color=%s]%s[/color]" % [new_color, new_text]

func animate() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -40), 0.8) # move up
	tween.tween_property(self, "modulate:a", 0.0, 0.8) # fade out
	tween.chain().tween_callback(queue_free)
