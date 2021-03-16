item_new_draft = class({})

function item_new_draft:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or not caster:IsRealHero() then return end 

    caster:EmitSound("DOTA_Item.Refresher.Activate")
    caster:SelectAbilities()

    local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:ReleaseParticleIndex(particle)

    self:SpendCharge()
end