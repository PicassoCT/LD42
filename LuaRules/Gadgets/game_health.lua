if not gadgetHandler:IsSyncedCode() then
	return
end

function gadget:GetInfo()
	return {
		name    = "Health",
		desc    = "Health mechanics.",
		author  = "gajop",
		date    = "LD42",
		license = "GNU GPL, v2 or later",
		layer   = -1,
		enabled = true,
	}
end

local function UpdateAllAttributes(unitID, table)
    for k, v in pairs(table) do
        Spring.SetUnitRulesParam(unitID, k, v)
    end
end

function gadget:UnitCreated(unitID, unitDefID)
    local unitDef = UnitDefs[unitDefID]
    Spring.SetUnitRulesParam(unitID, "health", unitDef.customParams.health or 100000)
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    local hp = Spring.GetUnitRulesParam(unitID, "health")
    if not hp then
        return 0
    end
    local damage = UnitDefs[attackerDefID].customParams.damage
    hp = hp - damage
    -- local damage = WeaponDefs[weaponDefID].customParams.damage
    Spring.SetUnitRulesParam(unitID, "health", hp)
    if hp < 0 then
        Spring.DestroyUnit(unitID)
    end
    return 0
end
