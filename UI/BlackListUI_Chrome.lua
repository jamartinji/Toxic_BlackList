local _, Addon = ...
local L = Addon.L
local U = Addon.UI

function BlackList:InitFriendsBlacklistRowButton(button)
	U.applyEPFListRowStyle(button)
end
function BlackList:AttachBlackListResizeGrip(frame)
	if not frame or frame.blackListResizeGrip then
		return
	end
	if not (frame.SetResizable and frame.StartSizing and frame.StopMovingOrSizing and frame.SetResizeBounds) then
		return
	end
	local minW = frame.blackListResizeMinW or 260
	local minH = frame.blackListResizeMinH or 200
	frame:SetResizable(true)
	local uw = UIParent and UIParent:GetWidth() or 2000
	local uh = UIParent and UIParent:GetHeight() or 1200
	frame:SetResizeBounds(minW, minH, math.max(minW, uw - 24), math.max(minH, uh - 24))

	local grip = CreateFrame("Button", nil, frame)
	grip:SetSize(16, 16)
	grip:EnableMouse(true)
	grip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, 1)
	grip:SetFrameLevel((frame:GetFrameLevel() or 0) + 10)
	grip:SetScript("OnMouseDown", function()
		frame:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnMouseUp", function()
		U.safeStopMovingOrSizing(frame)
		frame.blackListDesiredWidth = frame:GetWidth()
		frame.blackListDesiredHeight = frame:GetHeight()
	end)

	local resizeNormal = grip:CreateTexture(nil, "OVERLAY")
	resizeNormal:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	resizeNormal:SetTexCoord(0, 1, 0, 1)
	resizeNormal:SetPoint("BOTTOMLEFT", grip, 0, 1)
	resizeNormal:SetPoint("TOPRIGHT", grip, -1, 0)
	grip:SetNormalTexture(resizeNormal)

	local resizePushed = grip:CreateTexture(nil, "OVERLAY")
	resizePushed:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	resizePushed:SetTexCoord(0, 1, 0, 1)
	resizePushed:SetPoint("BOTTOMLEFT", grip, 0, 1)
	resizePushed:SetPoint("TOPRIGHT", grip, -1, 0)
	grip:SetPushedTexture(resizePushed)

	local resizeHighlight = grip:CreateTexture(nil, "OVERLAY")
	resizeHighlight:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	resizeHighlight:SetTexCoord(0, 1, 0, 1)
	resizeHighlight:SetPoint("BOTTOMLEFT", grip, 0, 1)
	resizeHighlight:SetPoint("TOPRIGHT", grip, -1, 0)
	grip:SetHighlightTexture(resizeHighlight)

	frame.blackListResizeGrip = grip
end

--- DBM-style options window: NineSliceUtil.ApplyLayout + dark background + GameFontNormal header + close (MainFrame.lua).
function BlackList:ApplyDBMPanelChrome(frame, initialTitle, titleFontStringGlobalName)
	if frame.blackListDBMChrome then
		if frame.BlackListTitleText and initialTitle ~= nil then
			frame.BlackListTitleText:SetText(initialTitle)
		end
		U.reapplyPanelSize(frame)
		return
	end
	frame.blackListDBMChrome = true

	if frame.blackListUsesNineSlice and NineSliceUtil and NineSliceUtil.ApplyLayoutByName then
		pcall(NineSliceUtil.ApplyLayoutByName, frame, "ButtonFrameTemplateNoPortrait")
	end

	local isMainline = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
	local topBg = frame.blackListUsesNineSlice and (isMainline and -24 or -21) or -40
	local botBg = frame.blackListUsesNineSlice and (isMainline and 2 or 8) or 6

	local frameBg = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
	frameBg:SetColorTexture(0, 0, 0, 0.82)
	frameBg:SetPoint("TOPLEFT", 5, topBg)
	frameBg:SetPoint("BOTTOMRIGHT", -2, botBg)

	local frameHeader = CreateFrame("Frame", nil, frame)
	frameHeader:SetSize(0, 22)
	frameHeader:SetPoint("TOPLEFT", 8, -2)
	frameHeader:SetPoint("TOPRIGHT", -30, -2)
	local fsName = titleFontStringGlobalName or "BlackList_FrameTitleText"
	local titleFs = frameHeader:CreateFontString(fsName, "ARTWORK", "GameFontNormal")
	titleFs:ClearAllPoints()
	titleFs:SetPoint("TOPLEFT", frameHeader, "TOPLEFT", 6, -6)
	titleFs:SetPoint("TOPRIGHT", frameHeader, "TOPRIGHT", -6, -6)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetText(initialTitle or "")
	frame.BlackListTitleText = titleFs
	frame.blackListTitleDragHeader = frameHeader
	if frame.blackListProminentTitleBar then
		if not frame.BlackListTitleBarBg then
			local titleBg = frame:CreateTexture(nil, "BACKGROUND", nil, -6)
			titleBg:SetColorTexture(0.1, 0.1, 0.12, 0.98)
			titleBg:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
			titleBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
			titleBg:SetPoint("BOTTOM", frameHeader, "BOTTOM", 0, 0)
			frame.BlackListTitleBarBg = titleBg
		end
		titleFs:SetTextColor(1, 0.82, 0)
	end
	if frame.blackListTitleDraggable then
		frame:SetMovable(true)
		frameHeader:EnableMouse(true)
		frameHeader:RegisterForDrag("LeftButton")
		frameHeader:SetScript("OnDragStart", function()
			frame:StartMoving()
		end)
		frameHeader:SetScript("OnDragStop", function()
			U.safeStopMovingOrSizing(frame)
		end)
	end

	local closeBtn
	local okClose = pcall(function()
		closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButtonDefaultAnchors")
	end)
	if okClose and closeBtn then
		closeBtn:SetScript("OnClick", function()
			frame:Hide()
		end)
	else
		closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
		closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
		closeBtn:SetScript("OnClick", function()
			frame:Hide()
		end)
	end
	frame.BlackListTitleCloseButton = closeBtn

	U.reapplyPanelSize(frame)
	if frame.blackListEnableResize then
		self:AttachBlackListResizeGrip(frame)
	end
	if not frame.blackListOnHideMovingHooked then
		frame.blackListOnHideMovingHooked = true
		frame:HookScript("OnHide", function(self)
			U.safeStopMovingOrSizing(self)
		end)
	end
	U.registerEscClose(frame)
end

--- Friends XML details frame: same NineSlice + background as DBM-GUI.
function BlackList:SkinFriendsDetailsFrameDBM(frame)
	if not frame or frame.blackListFriendsDBMSkinned then
		return
	end
	if not (NineSliceUtil and NineSliceUtil.ApplyLayoutByName) then
		return
	end
	local dw, dh = frame:GetWidth(), frame:GetHeight()
	if not dw or dw < 80 then
		dw = 297
	end
	if not dh or dh < 80 then
		dh = 250
	end
	frame.blackListDesiredWidth = dw
	frame.blackListDesiredHeight = dh
	local ok = pcall(function()
		if frame.SetBackdrop then
			frame:SetBackdrop(nil)
		end
		NineSliceUtil.ApplyLayoutByName(frame, "ButtonFrameTemplateNoPortrait")
	end)
	if not ok then
		return
	end
	frame.blackListFriendsDBMSkinned = true
	U.reapplyPanelSize(frame)
	frame.blackListEnableResize = true
	frame.blackListResizeMinW = 240
	frame.blackListResizeMinH = 180
	self:AttachBlackListResizeGrip(frame)
	local corner = _G["BlackListDetailsCorner"]
	if corner then
		corner:Hide()
	end
	local isMainline = not WOW_PROJECT_ID or WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
	local frameBg = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
	frameBg:SetColorTexture(0, 0, 0, 0.82)
	frameBg:SetPoint("TOPLEFT", 5, isMainline and -24 or -21)
	frameBg:SetPoint("BOTTOMRIGHT", -2, isMainline and 2 or 8)
	U.registerEscClose(frame)
end
BlackList._floatSizeSliders = BlackList._floatSizeSliders or {}

function BlackList:RegisterFloatSizeSlider(slider)
	if not slider then
		return
	end
	for _, s in ipairs(self._floatSizeSliders) do
		if s == slider then
			return
		end
	end
	table.insert(self._floatSizeSliders, slider)
end

function BlackList:SetFloatingQuickSizeSlidersValue(sz)
	sz = math.max(U.floatBtnSizeMin, math.min(U.floatBtnSizeMax, math.floor(tonumber(sz) or U.floatBtnDefaultSize)))
	for _, s in ipairs(self._floatSizeSliders or {}) do
		if s then
			s._blSuppress = true
			s:SetValue(sz)
			s._blSuppress = nil
			if s.blValueText then
				s.blValueText:SetText(tostring(sz) .. " × " .. tostring(sz))
			end
		end
	end
end

function BlackList:PropagateFloatingQuickSizeToOtherSliders(fromSlider, v)
	v = math.max(U.floatBtnSizeMin, math.min(U.floatBtnSizeMax, math.floor(tonumber(v) or U.floatBtnDefaultSize)))
	for _, s in ipairs(self._floatSizeSliders or {}) do
		if s and s ~= fromSlider then
			s._blSuppress = true
			s:SetValue(v)
			s._blSuppress = nil
			if s.blValueText then
				s.blValueText:SetText(tostring(v) .. " × " .. tostring(v))
			end
		end
	end
end

function BlackList:ApplyFloatingQuickButtonSize()
	local btn = _G.BlackListFloatingQuickButton
	if not btn then
		return
	end
	local raw = self:GetOption("floatingQuickButtonSize", U.floatBtnDefaultSize)
	local sz = tonumber(raw) or U.floatBtnDefaultSize
	sz = math.max(U.floatBtnSizeMin, math.min(U.floatBtnSizeMax, math.floor(sz)))
	if not BlackListOptions then
		BlackListOptions = {}
	end
	if BlackListOptions.floatingQuickButtonSize ~= sz then
		BlackListOptions.floatingQuickButtonSize = sz
	end
	btn:SetSize(sz, sz)
	local ic = btn.blackListFloatingIcon
	if ic then
		local isz = math.max(16, math.floor(sz * 0.875))
		ic:SetSize(isz, isz)
	end
end

--- Shared controls: in-game options window and Esc -> AddOns panel.
function BlackList:InstallFloatingQuickOptions(parent, namePrefix)
	if not parent or parent.blFloatingOptsInstalled then
		return
	end
	namePrefix = namePrefix or "BlackListFloatOpt"
	parent.blFloatingOptsInstalled = true

	local pad = -10
	U.createBlackListHeader(parent, L["OPT_SECTION_FLOATING"] or L["OPT_TAB_FLOATING"] or "On-screen button", 11, pad)
	pad = pad - 24

	local showCb = select(1, U.createBlackListOption(parent, namePrefix .. "ShowFloat", L["OPT_SHOW_FLOATING_QUICK_BUTTON"] or "Show on-screen quick button", pad, function(checked)
		BlackList:ToggleOption("showFloatingQuickButton", checked)
	end))
	pad = pad - U.optionsRowGap

	local lblSize = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	lblSize:SetFont("Fonts\\FRIZQT__.TTF", 11)
	lblSize:SetTextColor(1, 1, 1)
	lblSize:SetWidth(U.optionsCheckTextWidth)
	lblSize:SetJustifyH("LEFT")
	lblSize:SetPoint("TOPLEFT", showCb, "BOTTOMLEFT", 24, -10)
	lblSize:SetText(L["OPT_FLOAT_BTN_SIZE"] or "Button size (width × height)")

	local slider = CreateFrame("Slider", nil, parent)
	slider:SetOrientation("HORIZONTAL")
	slider:SetWidth(220)
	slider:SetHeight(20)
	slider:SetPoint("TOPLEFT", lblSize, "BOTTOMLEFT", -24, -8)
	slider:SetMinMaxValues(U.floatBtnSizeMin, U.floatBtnSizeMax)
	slider:SetValueStep(2)
	slider:EnableMouseWheel(true)
	pcall(function()
		slider:SetObeyStepOnDrag(true)
	end)
	local bg = slider:CreateTexture(nil, "BACKGROUND")
	bg:SetColorTexture(0.22, 0.22, 0.22, 0.95)
	bg:SetHeight(5)
	bg:SetPoint("LEFT", slider, "LEFT", 6, 0)
	bg:SetPoint("RIGHT", slider, "RIGHT", -6, 0)
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	local valStr = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	valStr:SetFont("Fonts\\FRIZQT__.TTF", 11)
	valStr:SetPoint("LEFT", slider, "RIGHT", 12, 0)
	valStr:SetTextColor(0.88, 0.88, 0.88)
	slider.blValueText = valStr
	slider:SetScript("OnValueChanged", function(self, v)
		if self._blSuppress then
			return
		end
		v = math.floor(tonumber(v) or U.floatBtnDefaultSize)
		v = math.max(U.floatBtnSizeMin, math.min(U.floatBtnSizeMax, v))
		if v % 2 ~= 0 then
			v = v - 1
		end
		if not BlackListOptions then
			BlackListOptions = {}
		end
		BlackListOptions.floatingQuickButtonSize = v
		valStr:SetText(tostring(v) .. " × " .. tostring(v))
		BlackList:ApplyFloatingQuickButtonSize()
		BlackList:PropagateFloatingQuickSizeToOtherSliders(self, v)
	end)
	slider:SetScript("OnMouseWheel", function(self, delta)
		local step = delta > 0 and 2 or -2
		self:SetValue(self:GetValue() + step)
	end)

	self:RegisterFloatSizeSlider(slider)

	local resetBtn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	resetBtn:SetSize(200, 26)
	resetBtn:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", -4, -18)
	resetBtn:SetText(L["OPT_FLOAT_BTN_RESET"] or "Reset position & size")
	resetBtn:SetScript("OnClick", function()
		if not BlackListOptions then
			BlackListOptions = {}
		end
		BlackListOptions.floatingQuickButtonPos = nil
		BlackListOptions.floatingQuickButtonSize = U.floatBtnDefaultSize
		local b = _G.BlackListFloatingQuickButton
		if b then
			BlackList:ApplyFloatingQuickButtonSavedPosition(b)
			BlackList:ApplyFloatingQuickButtonSize()
		end
		BlackList:SetFloatingQuickSizeSlidersValue(U.floatBtnDefaultSize)
	end)

	parent.blFloatingWidgets = {
		showCb = showCb,
		slider = slider,
		resetBtn = resetBtn,
	}

	function parent:SyncBlackListFloatingWidgets()
		local w = parent.blFloatingWidgets
		if not w then
			return
		end
		w.showCb:SetChecked(BlackList:GetOption("showFloatingQuickButton", true))
		local sz = tonumber(BlackList:GetOption("floatingQuickButtonSize", U.floatBtnDefaultSize)) or U.floatBtnDefaultSize
		sz = math.max(U.floatBtnSizeMin, math.min(U.floatBtnSizeMax, math.floor(sz)))
		if sz % 2 ~= 0 then
			sz = sz - 1
		end
		w.slider._blSuppress = true
		w.slider:SetValue(sz)
		w.slider._blSuppress = nil
		if w.slider.blValueText then
			w.slider.blValueText:SetText(tostring(sz) .. " × " .. tostring(sz))
		end
	end
end
