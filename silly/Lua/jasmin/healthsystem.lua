local jasminspawnhealth = function(mo)
	if (mo.skin == "jasmin" and not mo.jasminspawned) then
		mo.health = 3
		mo.jasminspawned = true
	end
end
addHook("MobjThinker", jasminspawnhealth, MT_PLAYER)

local jasmintakedamage = function(mo, inflictor, source)
	if (mo.skin == "jasmin") then
		if (mo.player.powers[pw_shield]) then
			return
		end
		mo.health = mo.health - 1
		if (mo.health) then
			S_StartSound(mo, sfx_shldls)
			P_DoPlayerPain(mo.player, inflictor, source)
			return true
		end
	end
end
addHook("MobjDamage", jasmintakedamage, MT_PLAYER)