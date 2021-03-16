examplemodifier = examplemodifier or class({})

-- check out https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API

-- The modifier Tooltip is inside resource/addon_english.txt (Have fun playing)


function examplemodifier:GetTexture() return "alchemist_chemical_rage" end -- get the icon from a different ability

function examplemodifier:IsPermanent() return true end
function examplemodifier:RemoveOnDeath() return false end
function examplemodifier:IsHidden() return false end 	-- we can hide the modifier
function examplemodifier:IsDebuff() return false end 	-- make it red or green

function examplemodifier:OnCreated(event)
	if IsClient() then return end
	self:StartIntervalThink(0.25)
end

function examplemodifier:OnIntervalThink()
	print()
end