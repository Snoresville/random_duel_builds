function CDOTA_BaseNPC:DuelBuildInit()
    local ultimate = self:GetAbilityByIndex(5)
    self:RemoveAbilityByHandle(ultimate)
    self:AddAbility("legion_commander_duel")


end