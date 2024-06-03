--- STEAMODDED HEADER
--- MOD_NAME: Hide
--- MOD_ID: hide
--- MOD_AUTHOR: [???]
--- MOD_DESCRIPTION: ???

----------------------------------------------
------------MOD CODE -------------------------
local create_UIBox_main_menu_buttonsRef = create_UIBox_main_menu_buttons
function create_UIBox_main_menu_buttons()
	local menu = create_UIBox_main_menu_buttonsRef()
	table.remove(menu.nodes[1].nodes[1].nodes, #menu.nodes[1].nodes[1].nodes)
	menu.nodes[1].nodes[1].config = {align = "cm", padding = 0.15, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true}
	return(menu)
end

----------------------------------------------
------------MOD CODE END----------------------