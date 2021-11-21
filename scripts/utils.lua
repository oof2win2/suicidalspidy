local lib = {}

---@class Target
---@field claimed boolean
---@field position Position
---@field owner_unit_number uint


---Set the target of a spidertron
---@param entity LuaEntity
---@param position Position
---@return Target
function lib.set_target(entity, position)
	for _, target in pairs(global.spidertron_targets) do
		if target.position.x == position.x and target.position.y == position.y then
			target.claimed = true
			target.owner_unit_number = entity.unit_number
			return target
		end
	end
end

---Gets or makes the target of a spidertron
---@param entity LuaEntity
---@return Target
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
			
			local spidertron = global.spidertrons[entity.unit_number]
			spidertron.target = target
			spidertron.pathing = true
			
			return target
		end
	end
end

---@alias target_param {position: Position}
---@param target target_param
---@return Target
function lib.add_target(target)
	local t = {
		position=target.position,
		claimed = false,
		owner_unit_number = nil,
	}
	table.insert(global.spidertron_targets, t)
	return t
end

---@param target Target
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
---@return LuaEntity|nil
function lib.find_free_spidy()
	for _, spidertron in pairs(global.spidertrons) do
		if not spidertron.target then
			return spidertron
		end
	end
end

---Create a spidertron
---@param entity LuaEntity
---@param target Target
function lib.create_spidy(entity, target)
	global.spidertrons[entity.unit_number] = {
		target = target or nil,
		pathing = false,
		entity = entity
	}
end

---Remove a spidertron from the global table and remove it's target
---@param entity LuaEntity
function lib.remove_spidy(entity)
	lib.remove_target_owner(entity)
	global.spidertrons[entity.unit_number] = nil
end
return lib