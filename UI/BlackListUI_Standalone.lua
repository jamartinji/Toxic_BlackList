local _, Addon = ...
local L = Addon.L
local U = Addon.UI

local function cloneEntryTable(src)
	if type(src) ~= "table" then
		return nil
	end
	local out = {}
	for k, v in pairs(src) do
		out[k] = v
	end
	return out
end

--- Remove list row at index (undo stack, selection); same rules as toolbar remove.
local function removeStandaloneListEntryAtIndex(index)
	if not index or index < 1 then
		return
	end
	local player = BlackList:GetPlayerByIndex(index)
	if not player then
		return
	end
	if BlackList:IsEntryDeleteLocked(player) then
		if BlackList.AddMessage then
			BlackList:AddMessage(BlackList:FormatChatTagPlain(L["REMOVE_BLOCKED_ENTRY_LOCKED"] or "That entry is locked.", "systemWarn"), "styled")
		end
		return
	end
	local list = BlackList.GetAccountList and BlackList:GetAccountList()
	if not list or list[index] ~= player then
		return
	end
	U.standaloneUndoStack = U.standaloneUndoStack or {}
	local entryCopy = cloneEntryTable(player)
	if entryCopy then
		U.standaloneUndoStack[#U.standaloneUndoStack + 1] = { entry = entryCopy, index = index }
		if #U.standaloneUndoStack > 20 then
			table.remove(U.standaloneUndoStack, 1)
		end
	end
	table.remove(list, index)
	local newSel = index
	if newSel > #list then
		newSel = #list
	end
	BlackList:SetSelectedBlackList(newSel > 0 and newSel or 0)
	BlackList:UpdateStandaloneUI()
end

--- One skull markup for the selected toxicity submenu row (green atlas like 1–9; 0 dimmed).
local function toxicitySubmenuChosenRowSkullMarkup(score)
	score = math.floor(math.min(10, math.max(0, tonumber(score) or 0)))
	if not CreateAtlasMarkup then
		return nil
	end
	local atlas = "DemonInvasion5"
	local mk
	if score == 0 then
		pcall(function()
			mk = CreateAtlasMarkup(atlas, 14, 14, 0, 0, 0.72, 0.74, 0.78)
		end)
	else
		pcall(function()
			mk = CreateAtlasMarkup(atlas, 14, 14, 0, 0)
		end)
	end
	if not mk or mk == "" then
		pcall(function()
			if score == 0 then
				mk = CreateAtlasMarkup("questlog-questtypeicon-dungeon", 14, 14, 0, 0, 0.72, 0.74, 0.78)
			else
				mk = CreateAtlasMarkup("questlog-questtypeicon-dungeon", 14, 14, 0, 0)
			end
		end)
	end
	return mk
end

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
	local evScore = math.floor(math.min(10, math.max(0, tonumber(player.evaluationScore) or 0)))
	if evScore > 0 then
		GameTooltip:AddLine(" ", 1, 1, 1)
		local toxLab = L["TOOLTIP_BL_TOXICITY_LABEL"] or "Toxicity:"
		local evMarkup = BlackList.GetEvaluationSkullRowMarkup and BlackList:GetEvaluationSkullRowMarkup(evScore) or nil
		local parenMk = BlackList.GetToxicityScoreParentheticalMarkup and BlackList:GetToxicityScoreParentheticalMarkup(evScore) or ("(" .. evScore .. ")")
		pcall(function()
			local line = toxLab .. "  "
			if evMarkup and evMarkup ~= "" then
				line = line .. evMarkup .. "  "
			end
			line = line .. parenMk
			GameTooltip:AddLine(line, 1, 1, 1, false)
		end)
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
	-- Layout first so GetWidth() and NineSlice are valid; then paint border/trims (same as pre–TooltipDataProcessor behavior).
	GameTooltip:Show()
	U.applyStandaloneTooltipPlayerColors(GameTooltip, self, player)
end

local function getStandaloneSortState()
	local k = BlackList.GetOption and BlackList:GetOption("standaloneSortKey", "added") or "added"
	local asc = BlackList.GetOption and BlackList:GetOption("standaloneSortAsc", true)
	if k ~= "added" and k ~= "name" and k ~= "realm" and k ~= "faction" and k ~= "toxicity" then
		k = "added"
	end
	return k, (asc == true)
end

local function setStandaloneSortState(key)
	local curKey, curAsc = getStandaloneSortState()
	local nextAsc = true
	if key == curKey then
		nextAsc = not curAsc
	end
	if BlackList.ToggleOption then
		BlackList:ToggleOption("standaloneSortKey", key)
		BlackList:ToggleOption("standaloneSortAsc", nextAsc)
	end
end

function BlackList:CreateStandaloneWindow()
	U.standaloneUndoStack = U.standaloneUndoStack or {}
	local minIconGap = math.max(2, (U.standaloneIconBarGap or 8) - 4)
	-- Seven toolbar icons (share removed): 6 gaps between them.
	local minBarContentW = (U.standaloneIconBarBtn * 7) + (minIconGap * 6)
	local minWindowW = math.max(200, minBarContentW + 32)
	local initialWindowW = math.max(280, minWindowW + 4)
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
	local function setSortState(key)
		setStandaloneSortState(key)
		BlackList:UpdateStandaloneUI()
	end
	local function sortArrowMarkup(asc, transparent)
		local atlas
		if transparent then
			atlas = "glues-characterSelect-icon-minus-disabled"
		else
			atlas = asc and "glues-characterSelect-icon-arrowUp" or "glues-characterSelect-icon-arrowDown"
		end
		if transparent then
			return string.format("|c00ffffff|A:%s:%d:%d:0:0|a|r", atlas, 14, 14)
		end
		return string.format("|A:%s:%d:%d:0:0|a", atlas, 14, 14)
	end
	local function sortLabel(key, baseText)
		local curKey, asc = getStandaloneSortState()
		local prefix = sortArrowMarkup(asc, curKey ~= key)
		return string.format("%s %s", prefix, baseText)
	end
	local listRowMenuHolder = CreateFrame("Frame", "BlackListStandaloneListRowMenuHolder", frame, "UIDropDownMenuTemplate")
	local showListRowContextMenu
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
		local nm = strtrim(tostring(player.name or ""))
		local rm = strtrim(tostring(player.realm or ""))
		if nm ~= "" and rm ~= "" then
			fields[#fields + 1] = nm .. "-" .. rm
		end
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

	local function setStandaloneListFilterQuery(q)
		q = strtrim(tostring(q or ""))
		if q == "" then
			return
		end
		if not searchVisible then
			searchVisible = true
		end
		if searchBoxContainer then
			searchBoxContainer:Show()
		end
		listContainer:ClearAllPoints()
		listContainer:SetPoint("TOPLEFT", searchBoxContainer, "BOTTOMLEFT", 0, -6)
		listContainer:SetPoint("BOTTOMRIGHT", listShell, "BOTTOMRIGHT", -U.listShellPad, U.listShellPad)
		if searchEditBox then
			searchEditBox:SetText(q)
			if searchPlaceholder then
				searchPlaceholder:SetShown(q == "")
			end
			if SearchBoxTemplate_OnTextChanged then
				pcall(SearchBoxTemplate_OnTextChanged, searchEditBox)
			end
		end
		currentSearchFilter = q
		BlackList:UpdateStandaloneUI()
	end
	frame.blackListStandaloneSetListFilter = setStandaloneListFilterQuery

	showListRowContextMenu = function(anchorButton)
		local idx = anchorButton and anchorButton:GetID()
		local p = idx and idx > 0 and BlackList:GetPlayerByIndex(idx)
		local sortBlock = {
			{ text = L["SORT_BY_TITLE"] or "Sort by...", isTitle = true, notCheckable = true },
			{ text = sortLabel("added", L["SORT_DATE"] or "Date"), notCheckable = true, isNotRadio = true, func = function()
				setSortState("added")
			end },
			{ text = sortLabel("name", L["SORT_NAME"] or "Name"), notCheckable = true, isNotRadio = true, func = function()
				setSortState("name")
			end },
			{ text = sortLabel("realm", L["SORT_REALM"] or "Realm"), notCheckable = true, isNotRadio = true, func = function()
				setSortState("realm")
			end },
			{ text = sortLabel("faction", L["SORT_FACTION"] or "Faction"), notCheckable = true, isNotRadio = true, func = function()
				setSortState("faction")
			end },
			{ text = sortLabel("toxicity", L["SORT_TOXICITY"] or "Toxicity"), notCheckable = true, isNotRadio = true, func = function()
				setSortState("toxicity")
			end },
		}
		local rowBlock = {}
		if p then
			rowBlock[#rowBlock + 1] = {
				text = L["LIST_MENU_EDIT"] or "Edit entry",
				notCheckable = true,
				func = function()
					local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
					if detailsFrame and detailsFrame.SaveReason then
						detailsFrame.SaveReason()
					end
					BlackList:SetSelectedBlackList(idx)
					BlackList:UpdateStandaloneUI()
					BlackList:ShowStandaloneDetails()
				end,
			}
			rowBlock[#rowBlock + 1] = {
				text = L["LIST_MENU_REMOVE"] or L["REMOVE_PLAYER"] or "Remove from list",
				notCheckable = true,
				disabled = BlackList:IsEntryDeleteLocked(p),
				func = function()
					removeStandaloneListEntryAtIndex(idx)
				end,
			}
			BlackList:EnsureEntryFields(p)
			local curTox = math.floor(math.min(10, math.max(0, tonumber(p.evaluationScore) or 0)))
			local toxList = {}
			for s = 0, 10 do
				local score = s
				local rowText = tostring(s)
				if score == curTox then
					local sk = toxicitySubmenuChosenRowSkullMarkup(score)
					if sk and sk ~= "" then
						rowText = rowText .. "  " .. sk
					end
				end
				toxList[#toxList + 1] = {
					text = rowText,
					notCheckable = true,
					func = function()
						BlackList:EnsureEntryFields(p)
						p.evaluationScore = score
						BlackList:UpdateStandaloneUI()
						local df = getglobal("BlackListStandaloneDetailsFrame")
						if df and df:IsShown() and df.currentPlayerIndex == idx and BlackList.RefreshStandaloneDetailsEvaluationSkulls then
							BlackList:RefreshStandaloneDetailsEvaluationSkulls(df)
						end
						if CloseDropDownMenus then
							CloseDropDownMenus()
						end
					end,
				}
			end
			rowBlock[#rowBlock + 1] = {
				text = L["LIST_MENU_TOXICITY"] or "Toxicity",
				notCheckable = true,
				hasArrow = true,
				menuList = toxList,
			}
			rowBlock[#rowBlock + 1] = { text = "", isSeparator = true, notCheckable = true }
		end
		local menuDD = {}
		for i = 1, #rowBlock do
			menuDD[#menuDD + 1] = rowBlock[i]
		end
		for i = 1, #sortBlock do
			menuDD[#menuDD + 1] = sortBlock[i]
		end
		local function flattenForEasy(src)
			local out = {}
			for _, e in ipairs(src) do
				if e.menuList then
					out[#out + 1] = {
						text = "— " .. tostring(e.text) .. " —",
						isTitle = true,
						notCheckable = true,
					}
					for _, sub in ipairs(e.menuList) do
						out[#out + 1] = sub
					end
				else
					out[#out + 1] = e
				end
			end
			return out
		end
		local menuEasy = {}
		local flatRow = flattenForEasy(rowBlock)
		for i = 1, #flatRow do
			menuEasy[#menuEasy + 1] = flatRow[i]
		end
		for i = 1, #sortBlock do
			menuEasy[#menuEasy + 1] = sortBlock[i]
		end
		if EasyMenu then
			EasyMenu(menuEasy, listRowMenuHolder, "cursor", 0, 0, "MENU")
			return
		end
		if UIDropDownMenu_Initialize and UIDropDownMenu_CreateInfo and UIDropDownMenu_AddButton and ToggleDropDownMenu then
			listRowMenuHolder.displayMode = "MENU"
			listRowMenuHolder.blListRowMenuTop = menuDD
			listRowMenuHolder.initialize = function(self, level, menuList)
				local list = menuList or self.blListRowMenuTop
				if not list then
					return
				end
				for _, src in ipairs(list) do
					local info = UIDropDownMenu_CreateInfo()
					info.text = src.text
					info.isTitle = src.isTitle
					info.isSeparator = src.isSeparator
					info.notCheckable = src.notCheckable ~= false
					info.disabled = src.disabled
					info.func = src.func
					info.hasArrow = src.hasArrow
					info.menuList = src.menuList
					if src.checked ~= nil then
						info.checked = src.checked
					end
					if src.isNotRadio ~= nil then
						info.isNotRadio = src.isNotRadio
					end
					UIDropDownMenu_AddButton(info, level or 1)
				end
			end
			UIDropDownMenu_Initialize(listRowMenuHolder, listRowMenuHolder.initialize, "MENU")
			ToggleDropDownMenu(1, nil, listRowMenuHolder, "cursor", 0, 0)
		end
	end

	local legendBar = CreateFrame("Frame", "BlackListStandaloneLegendBar", frame)
	legendBar:SetFrameLevel(baseLvl + 20)
	legendBar:SetHeight(U.legendRowH)
	legendBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, U.legendBottom)
	legendBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, U.legendBottom)

	-- Help "?" position: first number = inset from legend left edge (more negative = move icon left).
	local helpBtn = CreateFrame("Button", "BlackListStandalone_HelpButton", legendBar)
	helpBtn:SetSize(22, 22)
	helpBtn:SetPoint("LEFT", legendBar, "LEFT", -2, 0)
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

	-- Gap after help icon: first number = horizontal space before hint text (smaller = more room for list above).
	local hint = legendBar:CreateFontString("BlackListStandalone_Hint", "OVERLAY", "GameFontNormalSmall")
	hint:SetPoint("TOPLEFT", helpBtn, "TOPRIGHT", 6, 0)
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
			button.FactionIcon:SetSize(14, 18)
		end
		-- Fixed-width column so the "needs info" icon matches Alliance/Horde width (no extra push on the name).
		if not button.FactionSlot then
			button.FactionSlot = CreateFrame("Frame", nil, button)
			button.FactionSlot:SetSize(18, 18)
		end
		if not button.ToxScore then
			button.ToxScore = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			button.ToxScore:SetSize(18, 14)
			button.ToxScore:SetPoint("LEFT", button, "LEFT", 4, 0)
			button.ToxScore:SetJustifyH("RIGHT")
		end
		button.Text:ClearAllPoints()
		button.Text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -46, 0)
		button.Text:SetJustifyH("LEFT")
		button.Text:SetJustifyV("MIDDLE")
		local index = elementData.playerIndex or elementData.index
		button:SetID(index)
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		local player = BlackList:GetPlayerByIndex(index)
		if player then
			BlackList:EnsureEntryFields(player)
			local toxN = math.floor(math.min(10, math.max(0, tonumber(player.evaluationScore) or 0)))
			if BlackList.GetToxicityScoreNumberMarkup then
				button.ToxScore:SetText(BlackList:GetToxicityScoreNumberMarkup(toxN))
			else
				button.ToxScore:SetText(tostring(toxN))
			end
			button.ToxScore:Show()
			button.Text:SetText(BlackList:FormatStandaloneListLine(player))
			local fid = BlackList.GetFactionIdForPlayer and BlackList:GetFactionIdForPlayer(player) or nil
			local factionShown = false
			button.FactionSlot:ClearAllPoints()
			button.FactionSlot:SetPoint("LEFT", button.ToxScore, "RIGHT", 4, 0)
			if button.FactionIcon:GetParent() ~= button.FactionSlot then
				button.FactionIcon:SetParent(button.FactionSlot)
			end
			if fid == 1 or fid == 2 then
				local atlas = (fid == 1) and "communities-create-button-wow-alliance" or "communities-create-button-wow-horde"
				local okAtlas = pcall(function()
					button.FactionIcon:SetAtlas(atlas)
				end)
				if okAtlas and button.FactionIcon:GetAtlas() then
					button.FactionIcon:ClearAllPoints()
					button.FactionIcon:SetPoint("CENTER", button.FactionSlot, "CENTER", 0, 0)
					button.FactionIcon:SetSize(14, 18)
					button.FactionIcon:SetTexCoord(0, 1, 0, 1)
					button.FactionIcon:SetVertexColor(1, 1, 1, 1)
					button.FactionIcon:Show()
					factionShown = true
				else
					button.FactionIcon:Hide()
				end
			elseif BlackList.PlayerEntryNeedsInfo and BlackList:PlayerEntryNeedsInfo(player) then
				local okAtlas = pcall(function()
					button.FactionIcon:SetAtlas("QuestLegendaryTurnin")
				end)
				if okAtlas and button.FactionIcon:GetAtlas() then
					button.FactionIcon:ClearAllPoints()
					button.FactionIcon:SetPoint("CENTER", button.FactionSlot, "CENTER", 0, 0)
					-- Same footprint as faction buttons so the player name column does not shift.
					button.FactionIcon:SetSize(14, 18)
					button.FactionIcon:SetTexCoord(0, 1, 0, 1)
					button.FactionIcon:SetVertexColor(1, 1, 1, 1)
					button.FactionIcon:Show()
					factionShown = true
				else
					button.FactionIcon:Hide()
				end
			else
				button.FactionIcon:Hide()
			end
			if factionShown then
				button.FactionSlot:SetSize(18, 18)
				button.FactionSlot:Show()
			else
				button.FactionSlot:Hide()
			end
			button.Text:ClearAllPoints()
			button.Text:SetPoint("TOPLEFT", factionShown and button.FactionSlot or button.ToxScore, "TOPRIGHT", 6, 0)
			button.Text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -46, 0)
		else
			button.Text:SetText("")
			button.FactionIcon:Hide()
			if button.FactionSlot then
				button.FactionSlot:Hide()
			end
			if button.ToxScore then
				button.ToxScore:Hide()
			end
		end
		if not button.RowLockBtn then
			local lb = CreateFrame("Button", nil, button)
			lb:SetSize(16, 16)
			lb:SetPoint("RIGHT", button, "RIGHT", -4, 0)
			lb:SetFrameLevel((button:GetFrameLevel() or 0) + 10)
			local lt = lb:CreateTexture(nil, "ARTWORK")
			lt:SetAllPoints()
			lb.lockTex = lt
			pcall(function()
				lt:SetAtlas("collections-icon-lock")
			end)
			if not lt:GetAtlas() then
				lt:SetTexture("Interface\\PetBattles\\PetBattle-LockIcon")
				lt:SetTexCoord(0, 1, 0, 1)
			end
			lb:RegisterForClicks("LeftButtonUp")
			local lockTipR, lockTipG, lockTipB = 1, 0.28, 0.28
			local function refreshLockRowTooltip(btn)
				if not GameTooltip or not btn then
					return
				end
				GameTooltip:SetOwner(btn, "ANCHOR_LEFT")
				if GameTooltip.ClearLines then
					GameTooltip:ClearLines()
				end
				local idx = btn:GetParent():GetID()
				local p = idx and BlackList:GetPlayerByIndex(idx)
				if p and BlackList:IsEntryDeleteLocked(p) then
					GameTooltip:AddLine(L["ROW_LOCK_TOOLTIP_LOCKED"] or "Locked", lockTipR, lockTipG, lockTipB, false)
				else
					GameTooltip:AddLine(L["ROW_LOCK_TOOLTIP_UNLOCKED"] or "Unlocked", 1, 1, 1, false)
				end
				GameTooltip:Show()
			end
			lb:SetScript("OnEnter", function(self)
				refreshLockRowTooltip(self)
			end)
			lb:SetScript("OnLeave", GameTooltip_Hide)
			lb:SetScript("OnClick", function(self)
				local idx = self:GetParent():GetID()
				if not idx or idx < 1 then
					return
				end
				local p = BlackList:GetPlayerByIndex(idx)
				if not p then
					return
				end
				BlackList:EnsureEntryFields(p)
				p.entryLocked = not p.entryLocked
				BlackList:UpdateStandaloneUI()
				if GameTooltip and GameTooltip:IsOwned(self) then
					refreshLockRowTooltip(self)
				end
			end)
			button.RowLockBtn = lb
		end
		if not button.RowMuteBtn then
			local mb = CreateFrame("Button", nil, button)
			mb:SetSize(16, 16)
			mb:SetFrameLevel((button:GetFrameLevel() or 0) + 10)
			local mt = mb:CreateTexture(nil, "ARTWORK")
			mt:SetAllPoints()
			mb.muteTex = mt
			mb:RegisterForClicks("LeftButtonUp")
			local muteTipR, muteTipG, muteTipB = 1, 0.28, 0.28
			local function refreshMuteRowTooltip(btn)
				if not GameTooltip or not btn then
					return
				end
				GameTooltip:SetOwner(btn, "ANCHOR_LEFT")
				if GameTooltip.ClearLines then
					GameTooltip:ClearLines()
				end
				local idx = btn:GetParent() and btn:GetParent():GetID()
				local p = idx and BlackList:GetPlayerByIndex(idx)
				if p and p.muted then
					GameTooltip:AddLine(L["OPT_MUTED_CHAT_UNMUTE"] or "Messages ignored", muteTipR, muteTipG, muteTipB, false)
				else
					GameTooltip:AddLine(L["OPT_MUTED_CHAT"] or "Messages allowed", 1, 1, 1, false)
				end
				GameTooltip:Show()
			end
			mb:SetScript("OnEnter", function(self)
				refreshMuteRowTooltip(self)
			end)
			mb:SetScript("OnLeave", GameTooltip_Hide)
			mb:SetScript("OnClick", function(self)
				local idx = self:GetParent():GetID()
				if not idx or idx < 1 then
					return
				end
				local p = BlackList:GetPlayerByIndex(idx)
				if not p then
					return
				end
				BlackList:EnsureEntryFields(p)
				p.muted = not p.muted
				if self.muteTex and U.applyMuteIconTexture then
					U.applyMuteIconTexture(self.muteTex, p.muted and true or false)
				end
				BlackList:UpdateStandaloneUI()
				if GameTooltip and GameTooltip:IsOwned(self) then
					refreshMuteRowTooltip(self)
				end
			end)
			button.RowMuteBtn = mb
		end
		if button.RowMuteBtn and button.RowLockBtn then
			button.RowMuteBtn:ClearAllPoints()
			button.RowMuteBtn:SetPoint("RIGHT", button.RowLockBtn, "LEFT", -4, 0)
		end
		do
			local lb = button.RowLockBtn
			local pRow = BlackList:GetPlayerByIndex(index)
			if pRow and lb and lb.lockTex then
				BlackList:EnsureEntryFields(pRow)
				local lt = lb.lockTex
				if BlackList:IsEntryDeleteLocked(pRow) then
					pcall(function()
						if lt.SetDesaturated then
							lt:SetDesaturated(false)
						end
					end)
					lt:SetVertexColor(1, 0.28, 0.28, 1)
				else
					pcall(function()
						if lt.SetDesaturated then
							lt:SetDesaturated(true)
						end
					end)
					lt:SetVertexColor(0.48, 0.51, 0.55, 1)
				end
				lb:Show()
			elseif lb then
				lb:Hide()
			end
		end
		do
			local mb = button.RowMuteBtn
			local pRow = BlackList:GetPlayerByIndex(index)
			if pRow and mb and mb.muteTex and U.applyMuteIconTexture then
				BlackList:EnsureEntryFields(pRow)
				U.applyMuteIconTexture(mb.muteTex, pRow.muted and true or false)
				mb:Show()
			elseif mb then
				mb:Hide()
			end
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
		button:SetScript("OnMouseUp", function(self, mouseButton)
			if mouseButton == "RightButton" then
				showListRowContextMenu(self)
			end
		end)
		button:SetScript("OnClick", function(self, mouseButton)
			local idx = self:GetID()
			if not idx or idx < 1 then
				return
			end
			if mouseButton == "RightButton" then
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
	local texRem = U.styleStandaloneIconButton(removeBtn, 26)
	U.applyStandaloneAtlasTexture(texRem, { "Islands-MarkedArea" }, "Interface\\Buttons\\UI-MinusButton-Up", nil)
	U.setStandaloneIconTint(texRem, 0.95, 0.28, 0.28, 1)
	removeBtn:SetPoint("LEFT", editBtn, "RIGHT", iconGap, 0)
	removeBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local index = BlackList:GetSelectedBlackList()
		local p = index and index > 0 and BlackList:GetPlayerByIndex(index)
		if p and BlackList:IsEntryDeleteLocked(p) then
			GameTooltip:AddLine(L["REMOVE_BLOCKED_ENTRY_LOCKED"] or "That entry is locked. Unlock it in the list before removing.", 1, 0.45, 0.35, true)
		else
			GameTooltip:AddLine(L["REMOVE_PLAYER"] or "", 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	removeBtn:SetScript("OnLeave", GameTooltip_Hide)
	removeBtn:SetScript("OnClick", function()
		removeStandaloneListEntryAtIndex(BlackList:GetSelectedBlackList())
	end)

	local undoBtn = CreateFrame("Button", "BlackListStandalone_UndoButton", iconBar)
	local texUndo = U.styleStandaloneIconButton(undoBtn, 20)
	U.applyStandaloneAtlasTexture(texUndo, { "common-icon-undo" }, "Interface\\Buttons\\UI-RotateRightButton-Up", nil)
	U.setStandaloneIconTint(texUndo, 1, 1, 1, 1)
	undoBtn:SetPoint("LEFT", removeBtn, "RIGHT", iconGap, 0)
	undoBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local hasUndo = U.standaloneUndoStack and #U.standaloneUndoStack > 0
		if hasUndo then
			GameTooltip:AddLine(L["UNDO_DELETE"] or "Undo", 1, 1, 1, true)
		else
			GameTooltip:AddLine(L["UNDO_NOTHING"] or "Nothing to undo", 0.65, 0.65, 0.65, true)
		end
		GameTooltip:Show()
	end)
	undoBtn:SetScript("OnLeave", GameTooltip_Hide)
	undoBtn:SetScript("OnClick", function()
		local stack = U.standaloneUndoStack or {}
		local item = stack[#stack]
		if not item or type(item) ~= "table" or type(item.entry) ~= "table" then
			return
		end
		stack[#stack] = nil
		local list = BlackList.GetAccountList and BlackList:GetAccountList()
		if not list then
			return
		end
		local insertIndex = tonumber(item.index) or (#list + 1)
		if insertIndex < 1 then
			insertIndex = 1
		end
		if insertIndex > (#list + 1) then
			insertIndex = #list + 1
		end
		table.insert(list, insertIndex, item.entry)
		BlackList:SetSelectedBlackList(insertIndex)
		BlackList:UpdateStandaloneUI()
	end)

	local searchBtn = CreateFrame("Button", "BlackListStandalone_SearchToggleButton", iconBar)
	local texSearch = U.styleStandaloneIconButton(searchBtn)
	U.applyStandaloneAtlasTexture(texSearch, { "loreobject-32x32" }, U.assetsSearch or "Interface\\Buttons\\UI-Searchbox-Icon", nil)
	U.setStandaloneIconTint(texSearch, 1, 1, 1, 1)
	searchBtn:SetPoint("LEFT", undoBtn, "RIGHT", iconGap, 0)
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
	undoBtn:SetFrameLevel(barLvl)
	searchBtn:SetFrameLevel(barLvl)
	optionsBtn:SetFrameLevel(barLvl)

	local divLvl = barLvl - 1
	U.addStandaloneIconBarDivider(iconBar, addBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, addTargetBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, editBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, removeBtn, divLvl, iconGap)
	U.addStandaloneIconBarDivider(iconBar, undoBtn, divLvl, iconGap)
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
		local editBtn = getglobal("BlackListStandalone_EditButton")
		if editBtn then editBtn:Enable() end
	else
		local editBtn = getglobal("BlackListStandalone_EditButton")
		if editBtn then editBtn:Disable() end
	end
	
	local mainFrame = getglobal("BlackListStandaloneFrame")
	local scrollBox = mainFrame and mainFrame.blackListStandaloneScrollBox
	if not scrollBox or not CreateDataProvider then
		local removeBtnEarly = getglobal("BlackListStandalone_RemoveButton")
		if removeBtnEarly then
			if numBlackLists > 0 then
				local pSel = selectedBlackList and selectedBlackList > 0 and self:GetPlayerByIndex(selectedBlackList)
				if pSel and self:IsEntryDeleteLocked(pSel) then
					removeBtnEarly:Disable()
				else
					removeBtnEarly:Enable()
				end
			else
				removeBtnEarly:Disable()
			end
		end
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
	local sortKey, sortAsc = getStandaloneSortState()
	table.sort(filtered, function(aIdx, bIdx)
		local a = self:GetPlayerByIndex(aIdx)
		local b = self:GetPlayerByIndex(bIdx)
		if not a or not b then
			return aIdx < bIdx
		end
		local va, vb
		if sortKey == "name" then
			va = string.lower(tostring(a.name or ""))
			vb = string.lower(tostring(b.name or ""))
		elseif sortKey == "realm" then
			va = string.lower(tostring(a.realm or ""))
			vb = string.lower(tostring(b.realm or ""))
		elseif sortKey == "faction" then
			va = self.GetFactionIdForPlayer and (self:GetFactionIdForPlayer(a) or 3) or 3
			vb = self.GetFactionIdForPlayer and (self:GetFactionIdForPlayer(b) or 3) or 3
		elseif sortKey == "toxicity" then
			self:EnsureEntryFields(a)
			self:EnsureEntryFields(b)
			va = math.floor(math.min(10, math.max(0, tonumber(a.evaluationScore) or 0)))
			vb = math.floor(math.min(10, math.max(0, tonumber(b.evaluationScore) or 0)))
		else
			va = tonumber(a.added) or 0
			vb = tonumber(b.added) or 0
		end
		if va == vb then
			if sortKey ~= "name" then
				local an = string.lower(tostring(a.name or ""))
				local bn = string.lower(tostring(b.name or ""))
				if an ~= bn then
					if sortAsc then
						return an < bn
					else
						return an > bn
					end
				end
			end
			return aIdx < bIdx
		end
		if sortAsc then
			return va < vb
		end
		return va > vb
	end)

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
		if visibleCount > 0 then
			local pSel = selectedBlackList and selectedBlackList > 0 and self:GetPlayerByIndex(selectedBlackList)
			if pSel and self:IsEntryDeleteLocked(pSel) then
				removeBtn:Disable()
			else
				removeBtn:Enable()
			end
		else
			removeBtn:Disable()
		end
	end
	local undoBtn = getglobal("BlackListStandalone_UndoButton")
	if undoBtn then
		local hasUndo = U.standaloneUndoStack and #U.standaloneUndoStack > 0
		undoBtn:Enable()
		local t = undoBtn.blackListStandaloneIconTex
		if t then
			if hasUndo then
				t:SetVertexColor(1, 1, 1, 1)
			else
				t:SetVertexColor(0.55, 0.55, 0.55, 1)
			end
		end
		if hasUndo then
			undoBtn:SetAlpha(1)
		else
			undoBtn:SetAlpha(0.85)
		end
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

	local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
	if detailsFrame and detailsFrame:IsShown() then
		self:RefreshStandaloneDetailsEvaluationSkulls(detailsFrame)
	end
	local muteTop = getglobal("BlackListStandaloneDetails_MuteBtn")
	if detailsFrame and detailsFrame:IsShown() and muteTop and muteTop.muteTex and U.applyMuteIconTexture then
		local idx = detailsFrame.currentPlayerIndex
		local p = idx and self:GetPlayerByIndex(idx)
		if p then
			self:EnsureEntryFields(p)
			U.applyMuteIconTexture(muteTop.muteTex, p.muted and true or false)
		end
	end
end
