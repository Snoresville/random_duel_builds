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

ListenToGameEvent("entity_killed", function(keys)
	-- for k,v in pairs(keys) do	print("entity_killed",k,v) end
	local attackerUnit = keys.entindex_attacker and EntIndexToHScript(keys.entindex_attacker)
	local killedUnit = keys.entindex_killed and EntIndexToHScript(keys.entindex_killed)
	local damagebits = keys.damagebits -- This might always be 0 and therefore useless

	if (killedUnit and killedUnit:IsRealHero()) then
		local streak = PlayerResource:GetStreak(attackerUnit:GetPlayerOwnerID())
		local multipleKillCount = attackerUnit.GetMultipleKillCount and attackerUnit:GetMultipleKillCount() or 0
		print("kill streak:", streak)
		print("multiple kill count", attackerUnit.GetMultipleKillCount and attackerUnit:GetMultipleKillCount() or 0)
		
		if streak >= 10 then
			for i = 2, 5 do
				StopGlobalSound("truth"..i)
			end
			EmitGlobalSound("coalescence")
		elseif multipleKillCount > 1 then
			for i = 2, 5 do
				StopGlobalSound("truth"..i)
			end
			EmitGlobalSound("truth"..math.min(multipleKillCount))
		end
	end

end, nil)
