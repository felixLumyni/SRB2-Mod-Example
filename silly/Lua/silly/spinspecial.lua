--[[
local function HandleSpinSpecial(player)
    if not (player and player.valid and not (player.pflags & PF_THOKKED)) then return end

    player.mo.momz = 20*FRACUNIT
    S_StartSound(player.mo, sfx_boingf) 
    for i = 1, 5 do
        local spark = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_SPARK)
        spark.momx = P_RandomRange(-5, 5) * FRACUNIT
        spark.momy = P_RandomRange(-5, 5) * FRACUNIT
        spark.momz = P_RandomRange(0, 10) * FRACUNIT
    end
    player.pflags = $ | PF_THOKKED
end

addHook("SpinSpecial", HandleSpinSpecial)
]]