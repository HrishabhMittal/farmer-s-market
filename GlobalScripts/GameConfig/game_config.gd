extends Node

# --- TIME ---
var TICK_SPEED: float = 30.0

# --- CROPS ---
var seeds_per_bag: Dictionary = {
	"pumpkin_seed": 10,
	"carrot_seed": 10,
	"cabbage_seed": 10,
	"potato_seed": 10,
	"tomato_seed": 10
}

var crop_growth_chances: Dictionary = {
	"pumpkin": 50,
	"carrot": 80,
	"cabbage": 60,
	"potato": 60,
	"tomato": 80
}

var all_item_original_prices: Dictionary = {
	"carrot": 5,
	"tomato": 10,
	"potato": 20,
	"cabbage": 120,
	"pumpkin": 100,
	
	"carrot_seed": 50,
	"carrot_seed_barcode": 50,
	"carrot_seed_chomped": 50,
	"carrot_seed_spot": 50,
	"carrot_seed_tear": 50,

	"tomato_seed": 150,
	"tomato_seed_barcode": 150,
	"tomato_seed_chomped": 150,
	"tomato_seed_spot": 150,
	"tomato_seed_tear": 150,

	"potato_seed": 300,
	"potato_seed_barcode": 300,
	"potato_seed_chomped": 300,
	"potato_seed_spot": 300,
	"potato_seed_tear": 300,

	"cabbage_seed": 600,
	"cabbage_seed_barcode": 600,
	"cabbage_seed_chomped": 600,
	"cabbage_seed_spot": 600,
	"cabbage_seed_tear": 600,
	
	"pumpkin_seed": 1000,
	"pumpkin_seed_barcode": 1000,
	"pumpkin_seed_chomped": 1000,
	"pumpkin_seed_spot": 1000,
	"pumpkin_seed_tear": 1000
}

var crop_seed_yields: Dictionary = {
	"carrot_seed": 2,
	"tomato_seed": 3,
	"potato_seed": 3,
	"cabbage_seed": 1,
	"pumpkin_seed": 2,
	
	"carrot_seed_barcode": 1, "carrot_seed_chomped": 1, "carrot_seed_spot": 0, "carrot_seed_tear": 0,
	"tomato_seed_barcode": 2, "tomato_seed_chomped": 1, "tomato_seed_spot": 1, "tomato_seed_tear": 0,
	"potato_seed_barcode": 2, "potato_seed_chomped": 1, "potato_seed_spot": 1, "potato_seed_tear": 0,
	"cabbage_seed_barcode": 1, "cabbage_seed_chomped": 1, "cabbage_seed_spot": 0, "cabbage_seed_tear": 0,
	"pumpkin_seed_barcode": 1, "pumpkin_seed_chomped": 1, "pumpkin_seed_spot": 0, "pumpkin_seed_tear": 0
}

# --- SCAMMER / MARKET ---
var minimum_price_ratio: float = 0.75 
var scammer_chance: float = 0.25
var scammer_defective_ratio: float = 0.6 
var scam_seller_lowball: float = 0.4 
var target_money: int = 10000 
var mom_ask_money_chance: float = 0.15
