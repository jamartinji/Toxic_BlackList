local _, Addon = ...
local L = Addon.L

BlackList = BlackList or {};

BlackList_Blocked_Channels = {"SAY", "YELL", "WHISPER", "PARTY", "RAID", "RAID_WARNING", "GUILD", "OFFICER", "EMOTE", "TEXT_EMOTE", "CHANNEL", "CHANNEL_JOIN", "CHANNEL_LEAVE"};

Already_Warned_For = {};
Already_Warned_For["WHISPER"] = {};
Already_Warned_For["TARGET"] = {};
Already_Warned_For["PARTY_INVITE"] = {};
Already_Warned_For["PARTY"] = {};
Already_Warned_For["MOUSEOVER"] = {};
Already_Warned_For["NAMEPLATE"] = {};
Already_Warned_For["TARGETED_BY"] = {};

BlackListedPlayers = {};

local function BlackList_RunStep(name, fn)
	local ok, err = pcall(fn)
	if not ok then
		if DEFAULT_CHAT_FRAME then
			local pref = (type(BlackList.GetChatListPrefixMarkup) == "function" and BlackList:GetChatListPrefixMarkup())
				or "|cffffff00[Toxic BlackList]|r "
			DEFAULT_CHAT_FRAME:AddMessage(
				pref .. string.format(L["LOG_ERROR_IN"] or "ERROR in %s:", name) .. " " .. tostring(err),
				1, 0.25, 0.25
			)
		end
		return false
	end
	return true
end

-- Blizzard sound kits or files in Media/Audio (Modules/BlackListSounds.lua). Silence = per-context "no sound" preset.
local function BlackList_PlaySound(kind)
	if BlackList.PlaySoundForKind then
		BlackList:PlaySoundForKind(kind)
	end
end

--- Retail Unit* APIs may return "secret" booleans: never use `if v` / truthiness on API results.
--- Use equality inside pcall so we never boolean-test a secret value.
local function apiBoolIsTrue(v)
	if v == nil then
		return false
	end
	local okT, isTrue = pcall(function()
		return v == true
	end)
	if okT and isTrue then
		return true
	end
	local okF, isFalse = pcall(function()
		return v == false
	end)
	if okF and isFalse then
		return false
	end
	return false
end

--- Copy API strings to plain literals (matches BlackListData SanitizeApiString; helps list lookups).
--- pcall: Retail may return "secret" strings that error on implicit conversion (e.g. string.format in some contexts).
local function sanitizeApiString(s)
	if s == nil then
		return ""
	end
	local ok, out = pcall(function()
		return strtrim(string.format("%s", s))
	end)
	return (ok and out) or ""
end

local function BlackList_RefreshBlacklistedUnitsInGroup()
	if not IsInGroup() then
		return
	end
	local function tryUnit(unit)
		if BlackList.MaybeRefreshBlacklistedUnit then
			BlackList:MaybeRefreshBlacklistedUnit(unit)
		end
	end
	if IsInRaid() then
		for i = 1, 40 do
			local unit = "raid" .. i
			local okE, ex = pcall(UnitExists, unit)
			local okP, pl = pcall(UnitIsPlayer, unit)
			if okE and apiBoolIsTrue(ex) and okP and apiBoolIsTrue(pl) then
				tryUnit(unit)
			end
		end
	else
		local n = GetNumSubgroupMembers()
		for i = 1, n do
			tryUnit("party" .. i)
		end
	end
end

local function BlackList_CheckGroupForBlacklistedPlayers()
	if not IsInGroup() then
		return
	end
	BlackList_RefreshBlacklistedUnitsInGroup()
	local function warnForName(name)
		if not name then
			return
		end
		local idx = BlackList:GetIndexByName(name)
		if idx <= 0 then
			return
		end
		local player = BlackList:GetPlayerByIndex(idx)
		if not player then
			return
		end
		if not BlackList:GetOption("warnPartyJoin", true) then
			return
		end
		local alreadywarned = false
		for _, warnedname in pairs(Already_Warned_For["PARTY"]) do
			if name == warnedname then
				alreadywarned = true
				break
			end
		end
		if alreadywarned then
			return
		end
		table.insert(Already_Warned_For["PARTY"], name)
		BlackList_PlaySound("raid")
		BlackList:AddMessage(BlackList:GetChatListPrefixMarkup() .. "|cff555555==========================================|r", "styled")
		BlackList:AddMessage(BlackList:FormatChatTagPlain(L["PARTY_WARN_TITLE"] or "WARNING: Blacklisted player in your party!", "group"), "styled")
		local partyTail = L["MSG_TAIL_PARTY_GROUP"] or L["IS_BLACKLISTED"]
		BlackList:AddMessage(BlackList:FormatChatTagLine(player, partyTail, "group"), "styled")
		if player["reason"] and strtrim(tostring(player["reason"])) ~= "" then
			BlackList:AddMessage(BlackList:FormatChatTagPlain(L["REASON"] .. " ", "group", player["reason"]), "styled")
		end
		BlackList:AddMessage(BlackList:GetChatListPrefixMarkup() .. "|cff555555==========================================|r", "styled")
	end
	if IsInRaid() then
		for i = 1, 40 do
			local unit = "raid" .. i
			local okE, ex = pcall(UnitExists, unit)
			if okE and apiBoolIsTrue(ex) then
				warnForName(UnitName(unit))
			end
		end
	else
		local n = GetNumSubgroupMembers()
		for i = 1, n do
			warnForName(UnitName("party" .. i))
		end
	end
end

-- Function to handle onload event
function BlackList:OnLoad()

	if self._onLoadDone then
		return
	end

	BlackList_RunStep("InsertUI", function()
		self:InsertUI()
	end)
	BlackList_RunStep("RegisterEvents", function()
		self:RegisterEvents()
	end)
	BlackList_RunStep("HookFunctions", function()
		self:HookFunctions()
	end)
	BlackList_RunStep("RegisterSlashCmds", function()
		self:RegisterSlashCmds()
	end)

	BlackList_RunStep("CreateMinimapButton", function()
		self:CreateMinimapButton()
	end)
	BlackList_RunStep("CreateFloatingQuickButton", function()
		if self.CreateFloatingQuickButton then
			self:CreateFloatingQuickButton()
		end
	end)

	BlackList_RunStep("MigrateSoundPresetOptions", function()
		if self.MigrateSoundPresetOptions then
			self:MigrateSoundPresetOptions()
		end
	end)

	self._onLoadDone = true

end

-- Registers events to be recieved
function BlackList:RegisterEvents()

	local frame = _G.BlackListTopFrame or getglobal("BlackListTopFrame")
	if not frame then
		return
	end

	frame:RegisterEvent("VARIABLES_LOADED")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	frame:RegisterEvent("PARTY_INVITE_REQUEST")
	frame:RegisterEvent("GROUP_ROSTER_UPDATE")

	-- Nearby players with nameplates (no target or mouse required)
	pcall(function()
		frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	end)

	-- Detection: listed player targeting us (nameplates, party/raid, arena).
	if not frame._blTargetedByScanHooked then
		frame._blTargetedByScanHooked = true
		frame:SetScript("OnUpdate", function(self, elapsed)
			self._blTargetedByElapsed = (self._blTargetedByElapsed or 0) + (elapsed or 0)
			if self._blTargetedByElapsed >= 0.35 then
				self._blTargetedByElapsed = 0
				if BlackList.ScanBlacklistedTargetingPlayer then
					BlackList:ScanBlacklistedTargetingPlayer()
				end
			end
		end)
	end

end

--- Does `unit` (player) target the local player?
--- On Retail nameplates, accepts both nameplateNtarget and nameplateN-target.
--- No proximity alerts (target, mouseover, nameplate, targeting you) in city/inn; party and whispers unchanged.
function BlackList:ShouldMuteWorldProximityAlerts()
	if not self:GetOption("muteProximityInRestArea", false) then
		return false
	end
	return IsResting and IsResting() and true or false
end

function BlackList:UnitTokenTargetsPlayer(unit)
	if not unit then
		return false
	end
	local ok, exists = pcall(UnitExists, unit)
	if not ok or not apiBoolIsTrue(exists) then
		return false
	end
	local isPl
	ok, isPl = pcall(UnitIsPlayer, unit)
	if not ok or not apiBoolIsTrue(isPl) then
		return false
	end
	ok, exists = pcall(UnitIsUnit, unit, "player")
	if not ok or apiBoolIsTrue(exists) then
		return false
	end
	local targetToken
	if string.match(unit, "^nameplate%d+$") then
		local tPlain = unit .. "target"
		local tHyphen = unit .. "-target"
		local okP, exP = pcall(UnitExists, tPlain)
		local okH, exH = pcall(UnitExists, tHyphen)
		if okP and apiBoolIsTrue(exP) then
			targetToken = tPlain
		elseif okH and apiBoolIsTrue(exH) then
			targetToken = tHyphen
		else
			return false
		end
	else
		targetToken = unit .. "target"
		ok, exists = pcall(UnitExists, targetToken)
		if not ok or not apiBoolIsTrue(exists) then
			return false
		end
	end
	ok, exists = pcall(UnitIsUnit, targetToken, "player")
	if ok and apiBoolIsTrue(exists) then
		return true
	end
	return false
end

function BlackList:ScanBlacklistedTargetingPlayer()
	if self:ShouldMuteWorldProximityAlerts() then
		return
	end
	if not self:GetOption("warnTargetedBy", true) then
		return
	end
	if self.GetNumBlackLists and self:GetNumBlackLists() <= 0 then
		return
	end
	local now = GetTime()
	local warned = Already_Warned_For["TARGETED_BY"]
	local cooldown = 12

		local function checkUnit(unit)
		if self:UnitTokenTargetsPlayer(unit) ~= true then
			return
		end
		local okNm, nameRaw = pcall(UnitName, unit)
		if not okNm or not nameRaw then
			return
		end
		local name = sanitizeApiString(nameRaw)
		if name == "" or self:GetIndexByName(name) <= 0 then
			return
		end
		if self.MaybeRefreshBlacklistedUnit then
			self:MaybeRefreshBlacklistedUnit(unit)
		end
		for warnedname, t in pairs(warned) do
			if name == warnedname and now < t + cooldown then
				return
			end
		end
		warned[name] = now
		local player = self:GetPlayerByIndex(self:GetIndexByName(name))
		if self.MigrateSoundPresetOptions then
			self:MigrateSoundPresetOptions()
		end
		BlackList_PlaySound("targetedBy")
		local tgtTail = L["MSG_TAIL_TARGETED_BY"] or "from your blacklist has you targeted!"
		self:AddMessage(self:FormatChatTagLine(player, tgtTail, "targetedBy"), "styled")
	end

	checkUnit("target")
	checkUnit("focus")
	for i = 1, 40 do
		checkUnit("nameplate" .. i)
	end
	for i = 1, 4 do
		checkUnit("party" .. i)
	end
	if IsInRaid() then
		for i = 1, 40 do
			checkUnit("raid" .. i)
		end
	end
	for i = 1, 5 do
		checkUnit("arena" .. i)
	end
end

--- UnitGUID may return a secret string; never strsub/compare the raw value — copy to a plain string first.
local function guidPlainString(guid)
	if guid == nil then
		return ""
	end
	local ok, out = pcall(function()
		return strtrim(string.format("%s", guid))
	end)
	return (ok and out) or ""
end

local function guidLooksLikePlayer(guid)
	local g = guidPlainString(guid)
	return g ~= "" and strsub(g, 1, 7) == "Player-"
end

--- True if unit is another player character (not pet/NPC). Hostile nameplates sometimes fail UnitIsPlayer on first frames.
local function unitIsOtherPlayerCharacter(unitToken)
	local ok, isPl = pcall(UnitIsPlayer, unitToken)
	if ok and apiBoolIsTrue(isPl) then
		return true
	end
	local okG, guid = pcall(UnitGUID, unitToken)
	if not okG or not guid then
		return false
	end
	if guidLooksLikePlayer(guid) then
		return true
	end
	-- Secret GUID may not copy to a "Player-" string; GetPlayerInfoByGUID(guid) still identifies players (including hostile).
	if GetPlayerInfoByGUID then
		local okPi, _, _, _, _, piName = pcall(GetPlayerInfoByGUID, guid)
		if okPi and piName then
			local n = sanitizeApiString(piName)
			if n ~= "" then
				return true
			end
		end
	end
	return false
end

--- Name + realm from a player GUID when UnitName/UnitFullName are not ready yet (Blizzard pattern; helps hostile nameplates).
local function getNameRealmFromPlayerGUID(guid)
	if not guid then
		return nil, ""
	end
	if not GetPlayerInfoByGUID then
		return nil, ""
	end
	-- Always try raw GUID first (hostile / secret GUIDs: prefix check may fail before string copy).
	local ok, _, _, _, _, name, realmName = pcall(GetPlayerInfoByGUID, guid)
	if ok and name then
		local n = sanitizeApiString(name)
		if n ~= "" then
			return n, sanitizeApiString(realmName)
		end
	end
	local g = guidPlainString(guid)
	if g == "" or strsub(g, 1, 7) ~= "Player-" then
		return nil, ""
	end
	ok, _, _, _, _, name, realmName = pcall(GetPlayerInfoByGUID, g)
	if not ok or not name then
		return nil, ""
	end
	local n = sanitizeApiString(name)
	if n == "" then
		return nil, ""
	end
	return n, sanitizeApiString(realmName)
end

--- Resolve name + realm from a nameplate unit (cross-realm aware).
--- Order: UnitNameUnmodified (often best on nameplates) -> UnitName -> UnitFullName -> GetPlayerInfoByGUID(UnitGUID).
local function getUnitNameRealmForList(unitToken)
	if not unitToken then
		return nil, ""
	end
	local name, realm
	local ok, n, r
	if UnitNameUnmodified then
		ok, n, r = pcall(UnitNameUnmodified, unitToken)
		if ok and n and sanitizeApiString(n) ~= "" then
			name, realm = n, r
		end
	end
	if not name or sanitizeApiString(name) == "" then
		ok, n, r = pcall(UnitName, unitToken)
		if ok and n and sanitizeApiString(n) ~= "" then
			name, realm = n, r
		end
	end
	if not name or sanitizeApiString(name) == "" then
		if UnitFullName then
			ok, n, r = pcall(UnitFullName, unitToken)
			if ok and n and sanitizeApiString(n) ~= "" then
				name, realm = n, r
			end
		end
	end
	if not name or sanitizeApiString(name) == "" then
		local okG, guid = pcall(UnitGUID, unitToken)
		if okG and guid then
			local gn, gr = getNameRealmFromPlayerGUID(guid)
			if gn then
				name, realm = gn, gr
			end
		end
	end
	if not name or sanitizeApiString(name) == "" then
		return nil, ""
	end
	return sanitizeApiString(name), sanitizeApiString(realm)
end

--- If `unit` is a blacklisted player, append toxicity to the default UI tooltip (mouseover, target, etc.).
function BlackList:TryAppendToxicityToGameTooltip(tooltip)
	if not tooltip or not tooltip.AddLine or not tooltip.GetUnit then
		return
	end
	local okU, _, unit = pcall(tooltip.GetUnit, tooltip)
	if not okU or unit == nil then
		return
	end
	-- Never compare `unit` to "" — Retail may supply a secret unit token and `==` errors.
	local okE, ex = pcall(UnitExists, unit)
	if not okE or not apiBoolIsTrue(ex) then
		return
	end
	local okP, isPl = pcall(UnitIsPlayer, unit)
	if not okP or not apiBoolIsTrue(isPl) then
		return
	end
	local okSelf, isSelf = pcall(UnitIsUnit, unit, "player")
	if okSelf and apiBoolIsTrue(isSelf) then
		return
	end
	local nm, realm = getUnitNameRealmForList(unit)
	if not nm then
		return
	end
	local idx = self.FindEntryIndexForUnit and self:FindEntryIndexForUnit(nm, realm) or 0
	if idx <= 0 then
		idx = self:GetIndexByName(nm)
	end
	if idx <= 0 then
		return
	end
	local player = self:GetPlayerByIndex(idx)
	if not player then
		return
	end
	self:EnsureEntryFields(player)
	local sc = math.floor(math.min(10, math.max(0, tonumber(player.evaluationScore) or 0)))
	if sc <= 0 then
		return
	end
	local label = L["TOXICITY_HEADER"] or L["TOOLTIP_BL_TOXICITY_LABEL"] or "Toxicity:"
	local skulls = (self.GetEvaluationSkullRowMarkup and self:GetEvaluationSkullRowMarkup(sc)) or nil
	local paren = self.GetToxicityScoreParentheticalMarkup and self:GetToxicityScoreParentheticalMarkup(sc) or ("(" .. sc .. ")")
	local line = label .. "  "
	if skulls and skulls ~= "" then
		line = line .. skulls .. "  "
	end
	line = line .. paren
	pcall(function()
		tooltip:AddLine(" ", 1, 1, 1)
		tooltip:AddLine(line, 0.92, 0.62, 0.38, false)
	end)
end

function BlackList:RegisterGameTooltipToxicityLine()
	if self._gameTooltipToxicityRegistered then
		return
	end
	self._gameTooltipToxicityRegistered = true
	local function append(tip)
		self:TryAppendToxicityToGameTooltip(tip)
	end
	local usedProcessor = false
	if TooltipDataProcessor and Enum and Enum.TooltipDataType and TooltipDataProcessor.AddTooltipPostCall then
		usedProcessor = pcall(function()
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tip)
				append(tip)
			end)
		end)
	end
	if not usedProcessor and GameTooltip and GameTooltip.HookScript then
		GameTooltip:HookScript("OnTooltipSetUnit", function(tip)
			append(tip)
		end)
	end
end

--- Warn/sound when a blacklisted player's nameplate appears. Caller must ensure UnitExists(unitToken).
function BlackList:TryNameplateProximityWarn(unitToken)
	if not unitToken then
		return
	end
	local okEx, unitEx = pcall(UnitExists, unitToken)
	if not okEx or not apiBoolIsTrue(unitEx) then
		return
	end
	if self.MaybeRefreshBlacklistedUnit then
		self:MaybeRefreshBlacklistedUnit(unitToken)
	end
	local okSelf, isSelf = pcall(UnitIsUnit, unitToken, "player")
	if okSelf and apiBoolIsTrue(isSelf) then
		return
	end
	-- Resolve name before unitIsOtherPlayerCharacter: hostile / opposite-faction nameplates often fail
	-- UnitIsPlayer + GUID prefix checks until UnitName / GetPlayerInfoByGUID yields a match.
	local name, realm = getUnitNameRealmForList(unitToken)
	if not name then
		return
	end
	local idx = self.FindEntryIndexForUnit and self:FindEntryIndexForUnit(name, realm) or 0
	if idx <= 0 then
		idx = self:GetIndexByName(name)
	end
	if idx <= 0 then
		return
	end
	if self:ShouldMuteWorldProximityAlerts() or not self:GetOption("warnNameplate", true) then
		return
	end
	local player = self:GetPlayerByIndex(idx)
	if not player then
		return
	end
	local warnKey = name .. "|" .. realm
	local alreadywarned = false
	local now = GetTime()
	for key, timepassed in pairs(Already_Warned_For["NAMEPLATE"]) do
		if key == warnKey and now < timepassed + 20 then
			alreadywarned = true
			break
		end
	end
	if alreadywarned then
		return
	end
	Already_Warned_For["NAMEPLATE"][warnKey] = now
	BlackList_PlaySound("nameplate")
	local nearTail = L["MSG_TAIL_NAMEPLATE"] or L["IS_BLACKLISTED"]
	self:AddMessage(self:FormatChatTagLine(player, nearTail, "proximity"), "styled")
end

--- Blizzard may fire NAME_PLATE_UNIT_ADDED before the unit is queryable; defer + short retry.
function BlackList:ScheduleNameplateProximityCheck(unitToken)
	if not unitToken then
		return
	end
	local function run()
		if not unitToken then
			return
		end
		local okE, ex = pcall(UnitExists, unitToken)
		if not okE or not apiBoolIsTrue(ex) then
			return
		end
		self:TryNameplateProximityWarn(unitToken)
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0, run)
		C_Timer.After(0.05, run)
	else
		run()
	end
end

local Orig_ChatFrame_OnEvent;
local Orig_InviteByName;

-- Hooks onto the functions needed
function BlackList:HookFunctions()

	if ChatFrame_OnEvent then
		Orig_ChatFrame_OnEvent = ChatFrame_OnEvent;
		ChatFrame_OnEvent = BlackList_ChatFrame_OnEvent;
	else
		BlackList:AddMessage(BlackList:FormatChatTagPlain(L["LOG_CHATFRAME_HOOK_MISSING"] or "ChatFrame_OnEvent not found; whisper filter may not work.", "systemWarn"), "styled")
	end

	if InviteByName then
		Orig_InviteByName = InviteByName;
		InviteByName = BlackList_InviteByName;
	end

	self:RegisterChatMuteFilters();

	self:RegisterGameTooltipToxicityLine();

end

function BlackList:RegisterChatMuteFilters()
	if self._chatMuteFiltersRegistered then
		return
	end
	if not ChatFrame_AddMessageEventFilter then
		return
	end
	self._chatMuteFiltersRegistered = true
	local function filterMuted(_, event, msg, author, ...)
		if author and BlackList:IsChatMutedAuthor(author) then
			return true
		end
		return false
	end
	local events = {
		"CHAT_MSG_CHANNEL", "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_WHISPER",
		"CHAT_MSG_RAID", "CHAT_MSG_PARTY", "CHAT_MSG_GUILD", "CHAT_MSG_INSTANCE",
		"CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING",
	}
	for i = 1, #events do
		ChatFrame_AddMessageEventFilter(events[i], filterMuted)
	end
end

-- Hooked ChatFrame_OnEvent function (like SuperIgnore does)
function BlackList_ChatFrame_OnEvent(event, ...)

	-- Handle whisper blocking/warning
	if event == "CHAT_MSG_WHISPER" then
		local args = {...}
		local name = args[2] -- In Retail, whisper sender name is the 2nd argument

		if name and BlackList:IsChatMutedAuthor(name) then
			return
		end

		if (BlackList:GetIndexByName(name) > 0) then
			local player = BlackList:GetPlayerByIndex(BlackList:GetIndexByName(name));
			
			-- Always warn about whispers from blacklisted players (if enabled)
			if (BlackList:GetOption("warnWhispers", true)) then
				local alreadywarned = false;
				
				for key, warnedname in pairs(Already_Warned_For["WHISPER"]) do
					if (name == warnedname) then
						alreadywarned = true;
					end
				end
				
				if (not alreadywarned) then
					table.insert(Already_Warned_For["WHISPER"], name);
					local wmsg = string.format(L["MSG_WHISPER_WARN"] or "%s %s and whispered you.", name, L["IS_BLACKLISTED"])
					BlackList:AddMessage(BlackList:FormatChatAlertFromFormatted(player, wmsg, "social"), "styled");
				end
			end
			
			-- Check if we should block whispers
			if (BlackList:GetOption("preventWhispers", true)) then
				-- Block the whisper by not calling the original handler (no auto-reply)
				return;
			end
			
			-- If not blocking, call the original handler to display the whisper
			if Orig_ChatFrame_OnEvent then
				Orig_ChatFrame_OnEvent(event, ...);
			end
			return;
		end
	end
	
	-- Call the original handler for non-blacklisted messages
	if Orig_ChatFrame_OnEvent then
		Orig_ChatFrame_OnEvent(event, ...);
	end
end

-- Hooked InviteByName function
function BlackList_InviteByName(name)

	if (BlackList:GetOption("preventMyInvites", true)) then
		if (BlackList:GetIndexByName(name) > 0) then
			local pInv = BlackList:GetPlayerByIndex(BlackList:GetIndexByName(name))
			local imsg = string.format(L["MSG_PREVENT_MY_INVITE"] or "%s %s, preventing you from inviting them.", name, L["IS_BLACKLISTED"])
			BlackList:AddMessage(BlackList:FormatChatAlertFromFormatted(pInv, imsg, "social"), "styled");
			return;
		end
	end

	if Orig_InviteByName then
		Orig_InviteByName(name);
	end

end

-- Registers slash cmds (SlashCmdList debe asignarse antes que SLASH_* en muchos clientes)
function BlackList:RegisterSlashCmds()

	local function safeHandle(cmd, msg)
		local ok, err = pcall(function()
			BlackList:HandleSlashCmd(cmd, msg)
		end)
		if not ok and UIErrorsFrame then
			UIErrorsFrame:AddMessage("[Toxic BlackList] " .. tostring(err), 1, 0.1, 0.1)
		end
	end

	-- Callback receives (msg, chatEditBox) — see ChatFrameEditBox.lua
	SlashCmdList["TBL"] = function(msg, _)
		safeHandle("tbl", msg)
	end
	SLASH_TBL1 = "/tbl"

	SlashCmdList["TBLA"] = function(msg, _)
		safeHandle("tbla", msg)
	end
	SLASH_TBLA1 = "/tbla"

	SlashCmdList["TBLR"] = function(msg, _)
		safeHandle("tblr", msg)
	end
	SLASH_TBLR1 = "/tblr"

	-- Retail: slash commands go into hash_SlashCmdList via ImportAllListsToHash (each / in chat refreshes it; we force on register)
	if ChatFrameUtil and ChatFrameUtil.ImportAllListsToHash then
		ChatFrameUtil.ImportAllListsToHash()
	end
end

-- Handles /tbl (list), /tbla (add dialog), /tblr (remove).
function BlackList:HandleSlashCmd(cmdType, args)

	if type(args) ~= "string" then
		args = ""
	else
		args = strtrim(args)
	end

	if cmdType == "tbl" then
		if args ~= "" then
			return
		end
		self:ToggleStandaloneWindow()
	elseif cmdType == "tbla" then
		if self.ShowAddPlayerDialog then
			self:ShowAddPlayerDialog()
		end
	elseif cmdType == "tblr" then
		if args == "" then
			self:RemovePlayer("target")
		else
			self:RemovePlayer(args)
		end
	end

end

-- Function to handle events
function BlackList:HandleEvent(event, ...)
	local args = {...}

	if (event == "VARIABLES_LOADED" or event == "PLAYER_LOGIN") then
		if not BlackListedPlayers then
			BlackListedPlayers = {};
		end
		if (not BlackListOptions) then
			BlackListOptions = {};
		end
		if BlackList.MigrateToAccountWideList then
			BlackList:MigrateToAccountWideList()
		end
		if BlackList.MigrateAllBlacklistedEntries then
			BlackList:MigrateAllBlacklistedEntries()
		end
		if BlackList.RefreshFloatingQuickButtonVisibility then
			BlackList:RefreshFloatingQuickButtonVisibility()
		end
		if BlackList.ApplyFloatingQuickButtonSize then
			BlackList:ApplyFloatingQuickButtonSize()
		end
		-- If the addon loaded before ChatFrameUtil / slash hash existed
		if (event == "PLAYER_LOGIN") and ChatFrameUtil and ChatFrameUtil.ImportAllListsToHash then
			ChatFrameUtil.ImportAllListsToHash();
		end
		if (event == "PLAYER_LOGIN") and BlackList.RegisterContextMenu then
			BlackList:RegisterContextMenu();
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		local okEt, exT = pcall(UnitExists, "target")
		local okPt, plT = pcall(UnitIsPlayer, "target")
		if okEt and apiBoolIsTrue(exT) and okPt and apiBoolIsTrue(plT) and BlackList.MaybeRefreshBlacklistedUnit then
			BlackList:MaybeRefreshBlacklistedUnit("target")
		end
		-- search for player name (incl. self as target)
		local name = UnitName("target");
		local okPt2, plT2 = pcall(UnitIsPlayer, "target")
		if (name and okPt2 and apiBoolIsTrue(plT2) and BlackList:GetIndexByName(name) > 0) then
			local player = BlackList:GetPlayerByIndex(BlackList:GetIndexByName(name));

			if (not BlackList:ShouldMuteWorldProximityAlerts() and BlackList:GetOption("warnTarget", true)) then
				-- warn player
				local alreadywarned = false;

				for warnedname, timepassed in pairs(Already_Warned_For["TARGET"]) do
					if ((name == warnedname) and (GetTime() < timepassed+10)) then
						alreadywarned = true;
					end
				end

				if (not alreadywarned) then
					Already_Warned_For["TARGET"][name]=GetTime();
					BlackList_PlaySound("target");
					local onList = L["MSG_TAIL_TARGET_MOUSE"] or L["IS_BLACKLISTED"]
					BlackList:AddMessage(BlackList:FormatChatTagLine(player, onList, "proximity"), "styled")
				end
			end
		end
		if BlackList.ScanBlacklistedTargetingPlayer then
			BlackList:ScanBlacklistedTargetingPlayer()
		end
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		local okEm, exM = pcall(UnitExists, "mouseover")
		local okPm, plM = pcall(UnitIsPlayer, "mouseover")
		if okEm and apiBoolIsTrue(exM) and okPm and apiBoolIsTrue(plM) and BlackList.MaybeRefreshBlacklistedUnit then
			BlackList:MaybeRefreshBlacklistedUnit("mouseover")
		end
		-- search for player name (incl. mouseover self)
		local name = UnitName("mouseover");
		local okPm2, plM2 = pcall(UnitIsPlayer, "mouseover")
		if (name and okPm2 and apiBoolIsTrue(plM2) and BlackList:GetIndexByName(name) > 0) then
			local player = BlackList:GetPlayerByIndex(BlackList:GetIndexByName(name));

			if (not BlackList:ShouldMuteWorldProximityAlerts() and BlackList:GetOption("warnMouseover", true)) then
				-- warn player
				local alreadywarned = false;

				for warnedname, timepassed in pairs(Already_Warned_For["MOUSEOVER"]) do
					if ((name == warnedname) and (GetTime() < timepassed+15)) then
						alreadywarned = true;
					end
				end

				if (not alreadywarned) then
					Already_Warned_For["MOUSEOVER"][name]=GetTime();
					BlackList_PlaySound("mouseover");
					local onList = L["MSG_TAIL_TARGET_MOUSE"] or L["IS_BLACKLISTED"]
					BlackList:AddMessage(BlackList:FormatChatTagLine(player, onList, "proximity"), "styled")
				end
			end
		end
	elseif (event == "NAME_PLATE_UNIT_ADDED") then
		local unitToken = args[1]
		if unitToken and BlackList.ScheduleNameplateProximityCheck then
			BlackList:ScheduleNameplateProximityCheck(unitToken)
		end
	elseif (event == "PARTY_INVITE_REQUEST") then
		-- search for player name
		local name = args[1]; -- In Retail, inviter name is first argument
		if (name and BlackList:GetIndexByName(name) > 0) then
			local player = BlackList:GetPlayerByIndex(BlackList:GetIndexByName(name));

			if (BlackList:GetOption("preventInvites", false)) then
				-- decline party invite
				DeclineGroup();
				StaticPopup_Hide("PARTY_INVITE");
				local dmsg = string.format(L["MSG_DECLINED_PARTY_INVITE"] or "Declined party invite from blacklisted player %s.", name)
				BlackList:AddMessage(BlackList:FormatChatAlertFromFormatted(player, dmsg, "social"), "styled");
			else
				-- warn player
				local alreadywarned = false;

				for key, warnedname in pairs(Already_Warned_For["PARTY_INVITE"]) do
					if (name == warnedname) then
						alreadywarned = true;
					end
				end

				if (not alreadywarned) then
					table.insert(Already_Warned_For["PARTY_INVITE"], name);
					local pmsg = string.format(L["MSG_PARTY_INVITE_WARN"] or "%s %s and invited you to a party.", name, L["IS_BLACKLISTED"])
					BlackList:AddMessage(BlackList:FormatChatAlertFromFormatted(player, pmsg, "social"), "styled");
				end
			end
		end
	elseif (event == "GROUP_ROSTER_UPDATE") then
		BlackList_CheckGroupForBlacklistedPlayers();
	end

end

-- Blacklists the given player, sets the ignore flag to be 'ignore' and enters the given reason
function BlackListPlayer(player, reason)

	BlackList:AddPlayer(player, reason);

end

-- Minimap button: icon via NormalTexture (no MiniMap-TrackingBorder border), bl-icon.png.
function BlackList:CreateMinimapButton()
	local parent = Minimap or MinimapCluster
	if not parent then
		return
	end
	local button = CreateFrame("Button", "BlackListMinimapButton", parent)
	button:SetWidth(31)
	button:SetHeight(31)
	button:SetFrameStrata("MEDIUM")
	button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -10, 10)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:RegisterForDrag("LeftButton")
	button:SetMovable(true)

	local texPath = (Addon.MEDIA_PATH or "Interface\\AddOns\\Toxic_BlackList\\Media\\Images\\") .. "bl-icon.png"
	button:SetNormalTexture(texPath)
	local nt = button:GetNormalTexture()
	if nt then
		nt:SetTexCoord(0, 1, 0, 1)
		nt:ClearAllPoints()
		nt:SetPoint("CENTER", button, "CENTER", 0, 1)
		nt:SetSize(20, 20)
	end
	button:SetPushedTexture(texPath)
	local pt = button:GetPushedTexture()
	if pt then
		pt:SetTexCoord(0, 1, 0, 1)
		pt:ClearAllPoints()
		pt:SetPoint("CENTER", button, "CENTER", 0, 1)
		pt:SetSize(18, 18)
	end
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

	-- Left-click: list. Right-click: options.
	button:SetScript("OnClick", function(self, btn)
		if btn == "LeftButton" then
			BlackList:ToggleStandaloneWindow()
		elseif btn == "RightButton" then
			BlackList:ShowNewOptions()
		end
	end)

	button:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	button:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		-- Always pass strings; GameTooltip:SetText/AddLine require text (nil errors in Blizzard_Minimap tooltips).
		GameTooltip:AddLine(tostring(L["BLACKLIST"] or "Toxic BlackList"))
		local leftAction = tostring(L["MINIMAP_TOOLTIP_RIGHT_LIST"] or "Open list"):gsub("^[^:：]+[:：]%s*", "")
		local rightAction = tostring(L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] or "Open options"):gsub("^[^:：]+[:：]%s*", "")
		GameTooltip:AddLine(string.format(tostring(L["MINIMAP_TOOLTIP_LEFT_CLICK"] or "Left-click: %s"), leftAction), 1, 1, 1)
		GameTooltip:AddLine(string.format(tostring(L["MINIMAP_TOOLTIP_RIGHT_CLICK"] or "Right-click: %s"), rightAction), 1, 1, 1)
		GameTooltip:Show()
	end)

	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
end