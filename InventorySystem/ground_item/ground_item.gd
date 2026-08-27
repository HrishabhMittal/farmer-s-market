# Items that can be dropped on the ground and be picked up by the player
extends Node2D
class_name GroundItem

@export var texture_node: TextureRect
@export var label_node: Label
@export var collision_node: CollisionShape2D

var pick_raius: float = 300.0 # If player comes within this radius, item will start following the player
var pick_trigger_radius: float = 50.0 # Afer reaching this distance, the item will actually try to get pickked up

# Chase the player
var chase_target: Node2D
var chase_speed: float = 700.0
var is_chasing_player: bool = false

var current_pick_cooldown: float = 0.0
var pick_cooldown: float = 3.0 # If it fails to get picked up for any reason, it will wait
							   # this amount of time before requesting pickup again

var item: Item
var target_inventory_for_pickup: Inventory = StateManager.barn_inventory # Or should it be player inventory?

func initialize(new_item: Item) -> void:
	item = new_item
	texture_node.texture = item.item_data.item_texture
	label_node.text = str(item.amount)
	collision_node.shape.radius = pick_raius
	
	$Area2D.body_entered.connect(chase_player)
	
func attempt_pickup(body: Node2D) -> void:
	if target_inventory_for_pickup: # Not sure where it goes fo now
		if target_inventory_for_pickup.add_item(item, item.amount):
			SignalBus.ground_item_picked.emit(self)
			call_deferred("queue_free")
		# If the previous condion failed, then go on cooldown
		current_pick_cooldown = pick_cooldown
		chase_target = null
		is_chasing_player = false

func chase_player(body: Node2D) -> void:
	if current_pick_cooldown > 0.0: # If pick cooldown is not over, then return
		return
	
	if "Player" in body.get_groups(): # If the body it encountered is player
		chase_target = body
		is_chasing_player = true
		
func _process(delta):
	if is_chasing_player and chase_target:
		global_position = global_position.move_toward(chase_target.global_position, chase_speed*delta)
		if global_position.distance_to(chase_target.global_position) <= pick_trigger_radius:
			attempt_pickup(chase_target)
	
	if current_pick_cooldown > 0.0:
		current_pick_cooldown -= delta
