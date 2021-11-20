data:extend{
	{
		type = "ammo-category",
		name = "suicidalspidy-launcher"
	},
	{
		type = "ammo",
		name = "suicidalspidy-ammo",
		icon = "__base__/graphics/icons/atomic-bomb.png",
		icon_size = 1, icon_mipmaps = 1,
		ammo_type = {
			type = "direct",
			category = "suicidalspidy-launcher",
			action_delivery = {
				type = "instant",
				target_effects = {
					type = "script",
					effect_id = "suicidalspidy-launch"
				}
			}
		},
		stack_size = 1,
	},
	{
		type = "gun",
		name = "suicidalspidy-launcher-gun",
		localised_name = {"item-name.suidicidalspidy-launcher-gun"},
		icon = "__base__/graphics/icons/tank-cannon.png",
		icon_size = 64, icon_mipmaps = 4,
		flags = {"hidden"},
		subgroup = "gun",
		order = "z[artillery]-a[cannon]",
		attack_parameters =
		{
		  type = "projectile",
		  ammo_category = "suicidalspidy-launcher",
		  cooldown = 15 * 60,
		  movement_slow_down_factor = 0,
		  range = 1000
		},
		stack_size = 1
	},
	{
		type="artillery-turret",
		name = "suicidalspidy-launcher",
		localised_name = {"item-name.suicidalspidy-rocket"},
		icon = "__suicidalspidy__/graphics/rocket.png",
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
	  
		--collision_box = {{-1.45, -1.45}, {1.45, 1.45}},
		--selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		collision_mask = {},
	  
		inventory_size = 1,
		ammo_stack_limit = 5,
		automated_ammo_count = 1,
		gun = "suicidalspidy-launcher-gun",
		turret_rotation_speed = 1,
		manual_range_modifier = 1000000,
		disable_automatic_firing = true,
	  
		base_picture = util.empty_sprite(),
		cannon_barrel_pictures = util.empty_sprite(),
		cannon_base_pictures = util.empty_sprite(),
		order = "lol",
		alert_when_attacking = false
	},
}