local _, Addon = ...
local L = Addon.L
local U = Addon.UI


-- Inserts all of the UI elements
function BlackList:InsertUI()

	-- Create standalone BlackList window (no FriendsFrame integration)
	self:CreateStandaloneWindow();

end

function BlackList:ShowStandaloneListTooltip(anchor, playerIndex)
	if not anchor or not GameTooltip then
		return
	end
	local player = self:GetPlayerByIndex(playerIndex)
	if not player then
		GameTooltip:Hide()
		return
	end
	local function tipRich(text, wrap)
		if not text or text == "" then
			return
		end
		pcall(function()
			GameTooltip:AddLine(text, 1, 1, 1, wrap and true or false)
		end)
	end
	GameTooltip:SetOwner(anchor, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()
	local mainLines = (type(self.GetPlayerDetailsMainLines) == "function" and self:GetPlayerDetailsMainLines(player)) or {}
	for i = 1, #mainLines do
		tipRich(mainLines[i], true)
	end
	local extFn = self.GetPlayerDetailsExtensionTooltipLines or self.GetPlayerDetailsExtensionLines
	if type(extFn) == "function" then
		local ext = extFn(self, player) or {}
		if #ext > 0 then
			GameTooltip:AddLine(" ", 1, 1, 1)
		end
		for i = 1, #ext do
			tipRich(ext[i], true)
		end
	end
	GameTooltip:AddLine(" ", 1, 1, 1)
	local rh = L["REASON_HEADER"] or L["REASON"] or "Reason:"
	GameTooltip:AddLine(rh, 1, 1, 0.41, false)
	local rs = player.reason
	if rs and strtrim(tostring(rs)) ~= "" then
		tipRich(rs, true)
	else
		GameTooltip:AddLine(L["DETAILS_NO_INFO"] or "—", 0.65, 0.65, 0.65, true)
	end
	GameTooltip:AddLine(" ", 1, 1, 1)
	local dateLines = (type(self.GetPlayerDetailsDateLines) == "function" and self:GetPlayerDetailsDateLines(player)) or {}
	for i = 1, #dateLines do
		tipRich(dateLines[i], false)
	end
	U.applyStandaloneTooltipPlayerColors(GameTooltip, self, player)
	GameTooltip:Show()
end

function BlackList:CreateStandaloneWindow()
	local minIconGap = math.max(2, (U.standaloneIconBarGap or 8) - 4)
	local minBarContentW = (U.standaloneIconBarBtn * 6) + (minIconGap * 5)
	local minWindowW = math.max(268, minBarContentW + 32)
	local initialWindowW = math.max(300, minWindowW + 4)
	local frame = U.createChromeParent("BlackListStandaloneFrame", UIParent, initialWindowW, 392)
	-- Position like FriendsFrame/CharacterFrame (left side of screen)
	frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -116)
	frame:SetClampedToScreen(true)
	frame.blackListEnableResize = true
	frame.blackListResizeMinW = minWindowW
	frame.blackListResizeMinH = 300
	frame.blackListTitleDraggable = true
	U.applyEvergreenTopDecor(frame, { width = 300, toY = 0.36 })

	frame:SetScript("OnShow", function(self)
		U.scheduleReapplyPanelSize(self)
		if C_Timer and C_Timer.After then
			C_Timer.After(0.05, function()
				if self and self:IsShown() then
					U.reapplyPanelSize(self)
				end
			end)
		end
		local h = getglobal("BlackListStandalone_Hint")
		if h then
			h:SetText(L["REASON_EDIT_HINT"] or "")
		end
	end)

	self:ApplyDBMPanelChrome(frame, L["BLACKLIST"])
	U.scheduleReapplyPanelSize(frame)

	local baseLvl = frame:GetFrameLevel()

	local iconBarShellH = U.standaloneIconBarBtn + U.iconBarShellPad * 2
	local iconBarShell = CreateFrame("Frame", "BlackListStandaloneIconBarShell", frame, "BackdropTemplate")
	iconBarShell:SetFrameLevel(baseLvl + 2)
	U.applyStandaloneSectionBackdrop(iconBarShell)
	iconBarShell:SetHeight(iconBarShellH)
	iconBarShell:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, U.iconBarTop)
	iconBarShell:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, U.iconBarTop)

	local iconBar = CreateFrame("Frame", "BlackListStandaloneIconBar", iconBarShell)
	iconBar:SetFrameLevel((iconBarShell:GetFrameLevel() or 0) + 20)
	iconBar:SetPoint("TOPLEFT", iconBarShell, "TOPLEFT", U.iconBarShellPad, -U.iconBarShellPad)
	iconBar:SetPoint("BOTTOMRIGHT", iconBarShell, "BOTTOMRIGHT", -U.iconBarShellPad, U.iconBarShellPad)
	local iconGap = math.max(2, (U.standaloneIconBarGap or 8) - 4)

	local listTop = U.iconBarTop - iconBarShellH - 10
	local listBottomReserve = U.legendBottom + U.legendRowH + 6

	local listShell = CreateFrame("Frame", "BlackListStandaloneListShell", frame, "BackdropTemplate")
	listShell:SetFrameLevel(baseLvl + 2)
	U.applyStandaloneSectionBackdrop(listShell)
	listShell:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, listTop)
	listShell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, listBottomReserve)

	local currentSearchFilter = ""
	local function getSearchTextNorm()
		return strtrim(tostring(currentSearchFilter or "")):lower()
	end
	local function matchesSearch(player)
		local q = getSearchTextNorm()
		if q == "" then
			return true
		end
		if not player then
			return false
		end
		local fields = {
			tostring(player.name or ""),
			tostring(player.realm or ""),
			tostring(player.class or ""),
			tostring(player.race or ""),
			tostring(player.faction or ""),
			tostring(player.guild or ""),
			tostring(player.reason or ""),
		}
		for i = 1, #fields do
			if string.lower(fields[i]):find(q, 1, true) then
				return true
			end
		end
		return false
	end

	local searchBoxContainer = CreateFrame("Frame", "BlackListStandaloneSearchContainer", listShell, "BackdropTemplate")
	searchBoxContainer:SetFrameLevel((listShell:GetFrameLevel() or baseLvl) + 4)
	searchBoxContainer:SetHeight(24)
	searchBoxContainer:SetPoint("TOPLEFT", listShell, "TOPLEFT", U.listShellPad, -U.listShellPad)
	searchBoxContainer:SetPoint("TOPRIGHT", listShell, "TOPRIGHT", -U.listShellPad, -U.listShellPad)
	local searchEditBox, searchPlaceholder
	local searchVisible = false
	local okSearchTemplate = pcall(function()
		searchEditBox = CreateFrame("EditBox", "BlackListStandalone_SearchBox", searchBoxContainer, "SearchBoxTemplate")
	end)
	if okSearchTemplate and searchEditBox then
		searchEditBox:SetPoint("LEFT", 6, 0)
		searchEditBox:SetPoint("RIGHT", -6, 0)
		searchEditBox:SetPoint("TOP", 0, 0)
		searchEditBox:SetPoint("BOTTOM", 0, 0)
		searchEditBox:SetAutoFocus(false)
		searchEditBox:SetMaxLetters(80)
		if searchEditBox.Instructions then
			searchEditBox.Instructions:SetText(L["FILTER_PLACEHOLDER"] or "Filter...")
		end
		searchEditBox:SetScript("OnTextChanged", function(self)
			if SearchBoxTemplate_OnTextChanged then
				SearchBoxTemplate_OnTextChanged(self)
			end
			local text = self:GetText()
			currentSearchFilter = (text and text:len() > 0) and text or ""
			BlackList:UpdateStandaloneUI()
		end)
	else
		searchEditBox = CreateFrame("EditBox", "BlackListStandalone_SearchBox", searchBoxContainer)
		if searchBoxContainer.SetBackdrop then
			searchBoxContainer:SetBackdrop({
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 8,
				insets = { left = 4, right = 4, top = 2, bottom = 2 },
			})
			searchBoxContainer:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
			if searchBoxContainer.SetBackdropBorderColor then
				searchBoxContainer:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)
			end
		end
		searchEditBox:SetPoint("LEFT", 8, 0)
		searchEditBox:SetPoint("RIGHT", -8, 0)
		searchEditBox:SetPoint("TOP", 0, 0)
		searchEditBox:SetPoint("BOTTOM", 0, 0)
		searchEditBox:SetFontObject("GameFontHighlight")
		searchEditBox:SetAutoFocus(false)
		searchEditBox:SetMaxLetters(80)
		searchPlaceholder = searchEditBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		searchPlaceholder:SetPoint("LEFT", searchEditBox, "LEFT", 0, 0)
		searchPlaceholder:SetText(L["FILTER_PLACEHOLDER"] or "Filter...")
		searchPlaceholder:SetTextColor(0.5, 0.5, 0.5, 0.8)
		searchEditBox:SetScript("OnTextChanged", function(self)
			local text = self:GetText()
			if searchPlaceholder then
				searchPlaceholder:SetShown(not text or text:len() == 0)
			end
			currentSearchFilter = (text and text:len() > 0) and text or ""
			BlackList:UpdateStandaloneUI()
		end)
		searchEditBox:SetScript("OnEditFocusGained", function()
			if searchPlaceholder then
				searchPlaceholder:Hide()
			end
		end)
		searchEditBox:SetScript("OnEditFocusLost", function(self)
			if searchPlaceholder and (not self:GetText() or self:GetText():len() == 0) then
				searchPlaceholder:Show()
			end
		end)
	end
	searchEditBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		self:SetText("")
		currentSearchFilter = ""
		BlackList:UpdateStandaloneUI()
	end)
	frame.blackListStandaloneSearchFilterGet = getSearchTextNorm
	frame.blackListStandaloneMatchesSearch = matchesSearch

	-- List: WowScrollBoxList + MinimalScrollBar (same pattern as EPF skins in options)
	local listContainer = CreateFrame("Frame", "BlackListStandaloneListContainer", listShell)
	listContainer:SetFrameLevel((listShell:GetFrameLevel() or 0) + 4)
	listContainer:SetPoint("TOPLEFT", searchBoxContainer, "BOTTOMLEFT", 0, -6)
	listContainer:SetPoint("BOTTOMRIGHT", listShell, "BOTTOMRIGHT", -U.listShellPad, U.listShellPad)
	local function applySearchVisibility()
		if searchVisible then
			searchBoxContainer:Show()
			listContainer:ClearAllPoints()
			listContainer:SetPoint("TOPLEFT", searchBoxContainer, "BOTTOMLEFT", 0, -6)
			listContainer:SetPoint("BOTTOMRIGHT", listShell, "BOTTOMRIGHT", -U.listShellPad, U.listShellPad)
		else
			searchBoxContainer:Hide()
			listContainer:ClearAllPoints()
			listContainer:SetPoint("TOPLEFT", listShell, "TOPLEFT", U.listShellPad, -U.listShellPad)
			listContainer:SetPoint("BOTTOMRIGHT", listShell, "BOTTOMRIGHT", -U.listShellPad, U.listShellPad)
			if searchEditBox then
				searchEditBox:ClearFocus()
				searchEditBox:SetText("")
			end
			currentSearchFilter = ""
		end
		BlackList:UpdateStandaloneUI()
	end

	local legendBar = CreateFrame("Frame", "BlackListStandaloneLegendBar", frame)
	legendBar:SetFrameLevel(baseLvl + 20)
	legendBar:SetHeight(U.legendRowH)
	legendBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, U.legendBottom)
	legendBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, U.legendBottom)

	local helpBtn = CreateFrame("Button", "BlackListStandalone_HelpButton", legendBar)
	helpBtn:SetSize(22, 22)
	helpBtn:SetPoint("LEFT", legendBar, "LEFT", 2, 0)
	helpBtn:SetScript("OnEnter", function(self)
		U.showStandaloneHelpTooltip(self)
	end)
	helpBtn:SetScript("OnLeave", GameTooltip_Hide)
	helpBtn:RegisterForClicks("LeftButtonUp")
	local helpInfoPath = "Interface\\common\\help-i"
	helpBtn:SetNormalTexture(helpInfoPath)
	helpBtn:SetPushedTexture(helpInfoPath)
	helpBtn:SetHighlightTexture(helpInfoPath, "ADD")
	helpBtn:SetFrameLevel((legendBar:GetFrameLevel() or 0) + 2)

	local hint = legendBar:CreateFontString("BlackListStandalone_Hint", "OVERLAY", "GameFontNormalSmall")
	hint:SetPoint("TOPLEFT", helpBtn, "TOPRIGHT", 10, -2)
	hint:SetPoint("BOTTOMRIGHT", legendBar, "BOTTOMRIGHT", -6, 2)
	hint:SetJustifyH("LEFT")
	hint:SetJustifyV("TOP")
	hint:SetTextColor(0.75, 0.75, 0.75)
	hint:SetText(L["REASON_EDIT_HINT"] or "")

	local minimalBar = CreateFrame("EventFrame", "BlackListStandaloneListScrollBar", frame, "MinimalScrollBar")
	minimalBar:SetFrameLevel(baseLvl + 18)
	minimalBar:SetPoint("TOPLEFT", listShell, "TOPRIGHT", 6, 0)
	minimalBar:SetPoint("BOTTOMLEFT", listShell, "BOTTOMRIGHT", 6, 0)

	local scrollBox = CreateFrame("Frame", "BlackListStandaloneScrollBox", listContainer, "WowScrollBoxList")
	scrollBox:SetPoint("TOPLEFT", 0, 0)
	scrollBox:SetPoint("BOTTOMRIGHT", 0, 0)
	frame.blackListStandaloneScrollBox = scrollBox

	local function InitStandaloneListRow(button, elementData)
		U.applyEPFListRowStyle(button)
		-- 9-slice list atlases look off-center at full bleed on short rows; symmetric insets + centered text.
		local hInset, vInset = 2, 1
		if button.SelectedTexture then
			button.SelectedTexture:ClearAllPoints()
			button.SelectedTexture:SetPoint("TOPLEFT", button, "TOPLEFT", hInset, -vInset)
			button.SelectedTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -hInset, vInset)
		end
		local highlight = button.GetHighlightTexture and button:GetHighlightTexture()
		if highlight then
			highlight:ClearAllPoints()
			highlight:SetPoint("TOPLEFT", button, "TOPLEFT", hInset, -vInset)
			highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -hInset, vInset)
		end
		if not button.Text then
			button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		end
		if not button.FactionIcon then
			button.FactionIcon = button:CreateTexture(nil, "ARTWORK")
			-- Atlas source is 22x28; keep ratio when constraining to 22 height => ~17x22.
			button.FactionIcon:SetSize(14, 18)
			button.FactionIcon:SetPoint("LEFT", button, "LEFT", 10, 0)
		end
		button.Text:ClearAllPoints()
		button.Text:SetPoint("TOPLEFT", button, "TOPLEFT", 33, 0)
		button.Text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 0)
		button.Text:SetJustifyH("LEFT")
		button.Text:SetJustifyV("MIDDLE")
		local index = elementData.playerIndex or elementData.index
		button:SetID(index)
		local player = BlackList:GetPlayerByIndex(index)
		if player then
			button.Text:SetText(BlackList:FormatStandaloneListLine(player))
			local fid = BlackList.GetFactionIdForPlayer and BlackList:GetFactionIdForPlayer(player) or nil
			if fid == 1 or fid == 2 then
				local atlas = (fid == 1) and "communities-create-button-wow-alliance" or "communities-create-button-wow-horde"
				local okAtlas = pcall(function()
					button.FactionIcon:SetAtlas(atlas)
				end)
				if okAtlas and button.FactionIcon:GetAtlas() then
					button.FactionIcon:SetTexCoord(0, 1, 0, 1)
					button.FactionIcon:SetVertexColor(1, 1, 1, 1)
					button.FactionIcon:Show()
				else
					button.FactionIcon:Hide()
				end
			elseif BlackList.PlayerEntryNeedsInfo and BlackList:PlayerEntryNeedsInfo(player) then
				local okAtlas = pcall(function()
					button.FactionIcon:SetAtlas("QuestLegendaryTurnin")
				end)
				if okAtlas and button.FactionIcon:GetAtlas() then
					button.FactionIcon:SetTexCoord(0, 1, 0, 1)
					button.FactionIcon:SetVertexColor(1, 1, 1, 1)
					button.FactionIcon:Show()
				else
					button.FactionIcon:Hide()
				end
			else
				button.FactionIcon:Hide()
			end
		else
			button.Text:SetText("")
			button.FactionIcon:Hide()
		end
		local sel = BlackList:GetSelectedBlackList()
		if button.SelectedTexture then
			button.SelectedTexture:SetShown(index == sel)
		end
		button:SetScript("OnEnter", function(self)
			local idx = self:GetID()
			if idx and idx > 0 then
				BlackList:ShowStandaloneListTooltip(self, idx)
			end
		end)
		button:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		button:SetScript("OnClick", function(self)
			local idx = self:GetID()
			if not idx or idx < 1 then
				return
			end
			local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
			if detailsFrame and detailsFrame.SaveReason then
				detailsFrame.SaveReason()
			end
			local now = GetTime()
			local isDouble = (U.standaloneListClickState.index == idx) and ((now - U.standaloneListClickState.t) <= U.standaloneDoubleClickWindow)
			U.standaloneListClickState.t = now
			U.standaloneListClickState.index = idx
			BlackList:SetSelectedBlackList(idx)
			BlackList:UpdateStandaloneUI()
			if detailsFrame and detailsFrame:IsShown() then
				-- When editor is already open, switch to clicked row immediately.
				BlackList:ShowStandaloneDetails()
			elseif isDouble then
				U.standaloneListClickState.t = 0
				U.standaloneListClickState.index = 0
				BlackList:ShowStandaloneDetails()
			end
		end)
	end

	local view = CreateScrollBoxListLinearView and CreateScrollBoxListLinearView() or CreateScrollBoxListGridView(1)
	view:SetElementExtent(20)
	view:SetElementInitializer("Button", InitStandaloneListRow)
	view:SetPadding(0, 0, 0, 0, 0)
	if ScrollUtil and ScrollUtil.InitScrollBoxListWithScrollBar then
		ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, minimalBar, view)
	end

	-- Top bar: [+] [target] [edit] [−] … [options] (legend below)
	local addBtn = CreateFrame("Button", "BlackListStandalone_AddButton", iconBar)
	local texAdd = U.styleStandaloneIconButton(addBtn)
	U.applyStandaloneAtlasTexture(texAdd, { "GreenCross" }, "Interface\\Buttons\\UI-PlusButton-Up", nil)
	U.setStandaloneIconTint(texAdd, 0.2, 0.95, 0.35, 1)
	addBtn:SetPoint("LEFT", iconBar, "LEFT", 0, 0)
	addBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["ADD_PLAYER_POPUP"] or "", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	addBtn:SetScript("OnLeave", GameTooltip_Hide)
	addBtn:SetScript("OnClick", function()
		BlackList:ShowAddPlayerDialog()
	end)

	local addTargetBtn = CreateFrame("Button", "BlackListStandalone_AddTargetButton", iconBar)
	local texTgt = U.styleStandaloneIconButton(addTargetBtn)
	texTgt:SetTexture(U.assetsAim)
	texTgt:SetTexCoord(0, 1, 0, 1)
	U.setStandaloneIconTint(texTgt, 1, 1, 1, 1)
	addTargetBtn:SetPoint("LEFT", addBtn, "RIGHT", iconGap, 0)
	addTargetBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["ADD_TARGET"] or "", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	addTargetBtn:SetScript("OnLeave", GameTooltip_Hide)
	addTargetBtn:SetScript("OnClick", function()
		BlackList:AddPlayer("target")
		BlackList:UpdateStandaloneUI()
	end)

	local editBtn = CreateFrame("Button", "BlackListStandalone_EditButton", iconBar)
	local texEdit = U.styleStandaloneIconButton(editBtn)
	U.applyStandaloneAtlasTexture(texEdit, { "poi-workorders" }, U.assetsPencil, nil)
	U.setStandaloneIconTint(texEdit, 1, 1, 1, 1)
	editBtn:SetPoint("LEFT", addTargetBtn, "RIGHT", iconGap, 0)
	editBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local tip = L["TOOLTIP_EDIT_BTN"] or (L["ROW_MENU_EDIT"] or "Edit"):gsub("…", ""):gsub("%.%.%.$", "")
		GameTooltip:AddLine(tip, 1, 1, 1, false)
		GameTooltip:Show()
	end)
	editBtn:SetScript("OnLeave", GameTooltip_Hide)
	editBtn:SetScript("OnClick", function()
		local index = BlackList:GetSelectedBlackList()
		if not index or index < 1 then
			return
		end
		local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
		if detailsFrame and detailsFrame:IsShown() and detailsFrame.currentPlayerIndex == index then
			if detailsFrame.SaveReason then
				detailsFrame.SaveReason()
			end
			detailsFrame:Hide()
			return
		end
		BlackList:SetSelectedBlackList(index)
		BlackList:UpdateStandaloneUI()
		BlackList:ShowStandaloneDetails()
	end)

	local removeBtn = CreateFrame("Button", "BlackListStandalone_RemoveButton", iconBar)
	local texRem = U.styleStandaloneIconButton(removeBtn)
	U.applyStandaloneAtlasTexture(texRem, { "Islands-MarkedArea" }, "Interface\\Buttons\\UI-MinusButton-Up", nil)
	U.setStandaloneIconTint(texRem, 0.95, 0.28, 0.28, 1)
	removeBtn:SetPoint("LEFT", editBtn, "RIGHT", iconGap, 0)
	removeBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["REMOVE_PLAYER"] or "", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	removeBtn:SetScript("OnLeave", GameTooltip_Hide)
	removeBtn:SetScript("OnClick", function()
		local index = BlackList:GetSelectedBlackList()
		if index and index > 0 then
			local player = BlackList:GetPlayerByIndex(index)
			if player then
				BlackList:RemovePlayer(player["name"])
				BlackList:UpdateStandaloneUI()
			end
		end
	end)

	local searchBtn = CreateFrame("Button", "BlackListStandalone_SearchToggleButton", iconBar)
	local texSearch = U.styleStandaloneIconButton(searchBtn)
	U.applyStandaloneAtlasTexture(texSearch, { "loreobject-32x32" }, U.assetsSearch or "Interface\\Buttons\\UI-Searchbox-Icon", nil)
	U.setStandaloneIconTint(texSearch, 1, 1, 1, 1)
	searchBtn:SetPoint("LEFT", removeBtn, "RIGHT", iconGap, 0)
	searchBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local key = searchVisible and "HIDE" or "SHOW"
		local txt = L["TOOLTIP_FILTER_TOGGLE_" .. key] or (searchVisible and "Hide filter" or "Show filter")
		GameTooltip:AddLine(txt, 1, 1, 1, false)
		GameTooltip:Show()
	end)
	searchBtn:SetScript("OnLeave", GameTooltip_Hide)
	searchBtn:SetScript("OnClick", function(self)
		searchVisible = not searchVisible
		applySearchVisibility()
		if GameTooltip and GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local key = searchVisible and "HIDE" or "SHOW"
			local txt = L["TOOLTIP_FILTER_TOGGLE_" .. key] or (searchVisible and "Hide filter" or "Show filter")
			GameTooltip:AddLine(txt, 1, 1, 1, false)
			GameTooltip:Show()
		end
	end)

	local optionsBtn = CreateFrame("Button", "BlackListStandalone_OptionsButton", iconBar)
	local texOpt = U.styleStandaloneIconButton(optionsBtn)
	U.applyStandaloneAtlasTexture(texOpt, { "mechagon-projects" }, "Interface\\Icons\\Trade_Engineering", nil)
	optionsBtn:SetPoint("LEFT", searchBtn, "RIGHT", iconGap, 0)
	optionsBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:AddLine(L["OPTIONS"] or "Options", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	optionsBtn:SetScript("OnLeave", GameTooltip_Hide)
	optionsBtn:SetScript("OnClick", function()
		BlackList:ShowNewOptions()
	end)

	local barLvl = (iconBar:GetFrameLevel() or baseLvl) + 5
	addBtn:SetFrameLevel(barLvl)
	addTargetBtn:SetFrameLevel(barLvl)
	editBtn:SetFrameLevel(barLvl)
	removeBtn:SetFrameLevel(barLvl)
	searchBtn:SetFrameLevel(barLvl)
	optionsBtn:SetFrameLevel(barLvl)

	local divLvl = barLvl - 1
	U.addStandaloneIconBarDivider(iconBar, addBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, addTargetBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, editBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, removeBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, searchBtn, divLvl, iconGap)
	applySearchVisibility()
	
end

function BlackList:ToggleStandaloneWindow()
	local frame = getglobal("BlackListStandaloneFrame")
	if not frame then
		return
	end
	if frame:IsVisible() then
		frame:Hide()
	else
		frame:Show()
		self:UpdateStandaloneUI()
	end
end

function BlackList:UpdateStandaloneUI()
	local numBlackLists = BlackList:GetNumBlackLists()
	local selectedBlackList = self:GetSelectedBlackList()
	
	-- Set default selection
	if numBlackLists > 0 then
		if selectedBlackList == 0 or selectedBlackList > numBlackLists then
			self:SetSelectedBlackList(1)
			selectedBlackList = 1
		end
		-- Enable remove / edit buttons
		local removeBtn = getglobal("BlackListStandalone_RemoveButton")
		if removeBtn then removeBtn:Enable() end
		local editBtn = getglobal("BlackListStandalone_EditButton")
		if editBtn then editBtn:Enable() end
	else
		-- Disable remove / edit buttons
		local removeBtn = getglobal("BlackListStandalone_RemoveButton")
		if removeBtn then removeBtn:Disable() end
		local editBtn = getglobal("BlackListStandalone_EditButton")
		if editBtn then editBtn:Disable() end
	end
	
	local mainFrame = getglobal("BlackListStandaloneFrame")
	local scrollBox = mainFrame and mainFrame.blackListStandaloneScrollBox
	if not scrollBox or not CreateDataProvider then
		return
	end
	local matchesSearch = mainFrame and mainFrame.blackListStandaloneMatchesSearch
	local filtered = {}
	if type(matchesSearch) == "function" then
		for i = 1, numBlackLists do
			local p = self:GetPlayerByIndex(i)
			if matchesSearch(p) then
				filtered[#filtered + 1] = i
			end
		end
	else
		for i = 1, numBlackLists do
			filtered[#filtered + 1] = i
		end
	end

	local visibleCount = #filtered
	if visibleCount > 0 then
		local inFiltered = false
		for i = 1, visibleCount do
			if filtered[i] == selectedBlackList then
				inFiltered = true
				break
			end
		end
		if not inFiltered then
			self:SetSelectedBlackList(filtered[1])
			selectedBlackList = filtered[1]
		end
	else
		self:SetSelectedBlackList(0)
		selectedBlackList = 0
		local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
		if detailsFrame and detailsFrame:IsShown() then
			if detailsFrame.SaveReason then
				detailsFrame.SaveReason()
			end
			detailsFrame:Hide()
		end
	end
	local removeBtn = getglobal("BlackListStandalone_RemoveButton")
	if removeBtn then
		if visibleCount > 0 then removeBtn:Enable() else removeBtn:Disable() end
	end
	local editBtn = getglobal("BlackListStandalone_EditButton")
	if editBtn then
		if visibleCount > 0 then editBtn:Enable() else editBtn:Disable() end
	end

	local prevScrollKnown = false
	local prevPct
	if scrollBox.GetScrollPercentage then
		local ok, v = pcall(function()
			return scrollBox:GetScrollPercentage()
		end)
		if ok and v ~= nil then
			prevScrollKnown = true
			prevPct = v
		end
	end

	local dp = CreateDataProvider()
	for i = 1, visibleCount do
		dp:Insert({ index = i, playerIndex = filtered[i] })
	end
	scrollBox:SetDataProvider(dp)

	if prevScrollKnown and scrollBox.SetScrollPercentage and C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if scrollBox and scrollBox.SetScrollPercentage then
				local mode = ScrollBoxConstants and ScrollBoxConstants.NoScrollInterpolation
				pcall(function()
					scrollBox:SetScrollPercentage(prevPct, mode)
				end)
			end
		end)
	end
end
