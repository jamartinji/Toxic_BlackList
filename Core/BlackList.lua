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

-- Set to false in-game: /run BlackListDebugLog=false  (stops chat spam)
BlackListDebugLog = BlackListDebugLog ~= false

function BlackList.Log(msg)
	if BlackListDebugLog == false then
		return
	end
	if not DEFAULT_CHAT_FRAME then
		return
	end
	local pref = (type(BlackList.GetChatListPrefixMarkup) == "function" and BlackList:GetChatListPrefixMarkup())
		or "|cffffff00[Toxic BlackList]|r "
	DEFAULT_CHAT_FRAME:AddMessage(pref .. "|cff00ccff" .. tostring(msg) .. "|r", 1, 1, 1)
end

local function BlackList_RunStep(name, fn)
	local ok, err = pcall(fn)
	if not ok then
		BlackList.Log(string.format(L["LOG_ERROR_IN"] or "ERROR in %s:", name) .. " " .. tostring(err))
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
			if UnitExists(unit) and UnitIsPlayer(unit) then
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
			if UnitExists(unit) then
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
		BlackList.Log("RegisterEvents: BlackListTopFrame does not exist")
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
	if not ok or not exists then
		return false
	end
	local isPl
	ok, isPl = pcall(UnitIsPlayer, unit)
	if not ok or not isPl then
		return false
	end
	ok = pcall(function()
		return UnitIsUnit(unit, "player")
	end)
	if not ok or UnitIsUnit(unit, "player") then
		return false
	end
	local targetToken
	if string.match(unit, "^nameplate%d+$") then
		local tPlain = unit .. "target"
		local tHyphen = unit .. "-target"
		if pcall(UnitExists, tPlain) and UnitExists(tPlain) then
			targetToken = tPlain
		elseif pcall(UnitExists, tHyphen) and UnitExists(tHyphen) then
			targetToken = tHyphen
		else
			return false
		end
	else
		targetToken = unit .. "target"
		if not (pcall(UnitExists, targetToken) and UnitExists(targetToken)) then
			return false
		end
	end
	ok, exists = pcall(UnitIsUnit, targetToken, "player")
	return ok and exists
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
		if not self:UnitTokenTargetsPlayer(unit) then
			return
		end
		local name = UnitName(unit)
		if not name or self:GetIndexByName(name) <= 0 then
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
		if UnitExists("target") and UnitIsPlayer("target") and BlackList.MaybeRefreshBlacklistedUnit then
			BlackList:MaybeRefreshBlacklistedUnit("target")
		end
		-- search for player name (incl. self as target: useful for testing alerts)
		local name = UnitName("target");
		if (name and UnitIsPlayer("target") and BlackList:GetIndexByName(name) > 0) then
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
		if UnitExists("mouseover") and UnitIsPlayer("mouseover") and BlackList.MaybeRefreshBlacklistedUnit then
			BlackList:MaybeRefreshBlacklistedUnit("mouseover")
		end
		-- search for player name (incl. mouseover self for testing)
		local name = UnitName("mouseover");
		if (name and UnitIsPlayer("mouseover") and BlackList:GetIndexByName(name) > 0) then
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
		if (not unitToken or not UnitExists(unitToken)) then
			return
		end
		if BlackList.MaybeRefreshBlacklistedUnit then
			BlackList:MaybeRefreshBlacklistedUnit(unitToken)
		end
		if (not UnitIsPlayer(unitToken) or UnitIsUnit(unitToken, "player")) then
			return
		end
		local name = UnitName(unitToken)
		if (not name or BlackList:GetIndexByName(name) <= 0) then
			return
		end
		if (BlackList:ShouldMuteWorldProximityAlerts() or not BlackList:GetOption("warnNameplate", true)) then
			return
		end
		local player = BlackList:GetPlayerByIndex(BlackList:GetIndexByName(name))
		if (not player) then
			return
		end
		local alreadywarned = false
		for warnedname, timepassed in pairs(Already_Warned_For["NAMEPLATE"]) do
			if ((name == warnedname) and (GetTime() < timepassed + 20)) then
				alreadywarned = true
				break
			end
		end
		if (not alreadywarned) then
			Already_Warned_For["NAMEPLATE"][name] = GetTime()
			BlackList_PlaySound("nameplate")
			local nearTail = L["MSG_TAIL_NAMEPLATE"] or L["IS_BLACKLISTED"]
			BlackList:AddMessage(BlackList:FormatChatTagLine(player, nearTail, "proximity"), "styled")
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