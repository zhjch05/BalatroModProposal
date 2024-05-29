--- STEAMODDED HEADER
--- MOD_NAME: 爱情
--- MOD_ID: lovejoker
--- MOD_AUTHOR: [XXX]
--- MOD_DESCRIPTION: Love

----------------------------------------------
------------MOD CODE -------------------------
function SMODS.INIT.LoveJoker()

    local j_love = SMODS.Joker:new(
        "Love", "love",
        {},
        { x = 0, y = 0 }, loc_def,
        4, 6, true, true, true, true
    )

    j_love.slug = "j_love"
    j_love.loc_txt = {
        name = "爱情",
        text = {
            "把牌库所有牌变为{C:hearts}红桃{}",
            "以后所有牌的花色都变为{C:hearts}红桃{}"
        }
    }
    j_love.mod = "lovejoker"
    j_love.atlas = "lovejoker"
    j_love:register()

    local createCardRef = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        local card = createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if _type == 'Base' then
            local hasLoveJoker = false
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.name == 'Love' then
                    hasLoveJoker = true;
                end
            end
            if hasLoveJoker then
                local rank = card.base.value
                card:set_base(G.P_CARDS["H" .. "_" .. rank])
            end
        end
        return card
    end

    local Card_add_to_deck = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        Card_add_to_deck(self, from_debuff)
        if self.ability.name == 'Love' then
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.playing_cards, 1, -1 do
                        local rank = G.playing_cards[i].base.value
                        G.playing_cards[i]:set_base(G.P_CARDS["H" .. "_" .. rank])
                    end
                    return true
                end
            }))
        end
    end

    SMODS.Sprite:new("lovejoker", SMODS.findModByID("lovejoker").path, "j_love.png", 71, 95, "asset_atli"):register()
end



----------------------------------------------
------------MOD CODE END----------------------
