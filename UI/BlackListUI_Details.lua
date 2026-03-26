local _, Addon = ...
local L = Addon.L
local U = Addon.UI

-- Compat: same content as FormatPlayerDetailsMainBlock (name/realm … faction block).
function BlackList:FormatPlayerDetailsStatLine(player)
	if not player or not self.FormatPlayerDetailsMainBlock then
		return ""
	end
	return self:FormatPlayerDetailsMainBlock(player)
end

--- Build detail rows, per-row tooltips, and Save button (layout v2).
function BlackList:CreateStandaloneDetailsLayout(detailsFrame)
	if not detailsFrame or detailsFrame.blackListDetailsLayoutV2 then
		return
	end
	if getglobal("BlackListStandaloneDetails_Line1") then
		detailsFrame.blackListDetailsLayoutV2 = true
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
	local y0 = -64
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

	local datesFs = detailsFrame:CreateFontString("BlackListStandaloneDetails_DatesBlock", "OVERLAY", "GameFontNormal")
	datesFs:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -10)
	datesFs:SetWidth(rowW)
	datesFs:SetJustifyH("LEFT")

	local reasonHeader = detailsFrame:CreateFontString("BlackListStandaloneDetails_ReasonHeader", "OVERLAY", "GameFontNormalLarge")
	reasonHeader:SetPoint("TOPLEFT", datesFs, "BOTTOMLEFT", 0, -12)
	reasonHeader:SetTextColor(1, 1, 0.41)
	reasonHeader:SetText(L["REASON_HEADER"] or L["REASON"] or "Reason:")

	local reasonBg = CreateFrame("Frame", "BlackListStandaloneDetails_ReasonBg", detailsFrame, "BackdropTemplate")
	reasonBg:SetPoint("TOPLEFT", reasonHeader, "BOTTOMLEFT", 0, -8)
	reasonBg:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -padX, 44)
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

	local saveBtn = CreateFrame("Button", "BlackListStandaloneDetails_SaveBtn", detailsFrame, "UIPanelButtonTemplate")
	saveBtn:SetSize(110, 24)
	saveBtn:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -padX, 12)
	saveBtn:SetText(L["BUTTON_SAVE"] or "Save")

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
	detailsFrame.blackListDetailsLayoutV2 = true
end

function BlackList:ShowStandaloneDetails()
	local player = self:GetPlayerByIndex(self:GetSelectedBlackList())
	if not player then return end
	
	-- Create or get details frame
	local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
	if not detailsFrame then
		-- Same NineSlice frame + title bar as the list and Add Player dialog (ApplyDBMPanelChrome).
		detailsFrame = U.createChromeParent("BlackListStandaloneDetailsFrame", UIParent, 320, 380)
		detailsFrame:SetClampedToScreen(true)
		detailsFrame:SetFrameStrata("DIALOG")
		detailsFrame:SetFrameLevel(250)
		detailsFrame.blackListEnableResize = true
		detailsFrame.blackListResizeMinW = 280
		detailsFrame.blackListResizeMinH = 280
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

	local fs1 = getglobal("BlackListStandaloneDetails_Line1")
	if fs1 then
		fs1:SetText(self:FormatRichNameRealmLine(player))
	end
	local fs2 = getglobal("BlackListStandaloneDetails_Line2")
	local row2 = getglobal("BlackListStandaloneDetails_Row2")
	local row1 = getglobal("BlackListStandaloneDetails_Row1")
	local row3 = getglobal("BlackListStandaloneDetails_Row3")
	local gLine = self:FormatRichGuildLine(player)
	if fs2 and row2 and row1 and row3 then
		if gLine ~= "" then
			fs2:SetText(gLine)
			row2:Show()
			row2:SetHeight(18)
			row3:ClearAllPoints()
			row3:SetPoint("TOPLEFT", row2, "BOTTOMLEFT", 0, -6)
		else
			fs2:SetText("")
			row2:Hide()
			row3:ClearAllPoints()
			row3:SetPoint("TOPLEFT", row1, "BOTTOMLEFT", 0, -6)
		end
	end
	local fs3 = getglobal("BlackListStandaloneDetails_Line3")
	if fs3 then
		fs3:SetText(self:FormatRichLvlRaceClassLine(player))
	end
	local fs4 = getglobal("BlackListStandaloneDetails_Line4")
	if fs4 then
		fs4:SetText(self:FormatRichFactionLine(player))
	end

	local datesBlock = getglobal("BlackListStandaloneDetails_DatesBlock")
	if datesBlock and self.FormatPlayerDetailsRichDateBlock then
		datesBlock:SetText(self:FormatPlayerDetailsRichDateBlock(player))
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
