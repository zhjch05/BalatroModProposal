--- STEAMODDED HEADER
--- MOD_NAME: Hide
--- MOD_ID: hide
--- MOD_AUTHOR: [???]
--- MOD_DESCRIPTION: ???

----------------------------------------------
------------MOD CODE -------------------------

-- Hide Steam Mods MODS button
local create_UIBox_main_menu_buttonsRef = create_UIBox_main_menu_buttons
function create_UIBox_main_menu_buttons()
	local menu = create_UIBox_main_menu_buttonsRef()
	table.remove(menu.nodes[1].nodes[1].nodes, #menu.nodes[1].nodes[1].nodes)
	return(menu)
end

-- Hide Seed within run
local Orginal_create_UIBox_generic_options = create_UIBox_generic_options
function create_UIBox_generic_options(args)
  if  #args==0 and args.contents and #args.contents>=2 and G.STAGE == G.STAGES.RUN and not G.GAME.won then
    table.remove(args.contents, 2)
  end
  return Orginal_create_UIBox_generic_options(args)
end

----------------------------------------------
------------MOD CODE END----------------------