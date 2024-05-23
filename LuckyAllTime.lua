--- STEAMODDED HEADER
--- MOD_NAME: Lucky All Time
--- MOD_ID: LuckyAllTime
--- MOD_AUTHOR: [xxx]
--- MOD_DESCRIPTION: Get Lucky!

----------------------------------------------
------------MOD CODE -------------------------

-- force Enhanced card to be m_lucky only
local createCardRef = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local card = createCardRef(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == 'Enhanced' then
        card:set_ability(G.P_CENTERS.m_lucky)
    end
    return card
end

-- Never debuff card if blink is "The Head" (protects All Hearts deck)
local BlindDebuffCardRef = Blind.debuff_card
function Blind:debuff_card(card, from_blind)
    if self.name ~= 'The Head' then
        BlindDebuffCardRef(self, card, from_blind)
    end
    card:set_debuff(false)
end

-- Force Lucky Card to trigger mult
local CardGetChipMultRef = Card.get_chip_mult
function Card:get_chip_mult()
    local mult = CardGetChipMultRef(self)
    if self.ability.effect == "Lucky Card" then 
        self.lucky_trigger = true
        return self.ability.mult
    else
        return mult
    end
end

-- Force Lucky Card to trigger dollars
function Card:get_p_dollars()
    if self.debuff then return 0 end
    local ret = 0
    if self.seal == 'Gold' then
        ret = ret +  3
    end
    if self.ability.p_dollars > 0 then
        if self.ability.effect == "Lucky Card" then
                self.lucky_trigger = true
                ret = ret +  self.ability.p_dollars
        else
            ret = ret + self.ability.p_dollars
        end
    end
    if ret > 0 then
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + ret
        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
    end
    return ret
end

-- When open standard pack, only choose one card to be Enhanced and m_lucky
-- order of the card in the pack is picked randomly
function Card:open()
    if self.ability.set == "Booster" then
        stop_use()
        G.STATE_COMPLETE = false 
        self.opening = true

        if not self.config.center.discovered then
            discover_card(self.config.center)
        end
        self.states.hover.can = false

        if self.ability.name:find('Arcana') then 
            G.STATE = G.STATES.TAROT_PACK
            G.GAME.pack_size = self.ability.extra
        elseif self.ability.name:find('Celestial') then
            G.STATE = G.STATES.PLANET_PACK
            G.GAME.pack_size = self.ability.extra
        elseif self.ability.name:find('Spectral') then
            G.STATE = G.STATES.SPECTRAL_PACK
            G.GAME.pack_size = self.ability.extra
        elseif self.ability.name:find('Standard') then
            G.STATE = G.STATES.STANDARD_PACK
            G.GAME.pack_size = self.ability.extra
        elseif self.ability.name:find('Buffoon') then
            G.STATE = G.STATES.BUFFOON_PACK
            G.GAME.pack_size = self.ability.extra
        end

        G.GAME.pack_choices = self.config.center.config.choose or 1

        if self.cost > 0 then 
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                inc_career_stat('c_shop_dollars_spent', self.cost)
                self:juice_up()
            return true end }))
            ease_dollars(-self.cost) 
        else
            delay(0.2)
        end

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            self:explode()
            local pack_cards = {}

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                local _size = self.ability.extra

                local enhanced_card_position = math.random(1, _size)
                for i = 1, _size do
                    local card = nil
                    if self.ability.name:find('Arcana') then 
                        if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
                            card = create_card("Spectral", G.pack_cards, nil, nil, true, true, nil, 'ar2')
                        else
                            card = create_card("Tarot", G.pack_cards, nil, nil, true, true, nil, 'ar1')
                        end
                    elseif self.ability.name:find('Celestial') then
                        if G.GAME.used_vouchers.v_telescope and i == 1 then
                            local _planet, _hand, _tally = nil, nil, 0
                            for k, v in ipairs(G.handlist) do
                                if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                                    _hand = v
                                    _tally = G.GAME.hands[v].played
                                end
                            end
                            if _hand then
                                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                    if v.config.hand_type == _hand then
                                        _planet = v.key
                                    end
                                end
                            end
                            card = create_card("Planet", G.pack_cards, nil, nil, true, true, _planet, 'pl1')
                        else
                            card = create_card("Planet", G.pack_cards, nil, nil, true, true, nil, 'pl1')
                        end
                    elseif self.ability.name:find('Spectral') then
                        card = create_card("Spectral", G.pack_cards, nil, nil, true, true, nil, 'spe')
                    elseif self.ability.name:find('Standard') then
                        if i == enhanced_card_position then
                            card = create_card("Enhanced", G.pack_cards, nil, nil, nil, true, nil, 'sta')
                        else
                            card = create_card("Base", G.pack_cards, nil, nil, nil, true, nil, 'sta')
                        end
                        local edition_rate = 2
                        local edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true)
                        card:set_edition(edition)
                        local seal_rate = 10
                        local seal_poll = pseudorandom(pseudoseed('stdseal'..G.GAME.round_resets.ante))
                        if seal_poll > 1 - 0.02 * seal_rate then
                            local seal_type = pseudorandom(pseudoseed('stdsealtype'..G.GAME.round_resets.ante))
                            if seal_type > 0.75 then 
                                card:set_seal('Red')
                            elseif seal_type > 0.5 then 
                                card:set_seal('Blue')
                            elseif seal_type > 0.25 then 
                                card:set_seal('Gold')
                            else 
                                card:set_seal('Purple')
                            end
                        end
                    elseif self.ability.name:find('Buffoon') then
                        card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, 'buf')
                    end
                    card.T.x = self.T.x
                    card.T.y = self.T.y
                    card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5 * G.SETTINGS.GAMESPEED)
                    pack_cards[i] = card
                end
                return true
            end}))

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                if G.pack_cards then 
                    if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
                        for k, v in ipairs(pack_cards) do
                            G.pack_cards:emplace(v)
                        end
                        return true
                    end
                end
            end}))

            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({open_booster = true, card = self})
            end

            if G.GAME.modifiers.inflation then 
                G.GAME.inflation = G.GAME.inflation + 1
                G.E_MANAGER:add_event(Event({func = function()
                    for k, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                    return true end }))
            end

            return true end }))
    end
end



----------------------------------------------
------------MOD CODE END----------------------