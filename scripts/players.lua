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

--TODO: make this handler work properly
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

script.on_event(defines.events.on_entity_died, on_entity_died, {
	filter={
		filter="name",
		name="spidertron"
	}
})
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_player_used_capsule, on_player_used_capsule)