-- List of class names to give "Deathtower"
local buildings = {
	"npc_dota_tower",
	"ent_dota_fountain",
	"npc_dota_barracks",
	"npc_dota_fort",
	"npc_dota_filler",
	"npc_dota_roshan",
}

-- After game starts, all towers get deathtower
ListenToGameEvent("game_rules_state_change", function()
	if IsClient() then return end

	if (GameRules:State_Get()==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS) then
		for _,towerName in ipairs(buildings) do
			local tTowers = Entities:FindAllByClassname(towerName)
			for k, v in pairs(tTowers) do
				v:AddAbility("deathtower")
			end
		end
	end
end, nil)