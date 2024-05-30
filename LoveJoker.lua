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
        4, 0, true, true, true, true
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

local Game_set_globals_ref = Game.set_globals
function Game:set_globals()
    Game_set_globals_ref(self)
    
    G.LoveJokerMod = G.LoveJokerMod or { j_love_created = false }
end

Game:set_globals()

local createCardRef = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante == 1 and _type == 'Joker' and not G.LoveJokerMod.j_love_created then
        local card = createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, 'j_love', key_append)
        G.LoveJokerMod.j_love_created = true
        card:set_eternal(true)
        return card
    end
    return createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end

local Card_set_cost = Card.set_cost
function Card:set_cost()
    Card_set_cost(self)
    if self.ability.name == "Love" then
        self.cost = 0
    end
end



----------------------------------------------
------------MOD CODE END----------------------
