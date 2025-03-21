--TODO
--[[
local jasminheal = function(player)
    local mo = player.mo
    if not (mo and mo.valid and mo.skin == "jasmin" and (player.cmd.buttons & BT_CUSTOM1))
    or (player.jasmincustomdown)
    then
        player.jasmincustomdown = (player.cmd.buttons & BT_CUSTOM1)
        return
    else
        player.jasmincustomdown = (player.cmd.buttons & BT_CUSTOM1)
    end
    
    S_StartSound(mo, sfx_jslash)
    
    return true
end
addHook("SpinSpecial", jasminheal)
]]