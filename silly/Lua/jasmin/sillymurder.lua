local sillygore = CV_RegisterVar({"silly_gore", "On", CV_NETVAR, CV_OnOff})

local jasminmurder = function(silly, jasmin, source)
	if silly.skin == "silly"
	and jasmin and jasmin.valid and jasmin.player and jasmin.player.bot and jasmin.skin == "jasmin"
	and not ((silly.z+silly.height < jasmin.z) or (silly.z > jasmin.z+jasmin.height))
	then
		silly.jasminmurdered = sillygore.value
		P_KillMobj(silly, jasmin, source)
	end
end
addHook("MobjCollide", jasminmurder, MT_PLAYER)

local jastmintimeout = function(bot, cmd)
	if bot.mo and bot.mo.valid and bot.mo.skin == "jasmin" then
		bot.mo.likesmen = false
		return leveltime < TICRATE
	end
end
addHook("BotTiccmd", jastmintimeout)

/* Blood.lua Heavily modified from CSL_SonicEXE-v4-1-5a.pk3 by Lumyni */

/* SOUNDS */
freeslot("sfx_flckd", "sfx_nom")

local blood_color = SKINCOLOR_RED
local gibs_gibcooldown = 5

/* GIBS */
freeslot(
"SPR_BOLT",
"SPR_NUTT",
"SPR_BONE",
"SPR_SKLL",
"SPR_MONT",
"SPR_CORE",
"MT_GIBS",
"S_GIB_BOLT",
"S_GIB_NUTT",
"S_GIB_BONE",
"S_GIB_SKULL",
"S_GIB_MONT",
"S_GIB_CORE"
)

mobjinfo[MT_GIBS] = {
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	speed = 2*FRACUNIT,
	spawnstate = S_GIB_BOLT,
	flags = MF_BOUNCE|MF_SCENERY|MF_SPECIAL
}
states[S_GIB_BOLT] = {
	sprite = SPR_BOLT,
	frame = A,
	tics = -1,
}
states[S_GIB_NUTT] = {
	sprite = SPR_NUTT,
	frame = A,
	tics = -1,
}
states[S_GIB_BONE] = {
	sprite = SPR_BONE,
	frame = A,
	tics = -1,
}
states[S_GIB_SKULL] = {
	sprite = SPR_SKLL,
	frame = A,
	tics = -1,
}
states[S_GIB_MONT] = {
	sprite = SPR_MONT,
	frame = A,
	tics = -1,
}
states[S_GIB_CORE] = {
	sprite = SPR_CORE,
	frame = A,
	tics = -1,
}

local function gibs_handler(mo)
	if not mo.timeout
		mo.timeout = gibs_gibcooldown*TICRATE
	else
		mo.timeout = mo.timeout - 1
	end
	local new_frame
	if abs(mo.momx) > 0 and abs(mo.momy) > 0
		if abs(mo.momx) > abs(mo.momy)
			A_RollAngle(mo,(abs(mo.momx)/10))
		else
			A_RollAngle(mo,(abs(mo.momy)/10))
		end
	end
	if P_IsObjectOnGround(mo)
		P_SetObjectMomZ(mo,-(FixedInt(mo.prev_momz)/2)*FRACUNIT,false)
		if mo.momz < FRACUNIT
			mo.momz = 0
		end
	end
	if abs(mo.momx) > FRACUNIT and abs(mo.momy) > FRACUNIT and abs(mo.momz) > 0
		local trail = P_SpawnMobj(mo.x,mo.y,mo.z,MT_TRAIL)
		trail.color = mo.color
	end
	mo.prev_momz = mo.momz
	if mo.timeout == 0
		P_RemoveMobj(mo)
	end
end

local function gibs_kicker(mo,player)
	if player.momx > player.momy
		P_InstaThrust(mo,player.angle,player.momx)
		P_SetObjectMomZ(mo,player.momx,false)
	else
		P_InstaThrust(mo,player.angle,player.momy)
		P_SetObjectMomZ(mo,player.momy,false)
	end
	return true
end

addHook("MobjThinker", gibs_handler, MT_GIBS)
addHook("TouchSpecial", gibs_kicker, MT_GIBS)

local gibs_liqcooldown = 1

/* LIQUID */
freeslot(
"SPR_LIQD",
"MT_LIQUID",
"S_LIQD_BIG",
"S_LIQD_SMALL",
"S_LIQD_TINY",
"S_LIQD_BIG_SPLAT",
"S_LIQD_SMALL_SPLAT",
"S_LIQD_TINY_SPLAT"
)

mobjinfo[MT_LIQUID] = {
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	spawnstate = S_LIQD_BIG,
	flags = MF_BOUNCE|MF_SCENERY
}

states[S_LIQD_BIG] = {
	sprite = SPR_LIQD,
	frame = A|TR_TRANS40,
	tics = 10,
	nextstate = S_LIQD_BIG
}

states[S_LIQD_SMALL] = {
	sprite = SPR_LIQD,
	frame = B|TR_TRANS40,
	tics = 10,
	nextstate = S_LIQD_SMALL
}

states[S_LIQD_TINY] = {
	sprite = SPR_LIQD,
	frame = C|TR_TRANS40,
	tics = 10,
	nextstate = S_LIQD_TINY
}

states[S_LIQD_BIG_SPLAT] = {
	sprite = SPR_LIQD,
	frame = D|TR_TRANS40,
	tics = 10,
	nextstate = S_LIQD_BIG_SPLAT
}

states[S_LIQD_SMALL_SPLAT] = {
	sprite = SPR_LIQD,
	frame = E|TR_TRANS40,
	tics = 10,
	nextstate = S_LIQD_SMALL_SPLAT
}

states[S_LIQD_TINY_SPLAT] = {
	sprite = SPR_LIQD,
	frame = F|TR_TRANS40,
	tics = 10,
	nextstate = S_LIQD_TINY_SPLAT
}

local function liquid_handler(mo)
	if not mo.timeout
		mo.timeout = gibs_liqcooldown*TICRATE
	else
		mo.timeout = mo.timeout - 1
	end
	if P_IsObjectOnGround(mo)
		if mo.state == S_LIQD_BIG
			A_Create_Liquid(mo, 2, 3, mo.color, 2)
			mo.state = S_LIQD_BIG_SPLAT
			mo.momz = 0
		elseif mo.state == S_LIQD_SMALL
			if P_RandomRange(0, 100) > 50
				A_Create_Liquid(mo, 3, 5, mo.color, 1)
			end
			mo.state = S_LIQD_SMALL_SPLAT
			mo.momz = 0
		elseif mo.state == S_LIQD_TINY
			mo.state = S_LIQD_TINY_SPLAT
			mo.momz = 0
		end
	end
	if mo.timeout == 0
		P_RemoveMobj(mo)
	end
end
addHook("MobjThinker", liquid_handler, MT_LIQUID)

/* TRAILS THAT FOLLOW GIBS, BECAUSE IT CAN'T GET LAGGY ENOUGH (TM) */

freeslot(
"SPR_TRIL",
"MT_TRAIL",
"S_TRAIL"
)

mobjinfo[MT_TRAIL] = {
	spawnstate = S_TRAIL,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SCENERY
}
states[S_TRAIL] = {
	sprite = SPR_TRIL,
	frame = A|TR_TRANS70,
	tics = TICRATE,
	nextstate = S_TRAIL,
}

local function trail_handler(mo)
	if mo.destscale == FRACUNIT
		mo.destscale = 1
		mo.scalespeed = FRACUNIT/24
	end
	if mo.scale < FRACUNIT/5
		P_RemoveMobj(mo)
	end
end

addHook("MobjThinker", trail_handler, MT_TRAIL)

/* FUNCTIONS */

function A_Create_Liquid(mo,liq_type,max_liqd,color,mom)
	for i = 0,max_liqd
		local angle = ((mo.angle-(FixedAngle(180)*FRACUNIT)-(FixedAngle(i * 45)*FRACUNIT)) + FixedAngle(90/(i+1))*FRACUNIT)
		local liq = P_SpawnMobj(mo.x,mo.y,mo.z+(1*FRACUNIT),MT_LIQUID)
		if liq_type == 1
			liq.state = S_LIQD_BIG
		elseif liq_type == 2
			liq.state = S_LIQD_SMALL
		else
			liq.state = S_LIQD_TINY
		end
		liq.color = color
		P_SetObjectMomZ(liq,P_RandomRange(1,mom)*FRACUNIT,false)
		P_InstaThrust(liq,angle,P_RandomRange(1,mom)*FRACUNIT)
	end
end

function A_Create_Gibs(mo,gib_type,max_gibs,mom,color)
	if not (sillygore.value) return end
	if max_gibs == 0
		local angle = FixedAngle(P_RandomRange(0,360)*FRACUNIT)
		local gib = P_SpawnMobj(mo.x,mo.y,mo.z+(1*FRACUNIT),MT_GIBS)
		if gib_type == 1
			gib.state = S_GIB_BOLT
		elseif gib_type == 2
			gib.state = S_GIB_NUTT
		elseif gib_type == 3
			gib.state = S_GIB_BONE
		elseif gib_type == 4
			gib.state = S_GIB_SKULL
		elseif gib_type == 5
			gib.state = S_GIB_MONT
		else
			gib.state = S_GIB_CORE
		end
		gib.color = color
		P_SetObjectMomZ(gib,P_RandomRange(1,mom*2)*FRACUNIT,false)
		P_InstaThrust(gib,angle,P_RandomRange(1,mom*2)*FRACUNIT)
		return gib
	else
		for i = 0,max_gibs
			local angle = ((mo.angle-(FixedAngle(180)*FRACUNIT)-(FixedAngle(i * 45)*FRACUNIT)) + FixedAngle(90/(i+1))*FRACUNIT)
			local gib = P_SpawnMobj(mo.x,mo.y,mo.z+(1*FRACUNIT),MT_GIBS)
			if gib_type == 1
				gib.state = S_GIB_BOLT
			elseif gib_type == 2
				gib.state = S_GIB_NUTT
			elseif gib_type == 3
				gib.state = S_GIB_BONE
			elseif gib_type == 4
				gib.state = S_GIB_SKULL
			elseif gib_type == 5
				gib.state = S_GIB_MONT
			else
				gib.state = S_GIB_CORE
			end
			gib.color = color
			P_SetObjectMomZ(gib,P_RandomRange(1,mom)*FRACUNIT,false)
			P_InstaThrust(gib,angle,P_RandomRange(1,mom)*FRACUNIT)
		end
	end
end

/* PLAYER */

local function gib_handler(target)
	if target.jasminmurdered then
		target.jasminmurdered = nil
		S_StartSoundAtVolume(target, sfx_flckd, 100)
		S_StartSound(target, sfx_nom)
		A_Create_Liquid(target, 1, 10, blood_color, 10)
		A_Create_Liquid(target, 2, 8, blood_color, 12)
		A_Create_Liquid(target, 3, 6, blood_color, 14)
		A_Create_Gibs(target,3,11,4,blood_color)
		target.skull = A_Create_Gibs(target,4,0,8,blood_color)
		target.scale = FRACUNIT/5
		return false
	end
end
addHook("MobjDeath", gib_handler, MT_PLAYER)

local function player_handler(mo)
	if mo.skull and mo.skull.valid then
		P_MoveOrigin(mo,mo.skull.x,mo.skull.y,mo.skull.z)
		mo.angle = mo.skull.angle
		mo.height = mo.skull.height
		mo.flags2 = MF2_DONTDRAW
	end
end
addHook("MobjThinker", player_handler, MT_PLAYER)