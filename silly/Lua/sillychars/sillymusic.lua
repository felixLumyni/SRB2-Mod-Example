local function getSkinMusic(skin, musicname, isSuper)
    if isSuper and sillyChars[skin]["_super"..musicname] then
        return sillyChars[skin]["_super"..musicname]
    end
    return sillyChars[skin][musicname]
end

addHook("MusicChange", function(oldname, newname)
    if displayplayer
    and displayplayer.mo
    and displayplayer.mo.valid
    and sillyChars[displayplayer.mo.skin] then
        return getSkinMusic(displayplayer.mo.skin, newname, displayplayer.powers[pw_super])
    end
end)