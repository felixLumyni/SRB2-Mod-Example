freeslot("sfx_slyjmp")

local waterfactor = function(mo)
    return (mo.eflags & MFE_UNDERWATER) and 2 or 1
end

local doublejump = function(player)
    local pmo = player.mo
    if not (pmo and pmo.skin == "jasmin" and not (player.pflags & PF_THOKKED)) then return end
    player.pflags = $ | PF_THOKKED | PF_STARTJUMP

    --sfx and vfx
    pmo.state = S_PLAY_SPRING
    S_StartSound(pmo, sfx_slyjmp)
    local multiplier = player.powers[pw_super] and 3 or 1
    P_SetObjectMomZ(pmo, multiplier*(player.actionspd/2)/waterfactor(pmo), false)
    P_SpawnParaloop(pmo.x, pmo.y, pmo.z, pmo.radius * 5, 16, MT_DUST, ANGLE_90, S_NULL, true)
end
addHook("AbilitySpecial", doublejump)