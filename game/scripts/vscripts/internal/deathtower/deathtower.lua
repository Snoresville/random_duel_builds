-- Code courtesy of Snoresville.
-- originally used in dota_upgrades

deathtower = class({})

--               modifiername used below ,       filepath            , weird valve thing
LinkLuaModifier( "deathtowermodifier", "internal/deathtower/deathtower", LUA_MODIFIER_MOTION_NONE )
function deathtower:GetIntrinsicModifierName()
	return "deathtowermodifier"
end

function deathtower:Precache( context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
end

-------------------------------------------------------------------------------------------------------------------------------
-- everything down from here is a modifier. LinkLuaModifier adds it to the game, so the AddNewModifier(..) knows where to find it.



deathtowermodifier = class({})

function deathtowermodifier:GetTexture() return "item_mask_of_madness" end

function deathtowermodifier:IsPurgable() return false end
function deathtowermodifier:IsHidden() return false end
function deathtowermodifier:RemoveOnDeath() return false end

function deathtowermodifier:OnCreated( kv )
	if IsClient() then return end

	--self.health_multiplier = self:GetAbility():GetSpecialValueFor("max_hp_health_multiplier")
	
	local tower = self:GetParent()
	
	-- all these abilities aaaaaAAAAAAAAAAA
	local ability2 = tower:AddAbility("huskar_berserkers_blood")
	if self:GetAbility():GetSpecialValueFor("has_multishot") == 1 then local ability3 = tower:AddAbility("medusa_split_shot") end
	local ability4 = tower:AddAbility("spectre_dispersion")
	local ability5 = tower:AddAbility("ursa_fury_swipes")
	local ability6 = tower:AddAbility("tidehunter_kraken_shell")
	if self:GetAbility():GetSpecialValueFor("has_multishot") == 1 then local ability7 = tower:AddAbility("special_bonus_unique_medusa_4") end
	local ability8 = tower:AddAbility("special_bonus_unique_ursa_4")
	local ability9 = tower:AddAbility("special_bonus_unique_ursa")
	local ability10 = tower:AddAbility("slardar_bash")
	local ability11 = tower:AddAbility("special_bonus_unique_faceless_void_4")
	ability2:SetLevel(4)
	
	if self:GetAbility():GetSpecialValueFor("has_multishot") == 1 then ability3:SetLevel(4) end
	if self:GetAbility():GetSpecialValueFor("has_multishot") == 1 then if not string.find(self:GetParent():GetUnitName(), "roshan") then ability3:ToggleAbility() end end
	
	ability4:SetLevel(4)
	ability5:SetLevel(4)
	ability6:SetLevel(4)
	if self:GetAbility():GetSpecialValueFor("has_multishot") == 1 then ability7:SetLevel(1) end
	ability8:SetLevel(1)
	ability9:SetLevel(1)
	ability10:SetLevel(4)
	ability11:SetLevel(1)
	
	-- hp placeholder
	self:GetAbility():SetLevel(1)
	local maxHealth = tower:GetMaxHealth()
	local maxHealthMultiplier = self:GetAbility():GetSpecialValueFor("tower_max_hp_multiplier")
	if self:GetAbility():GetSpecialValueFor("scaling") ~= 0 then
		local scaling_factor = self:GetAbility():GetSpecialValueFor("scaling_factor")
		if string.find(self:GetParent():GetUnitName(), "2") then maxHealthMultiplier = maxHealthMultiplier * scaling_factor * 2 end
		if string.find(self:GetParent():GetUnitName(), "3") then maxHealthMultiplier = maxHealthMultiplier * scaling_factor * 3 end	
		if string.find(self:GetParent():GetUnitName(), "4") then maxHealthMultiplier = maxHealthMultiplier * scaling_factor * 4 end
		if string.find(self:GetParent():GetUnitName(), "fort") then maxHealthMultiplier = maxHealthMultiplier * scaling_factor * 5 end
	end
	
	tower:SetMaxHealth(maxHealth * maxHealthMultiplier)
	tower:SetBaseMaxHealth(maxHealth * maxHealthMultiplier)
	tower:ModifyHealth(maxHealth * maxHealthMultiplier, nil, false, 0)
	--tower:SetPhysicalArmorBaseValue(self:GetAbility():GetSpecialValueFor("base_armor"))
	--tower:SetBaseMagicalResistanceValue(self:GetAbility():GetSpecialValueFor("base_magic_resist"))
	
	-- towers fed ggwp
	tower:AddItemByName("item_rapier")
	--tower:AddItemByName("item_heart")
end

function deathtowermodifier:DeclareFunctions()
	return {
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_TELEPORTED, -- OnTeleported 
		-- MODIFIER_PROPERTY_MANA_BONUS, -- GetModifierManaBonus 

		-- can contain everything from the API
		-- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API

	}
end

function deathtowermodifier:GetModifierAttackSpeedBonus_Constant()
	return 0
end

function deathtowermodifier:OnAttackLanded(params)

	--for k,v in pairs(params) do
	--	print(k,v)
	--end
	
	if IsClient() then return end
	
	if params.attacker == self:GetParent() then

		local target = params.target
		if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local damagetable = {
						victim = target,
						attacker = self:GetParent(),
						damage = (target:GetMaxHealth() * self:GetAbility():GetSpecialValueFor( "max_hp_percent_damage" )/100),
						damage_type = DAMAGE_TYPE_PURE,
						damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR, -- Optional, more can be added with + .. No flags = 0.
					}
			ApplyDamage(damagetable)
		end
	end
end

-- ZAP THE UNWORTHY
function deathtowermodifier:OnDeath(params)
	if IsClient() then return end

	if params.attacker == self:GetParent() then
		local target = params.unit
		local killer = params.attacker
		
		
		if string.find(self:GetParent():GetUnitName(), "bad") or string.find(self:GetParent():GetUnitName(), "roshan") then
			local particle_finger_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, killer)
			ParticleManager:SetParticleControlEnt(particle_finger_fx, 0, killer, PATTACH_POINT_FOLLOW, "attach_attack1", killer:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(particle_finger_fx, 1, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_finger_fx, 2, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_finger_fx)    
			
			killer:EmitSound("Hero_Lion.FingerOfDeath")
			target:EmitSound("Hero_Lion.FingerOfDeathImpact")
		else	
			local blade_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, killer)
			ParticleManager:SetParticleControlEnt(blade_pfx, 0, killer, PATTACH_POINT_FOLLOW, "attach_attack1", killer:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(blade_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(blade_pfx)
			
			killer:EmitSound("Ability.LagunaBlade")
			target:EmitSound("Ability.LagunaBladeImpact")
		end
	end
end


--[[
-- MAN THIS FUNCTION DOESN'T EVEN WANT TO WORK!!!!!!!!!1
function deathtowermodifier:GetModifierExtraHealthBonus(params)
	
	local parent = self:GetParent() -- Modifier, finding the guy with the ability.
	local maxHealth = parent:GetMaxHealth()
	
	print(maxHealth)
	print(self.armor)
	print(self.health_multiplier)
	print("------------")
	
	return maxHealth * (self.health_multiplier - 1)
end
--]]