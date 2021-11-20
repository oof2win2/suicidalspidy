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
		position=target,
		tags={
			owner=statics.ownertag,
			unit_number=entity.unit_number,
			type="minimap-preview",
			has_target=target and true or false
		}
	}
	local button_frame = content_frame.add{type="frame", name="button_frame"}
	button_frame.add{
		type="switch",
		left_label_caption={"suicidalspidy.disarmed"},
		right_label_caption={"suicidalspidy.armed"},
		tags={
			owner=statics.ownertag,
			unit_number=entity.unit_number,
			type="armed"
		}
	}
	button_frame.add{
		type="button",
		caption="Path to target",
		tags={
			owner=statics.ownertag,
			unit_number=entity.unit_number,
			type="path-to-target"
		}
	}
	player_global.elements.main_frame = main_frame
	player.opened = main_frame
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

---@param event EventData|on_player_used_capsule
local function on_player_used_capsule (event)
	if event.item.name ~= "suicidalspidy-targeting-remote" then return end
	table.insert(global.spidertron_targets, {
		position=event.position,
		player_index=event.player_index,
	})

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
script.on_event(defines.events.on_player_used_capsule, on_player_used_capsule)

script.on_init(function ()
	global = {
		players = {},
		spidertron_targets = {},
		spidertrons = {}
	}
end)