# Contains item data of a inventory.
# Contains necessary functions to do add, remove and check existance of items to an inventory
# The global script InventoryManager calls these functions to do provide an easy access to players inventory
# The Inventory UI scene will pull data from it to show when player inventory is opened

extends Resource
class_name Inventory

signal slot_changed(slot_index: int)

var slot_count: int
var slots: Array[Item] = []
var is_quick_transfer_allowed: bool = true # Allows quick transfer of items by shift+click

# Needs to be called when a new inventory is made
func _init(new_slot_count: int, quick_transfer_allowed: bool = true) -> void:
	slot_count = new_slot_count
	slots.resize(slot_count)
	is_quick_transfer_allowed = quick_transfer_allowed
	#SignalBus.new_inventory_ready.emit(self)

# Adds item
# add_item_old is the code without stack_limit implemented
# This one handles stack_limit of items
## Probably should change return type from bool to int with different return codes,
## since this function can now add items partially with stack_limit. But that might
## breack current codes/make no difference at differnt places, so skipping it.
func add_item(new_item: Item, amount: int) -> bool:
	#prints("amount: ", amount) 
	# Check if the item is already there
	if does_have_same_item_in_inventory(new_item):
		# It is already there, so just add it to the stack
		for i in range(slot_count):
			# If slot is null, move to the next one
			if not slots[i]:
				continue
			
			# Find the item stack
			if slots[i].item_data == new_item.item_data:
				# If the stack is full, then skip to the next slot
				#prints("slots[i].amount = ", slots[i].amount)
				if slots[i].amount == slots[i].item_data.stack_limit:
					continue
				
				# How many more items can the current stack hold before becoming full
				var space_in_current_stack: int = slots[i].item_data.stack_limit - slots[i].amount
				# If space is bigger than the amount need to be added, then simply add them to stack
				if space_in_current_stack >= amount:
					slots[i].amount += amount
					slot_changed.emit(i)
					return true
					
				# If the previous condition failed that means 'amount' is bigger than the current stack can hold
				# In that case, add as much that can be added to the current stack and then recursively try to add rest of the amount
				var remaining_amount: int = amount - space_in_current_stack
				slots[i].amount += space_in_current_stack
				slot_changed.emit(i)
				return add_item(new_item, remaining_amount)
				
	# If it does not already exist or existing stacks of the item are full in the inventory, 
	# then find a new slot and add there
	var empty_slot_index: int = get_empty_slot()
	if empty_slot_index == -1:
		return false # No empty slot
	
	# If amount is bigger than a stack can hold, then make a stack and then add the rest recursively
	#prints("amount: ", amount)
	if amount > new_item.item_data.stack_limit:
		var remaining_amount: int = amount - new_item.item_data.stack_limit
		#prints("remaining_amount: ", remaining_amount)
		
		# Need to make a new item from the split stack
		var stack_split_new_item: Item = ItemManager.make_item(new_item.item_data.item_id, new_item.item_data.stack_limit)
		stack_split_new_item.update_info(self, empty_slot_index)
		slots[empty_slot_index] = stack_split_new_item
		slot_changed.emit(empty_slot_index)
		
		new_item.amount = remaining_amount
		return add_item(new_item, remaining_amount)
	
	# If the previous condition failed, then item can hold in a single stack
	new_item.amount = amount
	new_item.update_info(self, empty_slot_index)
	slots[empty_slot_index] = new_item
	slot_changed.emit(empty_slot_index)
	return true

# Removes the item in the given slot_index and puts the new item there 
func replace_item(new_item: Item, slot_index: int) -> void: # Note: "new_item" can be null, in that cause the slot just becomes empty
	slots[slot_index] = new_item
	if new_item: # If new item is null, no need to update info
		new_item.update_info(self, slot_index)
	slot_changed.emit(slot_index)

# Removes item	
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
			# If a single stacks amount is sufficient to remove the required amount then simply remove that from a stack
			if slots[i].amount >= amount:
				slots[i].amount -= amount
				amount = 0
			
			# If the amount is bigger than the current slots stack(might not be at stack_limit), then remove the stack and then keep looking
			else:
				amount -= slots[i].amount
				slots[i].amount = 0
				
			if slots[i].amount <= 0: # If items is 0 or less(should not be less though), then clear the slot
				slots[i].clear_info() # Clear all the reference to this inventory in the item
				slots[i] = null
			slot_changed.emit(i)	
			
			# All items were successfully removed
			if amount == 0:
				return true
	
	return false

# Check for existane of item in specific amount
func does_have_item(target_item: Item, amount: int) -> bool:
	var total_existing_amount: int = 0
	
	for slot in slots:
		# If slot is null, move to the next one
		if not slot:
			continue
		
		# Check if item exist
		if slot.item_data == target_item.item_data:
			# Since there can be multiple stacks of the same item, keep adding their amount to get the total amount
			total_existing_amount += slot.amount

	if total_existing_amount >= amount:
		return true
		
	# Item was not in ivnentory or not in sufficient amount, return false
	return false

func does_have_same_item_in_inventory(target_item: Item) -> bool:
	for slot in slots:
		# If slot is null, move to the next one
		if not slot:
			continue
		
		# Check if item exist
		if slot.item_data == target_item.item_data:
			return true
		
	# Item was not in ivnentory, return false
	return false

# Finds a empty slot in the inventory and returns it's index
func get_empty_slot() -> int:
	for i in range(slot_count):
		if not slots[i]:
			return i # Returning slot index
			
	return -1 # There is no empty slot

# Prints the current inventory info in the console
func print_inventory() -> void:
	prints(slots)

# Checks if the inventory is fully empty or not
func is_empty() -> bool:
	for slot in slots:
		if slot: # If there is a item in slot, then it's not empty
			return false
	return true

# Remvoe all items from the inventory
func make_empty() -> void:
	for i in range(slot_count):
		slots[i] = null

## Adds item
#func add_item_old(new_item: Item, amount: int) -> bool:
	## Check if the item is already there
	#if does_have_same_item_in_inventory(new_item):
		## It is already there, so just add it to the stack
		#for i in range(slot_count):
			## If slot is null, move to the next one
			#if not slots[i]:
				#continue
			#
			## Find the item stack
			#if slots[i].item_data == new_item.item_data:
				#slots[i].amount += amount
				#slot_changed.emit(i)
				#return true
				#
	## if it stacks and there it does not already exist in the inventory, then find a new slot and add there
	#var empty_slot_index: int = get_empty_slot()
	#if empty_slot_index == -1:
		#return false # No empty slot
	#
	#new_item.amount = amount
	#new_item.update_info(self, empty_slot_index)
	#slots[empty_slot_index] = new_item
	#slot_changed.emit(empty_slot_index)
	#return true
#
#
## Check for existane of item in specific amount
#func does_have_item_old(target_item: Item, amount: int) -> bool:
	#for slot in slots:
		## If slot is null, move to the next one
		#if not slot:
			#continue
		#
		## Check if item exist
		#if slot.item_data == target_item.item_data:
			## Check if required amount is there
			#if slot.amount >= amount:
				#return true
			## Not sufficient amount, so return false
			#return false
		#
	## Item was not in ivnentory, return false
	#return false
	#
## Removes item	
#func remove_item_old(new_item: Item, amount: int) -> bool:
	## Check if enough item is there
	#if not does_have_item(new_item, amount):
		#return false # Not enough items or item is not in inventory
		#
	## Find the item
	#for i in range(slot_count):
		## If slot is null, move to the next one
		#if not slots[i]:
			#continue
		#
		## Find the item stack
		#if slots[i].item_data == new_item.item_data:
			#slots[i].amount -= amount
			#if slots[i].amount <= 0: # If items is 0 or less(should not be less though), then clear the slot
				#slots[i].clear_info() # Clear all the reference to this inventory in the item
				#slots[i] = null
			#slot_changed.emit(i)
			#return true
			#
	#return false
