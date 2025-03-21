local uwu = CV_RegisterVar({
	name = "uwu",
    defaultvalue = 0,
    flags = CV_NETVAR,
    PossibleValue = CV_OnOff,
})

local uwuislowercase = CV_RegisterVar({
	name = "uwuislowercase",
    defaultvalue = 0,
    flags = CV_NETVAR,
    PossibleValue = CV_OnOff,
})

local localuwu = CV_RegisterVar({
	name = "localuwu",
    defaultvalue = 0,
    PossibleValue = CV_OnOff,
})

rawset(_G,"uwufy",{})
uwufy = function(string)
	local result = uwuislowercase.value and string:lower() or string
	result = $:gsub("you", "u")
	result = $:gsub("ove", "uv")
	result = $:gsub("l", "w")
	result = $:gsub("r", "w")
	result = $:gsub("s", "z")
	result = $:gsub("th", "ff")
	result = $:gsub("na", "nya")
	result = $:gsub("ne", "nye")
	result = $:gsub("ni", "nyi")
	result = $:gsub("no", "nyo")
	result = $:gsub("nu", "nyu")
	result = $:gsub("YOU", "U")
	result = $:gsub("OVE", "UV")
	result = $:gsub("L", "W")
	result = $:gsub("R", "W")
	result = $:gsub("S", "Z")
	result = $:gsub("TH", "FF")
	result = $:gsub("NA", "NYA")
	result = $:gsub("NE", "NYE")
	result = $:gsub("NI", "NYI")
	result = $:gsub("NO", "NYO")
	result = $:gsub("NU", "NYU")
	return result
end

addHook("PlayerMsg", function(source, type, target, msg)
	local issilly = source.mo and source.mo.valid and sillyChars[source.mo.skin]
	local mustuwu = uwu.value or localuwu.value or (issilly and not localuwu.value)
	if source.uwufied or not mustuwu then
		source.uwufied = nil
		return false
	end
	local filteredmsg = uwufy(msg)
	source.uwufied = true
	if type == 0 then
		COM_BufInsertText(source, "say "..filteredmsg)
	elseif type == 1 then
		COM_BufInsertText(source, "sayteam "..filteredmsg)
	elseif type == 2 then
		COM_BufInsertText(source, "sayto "..filteredmsg)
	elseif type == 3 then
		COM_BufInsertText(source, "csay "..filteredmsg)
	end
	return true
end)