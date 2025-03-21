freeslot("mt_jslash", "s_jslash", "spr_slsh", "sfx_jslash", "sfx_slash1", "sfx_slash2", "sfx_slash3")

local slashsounds = {sfx_slash1, sfx_slash2, sfx_slash3}

mobjinfo[MT_JSLASH] = {
    doomednum = -1,
    spawnstate = S_JSLASH,
    spawnhealth = 1000,
    radius = 16*FRACUNIT,
    height = 32*FRACUNIT,
    flags = MF_NOGRAVITY|MF_MISSILE
}

states[S_JSLASH] = {
    sprite = SPR_SLSH,
    frame = FF_FULLBRIGHT|FF_ANIMATE,
    tics = 12,
    var1 = 6,
    var2 = 2,
    nextstate = S_NULL
}

freeslot(
	"SPR__CUT",
	"S_CUT"
)

states[S_CUT] = {
	sprite = SPR__CUT,
	frame = FF_FULLBRIGHT|FF_ANIMATE,
	var1 = 5,
	var2 = 2,
	tics = 10,
	nexstate = S_NULL
}

local slashthinker = function(mo)
    local jasmin = mo.target
    local g = P_SpawnGhostMobj(jasmin)
    g.tics = TICRATE / 7
    mo.angle = jasmin.player.drawangle
    local xoffset = P_ReturnThrustX(jasmin, jasmin.player.drawangle, 48*FRACUNIT)
    local yoffset = P_ReturnThrustY(jasmin, jasmin.player.drawangle, 48*FRACUNIT)
    P_MoveOrigin(mo, jasmin.x+xoffset, jasmin.y+yoffset, jasmin.z+(jasmin.height/2))
end
addHook("MobjThinker", slashthinker, MT_JSLASH)

local function jasmincirclevfx(mo)
	local fuse = TICRATE / 5
	local destscale = 7 * mo.scale
	local circle = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_THOK)
	circle.blendmode = AST_ADD
	circle.sprite = SPR_STAB
	circle.frame = A
	circle.angle = mo.angle + ANGLE_90
	circle.tics = max($, fuse)
	circle.fuse = fuse
	circle.scale = mo.scale
	circle.destscale = destscale
	circle.scalespeed = destscale / fuse
	circle.colorized = true
	circle.color = SKINCOLOR_PEPPER
	circle.renderflags = $ | RF_FULLBRIGHT
end

local slashcollide = function(mo, mo2)
    if ((mo.z + mo.height < mo2.z) or (mo.z > mo2.z + mo2.height)) then
        return
    end
    if mo.target == mo2 then
        return
    end
    local killed = (mo2.flags & MF_SHOOTABLE)
    if mo2.type == MT_RING and mo2.health then
        P_KillMobj(mo2)
        mo2.health = 0
        mo.target.player.rings = $+1
        killed = true
    end
    if killed
    and not S_SoundPlaying(mo, sfx_slash1)
    and not S_SoundPlaying(mo, sfx_slash2)
    and not S_SoundPlaying(mo, sfx_slash3)
    then
        local audiosource = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_THOK)
        audiosource.tics = TICRATE*3/2
        audiosource.flags2 = $ | MF2_DONTDRAW
        S_StartSound(audiosource, slashsounds[P_RandomRange(1, #slashsounds)])
        local cut = P_SpawnMobjFromMobj(mo2, 0, 0, mo.height/2, MT_THOK)
        cut.state = S_CUT
        cut.colorized = true
        cut.color = SKINCOLOR_PEPPER
        jasmincirclevfx(mo2)
    end
end
addHook("MobjMoveCollide", slashcollide, MT_JSLASH)

local jasminslash = function(player)
    local mo = player.mo
    if not (mo and mo.valid and mo.skin == "jasmin")
    or (player.panim == PA_ABILITY2)
    or (player.pflags & PF_SPINDOWN)
    then
        return
    end
    
    local slash = P_SpawnMobjFromMobj(mo, 0, 0, mo.height/2, MT_JSLASH)
    slash.angle = player.drawangle
    slash.target = mo
    mo.state = S_PLAY_MELEE_FINISH
    mo.tics = slash.tics + 6
    player.powers[pw_strong] = $|STR_ANIM|STR_PUNCH|STR_HEAVY|STR_WALL
    P_InstaThrust(slash, mo.angle, FixedHypot(mo.momx, mo.momy))
    S_StartSound(mo, sfx_jslash)
    
    return true
end
addHook("SpinSpecial", jasminslash)