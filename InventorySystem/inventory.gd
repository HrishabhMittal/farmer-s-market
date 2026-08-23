# Contains item data of a inventory. The Inventory UI scene will pull data from it to show
extends Resource
class_name Inventory

var slot_count: int
var slots: Array[Item] = []

# Needs to be called when a new inventory is made
func initialize(new_slot_count: int) -> void:
	slot_count = new_slot_count
	slots.resize(slot_count)

func add_item(new_item: Item, amount: int) -> bool:
	## If item does not stack then just add it to a empty slot
	#if not new_item.item_data.does_stack:
		#var empty_slot_indx: int = get_empty_slot()
		#if empty_slot_indx == -1:
			#return false # No empty slot
		#
		#new_item.amount = amount
		#slots[empty_slot_indx] = new_item
		#return true
		
	# If it does stack, then check if the item is already there
	if does_have_item(new_item, amount):
		# It is already there, so just add it to the stack
		for slot in slots:
			# If slot is null, move to the next one
			if not slot:
				continue
			
			# Find the item stack
			if slot.item_data == new_item.item_data:
				slot.amount += amount
				
	# if it stacks and there it does not already exist in the inventory, then find a new slot and add there
	var empty_slot_indx: int = get_empty_slot()
	if empty_slot_indx == -1:
		return false # No empty slot
	
	new_item.amount = amount
	slots[empty_slot_indx] = new_item
	return true
	
	
func remove_item(new_item: Item, amount: int) -> bool:
	# Check if enough item is there
	if not does_have_item(new_item, amount):
		return false # Not enough items or item is not in inventory
		
	# Find the item
	for i in range(slot_count):
		# If slot is null, move to the next one
		if not slots[i]:
			continue
		
		# Find the item stack
		if slots[i].item_data == new_item.item_data:
			slots[i].amount -= amount
			if slots[i].amount <= 0: # If items is 0 or less(should not be less though), then clear the slot
				slots[i] = null
			return true
			
	return false
	
func does_have_item(target_item: Item, amount: int) -> bool:
	for slot in slots:
		# If slot is null, move to the next one
		if not slot:
			continue
		
		# Check if item exist
		if slot.item_data == target_item.item_data:
			# Check if required amount is there
			if slot.amount >= amount:
				return true
			# Not sufficient amount, so return false
			return false
		
	# Item was not in ivnentory, return false
	return false

func get_empty_slot() -> int:
	for i in range(slot_count):
		if not slots[i]:
			return i # Returning slot index
			
	return -1 # There is no empty slot
