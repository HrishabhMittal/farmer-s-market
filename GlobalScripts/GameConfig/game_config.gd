extends Node

# --- TIME ---
var TICK_SPEED: float = 5.0 # Seconds per tick

# --- POLICE / TRUST SETTINGS ---
var fine_amount: int = 1000 # Amount deducted when trust drops below 0

var seeds_per_bag: Dictionary = {
	"pumpkin_seed": 10,
	"carrot_seed": 15,
	"cabbage_seed": 12,
	"potato_seed": 15,
	"tomato_seed": 20
}

# --- FARMING ---
var crop_growth_chances: Dictionary = {
	"pumpkin": 50,
	"carrot": 60,
	"cabbage": 80,
	"potato": 60,
	"tomato": 80
}

# Infocards will get item prices from here
var all_item_original_prices: Dictionary = {
	# ---- Crops ----
	"pumpkin": 100,
	"carrot": 25,
	"cabbage": 60,
	"potato": 20,
	"tomato": 20,
	
	# ---- Seeds ----
	"pumpkin_seed": 50,
	"pumpkin_seed_barcode": 50,
	"pumpkin_seed_chomped": 50,
	"pumpkin_seed_spot": 50,
	"pumpkin_seed_tear": 50,
	
	"carrot_seed": 20,
	"carrot_seed_barcode": 20,
	"carrot_seed_chomped": 20,
	"carrot_seed_spot": 20,
	"carrot_seed_tear": 20,

	"cabbage_seed": 60,
	"cabbage_seed_barcode": 60,
	"cabbage_seed_chomped": 60,
	"cabbage_seed_spot": 60,
	"cabbage_seed_tear": 60,

	"potato_seed": 30,
	"potato_seed_barcode": 30,
	"potato_seed_chomped": 30,
	"potato_seed_spot": 30,
	"potato_seed_tear": 30,

	"tomato_seed": 30,
	"tomato_seed_barcode": 30,
	"tomato_seed_chomped": 30,
	"tomato_seed_spot": 30,
	"tomato_seed_tear": 30
}

var crop_seed_yields: Dictionary = {
	"pumpkin_seed": 5,
	"pumpkin_seed_barcode": 4,
	"pumpkin_seed_chomped": 3,
	"pumpkin_seed_spot": 2,
	"pumpkin_seed_tear": 1,
	
	"carrot_seed": 10,
	"carrot_seed_barcode": 9,
	"carrot_seed_chomped": 7,
	"carrot_seed_spot": 5,
	"carrot_seed_tear": 2,

	"cabbage_seed": 4,
	"cabbage_seed_barcode": 3,
	"cabbage_seed_chomped": 3,
	"cabbage_seed_spot": 2,
	"cabbage_seed_tear": 1,

	"potato_seed": 12,
	"potato_seed_barcode": 9,
	"potato_seed_chomped": 8,
	"potato_seed_spot": 6,
	"potato_seed_tear": 3,

	"tomato_seed": 10,
	"tomato_seed_barcode": 8,
	"tomato_seed_chomped": 6,
	"tomato_seed_spot": 4,
	"tomato_seed_tear": 2
}

# --- SCAMMER / MARKET SETTINGS ---
var minimum_price_ratio: float = 0.75 # Market variance: Honest prices fluctuate down to 70%
var scammer_chance: float = 0.25 # 30% chance a generated shopkeeper is a scammer

# Seed Shop Scams
var scammer_defective_ratio: float = 0.6 # 50% chance an individual bag from a scammer is defective
var defective_seed_multiplier: float = 0.5  # Defective bags yield 50% less seeds, more of these can be added, but for now 
											# I am going to wait for a proper sprite sheet before diving into scams
# one idea is to add defective seed which grow slowed
# or seeds that give low yeild


# Sell Shop Scams
var scam_seller_lowball: float = 0.4 # Scammers in the sell shop multiply their buying price by this (here, offering 40% of the value)
var target_money: int = 25000
var mom_ask_money_chance: float = 0.15
