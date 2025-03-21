freeslot("sfx_hypno")

local pulse = function(player)
    local pmo = player.mo
    if not (pmo and pmo.skin == "silly" and not (player.pflags & PF_THOKKED)) then return end
    player.pflags = $ | PF_THOKKED

	--sfx and vfx
    S_StartSound(pmo, sfx_hypno)
    local multiplier = player.powers[pw_super] and FRACUNIT*3 or FRACUNIT
	local speed = FixedMul(multiplier, 80*FRACUNIT)
	local scale = FixedMul(multiplier, pmo.scale)
	
	for i = 1, 16 do
		local dust = P_SpawnMobj(pmo.x, pmo.y, pmo.z + (pmo.height/2), MT_THOK)
		dust.angle = ANGLE_90 + ANG1* (22*(i-1))
		P_InstaThrust(dust, dust.angle, speed)
		dust.frame = A
		dust.momx = $+pmo.momx
		dust.momy = $+pmo.momy
		dust.scale = scale
		dust.destscale = 1
		dust.color = i%2 and SKINCOLOR_PINK or SKINCOLOR_YELLOW
	end

    --gameplay
	local searchpoint = P_SpawnMobjFromMobj(player.mo, 0,0,0, MT_THOK)
	searchpoint.radius = player.powers[pw_super] and RING_DIST*3 or RING_DIST
	searchBlockmap("objects", function(refmobj, mo)
        --negative conditions
	    if mo.flags & MF_NOCLIPTHING
        or mo.health <= 0
        or mo == player.mo
        or mo.flags2 & MF2_FRET
        or not P_CheckSight(player.mo, mo)
        then
	    	return
        end
        --positive conditions
		if mo.player
        or mo.flags & MF_ENEMY
        then
            mo.likesmen = pmo
        end
	end, searchpoint)
	P_RemoveMobj(searchpoint)
end

local likesmen = function(mo)
    for mo in mobjs.iterate() do
        if not (mo.likesmen and mo.likesmen.valid) then
            return
        end
        if (mo.flags & MF_ENEMY) then
            mo.colorized = true
            mo.color = mo.likesmen.color
        end
        local r1 = P_RandomRange(-20, 20)*mo.scale
        local r2 = P_RandomRange(-20, 20)*mo.scale
	    local particle = P_SpawnMobj(mo.x+r1, mo.y+r2, mo.z, MT_NIGHTSPARKLE)
	    particle.colorized = true
	    particle.color = mo.likesmen.color
	    particle.momz = P_RandomRange(3, 10)*mo.scale
	    particle.scalespeed = FRACUNIT/18
	    particle.destscale = 0
    end
end

local hypnodamage = function(target, inflictor, source)
    if target and target.valid and source and source.valid
    and source.likesmen and source.likesmen == target then
        return false
    end
end

addHook("AbilitySpecial", pulse)
addHook("ThinkFrame", likesmen)
addHook("ShouldDamage", hypnodamage)