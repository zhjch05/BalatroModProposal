-- STEAMODDED HEADER
-- MOD_NAME: Responsibility Joker
-- MOD_ID: responsibilityjoker
-- MOD_AUTHOR: [XXX]
-- MOD_DESCRIPTION: Responsibility Joker Mod

----------------------------------------------
------------MOD CODE -------------------------
function SMODS.INIT.ResponsibilityJoker()

    local j_responsibility = SMODS.Joker:new(
        "Responsibility", "responsibility",
        { extra = { immediate_gain = 100, random_gain = {min = 1, max = 10}, total_gain = 0} },
        { x = 0, y = 0 }, loc_def,
        4, 6, true, true, true, true
    )

    j_responsibility.slug = "j_responsibility"
    j_responsibility.loc_txt = {
        name = "责任",
        text = {
            "立即获得{C:gold}+$1#{}",
            "每回合随机获得{C:gold}+$2#{}",
            "{C:inactive}（当前总共获得{C:gold}+$3#{}）"
        }
    }
    j_responsibility.mod = "responsibilityjoker"
    j_responsibility.atlas = "responsibilityjoker"
    j_responsibility:register()

    local calculate_joker_old = Card.calculate_joker
    function Card:calculate_joker(context)
        local ret_val = calculate_joker_old(self, context)
        if context.end_of_round and self.ability.name == "Responsibility" then
            local gain = math.random(self.ability.extra.random_gain.min, self.ability.extra.random_gain.max)
            self.ability.extra.total_gain = self.ability.extra.total_gain + gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_gold', vars = {gain}},
                        colour = G.C.GOLD,
                        delay = 0.45,
                        card = self
                    })
                    return true
                end
            }))
        end
        return ret_val
    end

    function Card:calculate_dollar_bonus()
        if self.debuff then return end
        if self.ability.set == "Joker" then
            if self.ability.name == 'Responsibility' then
                return self.ability.extra.immediate_gain + self.ability.extra.total_gain
            end
        end
    end

    SMODS.Sprite:new("responsibilityjoker", SMODS.findModByID("responsibilityjoker").path, "j_responsibility.png", 71, 95, "asset_atli"):register()

    function SMODS.Jokers.j_responsibility.loc_def(card)
        return { card.ability.extra.immediate_gain, card.ability.extra.random_gain.min .. "-" .. card.ability.extra.random_gain.max, card.ability.extra.total_gain }
    end

    -- Initial gain of $100
    local add_to_deck_old = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        add_to_deck_old(self, from_debuff)
        if self.ability.name == 'Responsibility' then
            G.GAME.dollars = G.GAME.dollars + self.ability.extra.immediate_gain
            card_eval_status_text(self, 'extra', nil, nil, nil, {
                message = localize{type = 'variable', key = 'a_gold', vars = {self.ability.extra.immediate_gain}},
                colour = G.C.GOLD
            })
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------
