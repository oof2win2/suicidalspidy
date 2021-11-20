local lib = {}

---Set the target of a spidertron
---@param entity LuaEntity
---@param position Position
function lib.set_target(entity, position)
	for _, target in pairs(global.spidertron_targets) do
		if target.position == position then
			target.claimed = true
			target.owner_unit_number = entity.unit_number
			return target
		end
	end
end

---Gets or makes the target of a spidertron
---@param entity LuaEntity
---@return Position|nil
function lib.get_target(entity)
	for _, existing_target in pairs(global.spidertron_targets) do
		if existing_target.owner_unit_number == entity.unit_number then
			return existing_target
		end
	end

	-- find it a target since it doesn't have one
	for _, target in pairs(global.spidertron_targets) do
		if not target.claimed then
			target.claimed = true
			target.owner_unit_number = entity.unit_number
			
			local spidertron = global.spidertons[entity.unit_number]
			spidertron.target = target
			spidertron.pathing = true
			
			return target
		end
	end
end

function lib.add_target(target)
	return table.insert(global.spidertron_targets, {
		position=target.position,
		claimed = false,
		owner_unit_number = nil,
	})
end
function lib.remove_target(target)
	for index, existing_target in pairs(global.spidertron_targets) do
		if existing_target.position == target.position then
			table.remove(global.spidertron_targets, index)
		end
	end
end

---Removes a target owner
---@param entity LuaEntity
function lib.remove_target_owner(entity)
	for _, existing_target in pairs(global.spidertron_targets) do
		if existing_target.owner_unit_number == entity.unit_number then
			existing_target.owner_unit_number = nil
			existing_target.claimed = false
		end
	end
end

---Finds a spidertron that doesn't have any target yet
function lib.find_free_spidy()
	for _, spidertron in pairs(global.spidertons) do
		if not spidertron.target then
			return spidertron
		end
	end
end

---Create a spidertron
---@param entity LuaEntity
---@param target any
function lib.create_spidy(entity, target)
	global.spidertrons[entity.unit_number] = {
		target = target or nil,
		pathing = false
	}
end

---Remove a spidertron from the global table and remove it's target
---@param entity LuaEntity
function lib.remove_spidy(entity)
	lib.remove_target_owner(entity)
	global.spidertrons[entity.unit_number] = nil
end
return lib