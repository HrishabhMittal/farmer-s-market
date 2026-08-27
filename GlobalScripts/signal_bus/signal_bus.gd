extends Node

@warning_ignore_start("unused_signal")

signal game_loaded()
signal shop_visited()
signal global_growth_tick()
signal day_ended()

signal crop_harvested(farm_plant: FarmPlant)
signal item_added(item: Item)
signal ground_item_picked(ground_item: GroundItem)

@warning_ignore_restore("unused_signal")

var tick_timer: Timer
const TICK_TIME = 5.0

func _ready():
	tick_timer = Timer.new()
	tick_timer.wait_time = TICK_TIME
	tick_timer.autostart = true
	tick_timer.timeout.connect(func(): global_growth_tick.emit())
	add_child(tick_timer)
