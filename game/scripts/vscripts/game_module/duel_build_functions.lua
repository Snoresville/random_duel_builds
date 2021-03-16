function CDOTA_BaseNPC:DuelBuildInit()
    local ultimate = self:GetAbilityByIndex(5)
    self:RemoveAbilityByHandle(ultimate)
    self:AddAbility("legion_commander_duel")

    self:SelectAbilities()
end

function SetupAbilityPool()
    if BUTTINGS.DUEL_BUILD_PASSIVES == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_PASSIVES) end
    if BUTTINGS.DUEL_BUILD_MOVEMENT == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_MOVEMENT) end
    if BUTTINGS.DUEL_BUILD_DAMAGE_SCALING == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_DAMAGE_SCALING) end
    if BUTTINGS.DUEL_BUILD_ATTACK_MODS == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_ATTACK_MODS) end
    if BUTTINGS.DUEL_BUILD_DISABLE == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_DISABLE) end
    if BUTTINGS.DUEL_BUILD_BUFF == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_BUFF) end
    if BUTTINGS.DUEL_BUILD_DEBUFF == 1 then table.merge(DUEL_BUILD_FULL_ABILITY_LIST, DUEL_BUILD_DEBUFF) end
end

function CDOTA_BaseNPC:SelectAbilities()
    local ABILITY_LIST = table.copy(DUEL_BUILD_FULL_ABILITY_LIST)
    for i = 0, 4 do
        local selected_ability_index = math.random(#ABILITY_LIST)
        local selected_ability = #ABILITY_LIST == 0 and "legion_commander_duel" or table.remove(ABILITY_LIST, selected_ability_index)

        local ability_handle = self:GetAbilityByIndex(i)
        self:SetAbilityPoints(self:GetAbilityPoints() + ability_handle:GetLevel())
        self:RemoveAbilityByHandle(ability_handle)
        self:AddAbility(selected_ability)
    end
end