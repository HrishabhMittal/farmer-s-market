extends Node

@warning_ignore_start("unused_signal")

# Notification Signals
signal game_loaded()
signal item_added(item: Item)
signal day_ended()
signal crop_harvested(farm_plant: FarmPlant)
signal shop_visited()

# Command Signals

@warning_ignore_restore("unused_signal")
