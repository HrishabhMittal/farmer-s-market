extends Node

# some value changes
# i calced a smaller tick rate while keeping avg growth time same
# also changed up crop vals so that first 2 teir crops make profit, 3rd breaks even, and last 2 lose money

# --- TIME ---
var TICK_SPEED: float = 10.0


var seeds_per_bag: Dictionary = {
	"pumpkin_seed": 15,
	"carrot_seed": 15,
	"cabbage_seed": 15,
	"potato_seed": 15,
	"tomato_seed": 15
}


var crop_growth_chances: Dictionary = {
	"pumpkin": 17, 
	"carrot": 27, 
	"cabbage": 20, 
	"potato": 20, 
	"tomato": 27
}

var all_item_original_prices: Dictionary = {
	"carrot": 5,
	"tomato": 10,
	"potato": 25,
	"cabbage": 50,
	"pumpkin": 100,
	
	"carrot_seed": 200,
	"carrot_seed_barcode": 200,
	"carrot_seed_chomped": 200,
	"carrot_seed_spot": 200,
	"carrot_seed_tear": 200,
	
	"tomato_seed": 400,
	"tomato_seed_barcode": 400,
	"tomato_seed_chomped": 400,
	"tomato_seed_spot": 400,
	"tomato_seed_tear": 400,
	
	"potato_seed": 1000,
	"potato_seed_barcode": 1000,
	"potato_seed_chomped": 1000,
	"potato_seed_spot": 1000,
	"potato_seed_tear": 1000,
	
	"cabbage_seed": 2000,
	"cabbage_seed_barcode": 2000,
	"cabbage_seed_chomped": 2000,
	"cabbage_seed_spot": 2000,
	"cabbage_seed_tear": 2000,
	
	"pumpkin_seed": 4000,
	"pumpkin_seed_barcode": 4000,
	"pumpkin_seed_chomped": 4000,
	"pumpkin_seed_spot": 4000,
	"pumpkin_seed_tear": 4000
}

var crop_seed_yields: Dictionary = {
	"carrot_seed": 6,
	"tomato_seed": 6,
	"potato_seed": 6,
	"cabbage_seed": 6,
	"pumpkin_seed": 6,
	
	"carrot_seed_barcode": 5,
	"tomato_seed_barcode": 5,
	"potato_seed_barcode": 5,
	"cabbage_seed_barcode": 5,
	"pumpkin_seed_barcode": 5,
	
	"carrot_seed_chomped": 4,
	"tomato_seed_chomped": 4,
	"potato_seed_chomped": 4,
	"cabbage_seed_chomped": 4,
	"pumpkin_seed_chomped": 4,
	
	"carrot_seed_spot": 3,
	"tomato_seed_spot": 3,
	"potato_seed_spot": 3,
	"cabbage_seed_spot": 3,
	"pumpkin_seed_spot": 3,
	
	"carrot_seed_tear": 2,
	"tomato_seed_tear": 2,
	"potato_seed_tear": 2,
	"cabbage_seed_tear": 2,
	"pumpkin_seed_tear": 2
}


# --- SCAMMER / MARKET ---
var fine_amount: int = 300
var reward_amount: int = 300
var minimum_price_ratio: float = 0.75
var scammer_chance: float = 0.6
var scammer_defective_ratio: float = 0.5
var scam_seller_lowball: float = 0.4 
var target_money: int = 10000 
var mom_ask_money_chance: float = 0.15
var defective_seed_multiplier: float = 0.5
var farmers_reset_days: int = 2
