local _, Addon = ...
local L = Addon.L
BlackList = BlackList or {}

local function escBlizz(s)
	if s == nil then
		return ""
	end
	return tostring(s):gsub("|", "||")
end

function BlackList:RGBToHex(r, g, b)
	return string.format("%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

function BlackList:GetLocalizedClassDisplayName(player)
	if not player then
		return ""
	end
	local token = player.class or ""
	if token == "" then
		return ""
	end
	if _G.LOCALIZED_CLASS_NAMES_MALE and _G.LOCALIZED_CLASS_NAMES_MALE[token] then
		return _G.LOCALIZED_CLASS_NAMES_MALE[token]
	end
	if _G.LOCALIZED_CLASS_NAMES_FEMALE and _G.LOCALIZED_CLASS_NAMES_FEMALE[token] then
		return _G.LOCALIZED_CLASS_NAMES_FEMALE[token]
	end
	return token
end

--- Lowercase keys → 1 Alliance, 2 Horde. Covers API English + all addon locale strings (language changes).
local FACTION_ALIAS_TO_ID = {}
do
	local function add(id, ...)
		for i = 1, select("#", ...) do
			local s = select(i, ...)
			if type(s) == "string" and s ~= "" then
				FACTION_ALIAS_TO_ID[strlower(strtrim(s))] = id
			end
		end
	end
	add(1, "Alliance", "alliance", "Allianz", "Alianza", "Alleanza", "Aliança", "Альянс", "얼라이언스", "联盟", "聯盟")
	add(2, "Horde", "horde", "Horda", "Orda", "Орда", "호드", "部落")
end

local function factionDisplayStringFromGroupId(id)
	if id == 1 then
		return L["ALLIANCE"] or "Alliance"
	end
	if id == 2 then
		return L["HORDE"] or "Horde"
	end
	return L["UNKNOWN"] or "Unknown"
end

--- Persisted `factionGroupId`: 1 = Alliance, 2 = Horde; absent/nil = unknown. `player.faction` is display-only (current locale).
function BlackList:NormalizePlayerFactionFields(player)
	if not player then
		return
	end
	local id = tonumber(player.factionGroupId)
	if id == 1 or id == 2 then
		player.factionGroupId = id
		player.faction = factionDisplayStringFromGroupId(id)
		return
	end
	player.factionGroupId = nil
	local s = strlower(strtrim(tostring(player.faction or "")))
	if s ~= "" then
		local mapped = FACTION_ALIAS_TO_ID[s]
		if mapped == 1 or mapped == 2 then
			player.factionGroupId = mapped
			player.faction = factionDisplayStringFromGroupId(mapped)
			return
		end
	end
	local raceStr = player.race
	if raceStr and strtrim(tostring(raceStr)) ~= "" then
		local fac = GetFaction(raceStr)
		if fac == 1 or fac == 2 then
			player.factionGroupId = fac
			player.faction = factionDisplayStringFromGroupId(fac)
		end
	end
end

--- Returns 1 = Alliance, 2 = Horde, nil = unknown (used for colors, icons).
function BlackList:GetFactionIdForPlayer(player)
	if not player then
		return nil
	end
	self:EnsureEntryFields(player)
	local gid = tonumber(player.factionGroupId)
	if gid == 1 or gid == 2 then
		return gid
	end
	local raceStr = player.race
	if raceStr and raceStr ~= "" then
		local fac = GetFaction(raceStr)
		if fac == 1 or fac == 2 then
			return fac
		end
	end
	return nil
end

--- Specific color palette for class text/borders (RGB 0..1).
function BlackList:GetSpecificClassColorRGB(classTokenOrLocalized)
	local grayR, grayG, grayB = 0.75, 0.75, 0.75
	if not classTokenOrLocalized or classTokenOrLocalized == "" then
		return grayR, grayG, grayB
	end
	local colors = _G.RAID_CLASS_COLORS
	if not colors then
		return grayR, grayG, grayB
	end
	local c = colors[classTokenOrLocalized]
	if c and c.r then
		return c.r, c.g, c.b
	end
	for token, col in pairs(colors) do
		if type(token) == "string" and col and col.r then
			local locM = _G.LOCALIZED_CLASS_NAMES_MALE and _G.LOCALIZED_CLASS_NAMES_MALE[token]
			local locF = _G.LOCALIZED_CLASS_NAMES_FEMALE and _G.LOCALIZED_CLASS_NAMES_FEMALE[token]
			if locM == classTokenOrLocalized or locF == classTokenOrLocalized then
				return col.r, col.g, col.b
			end
		end
	end
	return grayR, grayG, grayB
end

--- Specific color palette for faction text/backgrounds (RGB 0..1). Accepts player table or faction id.
function BlackList:GetSpecificFactionColorRGB(playerOrFactionId)
	local id = playerOrFactionId
	if type(playerOrFactionId) == "table" then
		id = self:GetFactionIdForPlayer(playerOrFactionId)
	end
	if id == 1 then
		return 0.29, 0.33, 0.91
	end
	if id == 2 then
		return 0.90, 0.18, 0.18
	end
	return 0.75, 0.75, 0.75
end

--- Typical Alliance / Horde colors for faction text.
function BlackList:GetFactionColorRGBForPlayer(player)
	return self:GetSpecificFactionColorRGB(player)
end

--- Character Create faction logos (Blizzard_CharacterCreate.xml). Edit watermark via SetAtlas.
function BlackList:GetFactionBadgeAtlasNameForPlayer(player)
	local id = self:GetFactionIdForPlayer(player)
	if id == 1 then
		return "charactercreate-icon-alliance"
	elseif id == 2 then
		return "charactercreate-icon-horde"
	end
	return nil
end

--- Inline atlas markup for faction icon on FontStrings (|A:name:h:w:0:0|a). Empty if faction unknown.
function BlackList:GetFactionBadgeAtlasMarkupForPlayer(player, width, height)
	local atlas = self:GetFactionBadgeAtlasNameForPlayer(player)
	if not atlas then
		return ""
	end
	local w = width or 16
	local h = height or 16
	return string.format("|A:%s:%d:%d:0:0|a", atlas, h, w)
end

--- List row text (icon is rendered by the row widget, not inline markup).
function BlackList:GetStandaloneListIconMarkupForPlayer(player)
	return ""
end

--- Repeated DemonInvasion5 markup for tooltips (scores 1–10). Nil if score is 0.
function BlackList:GetEvaluationSkullRowMarkup(score)
	score = math.floor(math.min(10, math.max(0, tonumber(score) or 0)))
	if score < 1 then
		return nil
	end
	local w, h = 14, 14
	local mk
	if CreateAtlasMarkup then
		pcall(function()
			mk = CreateAtlasMarkup("DemonInvasion5", w, h)
		end)
		if not mk or mk == "" then
			pcall(function()
				mk = CreateAtlasMarkup("questlog-questtypeicon-dungeon", w, h)
			end)
		end
	end
	if not mk or mk == "" then
		return nil
	end
	local t = {}
	for i = 1, score do
		t[i] = mk
	end
	return table.concat(t)
end

--- RGB for toxicity 0–10: 0 gray, 1 green → yellow → orange → 10 red.
function BlackList:GetToxicityScoreColorRGB(score)
	score = math.floor(math.min(10, math.max(0, tonumber(score) or 0)))
	if score == 0 then
		return 0.55, 0.55, 0.58
	end
	local p = (score - 1) / 9
	local r1, g1, b1, r2, g2, b2, t
	if p <= 0.33 then
		t = p / 0.33
		r1, g1, b1 = 0.12, 0.82, 0.28
		r2, g2, b2 = 0.95, 0.88, 0.18
	elseif p <= 0.66 then
		t = (p - 0.33) / 0.33
		r1, g1, b1 = 0.95, 0.88, 0.18
		r2, g2, b2 = 1, 0.52, 0.12
	else
		t = (p - 0.66) / 0.34
		r1, g1, b1 = 1, 0.52, 0.12
		r2, g2, b2 = 0.95, 0.18, 0.14
	end
	return r1 + (r2 - r1) * t, g1 + (g2 - g1) * t, b1 + (b2 - b1) * t
end

--- Colored "(n)" for tooltips and details (0–10).
function BlackList:GetToxicityScoreParentheticalMarkup(score)
	score = math.floor(math.min(10, math.max(0, tonumber(score) or 0)))
	local r, g, b = self:GetToxicityScoreColorRGB(score)
	local hex = self:RGBToHex(r, g, b)
	return "|cff" .. hex .. "(" .. score .. ")|r"
end

--- Colored toxicity digit(s) for list rows (no parentheses).
function BlackList:GetToxicityScoreNumberMarkup(score)
	score = math.floor(math.min(10, math.max(0, tonumber(score) or 0)))
	local r, g, b = self:GetToxicityScoreColorRGB(score)
	local hex = self:RGBToHex(r, g, b)
	return "|cff" .. hex .. tostring(score) .. "|r"
end

--- Line 1: name (class color) - realm (white).
function BlackList:FormatRichNameRealmLine(player)
	if not player then
		return ""
	end
	self:EnsureEntryFields(player)
	local rr, gg, bb = self:GetClassColorRGB(player["class"])
	local nHex = self:RGBToHex(rr, gg, bb)
	local realm = strtrim(tostring(player.realm or ""))
	if realm == "" then
		realm = L["REALM_UNKNOWN"] or L["UNKNOWN"] or "?"
	end
	local nm = escBlizz(player.name or "")
	return string.format("|cff%s%s|r - |cffffffff%s|r", nHex, nm, escBlizz(realm))
end

--- Line 2: <Guild> in light blue; empty if no guild.
function BlackList:FormatRichGuildLine(player)
	if not player then
		return ""
	end
	self:EnsureEntryFields(player)
	local g = player.guild and strtrim(tostring(player.guild)) or ""
	if g == "" then
		return ""
	end
	return string.format("|cff66ccff<%s>|r", escBlizz(g))
end

--- Line 3: level race class (class with class color).
function BlackList:FormatRichLvlRaceClassLine(player)
	if not player then
		return ""
	end
	self:EnsureEntryFields(player)
	local lvl = strtrim(tostring(player.level or ""))
	local race = strtrim(tostring(player.race or ""))
	local token = player.class or ""
	local classLoc = self:GetLocalizedClassDisplayName(player)
	local parts = {}
	if lvl ~= "" then
		parts[#parts + 1] = "|cffffffff" .. escBlizz(lvl) .. "|r"
	end
	if race ~= "" then
		parts[#parts + 1] = "|cffffffff" .. escBlizz(race) .. "|r"
	end
	if token ~= "" then
		local cr, cg, cb = self:GetClassColorRGB(token)
		local ch = self:RGBToHex(cr, cg, cb)
		local cshow = (classLoc ~= "" and classLoc) or token
		parts[#parts + 1] = "|cff" .. ch .. escBlizz(cshow) .. "|r"
	end
	if #parts == 0 then
		return "|cffffffff" .. escBlizz(L["DETAILS_NO_INFO"] or "—") .. "|r"
	end
	return table.concat(parts, " ")
end

--- Line 4: faction with faction color.
function BlackList:FormatRichFactionLine(player)
	if not player then
		return ""
	end
	self:EnsureEntryFields(player)
	local text = ""
	if player.faction and strtrim(tostring(player.faction)) ~= "" then
		text = strtrim(tostring(player.faction))
	elseif player.race and player.race ~= "" then
		local fac = GetFaction(player.race)
		if fac == 1 or fac == 2 then
			text = GetFaction(player.race, true)
		end
	end
	if text == "" then
		text = L["UNKNOWN"] or "Unknown"
	end
	local r, g, b = self:GetFactionColorRGBForPlayer(player)
	local hex = self:RGBToHex(r, g, b)
	return "|cff" .. hex .. escBlizz(text) .. "|r"
end

--- Ordered rich lines: name/realm, optional guild, level/race/class, faction. Override extension via GetPlayerDetailsExtensionLines.
function BlackList:GetPlayerDetailsMainLines(player)
	if not player then
		return {}
	end
	local lines = {}
	lines[#lines + 1] = self:FormatRichNameRealmLine(player)
	local g = self:FormatRichGuildLine(player)
	if g ~= "" then
		lines[#lines + 1] = g
	end
	lines[#lines + 1] = self:FormatRichLvlRaceClassLine(player)
	lines[#lines + 1] = self:FormatRichFactionLine(player)
	return lines
end

--- Extra lines after the main block (e.g. kills/deaths from a companion addon). Default empty.
function BlackList:GetPlayerDetailsExtensionLines(player)
	return {}
end

--- Lines for list tooltip only; defaults to extension lines. Editor uses GetPlayerDetailsExtensionLines.
function BlackList:GetPlayerDetailsExtensionTooltipLines(player)
	return self:GetPlayerDetailsExtensionLines(player)
end

--- Full player-info section for tooltip/editor: main + extension, ends with blank line for spacing.
function BlackList:FormatPlayerDetailsPlayerInfoBlock(player)
	local lines = self:GetPlayerDetailsMainLines(player)
	local ext = self:GetPlayerDetailsExtensionLines(player)
	local t = {}
	for i = 1, #lines do
		t[#t + 1] = lines[i]
	end
	for i = 1, #ext do
		t[#t + 1] = ext[i]
	end
	if #t == 0 then
		return "\n\n"
	end
	return table.concat(t, "\n") .. "\n\n"
end

--- Date lines (gray markup) as separate strings for tooltip/list row parity.
function BlackList:GetPlayerDetailsDateLines(player)
	if not player then
		return {}
	end
	local lines = {}
	local dblock = self:FormatPlayerDetailsRichDateBlock(player)
	if dblock and dblock ~= "" then
		for line in string.gmatch(dblock, "[^\n]+") do
			lines[#lines + 1] = line
		end
	end
	return lines
end

--- Date block with trailing blank line (for spacing before reason / extensions).
function BlackList:FormatPlayerDetailsDateSection(player)
	local lines = self:GetPlayerDetailsDateLines(player)
	if #lines == 0 then
		return ""
	end
	return table.concat(lines, "\n") .. "\n\n"
end

--- Main block (name/realm … faction) for legacy UI or multiline text.
function BlackList:FormatPlayerDetailsMainBlock(player)
	return table.concat(self:GetPlayerDetailsMainLines(player), "\n")
end

--- Dates in gray (Added / Updated).
function BlackList:FormatPlayerDetailsRichDateBlock(player)
	if not player then
		return ""
	end
	local ts = player.added
	if type(ts) ~= "number" then
		ts = time()
	end
	local okFmt, dateStr = pcall(function()
		return date("%I:%M%p on %b %d, 20%y", ts)
	end)
	if not okFmt or not dateStr or dateStr == "" then
		dateStr = tostring(ts)
	end
	local preAdd = L["PREFIX_ADDED"] or "Added:"
	local s = "|cff888888" .. escBlizz(preAdd .. " " .. dateStr) .. "|r"
	local u = player.updatedAt
	if type(u) == "number" and u > 0 then
		local okU, uStr = pcall(function()
			return date("%I:%M%p on %b %d, 20%y", u)
		end)
		if not okU or not uStr or uStr == "" then
			uStr = tostring(u)
		end
		local preUp = L["PREFIX_UPDATED"] or "Updated:"
		s = s .. "\n|cff888888" .. escBlizz(preUp .. " " .. uStr) .. "|r"
	end
	return s
end

--- RGB from specific class color method. Unknown class: gray (not white; reads like priest).
function BlackList:GetClassColorRGB(classTokenOrLocalized)
	return self:GetSpecificClassColorRGB(classTokenOrLocalized)
end

--- Class-colored name only from RAID_CLASS_COLORS (no prefix/body). Use in UI or when building the message yourself.
function BlackList:FormatPlayerNameWithClassColor(player)
	if not player or not player["name"] then
		return ""
	end
	local r, g, b = self:GetClassColorRGB(player["class"])
	local rr = math.floor(r * 255 + 0.5)
	local gg = math.floor(g * 255 + 0.5)
	local bb = math.floor(b * 255 + 0.5)
	return string.format("|cff%02x%02x%02x%s|r", rr, gg, bb, escBlizz(player["name"]))
end

--- Reason for chat/list: no line breaks (first line + ...), max ~24 visible chars + ...
function BlackList:SanitizeReasonForDisplay(raw)
	if not raw or strtrim(raw) == "" then
		return ""
	end
	local s = strtrim(raw)
	if string.find(s, "[\r\n]") then
		local first = strtrim(s:match("^[^\r\n]+") or "")
		s = first .. "..."
	end
	s = s:gsub("%s+", " ")
	s = s:gsub("|", "||")
	local maxLen = 24
	if string.len(s) > maxLen then
		return string.sub(s, 1, maxLen - 3) .. "..."
	end
	return s
end

function BlackList:AppendReasonToChatMessage(msg, player)
	if not msg or not player then
		return msg
	end
	local r = self:SanitizeReasonForDisplay(player["reason"])
	if r ~= "" then
		return msg .. " - " .. r
	end
	return msg
end

--- Plain text: tail + reason (no color codes). For chat use FormatChatTagLine without concatenating reason.
function BlackList:AppendReasonToTail(tailText, player)
	if not tailText then
		tailText = ""
	end
	local r = self:SanitizeReasonForDisplay(player and player["reason"])
	if r ~= "" then
		return tailText .. " - " .. r
	end
	return tailText
end

--- Message body color by type (prefix [Toxic BlackList] and class-colored name are separate).
--- listAdd green | listRemove/listNeutral/group/social white | proximity yellow | targetedBy red | systemWarn yellow.
function BlackList:GetChatSeverityColorMarkup(severity)
	if severity == "listAdd" then
		return "|cff33cc33"
	end
	if severity == "proximity" then
		return "|cffffff00"
	end
	if severity == "targetedBy" then
		return "|cffff3333"
	end
	if severity == "systemWarn" then
		return "|cffffff00"
	end
	-- listRemove, listNeutral, group, social, and anything else → white
	return "|cffffffff"
end

--- Gray " - reason" suffix for chat (reason already passed through SanitizeReasonForDisplay).
function BlackList:GetChatReasonMarkup(player)
	if not player then
		return ""
	end
	local r = self:SanitizeReasonForDisplay(player["reason"])
	if r == "" then
		return ""
	end
	return " |cff888888- " .. r .. "|r"
end

--- Reusable prefix: [Toxic BlackList] in yellow + space (|cffRRGGBB).
function BlackList:GetChatListPrefixMarkup()
	return "|cffffff00[Toxic BlackList]|r "
end

local function stripLegacyAddonPrefix(s)
	if not s then
		return ""
	end
	s = strtrim(tostring(s))
	s = s:gsub("^Black[Ll]ist%s*:%s*", "")
	s = s:gsub("^Black[Ll]ist%s*：%s*", "")
	s = s:gsub("^Black List:%s*", "")
	return strtrim(s)
end

--- Prefix + name (class color only) + body with severity + gray reason if player and includeReason ~= false.
--- bodyText = translated tail only (no " - reason"; reason appended via GetChatReasonMarkup).
function BlackList:FormatChatTagLine(player, bodyText, severity, includeReason)
	severity = severity or "listNeutral"
	bodyText = bodyText or ""
	bodyText = bodyText:gsub("|", "||")
	local prefix = self:GetChatListPrefixMarkup()
	local cBody = self:GetChatSeverityColorMarkup(severity)
	local reasonMark = (includeReason ~= false and player) and self:GetChatReasonMarkup(player) or ""
	if player and player["name"] then
		return prefix .. self:FormatPlayerNameWithClassColor(player) .. " " .. cBody .. bodyText .. reasonMark .. "|r"
	end
	return prefix .. cBody .. bodyText .. reasonMark .. "|r"
end

--- No player name: prefix + body with severity. graySuffixPlain = extra plain text in gray only (e.g. reason in group warning).
function BlackList:FormatChatTagPlain(bodyText, severity, graySuffixPlain)
	severity = severity or "listNeutral"
	bodyText = stripLegacyAddonPrefix(bodyText)
	bodyText = bodyText:gsub("|", "||")
	local cBody = self:GetChatSeverityColorMarkup(severity)
	local gray = ""
	if graySuffixPlain and strtrim(tostring(graySuffixPlain)) ~= "" then
		local g = self:SanitizeReasonForDisplay(graySuffixPlain)
		if g ~= "" then
			gray = "|cff888888" .. g .. "|r"
		end
	end
	return self:GetChatListPrefixMarkup() .. cBody .. bodyText .. gray .. "|r"
end

--- Preformatted string.format line: class-colored name, body per severity, gray reason at end when applicable.
function BlackList:FormatChatAlertFromFormatted(player, formattedLine, severity)
	severity = severity or "social"
	local cBody = self:GetChatSeverityColorMarkup(severity)
	local inner = stripLegacyAddonPrefix(formattedLine)
	if not player or not player["name"] then
		return self:FormatChatTagPlain(inner, severity)
	end
	local n = player["name"]
	local nameCol = self:FormatPlayerNameWithClassColor(player)
	local pref = self:GetChatListPrefixMarkup()
	local reasonMark = self:GetChatReasonMarkup(player)
	if inner:sub(1, #n) == n then
		local rest = inner:sub(#n + 1):match("^%s*(.*)$") or ""
		return pref .. nameCol .. " " .. cBody .. rest:gsub("|", "||") .. reasonMark .. "|r"
	end
	local pos = inner:find(n, 1, true)
	if pos then
		local before = inner:sub(1, pos - 1)
		local after = inner:sub(pos + #n)
		return pref .. cBody .. before:gsub("|", "||") .. "|r"
			.. nameCol .. cBody .. after:gsub("|", "||") .. reasonMark .. "|r"
	end
	if player["reason"] and strtrim(tostring(player["reason"])) ~= "" then
		return self:FormatChatTagPlain(inner, severity, player["reason"])
	end
	return self:FormatChatTagPlain(inner, severity)
end

--- Plain `Name-Realm` (or `Name` if realm empty) for copy / filter; no color codes.
function BlackList:GetPlayerBattleNetIdString(player)
	if not player then
		return ""
	end
	self:EnsureEntryFields(player)
	local n = strtrim(tostring(player.name or ""))
	local r = strtrim(tostring(player.realm or ""))
	if n == "" then
		return ""
	end
	if r ~= "" then
		return n .. "-" .. r
	end
	return n
end

--- Standalone list line: faction icon, then name (class color) + realm in gray (reason in tooltip).
function BlackList:FormatStandaloneListLine(player)
	if not player or not player["name"] then
		return ""
	end
	self:EnsureEntryFields(player)
	local icons = self:GetStandaloneListIconMarkupForPlayer(player)
	local nameColored = self:FormatPlayerNameWithClassColor(player)
	local realm = strtrim(tostring(player.realm or ""))
	if realm == "" then
		realm = escBlizz(L["REALM_UNKNOWN"] or L["UNKNOWN"] or "?")
	else
		realm = escBlizz(realm)
	end
	return icons .. nameColored .. " |cff888888- " .. realm .. "|r"
end

function BlackList:AddMessage(msg, color)

	local r = 1.0
	local g = 1.0
	local b = 1.0

	if color == "red" then
		r, g, b = 1.0, 0.0, 0.0
	elseif color == "yellow" then
		r, g, b = 1.0, 1.0, 0.0
	elseif color == "styled" then
		r, g, b = 1.0, 1.0, 1.0
	end

	-- Messages with |cff…|r: base white so colored segments read clearly.
	if type(msg) == "string" and msg:find("|c", 1, true) then
		r, g, b = 1.0, 1.0, 1.0
	end

	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	end

end

function BlackList:AddErrorMessage(msg, color, timeout)

	local r = 0.0; g = 0.0; b = 0.0;

	if (color == "red") then
		r = 1.0; g = 0.0; b = 0.0;
	elseif (color == "yellow") then
		r = 1.0; g = 1.0; b = 0.0;
	end

	if (DEFAULT_CHAT_FRAME) then
		UIErrorsFrame:AddMessage(msg, r, g, b, nil, timeout);
	end

end

function GetFaction(race, returnText)

	local factions = {L["ALLIANCE"], L["HORDE"], L["UNKNOWN"]};
	local faction = 0;

	if	     (race == "Human" or
			race == "Dwarf" or
			race == "Night Elf" or
			race == "Gnome" or
			race == "Draenei") then
		faction = 1;
	elseif     (race == "Orc" or
			race == "Undead" or
			race == "Tauren" or
			race == "Troll" or
			race == "Blood Elf") then
		faction = 2;
	else
		faction = 3;
	end

	if (returnText) then
		return factions[faction];
	else
		return faction;
	end

end
