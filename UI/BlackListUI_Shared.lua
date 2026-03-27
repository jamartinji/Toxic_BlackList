--[[
  Shared layout state and helpers for Toxic BlackList UI (cross-file locals live on Addon.UI).
]]

local _, Addon = ...
local L = Addon.L

Addon.UI = Addon.UI or {}
local U = Addon.UI

local mp = Addon.MEDIA_PATH or "Interface\\AddOns\\Toxic_BlackList\\Media\\Images\\"

-- Globals kept for compatibility (Friends frame / scroll).
BLACKLISTS_TO_DISPLAY = 18
FRIENDS_FRAME_BLACKLIST_HEIGHT = 20
Classes = {"", "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"}
Races = {"", "Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Orc", "Undead", "Tauren", "Troll", "Blood Elf"}

U.selectedIndex = 1
U.optionsFrameWidth = 460
U.optionsCheckTextWidth = U.optionsFrameWidth - 56
U.optionsRowGap = 34
U.standaloneDoubleClickWindow = 0.35
U.standaloneListClickState = { t = 0, index = 0 }

U.standaloneIconBarBtn = 28
U.standaloneIconBarGap = 26
U.floatBtnSizeMin = 32
U.floatBtnSizeMax = 128
U.floatBtnDefaultSize = 64
U.standaloneIconTex = 24
U.iconBarTop = -38
U.iconBarShellPad = 6
U.listShellPad = 4
U.sectionBackdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}
U.legendBottom = 10
U.legendRowH = 52
U.assetsPencil = mp .. "pencil.png"
U.assetsAim = mp .. "aim.png"
U.assetsSearch = mp .. "search.png"
U.assetsIcon = mp .. "bl-icon.png"
U.assetsButton = mp .. "bl-button.png"

function U.applyStandaloneAtlasTexture(tex, atlasList, fallbackTexture, texCoord)
	if not tex then
		return false
	end
	local ok = false
	if atlasList then
		for _, atlas in ipairs(atlasList) do
			if pcall(function() tex:SetAtlas(atlas) end) and tex:GetAtlas() then
				ok = true
				break
			end
		end
	end
	if not ok and fallbackTexture then
		tex:SetTexture(fallbackTexture)
		if texCoord then
			tex:SetTexCoord(unpack(texCoord))
		else
			tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		end
	end
	return ok
end

--- Mouseover highlight: soft/circular, white, slightly larger than the button (not the default blue square).
function U.applyStandaloneIconButtonHighlight(btn)
	if not btn then
		return
	end
	local sz = math.floor(U.standaloneIconBarBtn * 1.25 + 0.5)
	local hl = btn:CreateTexture(nil, "HIGHLIGHT")
	hl:SetSize(sz, sz)
	hl:SetPoint("CENTER", 0, 0)
	local ok = pcall(function() hl:SetAtlas("Options_List_Hover") end)
	if not ok or not hl:GetAtlas() then
		hl:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		hl:SetTexCoord(0, 1, 0, 1)
	end
	hl:SetVertexColor(1, 1, 1, 0.9)
	btn:SetHighlightTexture(hl, "ADD")
end

function U.styleStandaloneIconButton(btn, iconSize)
	btn:SetSize(U.standaloneIconBarBtn, U.standaloneIconBarBtn)
	U.applyStandaloneIconButtonHighlight(btn)
	local sz = iconSize or U.standaloneIconTex
	local tex = btn:CreateTexture(nil, "ARTWORK")
	tex:SetSize(sz, sz)
	tex:SetPoint("CENTER", 0, 0)
	btn.blackListStandaloneIconTex = tex
	return tex
end

function U.setStandaloneIconTint(tex, r, g, b, a)
	if tex and tex.SetVertexColor then
		tex:SetVertexColor(r, g, b, a or 1)
	end
end

function U.applyStandaloneSectionBackdrop(f)
	if not f then
		return
	end
	if not f.SetBackdrop and BackdropTemplateMixin then
		Mixin(f, BackdropTemplateMixin)
	end
	if f.SetBackdrop then
		f:SetBackdrop(U.sectionBackdrop)
		f:SetBackdropColor(0.12, 0.12, 0.12, 0.55)
		if f.SetBackdropBorderColor then
			f:SetBackdropBorderColor(0.38, 0.38, 0.38, 1)
		end
	end
end

--- Shared top decoration config for evergreen scenario title background.
function U.applyEvergreenTopDecor(frame, opts)
	if not frame then
		return
	end
	opts = opts or {}
	frame.blackListTopDecorAtlas = "evergreen-scenario-titlebg"
	frame.blackListTopDecorSrcW = 350
	frame.blackListTopDecorSrcH = 165
	frame.blackListTopDecorWidth = opts.width or 300
	frame.blackListTopDecorFromY = opts.fromY or 0
	frame.blackListTopDecorToY = opts.toY or 0.36
	frame.blackListTopDecorOffsetY = opts.offsetY or -30
	frame.blackListTopDecorAlpha = opts.alpha or 0.9
end

--- Vertical line between icon-bar buttons (centered in the gap).
function U.addStandaloneIconBarDivider(iconBar, rightOfButton, frameLevel, gapOverride)
	if not iconBar or not rightOfButton then
		return
	end
	local d = CreateFrame("Frame", nil, iconBar)
	d:SetFrameLevel(frameLevel or ((iconBar:GetFrameLevel() or 0) + 4))
	d:SetSize(1, math.max(10, U.standaloneIconBarBtn - 10))
	local t = d:CreateTexture(nil, "ARTWORK")
	t:SetAllPoints()
	t:SetColorTexture(0.48, 0.48, 0.52, 0.82)
	local gap = gapOverride or U.standaloneIconBarGap
	local half = math.floor(gap / 2)
	d:SetPoint("CENTER", rightOfButton, "RIGHT", half, 0)
	return d
end

--- Help: tooltip only (same text as HELP_PANEL_TEXT in locales).
function U.showStandaloneHelpTooltip(anchor)
	if not anchor or not GameTooltip then
		return
	end
	GameTooltip:SetOwner(anchor, "ANCHOR_LEFT")
	if GameTooltip.SetMinimumWidth then
		GameTooltip:SetMinimumWidth(440)
	end
	if GameTooltip.SetPadding then
		GameTooltip:SetPadding(18, 10)
	end
	GameTooltip:AddLine(L["HELP_TITLE"] or "Toxic BlackList", 1, 0.82, 0, false)
	local body = L["HELP_PANEL_TEXT"] or ""
	for line in string.gmatch(body, "[^\n]+") do
		if strtrim(line) ~= "" then
			GameTooltip:AddLine(line, 1, 1, 1, true)
		end
	end
	GameTooltip:Show()
end

function U.resetGameTooltipToDefault(tooltip)
	if not tooltip then
		return
	end
	pcall(function()
		if SharedTooltip_SetBackdropStyle then
			SharedTooltip_SetBackdropStyle(tooltip, nil)
		end
	end)
	pcall(function()
		local bg = TOOLTIP_DEFAULT_BACKGROUND_COLOR
		if tooltip.NineSlice and tooltip.NineSlice.SetCenterColor then
			if bg then
				tooltip.NineSlice:SetCenterColor(bg:GetRGBA())
			else
				tooltip.NineSlice:SetCenterColor(0.09, 0.09, 0.09, 0.78)
			end
		elseif tooltip.SetBackdropColor then
			if bg then
				tooltip:SetBackdropColor(bg:GetRGBA())
			else
				tooltip:SetBackdropColor(0.09, 0.09, 0.09, 0.78)
			end
		end
	end)
	pcall(function()
		local bd = TOOLTIP_DEFAULT_COLOR
		if tooltip.SetBackdropBorderColor then
			if bd then
				tooltip:SetBackdropBorderColor(bd:GetRGBA())
			else
				tooltip:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			end
		end
		if tooltip.NineSlice and tooltip.NineSlice.SetBorderColor and bd then
			tooltip.NineSlice:SetBorderColor(bd:GetRGBA())
		end
	end)
	if tooltip.blackListFactionTrimTop then
		tooltip.blackListFactionTrimTop:Hide()
	end
	if tooltip.blackListFactionTrimBottom then
		tooltip.blackListFactionTrimBottom:Hide()
	end
end

function U.ensureStandaloneTooltipColorHook()
	if not GameTooltip or GameTooltip.blackListTooltipColorHooked then
		return
	end
	GameTooltip.blackListTooltipColorHooked = true
	GameTooltip:HookScript("OnHide", function(self)
		if self.blackListTooltipPlayerStyled then
			self.blackListTooltipPlayerStyled = nil
			U.resetGameTooltipToDefault(self)
		end
	end)
end

function U.applyStandaloneTooltipPlayerColors(tooltip, blackListAddon, player)
	if not tooltip or not blackListAddon or not player then
		return
	end
	U.ensureStandaloneTooltipColorHook()
	U.resetGameTooltipToDefault(tooltip)

	local cr, cg, cb = 0.75, 0.75, 0.75
	local fr, fg, fb = 0.12, 0.12, 0.12
	if blackListAddon.GetSpecificFactionColorRGB then
		local rr, gg, bb = blackListAddon:GetSpecificFactionColorRGB(player)
		cr, cg, cb = rr, gg, bb
		fr, fg, fb = rr * 0.28, gg * 0.28, bb * 0.28
	end

	pcall(function()
		if tooltip.NineSlice and tooltip.NineSlice.SetCenterColor then
			tooltip.NineSlice:SetCenterColor(fr, fg, fb, 0.95)
		end
		if tooltip.SetBackdropColor then
			tooltip:SetBackdropColor(fr, fg, fb, 0.95)
		end
	end)
	pcall(function()
		if tooltip.NineSlice and tooltip.NineSlice.SetBorderColor then
			tooltip.NineSlice:SetBorderColor(cr, cg, cb, 1)
		end
		if tooltip.SetBackdropBorderColor then
			tooltip:SetBackdropBorderColor(cr, cg, cb, 1)
		end
	end)
	local fid = blackListAddon.GetFactionIdForPlayer and blackListAddon:GetFactionIdForPlayer(player)
	local atlas = nil
	if fid == 1 then
		atlas = "AllianceScenario-TitleBG"
	elseif fid == 2 then
		atlas = "HordeScenario-TitleBG"
	end
	if atlas then
		if not tooltip.blackListFactionTrimTop then
			tooltip.blackListFactionTrimTop = tooltip:CreateTexture(nil, "ARTWORK", nil, 2)
		end
		if not tooltip.blackListFactionTrimBottom then
			tooltip.blackListFactionTrimBottom = tooltip:CreateTexture(nil, "ARTWORK", nil, 2)
		end
		local trim = tooltip.blackListFactionTrimTop
		local trimBottom = tooltip.blackListFactionTrimBottom
		local ok = pcall(function()
			trim:SetAtlas(atlas)
		end)
		local okB = pcall(function()
			trimBottom:SetAtlas(atlas)
		end)
		if ok and okB and trim:GetAtlas() and trimBottom:GetAtlas() then
			trim:SetTexCoord(0, 1, 0, 0.36)
			local tw = math.max(140, math.floor((tooltip:GetWidth() or 220) + 8))
			local srcW, srcH = 467, 141
			if C_Texture and C_Texture.GetAtlasInfo then
				local ok2, info = pcall(C_Texture.GetAtlasInfo, atlas)
				if ok2 and info and info.width and info.height and info.width > 0 and info.height > 0 then
					srcW, srcH = info.width, info.height
				end
			end
			local th = math.max(6, math.floor((tw * (((0.36 - 0) * srcH) / srcW)) + 0.5))
			trim:SetSize(tw, th)
			trim:ClearAllPoints()
			trim:SetPoint("BOTTOM", tooltip, "TOP", 0, -8)
			trim:SetAlpha(0.9)
			trim:Show()

			trimBottom:SetTexCoord(0, 1, 2 / 3, 1)
			local bh = math.max(6, math.floor((tw * (((1 - (2 / 3)) * srcH) / srcW)) + 0.5))
			trimBottom:SetSize(tw, bh)
			trimBottom:ClearAllPoints()
			trimBottom:SetPoint("TOP", tooltip, "BOTTOM", 0, 9)
			trimBottom:SetAlpha(0.9)
			trimBottom:Show()
		else
			trim:Hide()
			trimBottom:Hide()
		end
	end
	tooltip.blackListTooltipPlayerStyled = true
end

-- Same rules as EPF Custom Skins (Options.lua): gray hover, gold active row.
function U.applyEPFListRowStyle(button)
	if not button or button.blackListEPFStyled then
		return
	end
	button.blackListEPFStyled = true

	local selectedTex = button:CreateTexture(nil, "BACKGROUND")
	selectedTex:SetAllPoints(button)
	local okSel = pcall(function() selectedTex:SetAtlas("Options_List_Active") end)
	if not okSel or not selectedTex:GetAtlas() then
		selectedTex:SetColorTexture(1, 0.84, 0, 0.22)
	end
	button.SelectedTexture = selectedTex
	selectedTex:Hide()

	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints(button)
	local okH = pcall(function() highlight:SetAtlas("Options_List_Hover") end)
	if not okH or not highlight:GetAtlas() then
		highlight:SetColorTexture(1, 1, 1, 0.15)
	end
	button:SetHighlightTexture(highlight)
end

function U.createChromeParent(name, parent, width, height, opts)
	opts = opts or {}
	local f, usesNine
	local tryNine = not opts.noNineSlice
	local ok, fr = false, nil
	if tryNine then
		ok, fr = pcall(CreateFrame, "Frame", name, parent, "NineSlicePanelTemplate")
	end
	if ok and fr then
		f = fr
		usesNine = true
	else
		f = CreateFrame("Frame", name, parent, "BackdropTemplate")
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		usesNine = false
	end
	f.blackListDesiredWidth = width
	f.blackListDesiredHeight = height
	f:SetSize(width, height)
	f:EnableMouse(true)
	f:Hide()
	f.blackListUsesNineSlice = usesNine
	return f
end

function U.safeStopMovingOrSizing(frame)
	if frame and frame.StopMovingOrSizing then
		pcall(function()
			frame:StopMovingOrSizing()
		end)
	end
end

--- After NineSliceUtil.ApplyLayoutByName the frame may fill the screen; restore desired size.
function U.reapplyPanelSize(frame)
	if frame and frame.blackListDesiredWidth and frame.blackListDesiredHeight then
		frame:SetSize(frame.blackListDesiredWidth, frame.blackListDesiredHeight)
	end
end

--- NineSlice sometimes reapplies size one frame after first Show; force again on the next tick.
function U.scheduleReapplyPanelSize(panel)
	U.reapplyPanelSize(panel)
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if panel and panel:IsShown() then
				U.reapplyPanelSize(panel)
			end
		end)
	end
end

--- Edit window: avoid NineSlice here (Retail can full-screen + SetPoint "anchor family" error).
--- Same DBM chrome (ApplyDBMPanelChrome) on BackdropTemplate; fixed position next to the list.
function U.anchorStandaloneDetailsFrame(detailsFrame)
	if not detailsFrame then
		return
	end
	detailsFrame:ClearAllPoints()
	local mainFrame = getglobal("BlackListStandaloneFrame")
	if mainFrame and mainFrame:IsVisible() then
		detailsFrame:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 10, 0)
	else
		detailsFrame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
	end
end

--- ESC closes the frame (same UISpecialFrames list as Blizzard special windows).
function U.registerEscClose(frame)
	if not frame or frame.blackListEscCloseRegistered then
		return
	end
	local name = frame.GetName and frame:GetName()
	if not name or not UISpecialFrames or not tinsert then
		return
	end
	for i = 1, #UISpecialFrames do
		if UISpecialFrames[i] == name then
			frame.blackListEscCloseRegistered = true
			return
		end
	end
	tinsert(UISpecialFrames, name)
	frame.blackListEscCloseRegistered = true
end

--- Options panel shell (same chrome as main DBM-styled window).
function U.createBlackListFrame(name, width, parent, x, y)
	return U.createChromeParent(name, parent, width, 400)
end

function U.createBlackListHeader(frame, text, fontSize, pad)
	-- 3rd arg must be a font template name, not a Frame (Retail would show nothing)
	local t = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	t:SetPoint("TOP", frame, "TOP", 0, pad)
	t:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
	t:SetTextColor(1, 0.82, 0)  -- Gold color
	t:SetText(text)
	return t
end

function U.createBlackListOption(frame, name, desc, pad, onclick)
	local c = CreateFrame("CheckButton", name, frame, "UICheckButtonTemplate")
	c:SetHeight(20)
	c:SetWidth(20)
	c:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, pad)
	c:SetScript("OnClick", function(self)
		onclick(self:GetChecked())
	end)
	
	local ct = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	ct:SetPoint("LEFT", c, "RIGHT", 5, 0)
	ct:SetFont("Fonts\\FRIZQT__.TTF", 11)
	ct:SetTextColor(1, 1, 1)  -- White text
	ct:SetText(desc)
	ct:SetWidth(U.optionsCheckTextWidth)
	ct:SetJustifyH("LEFT")

	return c, ct
end
