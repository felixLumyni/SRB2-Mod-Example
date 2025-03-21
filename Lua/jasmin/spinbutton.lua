local function getrover(mo)
	if (mo.eflags & MFE_VERTICALFLIP)
		return mo.ceilingrover
	else
		return mo.floorrover
	end
end

addHook("PlayerHeight", function(player)
    local mo = player.mo
	if mo and mo.valid and mo.skin == "jasmin"
    and getrover(mo) and (getrover(mo).flags & ML_NOCLIMB)
	and player.cmd.forwardmove
    and not ((mo.eflags & MFE_TOUCHWATER) and not (mo.eflags & MFE_UNDERWATER))
    then
        player.pflags = $|PF_STARTDASH
        return P_GetPlayerSpinHeight(player)
	end
end)