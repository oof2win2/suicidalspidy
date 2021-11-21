local lib = require "scripts.utils"
local statics = require "statics"
-- use fake characters to shoot, LuaControl.shooting_state applies to them and makes the spidertron shoot

---@param e EventData|on_built_entity | EventData|on_robot_built_entity
local function on_built_entity (e)
	local entity = e.created_entity
	if entity.name ~= "spidertron" then return end

	-- add the spidy to the global free spidy list
	lib.create_spidy(entity)

	local fake_player = entity.surface.create_entity{
		name="character",
		force=entity.force,
		position=entity.position,
	}
	entity.set_driver(fake_player)
	entity.vehicle_automatic_targeting_parameters = {
		auto_target_with_gunner = false,
		auto_target_without_gunner = false,
	}

	-- insert the one rocket into the inventory
	local ammo_inv = entity.get_inventory(defines.inventory.spider_ammo)
	ammo_inv[1].set_stack{name="atomic-bomb", count=1}
end
local function on_entity_died (e)
	---@type LuaEntity
	local entity = e.entity
	if entity.name ~= "spidertron" then return end

	-- remove the target to take up less space
	lib.remove_target(entity)
	
	-- make spidertron go kaboom if there is a rocket inside
	local ammo_inv = entity.get_inventory(defines.inventory.spider_ammo)
	if ammo_inv[1].valid_for_read and ammo_inv[1].name == "atomic-bomb" then
		-- go kaboom
		entity.surface.create_entity{
			name="atomic-rocket",
			position=entity.position,
			target=entity.position,
			speed=1
		}
	end
end

---@param e EventData|on_player_used_capsule
local function on_player_used_capsule(e)
	if e.item.name ~= statics.remote_name then return end
	local target = lib.add_target({
		position=e.position
	})


	local spidy = lib.find_free_spidy()
	if spidy then
		lib.set_target(spidy, target)
	end
end

---@param e EventData|on_script_path_request_finished
local function on_script_path_request_finished(e)
	local req = global.pathing_requests[e.id]
	if not req then return end -- not our path request
	if not e.path then
		-- unsuccessful pathing
		global.pathing_requests[e.id] = nil
		return
	end

	-- set the paths
	local previous_dx = 0
	local previous_dy = 0
	local prev_x = req.entity.position.x
	local prev_y = req.entity.position.y
	for _, waypoint in pairs(e.path) do
		local current_dx = prev_x - waypoint.position.x
		local current_dy = prev_y - waypoint.position.y
		-- log(tostring(current_dx) .. " " .. tostring(previous_dx))
		if current_dx ~= previous_dx or current_dy ~= previous_dy then
			req.entity.add_autopilot_destination(waypoint.position)
		end
		previous_dx = current_dx
		previous_dy = current_dy
		prev_x = waypoint.position.x
		prev_y = waypoint.position.y
	end
	req.entity.add_autopilot_destination(e.path[#e.path].position)

	-- add the target's position to the autopilot so it goes exactly to the defined spot
	local target = lib.get_target(req.entity)
	req.entity.add_autopilot_destination(target.position)

	-- remove the pathing request from global
	global.pathing_requests[e.id] = nil
end

---@param e EventData|on_spider_command_completed
local function on_spider_command_completed(e)
	local entity = e.vehicle

	if not global.spidertrons[entity.unit_number] then return end

	if entity.autopilot_destination then return end
	entity.vehicle_automatic_targeting_parameters = {
		auto_target_with_gunner = true,
		auto_target_without_gunner = true,
	}
	local target = lib.get_target(entity)
	lib.remove_target(target)
	entity.die()
end

---@param e EventData|on_entity_destroyed
local function on_entity_destroyed(e)
	log(serpent.line(e))
	if e.unit_number then
		local entity = global.spidertrons[e.unit_number]
		lib.remove_spidy(entity)
		global.spidertrons[e.unit_number] = nil
	end
end

script.on_event(defines.events.on_entity_died, on_entity_died, {
	filter={
		filter="name",
		name="spidertron"
	}
})
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_player_used_capsule, on_player_used_capsule)
script.on_event(defines.events.on_script_path_request_finished, on_script_path_request_finished)
script.on_event(defines.events.on_spider_command_completed, on_spider_command_completed)
script.on_event(defines.events.on_entity_destroyed, on_entity_destroyed)