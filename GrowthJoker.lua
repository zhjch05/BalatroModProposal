--- STEAMODDED HEADER
--- MOD_NAME: Growth Joker
--- MOD_ID: growthjoker
--- MOD_AUTHOR: [XXX]
--- MOD_DESCRIPTION: A mod that introduces a Joker card which grows in multiplier each round.

----------------------------------------------
------------MOD CODE -------------------------
function SMODS.INIT.GrowthJoker()

    local j_growth = SMODS.Joker:new(
        "Growth", "growth",
        { extra = 3, mult = 3 },
        { x = 0, y = 0 }, loc_def,
        2, 6, true, true, true, true
    )

    j_growth.slug = "j_growth"
    j_growth.loc_txt = {
        name = "Growth",
        text = {
            "这张小丑牌在每轮结束时获得{C:red}+#1#{}倍率",
            "{C:inactive}（当前为{C:red}+#2#{}倍率）"
        }
    }
    j_growth.mod = "growthjoker"
    j_growth.atlas = "growthjoker"
    j_growth:register()

    local load_old = Card.load
    function Card:load(cardTable, other_card)
        load_old(self, cardTable, other_card)
    end

    local calculate_joker_old = Card.calculate_joker
    function Card:calculate_joker(context)
        local ret_val = calculate_joker_old(self, context)
        if context.end_of_round and self.ability.name == "Growth" then
            self.ability.mult = self.ability.mult + self.ability.extra
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra}},
                        colour = G.C.RED,
                        delay = 0.45, 
                        card = self
                    }) 
                    return true
                end
            }))
        end
        return ret_val
    end

    SMODS.Sprite:new("growthjoker", SMODS.findModByID("growthjoker").path, "j_growth.png", 71, 95, "asset_atli"):register()

    function SMODS.Jokers.j_growth.loc_def(card)
        return { card.ability.extra, card.ability.mult }
    end
end



----------------------------------------------
------------MOD CODE END----------------------
