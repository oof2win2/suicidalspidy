data:extend{
	{
		type = "artillery-flare",
		name = "suicidalspidy-flare",
		icon = "__base__/graphics/icons/artillery-targeting-remote.png",
		icon_size = 64, icon_mipmaps = 4,
		flags = {"placeable-off-grid", "not-on-map"},
		map_color = {r=1, g=0.5, b=0},
		life_time = 60 * 60,
		initial_height = 0,
		initial_vertical_speed = 0,
		initial_frame_speed = 1,
		shots_per_flare = 1,
		early_death_ticks = 3 * 60,
		pictures =
		{
			{
			filename = "__core__/graphics/shoot-cursor-red.png",
			priority = "low",
			width = 258,
			height = 183,
			frame_count = 1,
			scale = 1,
			flags = {"icon"}
			}
		},
	},
	{
		type="capsule",
		capsule_action={
			type="artillery-remote",
			flare="suicidalspidy-flare",
		},
		icon = "__base__/graphics/icons/discharge-defense-equipment-controller.png",
		icon_mipmaps=4,
		icon_size = 64,
		stack_size=1,
		name="suicidalspidy-targeting-remote",
		subgroup="capsule",
		order="b[personal-transport]-c[suicidal-spidertron]-b[remote]"
	},
	{
		type="recipe",
		name="suicidalspidy-targeting-remote",
		result="suicidalspidy-targeting-remote",
		ingredients={
			{"artillery-targeting-remote", 1},
			{"spidertron-remote", 1}
		}
	}
}