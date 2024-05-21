--- STEAMODDED HEADER
--- MOD_NAME: Deck of Hearts
--- MOD_ID: DeckOfHearts
--- MOD_AUTHOR: [xxx]
--- MOD_DESCRIPTION: Create a special deck that only contains hearts!

----------------------------------------------
------------MOD CODE -------------------------

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    Backapply_to_runRef(arg_56_0)

    if arg_56_0.effect.config.only_one_suit then
        -- G.E_MANAGER:add_event(Event({
		-- 	func = function()
		-- 		for iter_57_0 = #G.playing_cards, 1, -1 do
		-- 			sendDebugMessage(G.playing_cards[iter_57_0].base.id)
		-- 			if G.playing_cards[iter_57_0].base.suit ~= "Hearts" then
		-- 				G.playing_cards[iter_57_0]:change_suit("Hearts")
		-- 			end
		-- 		end

		-- 		return true
		-- 	end
		-- }))
        G.E_MANAGER:add_event(Event({
			func = function()
				local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"}
				local suits = {"H"}

				for i = #G.playing_cards, 1, -1 do
                    local rank = ranks[math.random( #ranks )] 
                    local suit = suits[math.random( #suits )]
                    
                    G.playing_cards[i]:set_base(G.P_CARDS[suit .. "_" .. rank])
				end

				return true
			end
		}))
    end
end

local loc_def = {
    ["name"]="古怪牌组",
    text = {
        "牌组中所有牌的",
        "{C:attention}点数{}和{C:attention}花色{}",
        "都是随机的"
    }
}

local deckOfHearts = SMODS.Deck:new("Erratic Deck 2", 1, {only_one_suit = true}, {x = 2, y = 3}, loc_def)
deckOfHearts:register()

----------------------------------------------
------------MOD CODE END----------------------