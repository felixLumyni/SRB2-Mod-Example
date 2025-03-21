local PREFIX = "JAS_HP_"
local scale = FRACUNIT/2
local separation = 15
local r = function(v) return v.RandomKey(2) end

local function jasminhealth(v, player)
	local mo = player.mo
	if not (mo and mo.valid and mo.skin == "jasmin") then
		return
	end
    local x = (320/2)-30
    local y = 240-65
	local health = mo.health
    if P_PlayerInPain(player) then
		x = $ + r(v) - r(v)
		y = $ + r(v) - r(v)
    end
	if not (consoleplayer == player) then
		y = $ + -40
	end
	local colormap
	local flags = V_PERPLAYER|V_SNAPTOBOTTOM|V_HUDTRANS
	v.drawScaled(x*FU, y*FU, scale, v.cachePatch(PREFIX.."BAR"), flags)
	local emptypatch = v.cachePatch(PREFIX.."MTY")
	local heartpatch = v.cachePatch(PREFIX.."HRT")
    local goldpatch = v.cachePatch(PREFIX.."GLD")
	for i=1, max(3, health) do
		local patch = (health < i) and emptypatch or heartpatch
        if (i > 3) then
            patch = goldpatch
        end
		local time = leveltime*2*ANG2
		local yoffset = sin(time+(i * ANGLE_90)) / 2
		if patch == emptypatch then
			yoffset = 0
		end
        v.drawScaled((x*FU)+((i-2)*separation*FU), (y*FU)+yoffset, scale, patch, flags, colormap)
	end
end
hud.add(jasminhealth)