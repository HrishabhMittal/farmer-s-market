extends Node

# --- TIME ---
var TICK_SPEED: float = 5.0 # Seconds per tick

# --- SEED SHOP (HONEST VALUES) ---
var seed_prices: Dictionary = {
	"pumpkin_seed": 50,
	"carrot_seed": 20,
	"cabbage_seed": 30,
	"potato_seed": 30,
	"tomato_seed": 30
}

var seeds_per_bag: Dictionary = {
	"pumpkin_seed": 32,
	"carrot_seed": 32,
	"cabbage_seed": 32,
	"potato_seed": 32,
	"tomato_seed": 32
}

# --- SELL SHOP (HONEST VALUES) ---
var crop_prices: Dictionary = {
	"pumpkin": 50,
	"carrot": 20,
	"cabbage": 35,
	"potato": 20,
	"tomato": 10
}

# --- FARMING ---
var crop_growth_chances: Dictionary = {
	"pumpkin": 60,
	"carrot": 60,
	"cabbage": 60,
	"potato": 60,
	"tomato": 60
}

# --- SCAMMER / MARKET SETTINGS ---
var minimum_price_ratio: float = 0.7 # Market variance: Honest prices fluctuate down to 70%
var scammer_chance: float = 0.3 # 30% chance a generated shopkeeper is a scammer

# Seed Shop Scams
var scammer_defective_ratio: float = 0.5 # 50% chance an individual bag from a scammer is defective
var defective_seed_multiplier: float = 0.5 # Defective bags yield 50% less seeds

# Sell Shop Scams
var scam_seller_lowball: float = 0.4 # Scammers in the sell shop multiply their buying price by this (e.g., offering 40% of the value)
