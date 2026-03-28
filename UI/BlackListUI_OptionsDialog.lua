local _, Addon = ...
local L = Addon.L
local U = Addon.UI

local ADD_DIALOG_CLASS_FILES = {
	"WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN",
	"MAGE", "WARLOCK", "MONK", "DRUID", "DEMONHUNTER", "EVOKER",
}

local function localizedClassLabel(classFile)
	local t = _G.LOCALIZED_CLASS_NAMES_MALE
	if t and classFile and t[classFile] then
		return t[classFile]
	end
	return tostring(classFile or "")
end

local function classAtlasForFileToken(classFile)
	if not classFile or classFile == "" then
		return nil
	end
	local atlas = "groupfinder-icon-class-" .. string.lower(classFile)
	local ok, has = pcall(function()
		return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas)
	end)
	if ok and has then
		return atlas
	end
	return nil
end

local function refreshAddDialogToxicIcons(f)
	if not f or not f.blToxicSkullTex then
		return
	end
	local sc = tonumber(f.blToxicityScore) or 0
	sc = math.floor(math.min(10, math.max(0, sc)))
	U.applyToxicitySkullSingleState(f.blToxicSkullTex, sc)
	if f.blToxicValueText then
		f.blToxicValueText:SetText(tostring(sc))
	end
end

-- Options frame state
local BlackListOptionsFrame_New = nil

local function CreateNewOptionsFrame()
	if BlackListOptionsFrame_New then
		return BlackListOptionsFrame_New
	end
	
	-- Create the main frame
	BlackListOptionsFrame_New = U.createBlackListFrame("BlackListOptionsFrame_New", U.optionsFrameWidth, UIParent, 0, 0)
	local f = BlackListOptionsFrame_New
	f:SetFrameStrata("DIALOG")
	f:SetFrameLevel(200)
	f.blackListEnableResize = true
	f.blackListResizeMinW = 380
	f.blackListResizeMinH = 480
	f.blackListTitleDraggable = true
	U.applyEvergreenTopDecor(f, { width = 300, toY = 0.36 })

	BlackList:ApplyDBMPanelChrome(f, L["OPTIONS"])

	local TAB_TOP = -38
	local TAB_BTN_W = 100
	local TAB_H = 24
	local tabGeneral = CreateFrame("Button", "BlackListOptTabGeneral", f, "UIPanelButtonTemplate")
	tabGeneral:SetSize(TAB_BTN_W, TAB_H)
	tabGeneral:SetPoint("TOPLEFT", f, "TOPLEFT", 14, TAB_TOP)
	tabGeneral:SetText(L["OPT_TAB_GENERAL"] or "General")
	local tabSound = CreateFrame("Button", "BlackListOptTabSound", f, "UIPanelButtonTemplate")
	tabSound:SetSize(TAB_BTN_W, TAB_H)
	tabSound:SetPoint("LEFT", tabGeneral, "RIGHT", 4, 0)
	tabSound:SetText(L["OPT_TAB_SOUND"] or "Sound")
	local tabFloating = CreateFrame("Button", "BlackListOptTabFloating", f, "UIPanelButtonTemplate")
	tabFloating:SetSize(TAB_BTN_W, TAB_H)
	tabFloating:SetPoint("LEFT", tabSound, "RIGHT", 4, 0)
	tabFloating:SetText(L["OPT_TAB_FLOATING"] or "Button")

	local PANEL_TOP = TAB_TOP - TAB_H - 8
	local panelGeneral = CreateFrame("Frame", nil, f)
	panelGeneral:SetPoint("TOPLEFT", f, "TOPLEFT", 8, PANEL_TOP)
	panelGeneral:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 8)
	local panelSound = CreateFrame("Frame", nil, f)
	panelSound:SetPoint("TOPLEFT", f, "TOPLEFT", 8, PANEL_TOP)
	panelSound:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 8)
	panelSound:Hide()
	local panelFloating = CreateFrame("Frame", nil, f)
	panelFloating:SetPoint("TOPLEFT", f, "TOPLEFT", 8, PANEL_TOP)
	panelFloating:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 8)
	panelFloating:Hide()
	f.panelFloating = panelFloating

	local function selectOptionsTab(which)
		f.blackListOptActiveTab = which
		panelGeneral:SetShown(which == 1)
		panelSound:SetShown(which == 2)
		panelFloating:SetShown(which == 3)
		tabGeneral:SetAlpha(which == 1 and 1 or 0.72)
		tabSound:SetAlpha(which == 2 and 1 or 0.72)
		tabFloating:SetAlpha(which == 3 and 1 or 0.72)
	end
	tabGeneral:SetScript("OnClick", function()
		selectOptionsTab(1)
	end)
	tabSound:SetScript("OnClick", function()
		selectOptionsTab(2)
	end)
	tabFloating:SetScript("OnClick", function()
		selectOptionsTab(3)
	end)
	f.blackListOptionsSelectTab = selectOptionsTab

	-- Sound tab (no inner frame or duplicate title).
	-- Each row must sit *below* the previous dropdown (not only under the label), or text overlaps the combo.
	-- The +16 on X offsets the UIDropDown BOTTOMLEFT shift.
	local function addSoundRow(parent, prevDD, labelText, optionKey, defaultIdx, ddGlobalName)
		local lbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		lbl:SetFont("Fonts\\FRIZQT__.TTF", 11)
		lbl:SetTextColor(1, 1, 1)
		lbl:SetWidth(U.optionsCheckTextWidth - 24)
		lbl:SetJustifyH("LEFT")
		lbl:SetText(labelText)
		if prevDD then
			lbl:SetPoint("TOPLEFT", prevDD, "BOTTOMLEFT", 16, -14)
		else
			lbl:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -8)
		end
		local dd = CreateFrame("Frame", ddGlobalName, parent, "UIDropDownMenuTemplate")
		dd:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", -16, -6)
		BlackList:BindSoundDropdown(dd, optionKey, defaultIdx)
		local btnTest = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		btnTest:SetSize(78, 24)
		btnTest:SetPoint("LEFT", dd, "RIGHT", 10, 0)
		btnTest:SetText(L["OPT_SOUND_TEST"] or "Test")
		btnTest:SetScript("OnClick", function()
			local def = defaultIdx
			local idx = BlackList:NormalizeSoundPresetIndex(BlackList:GetOption(optionKey, def), def)
			BlackList:PreviewSoundPresetIndex(idx, def)
		end)
		return dd
	end

	local ddTarget = addSoundRow(panelSound, nil, L["OPT_SOUND_TARGET"] or "Target warning sound", "soundPresetTarget", BlackList_SOUND_PRESET_DEFAULT_TARGET, "BlackListOptDdTarget")
	f.soundDdTarget = ddTarget

	local ddMouse = addSoundRow(panelSound, ddTarget, L["OPT_SOUND_MOUSEOVER"] or "Mouseover warning sound", "soundPresetMouseover", BlackList_SOUND_PRESET_DEFAULT_MOUSEOVER, "BlackListOptDdMouseover")
	f.soundDdMouseover = ddMouse

	local ddNp = addSoundRow(panelSound, ddMouse, L["OPT_SOUND_NAMEPLATE"] or "Nameplate warning sound", "soundPresetNameplate", BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE, "BlackListOptDdNameplate")
	f.soundDdNameplate = ddNp

	local ddRaid = addSoundRow(panelSound, ddNp, L["OPT_RAID_SOUND"] or "Party / group warning sound", "soundPresetRaid", BlackList_SOUND_PRESET_DEFAULT_RAID, "BlackListOptDdRaid")
	f.soundDdRaid = ddRaid

	local ddTargetedBy = addSoundRow(panelSound, ddRaid, L["OPT_SOUND_TARGETED_BY"] or "Blacklisted player targeting you", "soundPresetTargetedBy", BlackList_SOUND_PRESET_DEFAULT_TARGETED_BY, "BlackListOptDdTargetedBy")
	f.soundDdTargetedBy = ddTargetedBy

	local soundBodyH = 5 * 52 + 24

	BlackList:InstallFloatingQuickOptions(panelFloating, "BlackListOptFloat")
	local floatBodyH = 220

	-- Pestaña General
	local pad = -10
	U.createBlackListHeader(panelGeneral, L["OPT_SECTION_GENERAL"], 11, pad)
	pad = pad - 24

	local warnTarget, warnTargetText = U.createBlackListOption(panelGeneral, "BL_WarnTarget", L["OPT_WARN_TARGET"], pad, function(checked)
		BlackList:ToggleOption("warnTarget", checked)
	end)
	pad = pad - U.optionsRowGap

	local warnMouseover, warnMouseoverText = U.createBlackListOption(panelGeneral, "BL_WarnMouseover", L["WARN_MOUSEOVER"], pad, function(checked)
		BlackList:ToggleOption("warnMouseover", checked)
	end)
	pad = pad - U.optionsRowGap

	local warnNameplate, warnNameplateText = U.createBlackListOption(panelGeneral, "BL_WarnNameplate", L["WARN_NAMEPLATE"], pad, function(checked)
		BlackList:ToggleOption("warnNameplate", checked)
	end)
	pad = pad - U.optionsRowGap

	local warnTargetedBy, warnTargetedByText = U.createBlackListOption(panelGeneral, "BL_WarnTargetedBy", L["OPT_WARN_TARGETED_BY"] or "Warn when a blacklisted player targets you", pad, function(checked)
		BlackList:ToggleOption("warnTargetedBy", checked)
	end)
	pad = pad - U.optionsRowGap

	local muteProximityRest, muteProximityRestText = U.createBlackListOption(panelGeneral, "BL_MuteProximityRest", L["OPT_MUTE_PROXIMITY_REST"] or "Mute proximity alerts in rested areas", pad, function(checked)
		BlackList:ToggleOption("muteProximityInRestArea", checked)
	end)
	pad = pad - U.optionsRowGap

	-- Communication Section
	U.createBlackListHeader(panelGeneral, L["OPT_SECTION_COMMUNICATION"], 11, pad)
	pad = pad - 24
	
	local preventWhispers, preventWhispersText = U.createBlackListOption(panelGeneral, "BL_PreventWhispers", L["OPT_PREVENT_WHISPERS"], pad, function(checked)
		BlackList:ToggleOption("preventWhispers", checked)
	end)
	pad = pad - U.optionsRowGap
	
	local warnWhispers, warnWhispersText = U.createBlackListOption(panelGeneral, "BL_WarnWhispers", L["OPT_WARN_WHISPERS"], pad, function(checked)
		BlackList:ToggleOption("warnWhispers", checked)
	end)
	pad = pad - U.optionsRowGap
	
	-- Group Management Section
	U.createBlackListHeader(panelGeneral, L["OPT_SECTION_GROUP"], 11, pad)
	pad = pad - 24
	
	local preventInvites, preventInvitesText = U.createBlackListOption(panelGeneral, "BL_PreventInvites", L["OPT_PREVENT_INVITES"], pad, function(checked)
		BlackList:ToggleOption("preventInvites", checked)
	end)
	pad = pad - U.optionsRowGap
	
	local preventMyInvites, preventMyInvitesText = U.createBlackListOption(panelGeneral, "BL_PreventMyInvites", L["OPT_PREVENT_MY_INVITES"], pad, function(checked)
		BlackList:ToggleOption("preventMyInvites", checked)
	end)
	pad = pad - U.optionsRowGap
	
	local warnPartyJoin, warnPartyJoinText = U.createBlackListOption(panelGeneral, "BL_WarnPartyJoin", L["OPT_WARN_PARTY_JOIN"], pad, function(checked)
		BlackList:ToggleOption("warnPartyJoin", checked)
	end)
	pad = pad - U.optionsRowGap

	local generalBodyH = math.abs(pad) + 28
	local contentBodyH = math.max(generalBodyH, soundBodyH, floatBodyH)
	local optH = math.ceil(-PANEL_TOP + contentBodyH + 14)
	f.blackListDesiredWidth = U.optionsFrameWidth
	f.blackListDesiredHeight = optH
	f:SetSize(U.optionsFrameWidth, optH)
	f:SetScript("OnShow", function(self)
		U.scheduleReapplyPanelSize(self)
		if self.blackListOptionsSelectTab then
			self.blackListOptionsSelectTab(self.blackListOptActiveTab or 1)
		end
	end)

	selectOptionsTab(1)

	-- Store references for updating
	f.checkboxes = {
		{checkbox = warnTarget, option = "warnTarget", default = true},
		{checkbox = warnMouseover, option = "warnMouseover", default = true},
		{checkbox = warnNameplate, option = "warnNameplate", default = true},
		{checkbox = warnTargetedBy, option = "warnTargetedBy", default = true},
		{checkbox = muteProximityRest, option = "muteProximityInRestArea", default = false},
		{checkbox = preventWhispers, option = "preventWhispers", default = true},
		{checkbox = warnWhispers, option = "warnWhispers", default = true},
		{checkbox = preventInvites, option = "preventInvites", default = false},  -- Off by default
		{checkbox = preventMyInvites, option = "preventMyInvites", default = true},  -- On by default
		{checkbox = warnPartyJoin, option = "warnPartyJoin", default = true}
	}
	
	return f
end

function BlackList:ShowNewOptions()
	if self.MigrateSoundPresetOptions then
		self:MigrateSoundPresetOptions()
	end
	local frame = CreateNewOptionsFrame()
	
	-- Close details window if open
	local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
	if detailsFrame and detailsFrame:IsVisible() then
		detailsFrame:Hide()
	end
	
	-- Toggle behavior: if already shown, hide it
	if frame:IsVisible() then
		frame:Hide()
		return
	end
	
	frame:ClearAllPoints()
	local mainFrame = getglobal("BlackListStandaloneFrame")
	if mainFrame and mainFrame:IsVisible() then
		frame:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 10, 0)
	else
		frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
	end
	
	-- Update checkbox states
	if frame.checkboxes then
		for _, data in ipairs(frame.checkboxes) do
			data.checkbox:SetChecked(self:GetOption(data.option, data.default))
		end
	end
	if frame.soundDdTarget then
		self:RefreshSoundDropdown(frame.soundDdTarget, "soundPresetTarget", BlackList_SOUND_PRESET_DEFAULT_TARGET)
	end
	if frame.soundDdMouseover then
		self:RefreshSoundDropdown(frame.soundDdMouseover, "soundPresetMouseover", BlackList_SOUND_PRESET_DEFAULT_MOUSEOVER)
	end
	if frame.soundDdNameplate then
		self:RefreshSoundDropdown(frame.soundDdNameplate, "soundPresetNameplate", BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE)
	end
	if frame.soundDdRaid then
		self:RefreshSoundDropdown(frame.soundDdRaid, "soundPresetRaid", BlackList_SOUND_PRESET_DEFAULT_RAID)
	end
	if frame.soundDdTargetedBy then
		self:RefreshSoundDropdown(frame.soundDdTargetedBy, "soundPresetTargetedBy", BlackList_SOUND_PRESET_DEFAULT_TARGETED_BY)
	end
	if frame.panelFloating and frame.panelFloating.SyncBlackListFloatingWidgets then
		frame.panelFloating:SyncBlackListFloatingWidgets()
	end

	frame:Show()
end

--- Add by name: same NineSlice chrome as the main window (title bar + close).
function BlackList:ShowAddPlayerDialog()
	local dlgW, dlgH = 360, 400
	local f = _G["BlackListAddPlayerDialog"]
	if not f then
		f = U.createChromeParent("BlackListAddPlayerDialog", UIParent, dlgW, dlgH)
		f:SetClampedToScreen(true)
		f:SetFrameStrata("DIALOG")
		f:SetFrameLevel(250)
		f.blackListTitleDraggable = true
		U.applyEvergreenTopDecor(f, { width = 300, toY = 0.36 })
		self:ApplyDBMPanelChrome(f, L["WINDOW_TITLE_ADD_PLAYER"] or L["ADD_PLAYER_POPUP"] or "Add player", "BlackListAddPlayerDialog_Title")

		local innerW = dlgW - 48

		local lblName = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		lblName:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -52)
		lblName:SetJustifyH("LEFT")
		f.blLblName = lblName

		local ebName = CreateFrame("EditBox", "BlackListAddPlayerDialog_Name", f, "InputBoxTemplate")
		ebName:SetSize(innerW, 22)
		ebName:SetPoint("TOPLEFT", lblName, "BOTTOMLEFT", 4, -6)
		ebName:SetAutoFocus(false)
		ebName:SetMaxLetters(64)
		f.blNameEdit = ebName

		local lblRealm = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		lblRealm:SetPoint("TOPLEFT", ebName, "BOTTOMLEFT", -4, -10)
		lblRealm:SetJustifyH("LEFT")
		f.blLblRealm = lblRealm

		local ebRealm = CreateFrame("EditBox", "BlackListAddPlayerDialog_Realm", f, "InputBoxTemplate")
		ebRealm:SetSize(innerW, 22)
		ebRealm:SetPoint("TOPLEFT", lblRealm, "BOTTOMLEFT", 4, -6)
		ebRealm:SetAutoFocus(false)
		ebRealm:SetMaxLetters(64)
		f.blRealmEdit = ebRealm

		local lblClass = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		lblClass:SetPoint("TOPLEFT", ebRealm, "BOTTOMLEFT", -4, -10)
		lblClass:SetJustifyH("LEFT")
		f.blLblClass = lblClass

		local ddClass = CreateFrame("Frame", "BlackListAddPlayerDialog_ClassDD", f, "UIDropDownMenuTemplate")
		ddClass:SetPoint("TOPLEFT", lblClass, "BOTTOMLEFT", -16, -4)
		if ddClass.SetWidth then
			ddClass:SetWidth(math.max(200, innerW + 24))
		end
		f.blClassDD = ddClass
		ddClass.initialize = function()
			local unk = L["UNKNOWN_CLASS"] or "Unknown"
			local z = UIDropDownMenu_CreateInfo()
			z.text = unk
			z.value = ""
			z.func = function()
				f.blSelectedClassToken = ""
				UIDropDownMenu_SetSelectedValue(ddClass, "")
				if UIDropDownMenu_SetText then
					UIDropDownMenu_SetText(ddClass, unk)
				end
			end
			UIDropDownMenu_AddButton(z)
			for ix = 1, #ADD_DIALOG_CLASS_FILES do
				local file = ADD_DIALOG_CLASS_FILES[ix]
				local info = UIDropDownMenu_CreateInfo()
				info.text = localizedClassLabel(file)
				info.value = file
				local at = classAtlasForFileToken(file)
				if at then
					info.icon = at
				end
				info.func = function()
					f.blSelectedClassToken = file
					UIDropDownMenu_SetSelectedValue(ddClass, file)
					if UIDropDownMenu_SetText then
						UIDropDownMenu_SetText(ddClass, localizedClassLabel(file))
					end
				end
				UIDropDownMenu_AddButton(info)
			end
		end
		if UIDropDownMenu_Initialize then
			UIDropDownMenu_Initialize(ddClass, ddClass.initialize)
		end

		local lblToxic = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		lblToxic:SetPoint("TOPLEFT", ddClass, "BOTTOMLEFT", 16, -10)
		lblToxic:SetJustifyH("LEFT")
		f.blLblToxic = lblToxic

		local toxicRow = CreateFrame("Frame", nil, f)
		toxicRow:SetSize(innerW, 28)
		toxicRow:SetPoint("TOPLEFT", lblToxic, "BOTTOMLEFT", 0, -4)
		f.blToxicRow = toxicRow

		local toxVal = toxicRow:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		toxVal:SetPoint("LEFT", toxicRow, "LEFT", 0, 0)
		toxVal:SetJustifyH("LEFT")
		f.blToxicValueText = toxVal

		local szTox = 22
		local tbtn = CreateFrame("Button", nil, toxicRow)
		tbtn:SetSize(szTox, szTox)
		tbtn:SetPoint("LEFT", toxVal, "RIGHT", 10, 0)
		tbtn:SetFrameLevel((toxicRow:GetFrameLevel() or 0) + 3)
		local ttx = tbtn:CreateTexture(nil, "ARTWORK")
		ttx:SetAllPoints()
		f.blToxicSkullTex = ttx
		U.applyToxicityRowIconAtlas(ttx)
		tbtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		tbtn:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local tip = L["ADD_DIALOG_TOXICITY_TOOLTIP"]
			if tip then
				GameTooltip:AddLine(tip, 1, 1, 1, true)
			else
				GameTooltip:AddLine("Left-click: next (0–10, wraps). Right-click: previous.", 1, 1, 1, true)
			end
			GameTooltip:Show()
		end)
		tbtn:SetScript("OnLeave", GameTooltip_Hide)
		tbtn:SetScript("OnClick", function(_, button)
			local cur = math.floor(math.min(10, math.max(0, tonumber(f.blToxicityScore) or 0)))
			if button == "RightButton" then
				cur = cur - 1
				if cur < 0 then
					cur = 10
				end
			else
				cur = cur + 1
				if cur > 10 then
					cur = 0
				end
			end
			f.blToxicityScore = cur
			refreshAddDialogToxicIcons(f)
		end)
		f.blToxicSkullBtn = tbtn

		local lblReason = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		lblReason:SetPoint("TOPLEFT", toxicRow, "BOTTOMLEFT", 0, -10)
		lblReason:SetJustifyH("LEFT")
		f.blLblReason = lblReason

		local reasonBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
		reasonBg:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 8,
			edgeSize = 10,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },
		})
		reasonBg:SetBackdropColor(0.04, 0.04, 0.04, 0.95)
		reasonBg:SetBackdropBorderColor(0.5, 0.45, 0.35, 0.75)
		reasonBg:SetSize(innerW, 72)
		reasonBg:SetPoint("TOPLEFT", lblReason, "BOTTOMLEFT", -4, -4)

		local ebReason = CreateFrame("EditBox", "BlackListAddPlayerDialog_Reason", reasonBg)
		ebReason:SetMultiLine(true)
		if GameFontHighlightSmall then
			ebReason:SetFontObject(GameFontHighlightSmall)
		else
			ebReason:SetFontObject(GameFontHighlight)
		end
		ebReason:SetMaxLetters(500)
		ebReason:SetAutoFocus(false)
		ebReason:SetPoint("TOPLEFT", reasonBg, "TOPLEFT", 8, -8)
		ebReason:SetPoint("BOTTOMRIGHT", reasonBg, "BOTTOMRIGHT", -8, 8)
		ebReason:SetTextInsets(2, 2, 4, 4)
		f.blReasonEdit = ebReason

		local btnAccept = CreateFrame("Button", "BlackListAddPlayerDialog_Accept", f, "UIPanelButtonTemplate")
		btnAccept:SetSize(100, 24)
		btnAccept:SetPoint("TOPLEFT", reasonBg, "BOTTOMLEFT", 0, -16)
		btnAccept:SetText(ACCEPT or "Accept")
		btnAccept:SetScript("OnClick", function()
			local n = strtrim(f.blNameEdit:GetText() or "")
			local realm = strtrim(f.blRealmEdit:GetText() or "")
			local r = strtrim(f.blReasonEdit:GetText() or "")
			if n == "" then
				return
			end
			BlackList:AddPlayerManual(n, realm, r, f.blSelectedClassToken or "", f.blToxicityScore or 0)
			f:Hide()
		end)

		local btnCancel = CreateFrame("Button", "BlackListAddPlayerDialog_Cancel", f, "UIPanelButtonTemplate")
		btnCancel:SetSize(100, 24)
		btnCancel:SetPoint("TOPRIGHT", reasonBg, "BOTTOMRIGHT", 0, -16)
		btnCancel:SetText(CANCEL or "Cancel")
		btnCancel:SetScript("OnClick", function()
			f:Hide()
		end)

		ebName:SetScript("OnTabPressed", function()
			f.blRealmEdit:SetFocus()
		end)
		ebRealm:SetScript("OnTabPressed", function()
			f.blReasonEdit:SetFocus()
		end)
		ebReason:SetScript("OnTabPressed", function()
			f.blNameEdit:SetFocus()
		end)

		f:SetScript("OnHide", function()
			f.blNameEdit:ClearFocus()
			f.blRealmEdit:ClearFocus()
			f.blReasonEdit:ClearFocus()
		end)

		U.registerEscClose(f)
		if f.HookScript then
			f:HookScript("OnShow", function(self)
				U.scheduleReapplyPanelSize(self)
			end)
		end
	end

	f.blackListTitleDraggable = true
	if f.blackListTitleDragHeader then
		f:SetMovable(true)
		f.blackListTitleDragHeader:EnableMouse(true)
		f.blackListTitleDragHeader:RegisterForDrag("LeftButton")
		f.blackListTitleDragHeader:SetScript("OnDragStart", function()
			f:StartMoving()
		end)
		f.blackListTitleDragHeader:SetScript("OnDragStop", function()
			U.safeStopMovingOrSizing(f)
		end)
	end

	if f.BlackListTitleText then
		f.BlackListTitleText:SetText(L["WINDOW_TITLE_ADD_PLAYER"] or L["ADD_PLAYER_POPUP"] or "Add player")
	end
	f.blLblName:SetText(L["POPUP_NAME_EDIT_HINT"] or (L["BLACKLIST_PLAYER"] or "Name"))
	f.blLblRealm:SetText(L["ADD_DIALOG_REALM_LABEL"] or "Realm (optional)")
	if f.blLblClass then
		f.blLblClass:SetText(L["ADD_DIALOG_CLASS_LABEL"] or "Class")
	end
	if f.blLblToxic then
		f.blLblToxic:SetText(L["ADD_DIALOG_TOXICITY_LABEL"] or "Toxicity")
	end
	f.blLblReason:SetText(L["REASON"] or "Reason")
	f.blSelectedClassToken = ""
	f.blToxicityScore = 0
	if f.blClassDD and UIDropDownMenu_Initialize and f.blClassDD.initialize then
		UIDropDownMenu_Initialize(f.blClassDD, f.blClassDD.initialize)
		if UIDropDownMenu_SetSelectedValue then
			UIDropDownMenu_SetSelectedValue(f.blClassDD, "")
		end
		if UIDropDownMenu_SetText then
			UIDropDownMenu_SetText(f.blClassDD, L["UNKNOWN_CLASS"] or "Unknown")
		end
	end
	refreshAddDialogToxicIcons(f)
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
	f.blNameEdit:SetText("")
	f.blRealmEdit:SetText("")
	f.blReasonEdit:SetText("")
	f:SetSize(dlgW, dlgH)
	f:Raise()
	f:Show()
	f.blNameEdit:SetFocus()
end
