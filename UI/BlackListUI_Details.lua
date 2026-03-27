local _, Addon = ...
local L = Addon.L
local U = Addon.UI

local applyTrimDecor

--- Insert mute checkbox for layouts created before the muted row existed.
function BlackList:InsertMutedRowInDetails(detailsFrame)
	if not detailsFrame or getglobal("BlackListStandaloneDetails_MutedCb") then
		return
	end
	local anchor = getglobal("BlackListStandaloneDetails_ExtensionBlock")
	if not anchor then
		anchor = getglobal("BlackListStandaloneDetails_Row4")
	end
	local reasonHeader = getglobal("BlackListStandaloneDetails_ReasonHeader")
	if not anchor or not reasonHeader then
		return
	end
	reasonHeader:ClearAllPoints()
	local rowW = math.max(160, (anchor.GetWidth and anchor:GetWidth()) or 280)
	local mutedRow = CreateFrame("Frame", "BlackListStandaloneDetails_MutedRow", detailsFrame)
	mutedRow:SetSize(rowW, 26)
	mutedRow:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
	local mutedCb = CreateFrame("CheckButton", "BlackListStandaloneDetails_MutedCb", mutedRow, "UICheckButtonTemplate")
	mutedCb:SetSize(24, 24)
	mutedCb:SetPoint("TOPLEFT", mutedRow, "TOPLEFT", 0, 0)
	local mutedLabel = mutedRow:CreateFontString("BlackListStandaloneDetails_MutedLabel", "OVERLAY", "GameFontNormal")
	mutedLabel:SetPoint("LEFT", mutedCb, "RIGHT", 4, 0)
	mutedLabel:SetText(L["OPT_MUTED_CHAT"] or "Mute chat from this player")
	mutedCb:SetScript("OnClick", function(self)
		local idx = detailsFrame.currentPlayerIndex
		if idx and idx > 0 then
			local pl = BlackList:GetPlayerByIndex(idx)
			if pl then
				pl.muted = self:GetChecked() and true or false
			end
		end
	end)
	reasonHeader:SetPoint("TOPLEFT", mutedRow, "BOTTOMLEFT", 0, -12)
end

-- Compat: same content as FormatPlayerDetailsMainBlock (name/realm … faction block).
function BlackList:FormatPlayerDetailsStatLine(player)
	if not player or not self.FormatPlayerDetailsMainBlock then
		return ""
	end
	return self:FormatPlayerDetailsMainBlock(player)
end

--- Faction watermark (Character Create atlas), top-right of edit window.
function BlackList:EnsureStandaloneDetailsFactionDecor(detailsFrame)
	if not detailsFrame then
		return
	end
	local oldSmall = _G["BlackListStandaloneDetails_FactionIcon"]
	if oldSmall and oldSmall.Hide then
		oldSmall:Hide()
	end
	local oldRace = _G["BlackListStandaloneDetails_RaceIcon"]
	if oldRace and oldRace.Hide then
		oldRace:Hide()
	end
	detailsFrame.blackListRaceCornerIcon = nil
	if not detailsFrame.blackListFactionWatermark then
		-- Above ApplyDBMPanelChrome frameBg (BACKGROUND -8); below row text (ARTWORK).
		local w = detailsFrame:CreateTexture(nil, "BACKGROUND", nil, -4)
		w:SetAlpha(0.14)
		w:SetBlendMode("BLEND")
		detailsFrame.blackListFactionWatermark = w
	end
	local wm = detailsFrame.blackListFactionWatermark
	if wm then
		wm:SetDrawLayer("BACKGROUND", -4)
		wm:ClearAllPoints()
		wm:SetPoint("TOPLEFT", detailsFrame, "TOPLEFT", 3, -3)
		wm:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -3, 3)
	end
	if not detailsFrame.blackListFactionTrimTop then
		local tTop = detailsFrame:CreateTexture(nil, "OVERLAY", nil, 2)
		tTop:SetAlpha(0.9)
		detailsFrame.blackListFactionTrimTop = tTop
	end
	if not detailsFrame.blackListFactionTrimBottom then
		local tBottom = detailsFrame:CreateTexture(nil, "OVERLAY", nil, 2)
		tBottom:SetAlpha(0.9)
		detailsFrame.blackListFactionTrimBottom = tBottom
	end
	if not detailsFrame.blackListFactionTrimHooked and detailsFrame.HookScript then
		detailsFrame.blackListFactionTrimHooked = true
		detailsFrame:HookScript("OnSizeChanged", function(self)
			local cfg = self.blackListFactionTrimCfg
			if cfg and applyTrimDecor then
				applyTrimDecor(self, cfg)
			end
		end)
	end
end

local function getScenarioTitleAtlasForFaction(self, player)
	if not self or not player or not self.GetFactionIdForPlayer then
		return nil
	end
	local id = self:GetFactionIdForPlayer(player)
	if id == 1 then
		return "AllianceScenario-TitleBG"
	elseif id == 2 then
		return "HordeScenario-TitleBG"
	end
	return "jailerstower-scenario-TitleBG"
end

applyTrimDecor = function(frame, cfg)
	if not frame or not cfg then
		return
	end
	local top = frame.blackListFactionTrimTop
	local bottom = frame.blackListFactionTrimBottom
	if not top then
		return
	end
	local atlas = cfg.atlas
	if not atlas or atlas == "" then
		frame.blackListFactionTrimAtlas = nil
		top:Hide()
		if bottom then
			bottom:Hide()
		end
		return
	end
	local okTop = pcall(function()
		top:SetAtlas(atlas)
	end)
	local okBottom = true
	if bottom then
		okBottom = pcall(function()
			bottom:SetAtlas(atlas)
		end)
	end
	if not okTop or not okBottom or not top:GetAtlas() then
		frame.blackListFactionTrimAtlas = nil
		top:Hide()
		if bottom then
			bottom:Hide()
		end
		return
	end

	local srcW, srcH = 467, 141
	if C_Texture and C_Texture.GetAtlasInfo then
		local ok, info = pcall(C_Texture.GetAtlasInfo, atlas)
		if ok and info and info.width and info.height and info.width > 0 and info.height > 0 then
			srcW, srcH = info.width, info.height
		end
	end

	local width = cfg.width or 380
	local topFrom = cfg.topFrom or 0
	local topTo = cfg.topTo or 0.36
	local bottomFrom = cfg.bottomFrom or (2 / 3)
	local bottomTo = cfg.bottomTo or 1
	local enableBottom = (cfg.enableBottom == true)
	if topTo <= topFrom or (enableBottom and bottomTo <= bottomFrom) then
		top:Hide()
		if bottom then
			bottom:Hide()
		end
		return
	end

	local topH = math.max(6, math.floor((width * (((topTo - topFrom) * srcH) / srcW)) + 0.5))
	top:SetTexCoord(0, 1, topFrom, topTo)
	top:SetSize(width, topH)
	top:ClearAllPoints()
	top:SetPoint("BOTTOM", frame, "TOP", 0, cfg.topOffset or -32)
	if enableBottom and bottom then
		local bottomH = math.max(6, math.floor((width * (((bottomTo - bottomFrom) * srcH) / srcW)) + 0.5))
		bottom:SetTexCoord(0, 1, bottomFrom, bottomTo)
		bottom:SetSize(width, bottomH)
		bottom:ClearAllPoints()
		bottom:SetPoint("TOP", frame, "BOTTOM", 0, cfg.bottomOffset or 38)
		bottom:Show()
	elseif bottom then
		bottom:Hide()
	end
	if cfg.alpha then
		top:SetAlpha(cfg.alpha)
		if bottom then
			bottom:SetAlpha(cfg.alpha)
		end
	end
	frame.blackListFactionTrimAtlas = atlas
	top:Show()
end

function BlackList:ApplyStandaloneDetailsFactionTrim(detailsFrame, player)
	if not detailsFrame then
		return
	end
	local atlas = getScenarioTitleAtlasForFaction(self, player)
	detailsFrame.blackListFactionTrimCfg = {
		atlas = atlas,
		width = 380,
		topFrom = 0,
		topTo = 0.36,
		bottomFrom = 2 / 3,
		bottomTo = 1,
		topOffset = -32,
		bottomOffset = 38,
		enableBottom = false,
		alpha = 0.9,
	}
	applyTrimDecor(detailsFrame, detailsFrame.blackListFactionTrimCfg)
end

--- Build detail rows, per-row tooltips, and Save button (layout v2).
function BlackList:CreateStandaloneDetailsLayout(detailsFrame)
	if not detailsFrame or detailsFrame.blackListDetailsLayoutV2 then
		return
	end
	if getglobal("BlackListStandaloneDetails_Line1") then
		detailsFrame.blackListDetailsLayoutV2 = true
		self:EnsureStandaloneDetailsFactionDecor(detailsFrame)
		return
	end

	local oldLv = getglobal("BlackListStandaloneDetails_Level")
	if oldLv then
		oldLv:Hide()
	end
	local oldD = getglobal("BlackListStandaloneDetails_Date")
	if oldD then
		oldD:Hide()
	end
	local oldDu = getglobal("BlackListStandaloneDetails_DateUpdated")
	if oldDu then
		oldDu:Hide()
	end

	local function tipRow(frame, locKey, fallback)
		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(L[locKey] or fallback, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		frame:SetScript("OnLeave", GameTooltip_Hide)
	end

	local padX = 16
	local y0 = -38
	local prev = detailsFrame
	local rowW = (detailsFrame.blackListDesiredWidth or 300) - padX * 2

	local function addRow(name, rowName, tipKey, tipFb, isFirst)
		local row = CreateFrame("Frame", rowName, detailsFrame)
		row:SetHeight(18)
		row:EnableMouse(true)
		row:SetWidth(rowW)
		if isFirst then
			row:SetPoint("TOPLEFT", detailsFrame, "TOPLEFT", padX, y0)
		else
			row:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -6)
		end
		local fs = row:CreateFontString(name, "OVERLAY", "GameFontNormal")
		fs:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
		fs:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
		fs:SetJustifyH("LEFT")
		fs:SetJustifyV("TOP")
		tipRow(row, tipKey, tipFb)
		prev = row
		return row, fs
	end

	addRow("BlackListStandaloneDetails_Line1", "BlackListStandaloneDetails_Row1", "TOOLTIP_HINT_NAME_REALM", "Name and realm", true)
	addRow("BlackListStandaloneDetails_Line2", "BlackListStandaloneDetails_Row2", "TOOLTIP_HINT_GUILD", "Guild", false)
	addRow("BlackListStandaloneDetails_Line3", "BlackListStandaloneDetails_Row3", "TOOLTIP_HINT_LEVEL_RACE_CLASS", "Level, race and class", false)
	addRow("BlackListStandaloneDetails_Line4", "BlackListStandaloneDetails_Row4", "TOOLTIP_HINT_FACTION", "Faction", false)

	local extBlock = detailsFrame:CreateFontString("BlackListStandaloneDetails_ExtensionBlock", "OVERLAY", "GameFontNormal")
	extBlock:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -6)
	extBlock:SetWidth(rowW)
	extBlock:SetJustifyH("LEFT")
	prev = extBlock

	local mutedRow = CreateFrame("Frame", "BlackListStandaloneDetails_MutedRow", detailsFrame)
	mutedRow:SetSize(rowW, 26)
	mutedRow:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -10)
	local mutedCb = CreateFrame("CheckButton", "BlackListStandaloneDetails_MutedCb", mutedRow, "UICheckButtonTemplate")
	mutedCb:SetSize(24, 24)
	mutedCb:SetPoint("TOPLEFT", mutedRow, "TOPLEFT", 0, 0)
	local mutedLabel = mutedRow:CreateFontString("BlackListStandaloneDetails_MutedLabel", "OVERLAY", "GameFontNormal")
	mutedLabel:SetPoint("LEFT", mutedCb, "RIGHT", 4, 0)
	mutedLabel:SetText(L["OPT_MUTED_CHAT"] or "Mute chat from this player")
	mutedCb:SetScript("OnClick", function(self)
		local idx = detailsFrame.currentPlayerIndex
		if idx and idx > 0 then
			local pl = BlackList:GetPlayerByIndex(idx)
			if pl then
				pl.muted = self:GetChecked() and true or false
			end
		end
	end)

	local reasonHeader = detailsFrame:CreateFontString("BlackListStandaloneDetails_ReasonHeader", "OVERLAY", "GameFontNormalLarge")
	reasonHeader:SetPoint("TOPLEFT", mutedRow, "BOTTOMLEFT", 0, -12)
	reasonHeader:SetTextColor(1, 1, 0.41)
	reasonHeader:SetText(L["REASON_HEADER"] or L["REASON"] or "Reason:")

	-- Bottom row: info (dates tooltip) + Save — widens panel slightly vs inline dates.
	local bottomRow = CreateFrame("Frame", "BlackListStandaloneDetails_BottomRow", detailsFrame)
	bottomRow:SetHeight(28)
	bottomRow:SetPoint("BOTTOMLEFT", detailsFrame, "BOTTOMLEFT", padX, 12)
	bottomRow:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -padX, 12)

	local infoDatesBtn = CreateFrame("Button", "BlackListStandaloneDetails_DatesInfoBtn", bottomRow)
	infoDatesBtn:SetSize(22, 22)
	infoDatesBtn:SetPoint("LEFT", bottomRow, "LEFT", 0, 0)
	infoDatesBtn:SetNormalTexture("Interface\\common\\help-i")
	infoDatesBtn:SetPushedTexture("Interface\\common\\help-i")
	infoDatesBtn:SetHighlightTexture("Interface\\common\\help-i", "ADD")
	infoDatesBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local idx = detailsFrame.currentPlayerIndex
		local p = idx and BlackList:GetPlayerByIndex(idx)
		if p and BlackList.FormatPlayerDetailsRichDateBlock then
			local block = BlackList:FormatPlayerDetailsRichDateBlock(p)
			if block and strtrim(block) ~= "" then
				for line in string.gmatch(block, "[^\n]+") do
					GameTooltip:AddLine(line, 1, 1, 1, true)
				end
			else
				GameTooltip:AddLine(L["DETAILS_NO_INFO"] or "—", 0.53, 0.53, 0.53, false)
			end
		else
			GameTooltip:AddLine(L["DETAILS_NO_INFO"] or "—", 0.53, 0.53, 0.53, false)
		end
		GameTooltip:Show()
	end)
	infoDatesBtn:SetScript("OnLeave", GameTooltip_Hide)

	local saveBtn = CreateFrame("Button", "BlackListStandaloneDetails_SaveBtn", bottomRow, "UIPanelButtonTemplate")
	saveBtn:SetSize(110, 24)
	saveBtn:SetPoint("RIGHT", bottomRow, "RIGHT", 0, 0)
	saveBtn:SetText(L["BUTTON_SAVE"] or "Save")

	local reasonBg = CreateFrame("Frame", "BlackListStandaloneDetails_ReasonBg", detailsFrame, "BackdropTemplate")
	reasonBg:SetPoint("TOPLEFT", reasonHeader, "BOTTOMLEFT", 0, -8)
	reasonBg:SetPoint("BOTTOMRIGHT", bottomRow, "TOPRIGHT", 0, 8)
	reasonBg:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	reasonBg:SetBackdropColor(0, 0, 0, 0.5)

	local reasonBox = CreateFrame("ScrollFrame", "BlackListStandaloneDetails_ReasonScroll", reasonBg, "ScrollFrameTemplate")
	local sbTrack = 16
	reasonBox:SetPoint("TOPLEFT", reasonBg, "TOPLEFT", 8, -8)
	reasonBox:SetPoint("BOTTOMRIGHT", reasonBg, "BOTTOMRIGHT", -8, 8)

	local reasonText = CreateFrame("EditBox", "BlackListStandaloneDetails_ReasonText", reasonBox)
	reasonText:SetWidth(math.max(160, rowW - 50))
	reasonText:SetHeight(100)
	reasonText:SetMultiLine(true)
	reasonText:SetAutoFocus(false)
	reasonText:SetFontObject(GameFontHighlight)
	reasonText:SetTextInsets(5, 5, 5, 5)
	reasonBox:SetScrollChild(reasonText)

	local function SyncReasonScrollMetrics()
		local w = reasonBox:GetWidth() - sbTrack
		if w > 48 then
			reasonText:SetWidth(w)
		end
		if reasonBox.UpdateScrollChildRect then
			pcall(function()
				reasonBox:UpdateScrollChildRect()
			end)
		end
	end

	reasonBox:SetScript("OnSizeChanged", function()
		SyncReasonScrollMetrics()
	end)
	SyncReasonScrollMetrics()

	local sb = reasonBox.ScrollBar
	if sb and sb.ClearAllPoints then
		sb:ClearAllPoints()
		sb:SetPoint("TOPRIGHT", reasonBox, "TOPRIGHT", -2, -2)
		sb:SetPoint("BOTTOMRIGHT", reasonBox, "BOTTOMRIGHT", -2, 2)
		sb:SetFrameLevel((reasonBox:GetFrameLevel() or 0) + 3)
		if sb.Update then
			pcall(function() sb:Update() end)
		end
	end

	local function SaveReason()
		local index = detailsFrame.currentPlayerIndex
		if index and index > 0 then
			local player = BlackList:GetPlayerByIndex(index)
			if player then
				local text = reasonText:GetText()
				if text ~= player["reason"] then
					player["reason"] = text
					local sv = string.format(L["REASON_SAVED_FOR"] or "Reason saved for %s", player["name"])
					BlackList:AddMessage(BlackList:FormatChatAlertFromFormatted(player, sv, "listAdd"), "styled")
				end
			end
		end
	end

	reasonText:SetScript("OnEditFocusLost", SaveReason)
	reasonText:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		SaveReason()
	end)
	saveBtn:SetScript("OnClick", function()
		SaveReason()
		reasonText:ClearFocus()
		detailsFrame:Hide()
	end)

	detailsFrame.SaveReason = SaveReason

	if detailsFrame.HookScript then
		detailsFrame:HookScript("OnHide", function()
			SaveReason()
		end)
	end
	if detailsFrame.HookScript and not detailsFrame.blackListDetailsReasonResizeHook then
		detailsFrame.blackListDetailsReasonResizeHook = true
		detailsFrame:HookScript("OnSizeChanged", function(self)
			local rs = _G["BlackListStandaloneDetails_ReasonScroll"]
			if rs and rs.GetWidth then
				local w = rs:GetWidth() - 16
				local rt = _G["BlackListStandaloneDetails_ReasonText"]
				if rt and w > 48 then
					rt:SetWidth(w)
				end
			end
		end)
	end

	self:EnsureStandaloneDetailsFactionDecor(detailsFrame)

	detailsFrame.blackListDetailsLayoutV2 = true
end

function BlackList:ShowStandaloneDetails()
	local player = self:GetPlayerByIndex(self:GetSelectedBlackList())
	if not player then return end
	
	-- Create or get details frame
	local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
	if not detailsFrame then
		-- Same NineSlice frame + title bar as the list and Add Player dialog (ApplyDBMPanelChrome).
		detailsFrame = U.createChromeParent("BlackListStandaloneDetailsFrame", UIParent, 320, 392)
		detailsFrame:SetClampedToScreen(true)
		detailsFrame:SetFrameStrata("DIALOG")
		detailsFrame:SetFrameLevel(250)
		detailsFrame.blackListEnableResize = true
		detailsFrame.blackListResizeMinW = 320
		detailsFrame.blackListResizeMinH = 380
		detailsFrame.blackListTitleDraggable = true
		self:ApplyDBMPanelChrome(detailsFrame, L["WINDOW_TITLE_EDIT"] or "Edit", "BlackListStandaloneDetails_Title")
		U.anchorStandaloneDetailsFrame(detailsFrame)
		U.reapplyPanelSize(detailsFrame)

		if detailsFrame.HookScript then
			detailsFrame:HookScript("OnShow", function()
				U.anchorStandaloneDetailsFrame(detailsFrame)
				U.safeStopMovingOrSizing(detailsFrame)
				U.scheduleReapplyPanelSize(detailsFrame)
				local optionsFrame = getglobal("BlackListOptionsFrame_New")
				if optionsFrame and optionsFrame:IsVisible() then
					optionsFrame:Hide()
				end
			end)
		end
	end

	if detailsFrame and not detailsFrame.blackListDetailsLayoutV2 then
		self:CreateStandaloneDetailsLayout(detailsFrame)
	end
	if detailsFrame and not getglobal("BlackListStandaloneDetails_MutedCb") and getglobal("BlackListStandaloneDetails_BottomRow") then
		self:InsertMutedRowInDetails(detailsFrame)
	end
	self:EnsureStandaloneDetailsFactionDecor(detailsFrame)

	-- Save previous player's reason before showing new one
	if detailsFrame.SaveReason and detailsFrame.currentPlayerIndex then
		detailsFrame.SaveReason()
	end
	
	-- Store the current player index for saving
	detailsFrame.currentPlayerIndex = self:GetSelectedBlackList()
	
	-- Update details
	local title = getglobal("BlackListStandaloneDetails_Title")
	if title then
		title:SetText(L["WINDOW_TITLE_EDIT"] or "Edit")
	end

	local mainLines = self.GetPlayerDetailsMainLines and self:GetPlayerDetailsMainLines(player) or {}
	local fs1 = getglobal("BlackListStandaloneDetails_Line1")
	local fs2 = getglobal("BlackListStandaloneDetails_Line2")
	local row2 = getglobal("BlackListStandaloneDetails_Row2")
	local row1 = getglobal("BlackListStandaloneDetails_Row1")
	local row3 = getglobal("BlackListStandaloneDetails_Row3")
	local fs3 = getglobal("BlackListStandaloneDetails_Line3")
	local fs4 = getglobal("BlackListStandaloneDetails_Line4")
	if fs1 then
		fs1:SetText(mainLines[1] or "")
	end
	if fs2 and row2 and row1 and row3 and fs3 and fs4 then
		if #mainLines == 4 then
			fs2:SetText(mainLines[2] or "")
			row2:Show()
			row2:SetHeight(18)
			fs3:SetText(mainLines[3] or "")
			fs4:SetText(mainLines[4] or "")
			row3:ClearAllPoints()
			row3:SetPoint("TOPLEFT", row2, "BOTTOMLEFT", 0, -6)
		else
			fs2:SetText("")
			row2:Hide()
			fs3:SetText(mainLines[2] or "")
			fs4:SetText(mainLines[3] or "")
			row3:ClearAllPoints()
			row3:SetPoint("TOPLEFT", row1, "BOTTOMLEFT", 0, -6)
		end
	end
	local extFs = getglobal("BlackListStandaloneDetails_ExtensionBlock")
	if extFs and self.GetPlayerDetailsExtensionLines then
		local ext = self:GetPlayerDetailsExtensionLines(player)
		if #ext > 0 then
			extFs:SetText(table.concat(ext, "\n"))
			extFs:Show()
		else
			extFs:SetText("")
			extFs:Hide()
		end
	end

	self:EnsureEntryFields(player)
	local mutedCb = getglobal("BlackListStandaloneDetails_MutedCb")
	if mutedCb then
		mutedCb:SetChecked(player.muted and true or false)
	end

	local reasonHeader = getglobal("BlackListStandaloneDetails_ReasonHeader")
	if reasonHeader then
		reasonHeader:SetText(L["REASON_HEADER"] or L["REASON"] or "Reason:")
		reasonHeader:SetTextColor(1, 1, 0.41)
	end

	local reasonText = getglobal("BlackListStandaloneDetails_ReasonText")
	if reasonText then
		reasonText:SetText(player["reason"] or "")
	end

	local wm = detailsFrame.blackListFactionWatermark
	if wm then
		local id = self.GetFactionIdForPlayer and self:GetFactionIdForPlayer(player)
		if id == 1 or id == 2 then
			local r, g, b = 0.75, 0.75, 0.75
			if self.GetSpecificFactionColorRGB then
				r, g, b = self:GetSpecificFactionColorRGB(id)
			end
			wm:SetColorTexture(r, g, b, 0.18)
			wm:Show()
		else
			wm:Hide()
		end
	end
	self:ApplyStandaloneDetailsFactionTrim(detailsFrame, player)
	U.anchorStandaloneDetailsFrame(detailsFrame)
	U.safeStopMovingOrSizing(detailsFrame)
	U.reapplyPanelSize(detailsFrame)
	detailsFrame:Show()
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if detailsFrame:IsShown() then
				U.anchorStandaloneDetailsFrame(detailsFrame)
				U.safeStopMovingOrSizing(detailsFrame)
				U.reapplyPanelSize(detailsFrame)
			end
		end)
	end
end
