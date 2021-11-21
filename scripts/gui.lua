local statics = require "statics"
local lib = require "scripts.utils"

---Create the GUI for a player
---@param player LuaPlayer
---@param entity LuaEntity
local function create_gui(player, entity)
	local screen = player.gui.screen
	local player_global = global.players[player.index]
	if not player_global.elements then player_global.elements = {} end
	
	local main_frame = screen.add{type="frame", caption={"suicidalspidy.gui-name"}, name="suicidalspidy-option-selector"}
	main_frame.auto_center = true
	local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical"}
	local target = lib.get_target(entity)
	content_frame.add{
		type="minimap",
		position=target and target.position,
		tags={
			owner=statics.ownertag,
			unit_number=entity.unit_number,
			type="minimap-preview",
			has_target=target and true or false
		}
	}
	content_frame.add{
		type="button",
		caption="Path to target",
		enabled=target and true or false,
		tags={
			owner=statics.ownertag,
			unit_number=entity.unit_number,
			type="path-to-target",
		}
	}
	player_global.elements.main_frame = main_frame
	player.opened = main_frame
end

local function set_pathing(entity, target)
	
end

---Toggle the GUI for a player
---@param player LuaPlayer
local toggle_gui = function(player)
	local player_global = global.players[player.index]
	if not player_global then
		global.players[player.index] = {
			elements={}
		}
		player_global = global.players[player.index]
	end
	local entity = player.opened


	if not player_global.elements.main_frame then
		create_gui(player, entity)
	else
		player_global.elements.main_frame.destroy()
		player_global.elements.main_frame = nil
	end
end

script.on_event(defines.events.on_gui_opened, function (event)
	local entity = event.entity
	if entity == nil or entity.name ~= "spidertron" then return end
	
	local player = game.get_player(event.player_index)
	toggle_gui(player)
end)
script.on_event(defines.events.on_gui_closed, function (event)
	local element = event.element
	if element == nil or element.name ~= "suicidalspidy-option-selector" then return end

	local player = game.get_player(event.player_index)
	toggle_gui(player)
end)
script.on_event(defines.events.on_gui_click, function (event)
	local element = event.element
	if element == nil or element.tags.owner ~= statics.ownertag then return end
	
	local spidertron = global.spidertrons[element.tags.unit_number]
	local entity = spidertron.entity
	local target = lib.get_target(entity)
	if not target then return end
	local request = entity.surface.request_path{
		bounding_box = {{0.5, 0.5}, {-0.5, -0.5}},
		force = entity.force,
		collision_mask = {"water-tile"},
		start = entity.position,
		goal = target.position,
		radius = 20,
		can_open_gates =  true,
		pathfind_flags = {
			prefer_straight_paths = true
		},
	}
	global.pathing_requests[request] = {
		entity = entity,
		id = request
	}
end)

---@class PathingRequest
---@field entity LuaEntity
---@field id uint

---@class Spidertron
---@field target Target
---@field pathing boolean
---@field entity LuaEntity

script.on_init(function ()
	global = {
		players = {},
		---@type Target[]
		spidertron_targets = {},
		---@type Spidertron[]
		spidertrons = {},
		---@type PathingRequest
		pathing_requests = {}
	}
end)