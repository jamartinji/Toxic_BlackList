-- Esc -> Options -> AddOns (settings only). Floating list: /blacklist or /tbl or right-click minimap button.

local _, Addon = ...
local L = Addon.L

local ADDON_FOLDER = "Toxic_BlackList"

local panel = CreateFrame("Frame", "BlackListSettingsPanel", UIParent)
panel.name = L["BLACKLIST"] or "Toxic BlackList"
panel:SetSize(520, 480)
panel:Hide()

local BackdropMixin = "BackdropTemplate"
local CONTAINER_BACKDROP = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local function setSectionBackdrop(frame)
	if not frame.SetBackdrop and BackdropTemplateMixin then
		Mixin(frame, BackdropTemplateMixin)
	end
	if frame.SetBackdrop then
		frame:SetBackdrop(CONTAINER_BACKDROP)
		frame:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
		if frame.SetBackdropBorderColor then
			frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
		end
	end
end

local PAD = 16

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(L["BLACKLIST"] or "Toxic BlackList")

local hint = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
hint:SetJustifyH("LEFT")
hint:SetWidth(480)
hint:SetTextColor(0.75, 0.75, 0.75)
hint:SetText(L["SETTINGS_HINT_OPTIONS_ONLY"] or "")

local optsGroup = CreateFrame("Frame", nil, panel, BackdropMixin)
optsGroup:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -12)
optsGroup:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -PAD, 24)
setSectionBackdrop(optsGroup)

local tabGen = CreateFrame("Button", nil, optsGroup, "UIPanelButtonTemplate")
tabGen:SetSize(125, 22)
tabGen:SetPoint("TOPLEFT", optsGroup, "TOPLEFT", 8, -6)
tabGen:SetText(L["OPT_TAB_GENERAL"] or "General")

local tabFl = CreateFrame("Button", nil, optsGroup, "UIPanelButtonTemplate")
tabFl:SetSize(145, 22)
tabFl:SetPoint("LEFT", tabGen, "RIGHT", 6, 0)
tabFl:SetText(L["OPT_TAB_FLOATING"] or "Button")

local generalPane = CreateFrame("Frame", nil, optsGroup)
generalPane:SetPoint("TOPLEFT", optsGroup, "TOPLEFT", 0, -32)
generalPane:SetPoint("BOTTOMRIGHT", optsGroup, "BOTTOMRIGHT", 0, 0)

local floatPane = CreateFrame("Frame", nil, optsGroup)
floatPane:SetPoint("TOPLEFT", generalPane, "TOPLEFT", 0, 0)
floatPane:SetPoint("BOTTOMRIGHT", generalPane, "BOTTOMRIGHT", 0, 0)
floatPane:Hide()

local settingsActiveTab = 1
local function selectSettingsTab(which)
	settingsActiveTab = which
	generalPane:SetShown(which == 1)
	floatPane:SetShown(which == 2)
	tabGen:SetAlpha(which == 1 and 1 or 0.72)
	tabFl:SetAlpha(which == 2 and 1 or 0.72)
end

tabGen:SetScript("OnClick", function()
	selectSettingsTab(1)
end)
tabFl:SetScript("OnClick", function()
	selectSettingsTab(2)
end)
selectSettingsTab(1)

local function makeCheck(parent, anchor, label, key, default, gapAfterSection)
	gapAfterSection = gapAfterSection or 8
	local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	cb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gapAfterSection)
	local lbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	lbl:SetPoint("LEFT", cb, "RIGHT", 5, 0)
	lbl:SetTextColor(1, 1, 1)
	lbl:SetText(label)
	lbl:SetWidth(280)
	lbl:SetJustifyH("LEFT")
	cb:SetScript("OnClick", function(self)
		BlackList:ToggleOption(key, self:GetChecked())
		BlackListSettings_Refresh()
	end)
	cb.optionKey = key
	cb.defaultVal = default
	cb.label = lbl
	return cb
end

local y0 = generalPane:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
y0:SetPoint("TOPLEFT", 10, -10)
y0:SetText(L["OPT_SECTION_GENERAL"] or "General")

local cPlay = makeCheck(generalPane, y0, L["OPT_PLAY_SOUNDS"] or "Play sounds", "playSounds", true, 10)

local lblAlertSound = generalPane:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
lblAlertSound:SetPoint("TOPLEFT", cPlay, "BOTTOMLEFT", 0, -12)
lblAlertSound:SetText(L["OPT_ALERT_SOUND"] or "Alert sound")

local ddAlert = CreateFrame("Frame", "BlackListSettingsDdAlert", generalPane, "UIDropDownMenuTemplate")
ddAlert:SetPoint("TOPLEFT", lblAlertSound, "BOTTOMLEFT", -16, -4)
BlackList:BindSoundDropdown(ddAlert, "soundPresetAlert", 1)

local btnTestAlert = CreateFrame("Button", nil, generalPane, "UIPanelButtonTemplate")
btnTestAlert:SetSize(70, 22)
btnTestAlert:SetPoint("LEFT", ddAlert, "RIGHT", 8, 0)
btnTestAlert:SetText(L["OPT_SOUND_TEST"] or "Test")
btnTestAlert:SetScript("OnClick", function()
	local idx = BlackList:NormalizeSoundPresetIndex(BlackList:GetOption("soundPresetAlert", 1), 1)
	BlackList:PreviewSoundPresetIndex(idx)
end)

local lblRaidSound = generalPane:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
lblRaidSound:SetPoint("TOPLEFT", ddAlert, "BOTTOMLEFT", 16, -12)
lblRaidSound:SetText(L["OPT_RAID_SOUND"] or "Party warning sound")

local ddRaid = CreateFrame("Frame", "BlackListSettingsDdRaid", generalPane, "UIDropDownMenuTemplate")
ddRaid:SetPoint("TOPLEFT", lblRaidSound, "BOTTOMLEFT", -16, -4)
BlackList:BindSoundDropdown(ddRaid, "soundPresetRaid", 2)

local btnTestRaid = CreateFrame("Button", nil, generalPane, "UIPanelButtonTemplate")
btnTestRaid:SetSize(70, 22)
btnTestRaid:SetPoint("LEFT", ddRaid, "RIGHT", 8, 0)
btnTestRaid:SetText(L["OPT_SOUND_TEST"] or "Test")
btnTestRaid:SetScript("OnClick", function()
	local idx = BlackList:NormalizeSoundPresetIndex(BlackList:GetOption("soundPresetRaid", 2), 2)
	BlackList:PreviewSoundPresetIndex(idx)
end)

local cWarnT = makeCheck(generalPane, ddRaid, L["OPT_WARN_TARGET"] or "Warn target", "warnTarget", true, 14)
local cWarnM = makeCheck(generalPane, cWarnT, L["WARN_MOUSEOVER"] or "Warn mouseover", "warnMouseover", true, 6)
local cWarnN = makeCheck(generalPane, cWarnM, L["WARN_NAMEPLATE"] or "Warn nameplate", "warnNameplate", true, 6)
local cMuteRest = makeCheck(generalPane, cWarnN, L["OPT_MUTE_PROXIMITY_REST"] or "Disable alerts in cities", "muteProximityInRestArea", false, 6)

local y1 = generalPane:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
y1:SetPoint("TOPLEFT", cMuteRest, "BOTTOMLEFT", 0, -14)
y1:SetText(L["OPT_SECTION_COMMUNICATION"] or "Communication")

local cPrevW = makeCheck(generalPane, y1, L["OPT_PREVENT_WHISPERS"] or "Prevent whispers", "preventWhispers", true, 10)
local cWarnW = makeCheck(generalPane, cPrevW, L["OPT_WARN_WHISPERS"] or "Warn whispers", "warnWhispers", true, 6)

local y2 = generalPane:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
y2:SetPoint("TOPLEFT", cWarnW, "BOTTOMLEFT", 0, -14)
y2:SetText(L["OPT_SECTION_GROUP"] or "Group")

local cPrevI = makeCheck(generalPane, y2, L["OPT_PREVENT_INVITES"] or "Prevent invites", "preventInvites", false, 10)
local cPrevMI = makeCheck(generalPane, cPrevI, L["OPT_PREVENT_MY_INVITES"] or "Prevent my invites", "preventMyInvites", true, 6)
local cWarnP = makeCheck(generalPane, cPrevMI, L["OPT_WARN_PARTY_JOIN"] or "Warn party", "warnPartyJoin", true, 6)

BlackList:InstallFloatingQuickOptions(floatPane, "BlackListSetFloat")

local optionChecks = {
	cPlay, cWarnT, cWarnM, cWarnN, cMuteRest,
	cPrevW, cWarnW,
	cPrevI, cPrevMI, cWarnP
}

local function syncOptionsFromSaved()
	for _, cb in ipairs(optionChecks) do
		local v = BlackList:GetOption(cb.optionKey, cb.defaultVal)
		cb:SetChecked(v and true or false)
	end
	BlackList:RefreshSoundDropdown(ddAlert, "soundPresetAlert", 1)
	BlackList:RefreshSoundDropdown(ddRaid, "soundPresetRaid", 2)
	if floatPane.SyncBlackListFloatingWidgets then
		floatPane:SyncBlackListFloatingWidgets()
	end
end

function BlackListSettings_Refresh()
	if not panel:IsVisible() then
		return
	end
	syncOptionsFromSaved()
end

panel:SetScript("OnShow", function()
	panel.name = L["BLACKLIST"] or "Toxic BlackList"
	title:SetText(L["BLACKLIST"] or "Toxic BlackList")
	hint:SetText(L["SETTINGS_HINT_OPTIONS_ONLY"] or "")
	tabGen:SetText(L["OPT_TAB_GENERAL"] or "General")
	tabFl:SetText(L["OPT_TAB_FLOATING"] or "Button")
	y0:SetText(L["OPT_SECTION_GENERAL"] or "General")
	y1:SetText(L["OPT_SECTION_COMMUNICATION"] or "Communication")
	y2:SetText(L["OPT_SECTION_GROUP"] or "Group")
	if cPlay.label then cPlay.label:SetText(L["OPT_PLAY_SOUNDS"] or "") end
	if cWarnT.label then cWarnT.label:SetText(L["OPT_WARN_TARGET"] or "") end
	if cWarnM.label then cWarnM.label:SetText(L["WARN_MOUSEOVER"] or "") end
	if cWarnN.label then cWarnN.label:SetText(L["WARN_NAMEPLATE"] or "") end
	if cMuteRest.label then cMuteRest.label:SetText(L["OPT_MUTE_PROXIMITY_REST"] or "") end
	if cPrevW.label then cPrevW.label:SetText(L["OPT_PREVENT_WHISPERS"] or "") end
	if cWarnW.label then cWarnW.label:SetText(L["OPT_WARN_WHISPERS"] or "") end
	if cPrevI.label then cPrevI.label:SetText(L["OPT_PREVENT_INVITES"] or "") end
	if cPrevMI.label then cPrevMI.label:SetText(L["OPT_PREVENT_MY_INVITES"] or "") end
	if cWarnP.label then cWarnP.label:SetText(L["OPT_WARN_PARTY_JOIN"] or "") end
	lblAlertSound:SetText(L["OPT_ALERT_SOUND"] or "Alert sound")
	lblRaidSound:SetText(L["OPT_RAID_SOUND"] or "Party warning sound")
	btnTestAlert:SetText(L["OPT_SOUND_TEST"] or "Test")
	btnTestRaid:SetText(L["OPT_SOUND_TEST"] or "Test")
	local w = floatPane.blFloatingWidgets
	if w and w.resetBtn then
		w.resetBtn:SetText(L["OPT_FLOAT_BTN_RESET"] or "Reset position & size")
	end

	local wPanel = panel:GetWidth()
	if wPanel and wPanel > 0 then
		hint:SetWidth(math.max(280, wPanel - 32))
	end
	selectSettingsTab(settingsActiveTab)
	BlackListSettings_Refresh()
end)

local function registerOptions()
	if InterfaceOptions_AddCategory then
		pcall(InterfaceOptions_AddCategory, panel)
	end
	if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
		pcall(function()
			local category = Settings.RegisterCanvasLayoutCategory(panel, L["BLACKLIST"] or "Toxic BlackList")
			Settings.RegisterAddOnCategory(category)
			panel.blackListSettingsCategory = category
		end)
	end
end

local ef = CreateFrame("Frame")
ef:RegisterEvent("ADDON_LOADED")
ef:SetScript("OnEvent", function(_, event, name)
	if event == "ADDON_LOADED" and name == ADDON_FOLDER then
		ef:UnregisterEvent("ADDON_LOADED")
		registerOptions()
	end
end)

_G.BlackListSettings_Refresh = BlackListSettings_Refresh

--- Open the built-in panel (Esc -> Options -> AddOns) when the API allows; otherwise the floating options window.
function BlackList:OpenAddonSettingsPanel()
	local p = _G.BlackListSettingsPanel
	local function openPopup()
		if self.ShowNewOptions then
			self:ShowNewOptions()
		end
	end
	if not p then
		openPopup()
		return
	end
	local category = p.blackListSettingsCategory
	if category and Settings and Settings.OpenToCategory then
		local ok = pcall(function()
			if Settings.Open then
				Settings.Open()
			end
			Settings.OpenToCategory(category)
		end)
		if ok then
			return
		end
	end
	if InterfaceOptionsFrame_OpenToCategory then
		local ok = pcall(function()
			InterfaceOptionsFrame_OpenToCategory(p)
		end)
		if ok then
			return
		end
	end
	openPopup()
end
