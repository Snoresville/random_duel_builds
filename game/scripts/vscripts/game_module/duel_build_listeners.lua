-- Replace hero skills with a randomly generated duel build
ListenToGameEvent("npc_first_spawn",function(event)
    if IsClient() then return end

	local hero = EntIndexToHScript(event.entindex)
	if (not hero:IsRealHero()) then return end
	
    hero:DuelBuildInit()
end, self)

ListenToGameEvent("game_rules_state_change", function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
        SetupAbilityPool()
	end
end, self)