local function on_built_entity (e)
	local entity = e.created_entity
	if entity.name ~= "spidertron" then return end
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
	global.spidertron_targets[entity.unit_number] = nil
	
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

script.on_event(defines.events.on_entity_died, on_entity_died, {
	filter={
		filter="name",
		name="spidertron"
	}
})
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)