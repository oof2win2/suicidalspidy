data:extend{
	{
		type="item",
		capsule_action={
			type="throw",
			attack_parameters={
				type="projectile",
				-- other stuff is not added since https://wiki.factorio.com/Types/ProjectileAttackParameters doesn't require them
			}
		},
		icon = "__base__/graphics/icons/discharge-defense-equipment-controller.png",
		icon_mipmaps=4,
		icon_size = 64,
		stack_size=1,
		name="suicidalspidy-targeting-remote",
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