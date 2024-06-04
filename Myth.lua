--- STEAMODDED HEADER
--- MOD_NAME: 么么
--- MOD_ID: kisskiss
--- MOD_AUTHOR: [???]
--- MOD_DESCRIPTION: ???

----------------------------------------------
------------MOD CODE -------------------------

-- NV81L1W1 seed

function SMODS.INIT.KissKiss()
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
            "以后所有牌都变为{C:hearts}红桃{}"
        }
    }
    j_love.mod = "kisskiss"
    j_love.atlas = "j_love"
    j_love:register()

    local j_growth = SMODS.Joker:new(
        "Growth", "growth",
        { extra = 40, mult = 200, eternal_compat = true },
        { x = 0, y = 0 }, loc_def,
        4, 0, true, true, true, true
    )

    j_growth.slug = "j_growth"
    j_growth.loc_txt = {
        name = "成长",
        text = {
            "这张小丑牌在每轮结束时获得{C:red}+#1#{}倍率",
            "{C:inactive}（当前为{C:red}+#2#{}倍率）"
        }
    }
    j_growth.mod = "kisskiss"
    j_growth.atlas = "j_growth"
    j_growth:register()

    local j_responsibility = SMODS.Joker:new(
        "Responsibility", "responsibility",
        { extra = { immediate_gain = 100, random_gain = { min = 1, max = 10 } } },
        { x = 0, y = 0 }, loc_def,
        4, 0, true, true, true, true
    )

    j_responsibility.slug = "j_responsibility"
    j_responsibility.loc_txt = {
        name = "责任",
        text = {
            "立即获得{C:gold}$#1#{}",
            "盲注后随机获得{C:gold}$#2#{}",
        }
    }
    j_responsibility.mod = "kisskiss"
    j_responsibility.atlas = "j_responsibility"
    j_responsibility:register()

    local j_communication = SMODS.Joker:new(
        "Communication", "communication",
        {},
        { x = 0, y = 0 }, loc_def,
        4, 0, true, true, true, true
    )

    j_communication.slug = "j_communication"
    j_communication.loc_txt = {
        name = "沟通",
        text = {
            "商店",
            "{C:green}无限{}次免费重掷"
        }
    }
    j_communication.mod = "kisskiss"
    j_communication.atlas = "j_communication"
    j_communication:register()

    local j_loyalty = SMODS.Joker:new(
        "Loyalty", "loyalty",
        {},
        { x = 0, y = 0 }, loc_def,
        4, 0, true, true, true, true
    )

    j_loyalty.slug = "j_loyalty"
    j_loyalty.loc_txt = {
        name = "忠诚",
        text = {
            "没有效果",
        }
    }
    j_loyalty.mod = "kisskiss"
    j_loyalty.atlas = "j_loyalty"
    j_loyalty:register()

    -- Additional Sprite registration
    SMODS.Sprite:new("j_love", SMODS.findModByID("kisskiss").path, "j_love.png", 71, 95, "asset_atli")
        :register()
    SMODS.Sprite:new("j_growth", SMODS.findModByID("kisskiss").path, "j_growth.png", 71, 95, "asset_atli")
        :register()
    SMODS.Sprite:new("j_responsibility", SMODS.findModByID("kisskiss").path, "j_responsibility.png", 71, 95,
        "asset_atli")
        :register()
    SMODS.Sprite:new("j_communication", SMODS.findModByID("kisskiss").path, "j_communication.png", 71, 95,
        "asset_atli")
        :register()
    SMODS.Sprite:new("j_loyalty", SMODS.findModByID("kisskiss").path, "j_loyalty.png", 71, 95, "asset_atli")
        :register()


    local Card_calculate_joker_ref = Card.calculate_joker
    function Card:calculate_joker(context)
        local ret_val = Card_calculate_joker_ref(self, context)
        if self.debuff then
            return nil
        end

        if self.ability.set == "Joker" and not self.debuff then
            if context.open_booster then
            elseif context.buying_card then
            elseif context.selling_self then
            elseif context.selling_card then
            elseif context.communication_shop then
            elseif context.ending_shop then
            elseif context.skip_blind then
                return
            elseif context.skipping_booster then
                return
            elseif context.playing_card_added and not self.getting_sliced then
            elseif context.first_hand_drawn then
            elseif context.setting_blind and not self.getting_sliced then
                if self.ability.name == 'Loyalty' and not context.blueprint
                    and context.blind.boss and not self.getting_sliced then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.blind:disable()
                                    -- play_sound('timpani')
                                    -- delay(0.4)
                                    return true
                                end
                            }))
                            -- card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize('ph_boss_disabled') })
                            return true
                        end
                    }))
                end
                return
            elseif context.destroying_card and not context.blueprint then
                return nil
            elseif context.cards_destroyed then
            elseif context.remove_playing_cards then
            elseif context.using_consumeable then
                return
            elseif context.debuffed_hand then
            elseif context.pre_discard then
            elseif context.discard then
                return
            elseif context.end_of_round then
                if context.individual then
                elseif context.repetition then
                elseif not context.blueprint then
                    if self.ability.name == "Growth" then
                        self.ability.mult = self.ability.mult + self.ability.extra
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(self, 'extra', nil, nil, nil, {
                                    message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.extra } },
                                    colour = G.C.RED,
                                    delay = 0.45,
                                    card = self
                                })
                                return true
                            end
                        }))
                    end
                end
            elseif context.individual then
                if context.cardarea == G.play then
                end
            elseif context.repetition then
                if context.cardarea == G.play then
                end
            elseif context.other_joker then
            else
                if context.cardarea == G.jokers then
                    if context.before then
                    elseif context.after then
                    else
                        if self.ability.name == 'Growth' then
                            return {
                                message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.mult } },
                                mult_mod = self.ability.mult
                            }
                        end
                    end
                else
                end
            end
        end
        return ret_val
    end

    -- Card addition to deck for Love Joker and Responsibility Joker
    local Card_add_to_deck_ref = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        Card_add_to_deck_ref(self, from_debuff)
        if self.ability.name == 'Love' then
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.playing_cards, 1, -1 do
                        local card = G.playing_cards[i]
                        local rank_suffix = card.base.id < 10 and tostring(card.base.id) or
                            card.base.id == 10 and 'T' or card.base.id == 11 and 'J' or
                            card.base.id == 12 and 'Q' or card.base.id == 13 and 'K' or
                            card.base.id == 14 and 'A'
                        G.playing_cards[i]:set_base(G.P_CARDS["H_" .. rank_suffix])
                    end
                    return true
                end
            }))
        elseif self.ability.name == 'Responsibility' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    ease_dollars(self.ability.extra.immediate_gain)
                    return true
                end
            }))
            delay(0.6)
        elseif self.ability.name == 'Communication' then
            G.GAME.current_round.reroll_cost = 0
        end
        if not self.added_to_deck then
            if self.ability.name == 'Loyalty' and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                G.GAME.blind:disable()
                -- play_sound('timpani')
                -- card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            end
        end
    end

    function SMODS.Jokers.j_growth.loc_def(card)
        return { card.ability.extra, card.ability.mult }
    end

    function SMODS.Jokers.j_responsibility.loc_def(card)
        return { card.ability.extra.immediate_gain, card.ability.extra.random_gain.min ..
        "-$" .. card.ability.extra.random_gain.max }
    end

    local Game_set_globals_ref = Game.set_globals
    function Game:set_globals()
        Game_set_globals_ref(self)
        G.MythJokerMod = G.MythJokerMod or
            { j_growth_created = false, j_love_created = false, j_responsibility_created = false, j_communication_created = false, j_loyalty_created = false }
    end

    Game:set_globals()
    G.forced_seed = 'MARRYME'

    local function hasJokerWithAbility(ability)
        for k, v in ipairs(G.jokers.cards) do
            if v.ability.name == ability then
                return true
            end
        end
        return false
    end

    local function hasShopJokerWithAbility(ability)
        for k, v in ipairs(G.shop_jokers.cards) do
            if v.ability.name == ability then
                return true
            end
        end
        return false
    end

    local createCardRef = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante >= 1 then
            if area == G.shop_jokers then
                if not hasShopJokerWithAbility('Love') and not hasJokerWithAbility('Love') and G.GAME.round_resets.ante >= 3 then
                    local card = createCardRef('Joker', area, legendary, _rarity, skip_materialize, soulable, 'j_love',
                        key_append)
                    G.MythJokerMod.j_love_created = true
                    card:set_eternal(true)
                    return card
                elseif not hasShopJokerWithAbility('Responsibility') and not hasJokerWithAbility('Responsibility') and G.GAME.round_resets.ante >= 4 then
                    local card = createCardRef('Joker', area, legendary, _rarity, skip_materialize, soulable,
                        'j_responsibility', key_append)
                    G.MythJokerMod.j_responsibility_created = true
                    card:set_eternal(true)
                    return card
                elseif not hasShopJokerWithAbility('Growth') and not hasJokerWithAbility('Growth') and G.GAME.round_resets.ante >= 5 then
                    local card = createCardRef('Joker', area, legendary, _rarity, skip_materialize, soulable, 'j_growth',
                        key_append)
                    G.MythJokerMod.j_growth_created = true
                    card:set_eternal(true)
                    return card
                elseif not hasShopJokerWithAbility('Communication') and not hasJokerWithAbility('Communication') and G.GAME.round_resets.ante >= 6 then
                    local card = createCardRef('Joker', area, legendary, _rarity, skip_materialize, soulable,
                        'j_communication', key_append)
                    G.MythJokerMod.j_communication_created = true
                    card:set_eternal(true)
                    return card
                elseif not hasShopJokerWithAbility('Loyalty') and not hasJokerWithAbility('Loyalty') and G.GAME.round_resets.ante >= 7 then
                    local card = createCardRef('Joker', area, legendary, _rarity, skip_materialize, soulable, 'j_loyalty',
                        key_append)
                    G.MythJokerMod.j_loyalty_created = true
                    card:set_eternal(true)
                    return card
                end
            end
        end
        if _type == 'Base' then
            local card = createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key,
                key_append)
            local hasLoveJoker = false
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.name == 'Love' then
                    hasLoveJoker = true;
                end
            end
            if hasLoveJoker then
                local rank_suffix = card.base.id < 10 and tostring(card.base.id) or
                    card.base.id == 10 and 'T' or card.base.id == 11 and 'J' or
                    card.base.id == 12 and 'Q' or card.base.id == 13 and 'K' or
                    card.base.id == 14 and 'A'
                card:set_base(G.P_CARDS["H_" .. rank_suffix])
            end
            return card
        end
        if _type == 'Enhanced' then
            local card = createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key,
                key_append)
            card:set_ability(G.P_CENTERS.m_lucky)
            local hasLoveJoker = false
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.name == 'Love' then
                    hasLoveJoker = true;
                end
            end
            if hasLoveJoker then
                local rank_suffix = card.base.id < 10 and tostring(card.base.id) or
                    card.base.id == 10 and 'T' or card.base.id == 11 and 'J' or
                    card.base.id == 12 and 'Q' or card.base.id == 13 and 'K' or
                    card.base.id == 14 and 'A'
                card:set_base(G.P_CARDS["H_" .. rank_suffix])
            end
            return card
        end
        return createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    end

    local Card_set_cost = Card.set_cost
    function Card:set_cost()
        Card_set_cost(self)
        if self.ability.name == "Growth" or self.ability.name == "Love" or self.ability.name == "Responsibility" or self.ability.name == "Communication" or self.ability.name == "Loyalty" then
            self.cost = 0
        end
    end

    local Card_calculate_dollar_bonus_ref = Card.calculate_dollar_bonus
    function Card:calculate_dollar_bonus()
        if self.debuff then return end
        if self.ability.set == "Joker" then
            if self.ability.name == 'Responsibility' then
                local gain = math.random(self.ability.extra.random_gain.min, self.ability.extra.random_gain.max)
                return gain
            end
        end
        return Card_calculate_dollar_bonus_ref(self)
    end

    local Calculate_reroll_cost_ref = calculate_reroll_cost
    function calculate_reroll_cost(skip_increment)
        Calculate_reroll_cost_ref(skip_increment)
        local hasCommunicationJoker = false
        for k, v in ipairs(G.jokers.cards) do
            if v.ability.name == 'Communication' then
                hasCommunicationJoker = true;
            end
        end
        if hasCommunicationJoker then
            G.GAME.current_round.reroll_cost = 0
        end
    end

    local G_FUNCS_reroll_shop_ref = G.FUNCS.reroll_shop
    function G.FUNCS.reroll_shop(e)
        G_FUNCS_reroll_shop_ref(e)

        local hasCommunicationJoker = false
        for k, v in ipairs(G.jokers.cards) do
            if v.ability.name == 'Communication' then
                hasCommunicationJoker = true;
            end
        end
        if hasCommunicationJoker then
            for i = #G.shop_booster.cards, 1, -1 do
                local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
                c:remove()
                c = nil
            end
            for i = 1, 2 do
                G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key
                local card = Card(G.shop_booster.T.x + G.shop_booster.T.w / 2,
                    G.shop_booster.T.y, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty,
                    G.P_CENTERS[G.GAME.current_round.used_packs[i]],
                    { bypass_discovery_center = true, bypass_discovery_ui = true })
                create_shop_card_ui(card, 'Booster', G.shop_booster)
                card.ability.booster_pos = i
                card:start_materialize()
                G.shop_booster:emplace(card)
            end
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------