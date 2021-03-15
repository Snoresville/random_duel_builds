-- Replace hero skills with a randomly generated duel build
ListenToGameEvent("npc_first_spawn",function(event)
    if IsClient() then return end

	local hero = EntIndexToHScript(event.entindex)
	if (not hero:IsRealHero()) then return end
	
    hero:DuelBuildInit()
end, self)