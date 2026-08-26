extends Node2D
var good
var place_holder_common = [2,3,4]
var place_holder_rare = [5,6]
var chosen = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() >= 0.70:
		chosen = place_holder_rare.pick_random()
	else:
		chosen = place_holder_common.pick_random() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if chosen == 1:
		$"bag/place holder".frame = 1
	elif chosen == 2:
		$"bag/place holder".frame = 2
	elif chosen == 3:
		$"bag/place holder".frame = 3
	elif chosen == 4:
		$"bag/place holder".frame = 4
	elif chosen == 5:
		$"bag/place holder".frame = 5
	elif chosen == 6:
		$"bag/place holder".frame = 6
