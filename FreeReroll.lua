--- STEAMODDED HEADER
--- MOD_NAME: Free Reroll
--- MOD_ID: FreeReroll
--- MOD_AUTHOR: [Tianjing]
--- MOD_DESCRIPTION: Rerolls are free! It may ruin your game experience.

----------------------------------------------
------------MOD CODE -------------------------

local Calculate_reroll_costRef = calculate_reroll_cost

function calculate_reroll_cost(skip_increment)
	Calculate_reroll_costRef(skip_increment)

	G.GAME.current_round.reroll_cost = 0
end

----------------------------------------------
------------MOD CODE END----------------------
