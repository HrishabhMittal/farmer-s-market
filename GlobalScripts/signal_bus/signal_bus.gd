extends Node

@warning_ignore_start("unused_signal")

signal game_loaded()
signal item_added(item: Item)
signal day_ended()
signal crop_harvested(farm_plant: FarmPlant)
signal shop_visited()
signal global_growth_tick()
@warning_ignore_restore("unused_signal")

var tick_timer: Timer

func _ready():
	tick_timer = Timer.new()
	tick_timer.wait_time = 5.0
	tick_timer.autostart = true
	tick_timer.timeout.connect(func(): global_growth_tick.emit())
	add_child(tick_timer)
