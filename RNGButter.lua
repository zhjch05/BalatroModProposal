--- STEAMODDED HEADER
--- MOD_NAME: RNG Butter v1.0.0.
--- MOD_ID: RNGButter
--- MOD_AUTHOR: [Kusoro]
--- MOD_DESCRIPTION: A mod that tilts RNG somewhat in player's favour: synergistic Jokers are more likely to appear depending on what you already have and done. Semi-compatible with Joker mods (mod Jokers won't be manipulated but they will still exist).

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.RNGButter()

	local spr_rngblucky = SMODS.Sprite:new("rngblucky", SMODS.findModByID('RNGButter').path, "b_rngblucky.png", 71, 95, "asset_atli")
	local spr_rngbunlucky = SMODS.Sprite:new("rngbunlucky", SMODS.findModByID('RNGButter').path, "b_rngbunlucky.png", 71, 95, "asset_atli")

	spr_rngblucky:register()
	spr_rngbunlucky:register()

	local lucky_def = {
	["name"]="Lucky Deck",
	["text"]={[1]="You feel {C:blue}blessed{}"}
	}
	local unlucky_def = {
	["name"]="Unlucky Deck",
	["text"]={[1]="You feel {C:red}cursed...{}"}
	}
	local luckydeck = SMODS.Deck:new("Lucky Deck", "rngblucky", {atlas = 'rngblucky', rngblucky = true}, {x = 0, y = 0}, lucky_def)
	local unluckydeck = SMODS.Deck:new("Unlucky Deck", "rngbunlucky", {atlas = 'rngbunlucky', rngbunlucky = true}, {x = 0, y = 0}, unlucky_def)

	luckydeck:register()
	unluckydeck:register()
end

--Injection into Game.init_game_object function
--Creates a bunch of new fields inside game object necessary for the mod
--Does this work with saving? One would hope, I really don't want to find out that this mod makes saves incompatible with unmodded Balatro
--Probably makes this mod highly incompatible with some other mods
--I tried not to make it so but who knows honestly
--I really am not a programmer I've no clue what I'm doing
local Game_init_game_object = Game.init_game_object
function Game.init_game_object(self)
	local game_object = Game_init_game_object(self)

	game_object.ksr_seen_jokers = {} -- < {string = number} jokers that have been in the shop this run
	game_object.ksr_temperature = G.SETTINGS.KSR_LUCK or 100000 -- < closer to zero means more extreme nudging, larger means closer to uniform distribution (ie vanilla behaviour)
	ksr_init_joker_scores()

	return game_object
end

--Initialization function for G.P_CENTERS side extra fields
--All scores are initialized at 1
--All tags are initialized as an empty array
--Should hopefully make it baseline compatible with joker mods that don't mess around with get_current_pool and create_card
function ksr_init_joker_scores()
	for k, v in pairs(G.P_CENTERS) do
		if v.set == 'Joker' then
			v.config.ksr_score = 1
			v.config.ksr_tags = {}
		end
	end
	--hhhhhhhhere we goooooooooooooooooooooooooooooooooooooooooooooooo
	G.P_CENTERS.j_joker.config.ksr_tags = {'Mult', 'Early Get'}
	G.P_CENTERS.j_greedy_joker.config.ksr_tags = {'On-hand', 'Mult', 'Diamonds'}
	G.P_CENTERS.j_lusty_joker.config.ksr_tags = {'On-hand', 'Mult', 'Hearts'}
	G.P_CENTERS.j_wrathful_joker.config.ksr_tags = {'On-hand', 'Mult', 'Spades'}
	G.P_CENTERS.j_gluttenous_joker.config.ksr_tags = {'On-hand', 'Mult', 'Clubs'}
	G.P_CENTERS.j_jolly.config.ksr_tags = {'Mult', 'Pair'}
	G.P_CENTERS.j_zany.config.ksr_tags = {'Mult', 'Three of a Kind'}
	G.P_CENTERS.j_mad.config.ksr_tags = {'Mult', 'Four of a Kind'}
	G.P_CENTERS.j_crazy.config.ksr_tags = {'Mult', 'Straight'}
	G.P_CENTERS.j_droll.config.ksr_tags = {'Mult', 'Flush'}
	G.P_CENTERS.j_sly.config.ksr_tags = {'Chips', 'Pair'}
	G.P_CENTERS.j_wily.config.ksr_tags = {'Chips', 'Three of a Kind'}
	G.P_CENTERS.j_clever.config.ksr_tags = {'Chips', 'Four of a Kind'}
	G.P_CENTERS.j_devious.config.ksr_tags = {'Chips', 'Straight'}
	G.P_CENTERS.j_crafty.config.ksr_tags = {'Chips', 'Flush'}
	G.P_CENTERS.j_half.config.ksr_tags = {'Mult', 'N_Flush', 'N_Straight', 'N_Four of a Kind'}
	G.P_CENTERS.j_stencil.config.ksr_tags = {'xN'}
	G.P_CENTERS.j_four_fingers.config.ksr_tags = {'!_Straight', 'Flush'}
	G.P_CENTERS.j_mime.config.ksr_tags = {'Retrigger', 'In-hand'}
	G.P_CENTERS.j_credit_card.config.ksr_tags = {'Money', 'Early Get'}
	G.P_CENTERS.j_ceremonial.config.ksr_tags = {'Mult', '!_Sell Value'}
	G.P_CENTERS.j_banner.config.ksr_tags = {'Chips', 'Discards'}
	G.P_CENTERS.j_mystic_summit.config.ksr_tags = {'Mult', 'N_Discards'}
	G.P_CENTERS.j_marble.config.ksr_tags = {'Enhancement', 'Stone'}
	G.P_CENTERS.j_loyalty_card.config.ksr_tags = {'xN', 'Hands'}
	G.P_CENTERS.j_8_ball.config.ksr_tags = {'Planets', '8s'}
	G.P_CENTERS.j_misprint.config.ksr_tags = {'Mult', 'Early Get'}
	G.P_CENTERS.j_dusk.config.ksr_tags = {'Retrigger', 'On-hand', 'Final Hand'}
	G.P_CENTERS.j_raised_fist.config.ksr_tags = {'Mult'}
	G.P_CENTERS.j_chaos.config.ksr_tags = {'Reroll'}
	G.P_CENTERS.j_fibonacci.config.ksr_tags = {'Mult', 'On-hand', '?_?_Aces', '?_?_2s', '?_?_3s', '?_?_5s', '?_?_8s'}
	G.P_CENTERS.j_steel_joker.config.ksr_tags = {'Enhancement', 'Steel'}
	G.P_CENTERS.j_scary_face.config.ksr_tags = {'Chips', 'Faces', 'On-hand'}
	G.P_CENTERS.j_abstract.config.ksr_tags = {'Mult'}
	G.P_CENTERS.j_delayed_grat.config.ksr_tags = {'Money', 'N_Discard', 'Early Get'}
	G.P_CENTERS.j_hack.config.ksr_tags = {'Retrigger', 'On-hand', '?_?_2s', '?_?_3s', '?_?_4s', '?_?_5s'}
	G.P_CENTERS.j_pareidolia.config.ksr_tags = {'!_Faces', 'Flush'}
	G.P_CENTERS.j_gros_michel.config.ksr_tags = {'Mult', 'RNG'}
	G.P_CENTERS.j_even_steven.config.ksr_tags = {'Mult', '?_?_2s', '?_?_4s', '?_?_6s', '?_?_8s', '?_?_10s'}
	G.P_CENTERS.j_odd_todd.config.ksr_tags = {'Chips', '?_?_Aces', '?_?_9s', '?_?_7s', '?_?_5s', '?_?_3s'}
	G.P_CENTERS.j_scholar.config.ksr_tags = {'!_Aces', '?_Chips', '?_Mult', 'On-hand'}
	G.P_CENTERS.j_business.config.ksr_tags = {'Faces', 'RNG', 'Money'}
	G.P_CENTERS.j_supernova.config.ksr_tags = {'Mult', 'Most Played Hand'}
	G.P_CENTERS.j_ride_the_bus.config.ksr_tags = {'Mult', 'N_Faces'}
	G.P_CENTERS.j_space.config.ksr_tags = {'!_RNG'}
	G.P_CENTERS.j_egg.config.ksr_tags = {'Sell Value', 'Early Get'}
	G.P_CENTERS.j_burglar.config.ksr_tags = {'Hands', 'N_Discards'}
	G.P_CENTERS.j_blackboard.config.ksr_tags = {'xN', 'Spades', 'Clubs'}
	G.P_CENTERS.j_runner.config.ksr_tags = {'Chips', 'Straight'}
	G.P_CENTERS.j_ice_cream.config.ksr_tags = {'Chips', 'Early Get'}
	G.P_CENTERS.j_dna.config.ksr_tags = {'Card Gen', '!_Pogs'}
	G.P_CENTERS.j_splash.config.ksr_tags = {'On-hand'}
	G.P_CENTERS.j_blue_joker.config.ksr_tags = {'Chips', 'Deck Size'}
	G.P_CENTERS.j_sixth_sense.config.ksr_tags = {'!_6s'}
	G.P_CENTERS.j_constellation.config.ksr_tags = {'!_Planet', 'xN'}
	G.P_CENTERS.j_hiker.config.ksr_tags = {'Chips', 'Early Get'}
	G.P_CENTERS.j_faceless.config.ksr_tags = {'Money', 'Faces'}
	G.P_CENTERS.j_green_joker.config.ksr_tags = {'Mult', '!_N_Discards', 'Early Get'}
	G.P_CENTERS.j_superposition.config.ksr_tags = {'Aces', 'Straight', 'Tarot'}
	G.P_CENTERS.j_todo_list.config.ksr_tags = {'Money'}
	G.P_CENTERS.j_cavendish.config.ksr_tags = {'xN', 'RNG', 'Late Get'}
	G.P_CENTERS.j_card_sharp.config.ksr_tags = {'xN', 'Late Get'}
	G.P_CENTERS.j_red_card.config.ksr_tags = {'Mult', 'Money'}
	G.P_CENTERS.j_madness.config.ksr_tags = {'xN', 'Early Get'}
	G.P_CENTERS.j_square.config.ksr_tags = {'Chips', 'N_Flush', 'N_Straight', 'N_Three of a Kind', 'N_Pair', 'Four of a Kind', 'Two-Pair'}
	G.P_CENTERS.j_seance.config.ksr_tags = {'?_Straight', '?_Flush'}
	G.P_CENTERS.j_riff_raff.config.ksr_tags = {'Card Gen', 'Early Get'}
	G.P_CENTERS.j_vampire.config.ksr_tags = {'!_Enhancement', 'Early Get'}
	G.P_CENTERS.j_shortcut.config.ksr_tags = {'!_Straight', 'Early Get'}
	G.P_CENTERS.j_hologram.config.ksr_tags = {'xN'}
	G.P_CENTERS.j_vagabond.config.ksr_tags = {'Money', 'Tarot'}
	G.P_CENTERS.j_baron.config.ksr_tags = {'!_Kings', 'xN', '!_In-hand'}
	G.P_CENTERS.j_cloud_9.config.ksr_tags = {'Money', 'Early Get', '9s'}
	G.P_CENTERS.j_rocket.config.ksr_tags = {'Money', 'Early Get'}
	G.P_CENTERS.j_obelisk.config.ksr_tags = {'xN', '!_Late Get'}
	G.P_CENTERS.j_midas_mask.config.ksr_tags = {'!_Faces', 'Enhancement', 'On-hand'}
	G.P_CENTERS.j_luchador.config.ksr_tags = {}
	G.P_CENTERS.j_photograph.config.ksr_tags = {'Faces', 'xN', 'On-hand'}
	G.P_CENTERS.j_gift.config.ksr_tags = {'Sell Value'}
	G.P_CENTERS.j_turtle_bean.config.ksr_tags = {'Hand Size', 'Late Get'}
	G.P_CENTERS.j_erosion.config.ksr_tags = {'Mult', 'N_Deck Size'}
	G.P_CENTERS.j_reserved_parking.config.ksr_tags = {'Faces', 'In-hand', 'RNG', 'Money'}
	G.P_CENTERS.j_mail.config.ksr_tags = {'Money'}
	G.P_CENTERS.j_to_the_moon.config.ksr_tags = {'Money'}
	G.P_CENTERS.j_hallucination.config.ksr_tags = {'RNG', 'Tarot'}
	G.P_CENTERS.j_fortune_teller.config.ksr_tags = {'Mult', 'Tarot'}
	G.P_CENTERS.j_juggler.config.ksr_tags = {'Hand Size'}
	G.P_CENTERS.j_drunkard.config.ksr_tags = {'Discards'}
	G.P_CENTERS.j_stone.config.ksr_tags = {'Chips', '!_Stone'}
	G.P_CENTERS.j_golden.config.ksr_tags = {'Money', 'Early Get'}
	G.P_CENTERS.j_lucky_cat.config.ksr_tags = {'xN', 'RNG'}
	G.P_CENTERS.j_baseball.config.ksr_tags = {'xN', 'Uncommon Driven', 'Late Get'}
	G.P_CENTERS.j_bull.config.ksr_tags = {'N_Money', 'Late Get'}
	G.P_CENTERS.j_diet_cola.config.ksr_tags = {}
	G.P_CENTERS.j_trading.config.ksr_tags = {'Money'}
	G.P_CENTERS.j_flash.config.ksr_tags = {'Mult', 'Reroll'}
	G.P_CENTERS.j_popcorn.config.ksr_tags = {'Mult', 'Early Get'}
	G.P_CENTERS.j_trousers.config.ksr_tags = {'Mult', 'On-hand', 'Two-Pair'}
	G.P_CENTERS.j_ancient.config.ksr_tags = {'xN', 'On-hand'}
	G.P_CENTERS.j_ramen.config.ksr_tags = {'xN', 'N_Discards'}
	G.P_CENTERS.j_walkie_talkie.config.ksr_tags = {'?_Mult', '?_Chips', '10s', '4s'}
	G.P_CENTERS.j_selzer.config.ksr_tags = {'Retrigger'}
	G.P_CENTERS.j_castle.config.ksr_tags = {'Chips', 'Early Get'}
	G.P_CENTERS.j_smiley.config.ksr_tags = {'Mult', '!_Faces', 'On-hand'}
	G.P_CENTERS.j_campfire.config.ksr_tags = {'xN', 'Late Get'}
	G.P_CENTERS.j_ticket.config.ksr_tags = {'Enhancement', 'Gold', 'Money', 'On-hand'}
	G.P_CENTERS.j_mr_bones.config.ksr_tags = {}
	G.P_CENTERS.j_acrobat.config.ksr_tags = {'xN', 'Final Hand', 'Late Get'}
	G.P_CENTERS.j_sock_and_buskin.config.ksr_tags = {'Retrigger', 'On-hand', 'Faces'}
	G.P_CENTERS.j_swashbuckler.config.ksr_tags = {'Mult'}
	G.P_CENTERS.j_troubadour.config.ksr_tags = {'Hand Size', 'N_Hands'}
	G.P_CENTERS.j_certificate.config.ksr_tags = {'Card Gen'}
	G.P_CENTERS.j_smeared.config.ksr_tags = {'Flush'}
	G.P_CENTERS.j_throwback.config.ksr_tags = {'xN', 'Early Get'}
	G.P_CENTERS.j_hanging_chad.config.ksr_tags = {'Retrigger'}
	G.P_CENTERS.j_rough_gem.config.ksr_tags = {'Money', 'On-hand', 'Diamonds'}
	G.P_CENTERS.j_bloodstone.config.ksr_tags = {'xN', 'On-hand', '!_RNG', 'Hearts'}
	G.P_CENTERS.j_arrowhead.config.ksr_tags = {'Chips', 'On-hand', 'Spades'}
	G.P_CENTERS.j_onyx_agate.config.ksr_tags = {'Mult', 'On-hand', 'Clubs'}
	G.P_CENTERS.j_glass.config.ksr_tags = {'xN', 'RNG', 'Enhancement', 'Glass'}
	G.P_CENTERS.j_ring_master.config.ksr_tags = {'Dupes'}
	G.P_CENTERS.j_flower_pot.config.ksr_tags = {'xN', 'N_Flush'}
	G.P_CENTERS.j_blueprint.config.ksr_tags = {'Pogs', 'Late Get'}
	G.P_CENTERS.j_wee.config.ksr_tags = {'Chips', '2s'}
	G.P_CENTERS.j_merry_andy.config.ksr_tags = {'Hand Size', 'Discards'}
	G.P_CENTERS.j_oops.config.ksr_tags = {'!_RNG'}
	G.P_CENTERS.j_idol.config.ksr_tags = {'xN', 'On-hand'}
	G.P_CENTERS.j_seeing_double.config.ksr_tags = {'xN', 'N_Flush', 'Clubs'}
	G.P_CENTERS.j_matador.config.ksr_tags = {'Money'}
	G.P_CENTERS.j_hit_the_road.config.ksr_tags = {'xN', 'Jacks', 'Discards'}
	G.P_CENTERS.j_duo.config.ksr_tags = {'xN', 'Pair', 'Two-Pair', 'Three of a Kind', 'Four of a Kind', 'Full House'}
	G.P_CENTERS.j_trio.config.ksr_tags = {'xN', 'Three of a Kind', 'Four of a Kind', 'Full House'}
	G.P_CENTERS.j_family.config.ksr_tags = {'xN', 'Four of a Kind'}
	G.P_CENTERS.j_order.config.ksr_tags = {'Mult', 'Straight'}
	G.P_CENTERS.j_tribe.config.ksr_tags = {'Mult', 'Flush'}
	G.P_CENTERS.j_stuntman.config.ksr_tags = {'!_Chips', '!_Hand Size'}
	G.P_CENTERS.j_invisible.config.ksr_tags = {'!_Pogs'}
	G.P_CENTERS.j_brainstorm.config.ksr_tags = {'Pogs', 'Late Get'}
	G.P_CENTERS.j_satellite.config.ksr_tags = {'Planet', 'Money'}
	G.P_CENTERS.j_shoot_the_moon.config.ksr_tags = {'Mult', 'In-hand', 'Queens'}
	G.P_CENTERS.j_drivers_license.config.ksr_tags = {'xN', 'Enhancements', 'Late Get'}
	G.P_CENTERS.j_cartomancer.config.ksr_tags = {'Tarot'}
	G.P_CENTERS.j_astronomer.config.ksr_tags = {'Planet', 'Packs'}
	G.P_CENTERS.j_burnt.config.ksr_tags = {'Discards', 'Early Get'}
	G.P_CENTERS.j_bootstraps.config.ksr_tags = {'Mult', 'N_Money'}
	G.P_CENTERS.j_caino.config.ksr_tags = {'xN', '!_Faces'}
	G.P_CENTERS.j_triboulet.config.ksr_tags = {'xN', '!_On-hand', '!_Kings', '!_Queens'}
	G.P_CENTERS.j_yorick.config.ksr_tags = {'xN', '!_Discards'}
	G.P_CENTERS.j_chicot.config.ksr_tags = {}
	G.P_CENTERS.j_perkeo.config.ksr_tags = {'!_Tarot', '!_Planet', 'Pogs'}
	--this took me approximately 5 hours

end

--Updates scores of the jokers in the pool random joker is drawn from based on the tags it has and whether it's been acquired in this run before
function ksr_update_joker_scores(current_pool)
	local score_table = ksr_get_jokers_score_modifiers()

	for k, v in pairs(current_pool) do
		local new_score = 1

		for kk, vv in pairs(G.P_CENTERS[v].config.ksr_tags) do
			local tag, multi = ksr_check_tag_for_prefixes(vv, 1)
			new_score = ksr_calculate_score(new_score, tag, multi, score_table, G.P_CENTERS[v])
		end
		for kk, vv in pairs(G.GAME.ksr_seen_jokers) do
			if kk == v then
				new_score = new_score - vv
			end
		end
		G.P_CENTERS[v].config.ksr_score = ksr_clamp(new_score, -10, 10)
	end
end

--Calculates joker score based on the multiplier from the tag's prefixes and tag's meaning
--Highly cursed, chosen with no rigor and subject to change after testing/feedback
function ksr_calculate_score(score, tag, multi, score_mods, card)

	--basic tags
	if tag == 'Mult' then
		if score_mods['Chips'] then
			score = score + multi * score_mods['Chips']
		end
		if score_mods['xN'] then
			score = score + multi * score_mods['xN']
		end
		if score_mods['Mult'] then
			score = score - multi * score_mods['Mult']
		end
	elseif tag == 'Chips' then
		if score_mods['Chips'] then
			score = score - multi * score_mods['Chips']
		end
		if score_mods['xN'] then
			score = score + multi * score_mods['xN']
		end
		if score_mods['Mult'] then
			score = score + multi * score_mods['Mult']
		end
	elseif tag == 'xN' then
		if score_mods['Chips'] then
			score = score + 0.5 * multi * score_mods['Chips']
		end
		if score_mods['xN'] then
			score = score - multi * score_mods['xN']
		end
		if score_mods['Mult'] then
			score = score + 0.5 * multi * score_mods['Mult']
		end

	--type tags
	elseif tag == 'On-hand' then
		if score_mods['On-hand'] then
			score = score + 0.5 * multi * score_mods['On-hand']
		end
		if score_mods['Retrigger'] then
			score = score + multi * score_mods['Retrigger']
		end
	elseif tag == 'In-hand' then
		if score_mods['In-hand'] then
			score = score + 0.5 * multi * score_mods['In-hand']
		end
		if score_mods['Retrigger'] then
			score = score + multi * score_mods['Retrigger']
		end

	--suits tags
	elseif tag == 'Diamonds' then
		if score_mods['Diamonds'] then
			score = score + multi * score_mods['Diamonds']
		end
	elseif tag == 'Hearts' then
		if score_mods['Hearts'] then
			score = score + multi * score_mods['Hearts']
		end
	elseif tag == 'Spades' then
		if score_mods['Spades'] then
			score = score + multi * score_mods['Spades']
		end
	elseif tag == 'Clubs' then
		if score_mods['Clubs'] then
			score = score + multi * score_mods['Clubs']
		end

	--run duration tags
	elseif tag == 'Early Get' then
		score = score + (3 - (G.GAME.round_resets.ante or 1)) * multi
		if score_mods['Early Get'] then
			score = score - multi * score_mods['Early Get']
		end

	elseif tag == 'Late Get' then
		score = ksr_clamp(score - (5 - (G.GAME.round_resets.ante or 1)), -5, 3) * multi
		if score_mods['Late Get'] then
			score = score - multi * score_mods['Late Get']
		end


	--score hand tags
	elseif tag == 'Pair' then
		if score_mods['Pair'] then
			score = score + multi * score_mods['Pair']
		end
		if score_mods['Three of a Kind'] then
			score = score + multi * 0.25 * score_mods['Three of a Kind']
		end
		if score_mods['Four of a Kind'] then
			score = score + multi * 0.25 * score_mods['Four of a Kind']
		end
		if score_mods['Full House'] then
			score = score + multi * 0.25 * score_mods['Full House']
		end
		if score_mods['Straight'] then
			score = score - multi * score_mods['Straight']
		end
		score = score + 0.1 * multi * G.GAME.hands['Pair'].played
	elseif tag == 'Two-Pair' then
		if score_mods['Two-Pair'] then
			score = score + multi * score_mods['Two-Pair']
		end
		if score_mods['Pair'] then
			score = score + multi * 0.25 * score_mods['Pair']
		end
		if score_mods['Three of a Kind'] then
			score = score - multi * 0.5 * score_mods['Three of a Kind']
		end
		if score_mods['Four of a Kind'] then
			score = score + multi * 0.5 * score_mods['Four of a Kind']
		end
		if score_mods['Full House'] then
			score = score + multi * 0.5 * score_mods['Full House']
		end
		if score_mods['Straight'] then
			score = score - multi * score_mods['Straight']
		end
		score = score + 0.1 * multi * G.GAME.hands['Two Pair'].played
	elseif tag == 'Three of a Kind' then
		if score_mods['Three of a Kind'] then
			score = score + multi * score_mods['Three of a Kind']
		end
		if score_mods['Four of a Kind'] then
			score = score + 0.5 * multi * score_mods['Four of a Kind']
		end
		if score_mods['Full House'] then
			score = score + 0.5 * multi * score_mods['Full House']
		end
		if score_mods['Flush'] then
			score = score - 0.1 * multi * score_mods['Flush']
		end
		if score_mods['Straight'] then
			score = score - multi * score_mods['Straight']
		end
		score = score + 0.1 * multi * G.GAME.hands['Three of a Kind'].played
	elseif tag == 'Full House' then
		if score_mods['Full House'] then
			score = score + multi * score_mods['Full House']
		end
		if score_mods['Pair'] then
			score = score + 0.2 * multi * score_mods['Pair']
		end
		if score_mods['Two-Pair'] then
			score = score + 0.2 * multi * score_mods['Two-Pair']
		end
		if score_mods['Three of a Kind'] then
			score = score + 0.2 * multi * score_mods['Three of a Kind']
		end
		if score_mods['Four of a Kind'] then
			score = score - 0.5 * multi * score_mods['Four of a Kind']
		end
		if score_mods['Straight'] then
			score = score - multi * score_mods['Straight']
		end
		score = score + 0.1 * multi * G.GAME.hands['Full House'].played
	elseif tag == 'Four of a Kind' then
		if score_mods['Four of a Kind'] then
			score = score + multi * score_mods['Four of a Kind']
		end
		if score_mods['Flush'] then
			score = score - 0.2 * multi * score_mods['Flush']
		end
		if score_mods['Straight'] then
			score = score - multi * score_mods['Straight']
		end
		score = score + 0.1 * multi * G.GAME.hands['Four of a Kind'].played
	elseif tag == 'Straight' then
		if score_mods['Straight'] then
			score = score + 3 * multi * score_mods['Straight']
		end
		if score_mods['Four of a Kind'] then
			score = score - multi * score_mods['Four of a Kind']
		end
		if score_mods['Three of a Kind'] then
			score = score - multi * score_mods['Three of a Kind']
		end
		if score_mods['Two-Pair'] then
			score = score - multi * score_mods['Two-Pair']
		end
		if score_mods['Full House'] then
			score = score - multi * score_mods['Full House']
		end
		if score_mods['Pair'] then
			score = score - multi * score_mods['Pair']
		end
		score = score + 0.1 * multi * G.GAME.hands['Straight'].played
	elseif tag == 'Flush' then
		if score_mods['Flush'] then
			score = score + multi * score_mods['Flush']
		end
		score = score + 0.1 * multi * G.GAME.hands['Flush'].played

	--rank tags
	elseif tag == '2s' then
		if score_mods['2s'] then
			score = score + multi * score_mods['2s']
		end
	elseif tag == '3s' then
		if score_mods['3s'] then
			score = score + multi * score_mods['3s']
		end
	elseif tag == '4s' then
		if score_mods['4s'] then
			score = score + multi * score_mods['4s']
		end
	elseif tag == '5s' then
		if score_mods['5s'] then
			score = score + multi * score_mods['5s']
		end
	elseif tag == '6s' then
		if score_mods['6s'] then
			score = score + multi * score_mods['6s']
		end
	elseif tag == '7s' then
		if score_mods['7s'] then
			score = score + multi * score_mods['7s']
		end
	elseif tag == '8s' then
		if score_mods['8s'] then
			score = score + multi * score_mods['8s']
		end
	elseif tag == '9s' then
		if score_mods['9s'] then
			score = score + multi * score_mods['9s']
		end
	elseif tag == '10s' then
		if score_mods['10s'] then
			score = score + multi * score_mods['10s']
		end
	elseif tag == 'Jacks' then
		if score_mods['Jacks'] then
			score = score + multi * score_mods['Jacks']
		end
	elseif tag == 'Queens' then
		if score_mods['Queens'] then
			score = score + multi * score_mods['Queens']
		end
	elseif tag == 'Kings' then
		if score_mods['Kings'] then
			score = score + multi * score_mods['Kings']
		end
	elseif tag == 'Aces' then
		if score_mods['Aces'] then
			score = score + multi * score_mods['Aces']
		end

	--weird tags
	elseif tag == 'Retrigger' then
		if score_mods['On-hand'] then
			score = score + 0.25 * multi * score_mods['On-hand']
		end
		if score_mods['In-hand'] then
			score = score + 0.25 * multi * score_mods['In-hand']
		end
	elseif tag == 'Sell Value' then
		if score_mods['Sell Value'] then
			score = score + multi * score_mods['Sell Value']
		end
	elseif tag == 'Money' then
		if score_mods['Money'] then
			score = score - multi * score_mods['Money']
		end
		score = score - 0.01 * multi * G.GAME.dollars
	elseif tag == 'Discards' then
		if score_mods['Discards'] then
			score = score - multi * score_mods['Discards']
		end
	elseif tag == 'Hands' then
		if score_mods['Hands'] then
			score = score - multi * score_mods['Hands']
		end
	elseif tag == 'Hand Size' then
		if score_mods['Hand Size'] then
			score = score - multi * score_mods['Hand Size']
		end
	elseif tag == 'Reroll' then

	elseif tag == 'RNG' then
		if score_mods['RNG'] then
			score = score + multi * score_mods['RNG']
		end
	elseif tag == 'Enhancement' then
		if score_mods['Enhancement'] then
			score = score + multi * score_mods['Enhancement']
		end
	elseif tag == 'Planet' then
		if score_mods['Planet'] then
			score = score + multi * score_mods['Planet']
		end
	elseif tag == 'Tarot' then
		if score_mods['Tarot'] then
			score = score + multi * score_mods['Tarot']
		end
	elseif tag == 'Packs' then
		if score_mods['Packs'] then
			score = score + multi * score_mods['Packs']
		end
	elseif tag == 'Most Played Hand' then
		local most_played = 0
		for k, v in pairs(G.GAME.hands) do
			if v.played and most_played < v.played then most_played = v.played end
		end
		score = score + multi * most_played * 0.05
	elseif tag == 'Uncommon Driven' then
		local uncommon_amt = 0
		if G.jokers.cards then
			for k, v in pairs(G.jokers.cards) do
				if v.config.center.rarity == 2 then uncommon_amt = uncommon_amt + 1 end
			end
		end
		score = score + 0.5 * multi * uncommon_amt
	elseif tag == 'Card Gen' then
		if score_mods['Card Gen'] then
			score = score + multi * score_mods['Card Gen']
		end
	elseif tag == 'Pogs' then
		if score_mods['Pogs'] then
			score = score + multi * score_mods['Pogs']
		end
	elseif tag == 'Faces' then
		if score_mods['Faces'] then
			score = score + 0.5 * multi * score_mods['Faces']
		end
	else end

	--cursed stuff to make it more likely that dupes appear if you have Showman
	for k, v in pairs(G.jokers.cards) do
		if v.config.center.key == 'j_ring_master' then
			for kk, vv in pairs(G.jokers.cards) do
				if vv.config.center.key == card.key and card.key ~= 'j_ring_master' then
					score = score + 6
					return score
				end
			end
		end
	end

	return score
end

--Creates a table of modifiers based on current jokers in hand
function ksr_get_jokers_score_modifiers()
	local score_table = {}

	if G.jokers.cards then
		for k, v in pairs(G.jokers.cards) do
			for kk, vv in pairs(v.config.center.config.ksr_tags) do
				local tag, multi = ksr_check_tag_for_prefixes(vv, 1)
				score_table[tag] = (score_table[tag] or 0) + (1 * multi)
			end
		end
	end

	return score_table
end

--Parses prefixes for tags and updates given multiplier
--Recursive so prefixes like N_!_ and such work as well
function ksr_check_tag_for_prefixes(tag, multi)
	if tag:sub(1,2) == 'N_' then
		tag = tag:sub(3)
		multi = multi * -1
		tag, multi = ksr_check_tag_for_prefixes(tag, multi)
		return tag, multi
	elseif tag:sub(1,2) == '!_' then
		tag = tag:sub(3)
		multi = multi * 2
		tag, multi = ksr_check_tag_for_prefixes(tag, multi)
		return tag, multi
	elseif tag:sub(1,2) == '?_' then
		tag = tag:sub(3)
		multi = multi * 0.5
		tag, multi = ksr_check_tag_for_prefixes(tag, multi)
		return tag, multi
	end
	return tag, multi
end

--Injection into CardArea.emplace method (cardarea.lua)
--Adds the jokers seen in shop and booster packs to the list of such jokers
local Cardareaemplace = CardArea.emplace
function CardArea.emplace(self, card, location, stay_flipped)
	Cardareaemplace(self, card, location, stay_flipped)
	if self == (G.shop_jokers or G.pack_cards) and card.config.center.key:sub(1,2) == 'j_' then
		G.GAME.ksr_seen_jokers[card.config.center.key] = (G.GAME.ksr_seen_jokers[card.config.center.key] or 0) + 1
	end
end

--Selects a card key from the pool via softmax over cards scores
function ksr_select_from_pool(pool, poolkey) -- {string}, string
	local cumul = 0
	local cutoff = 0
	local prob_table = {}
	local temperature = G.GAME.ksr_temperature_sp and G.GAME.ksr_temperature_sp or G.GAME.ksr_temperature
	local newpool = ksr_cleanse_pool(pool)
	local centerkey = 'j_joker'
	local roll = pseudorandom(poolkey)

	ksr_update_joker_scores(newpool)
	for k, v in pairs(newpool) do
		prob_table[v] = math.exp(G.P_CENTERS[v].config.ksr_score / temperature)
		cumul = cumul + prob_table[v]
	end
	for k, v in pairs(prob_table) do
		cutoff = cutoff + v
		if roll * cumul < cutoff then
			centerkey = k
			break
		end
	end

	return centerkey
end

--Takes in the pool string array and generates a new array without the 'UNAVAILABLE' entries
function ksr_cleanse_pool(pool)
	local t = {}

	for k,v in pairs(pool) do
		if v ~= 'UNAVAILABLE' then table.insert(t, v) end
	end

	return t
end

--Injection into create_card function (common_events.lua)
--If the type of the card to create is a random joker, get a forced key via probability table and run the vanilla function with it, otherwise just run vanilla function
local Createcard = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if _type == 'Joker' and not forced_key then forced_key = ksr_select_from_pool(get_current_pool(_type, _rarity, legendary, key_append)) end

	return Createcard(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end

--Injection into Back.apply_to_run (back.lua)
--Sets temperature appropriately in case player chooses the Lucky or the Unlucky deck
local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(self)
	Backapply_to_runRef(self)

	if self.effect.config.rngblucky then G.GAME.ksr_temperature_sp = 0.125 end
	if self.effect.config.rngbunlucky then G.GAME.ksr_temperature_sp = -0.125 end
end

--Injection into G.UIDEF.setting_tab (UI_definitions.lua)
--Adds a cycling toggle for luck in game options
local Guidefsettingstab = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
	local set_tab = Guidefsettingstab(tab)

	if tab == 'Game' then
		table.insert(set_tab.nodes, create_option_cycle({label = 'Luck',
														scale = 0.8,
														options = {'Very lucky!', 'Lucky', 'A bit lucky', 'Slight nudge', 'Vanilla'},
														opt_callback = 'ksr_set_luck',
														current_option = (G.SETTINGS.KSR_LUCK == 1 and 1 or
																		G.SETTINGS.KSR_LUCK == 2.5 and 2 or
																		G.SETTINGS.KSR_LUCK == 3.5 and 3 or
																		G.SETTINGS.KSR_LUCK == 5 and 4 or 5
																		)
														})
					)
	end

	return set_tab
end

--Callback for the cycling toggle
G.FUNCS.ksr_set_luck = function(args)
	if args.to_val == 'Very lucky!' then G.SETTINGS.KSR_LUCK = 1; G.GAME.ksr_temperature = 0.5
	elseif args.to_val == 'Lucky' then G.SETTINGS.KSR_LUCK = 2.5; G.GAME.ksr_temperature = 2.5
	elseif args.to_val == 'A bit lucky' then G.SETTINGS.KSR_LUCK = 3.5; G.GAME.ksr_temperature = 3.5
	elseif args.to_val == 'Slight nudge' then G.SETTINGS.KSR_LUCK = 5; G.GAME.ksr_temperature = 5
	elseif args.to_val == 'Vanilla' then G.SETTINGS.KSR_LUCK = 100000; G.GAME.ksr_temperature = 100000
	end
end

--no clamp in stdlib icant
function ksr_clamp(value, min, max)
	return math.min(math.max(value, min), max)
end

----------------------------------------------
------------MOD CODE END----------------------
