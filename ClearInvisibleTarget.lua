require "Apollo"

local ClearInvisibleTarget = {}
 
function ClearInvisibleTarget:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.IsInvisibleTarget = true
	self.InvisibleTargetName = "(unknown)"
	
	return o
end

function ClearInvisibleTarget:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {}

	Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end

function ClearInvisibleTarget:OnLoad()
	Apollo.RegisterEventHandler("DamageOrHealingDone", "OnDamageOrHealingDone", self)
	Apollo.RegisterEventHandler("AttackMissed", "OnAttackMissed", self)

	Apollo.RegisterEventHandler("TargetUnitChanged", "OnTargetUnitChanged", self)
end

function ClearInvisibleTarget:OnHitOrMiss(casterUnit, targetUnit, spellName)
	if self.IsInvisibleTarget == false then return end
	if casterUnit ~= GameLib.GetPlayerUnit() then return end

	Print("Invisible Target Cleared: " .. self.InvisibleTargetName)

	GameLib.SetTargetUnit(nil)
end

function ClearInvisibleTarget:OnDamageOrHealingDone(casterUnit, targetUnit, damageType, damageDone, argOne, argTwo, isCritical, spellName)
	self:OnHitOrMiss(casterUnit, targetUnit, spellName)
end

function ClearInvisibleTarget:OnAttackMissed(casterUnit, targetUnit, missType, spellName)
	self:OnHitOrMiss(casterUnit, targetUnit, spellName)
end

function ClearInvisibleTarget:OnTargetUnitChanged(unitTarget)
	self.IsInvisibleTarget = false

	if unitTarget == nil then return end

	local unitMaxHealth = unitTarget:GetMaxHealth()

	if unitMaxHealth ~= nil and unitMaxHealth > 0 then return end

	self.IsInvisibleTarget = true
	self.InvisibleTargetName = unitTarget:GetName() or "(unknown)"
end

local ClearInvisibleTargetInst = ClearInvisibleTarget:new()
ClearInvisibleTargetInst:Init()
