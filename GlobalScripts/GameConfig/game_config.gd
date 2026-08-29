extends Node

# --- TIME ---
var TICK_SPEED: float = 5.0

# --- SEED SHOP ---
# Honest buy prices for seeds
var seed_prices: Dictionary = {
	"pumpkin_seed": 50,
	"carrot_seed": 20,
	"cabbage_seed": 30,
	"potato_seed": 30,
	"tomato_seed": 30
}

# Number of seeds given per bag
var seeds_per_bag: Dictionary = {
	"pumpkin_seed": 32,
	"carrot_seed": 32,
	"cabbage_seed": 32,
	"potato_seed": 32,
	"tomato_seed": 32
}

# --- SELL SHOP ---
# Honest base sell prices for grown crops
var crop_prices: Dictionary = {
	"pumpkin": 50,
	"carrot": 20,
	"cabbage": 35,
	"potato": 20,
	"tomato": 10
}

# --- FARMING ---
# Growth chance per tick (0 to 100)
var crop_growth_chances: Dictionary = {
	"pumpkin": 60,
	"carrot": 60,
	"cabbage": 60,
	"potato": 60,
	"tomato": 60
}

# --- SCAMMER SETTINGS ---
# Chance of the seller being a scammer (0.0 to 1.0)
var scammer_chance: float = 0.3
