local _, Addon = ...
local L = Addon.L
local U = Addon.UI

function BlackList:ShowOptions()
	-- Use the new SuperIgnore-style options instead of the old XML frame
	self:ShowNewOptions()
end

function BlackList:ToggleOption(optionName, value)
	if (not BlackListOptions) then
		BlackListOptions = {};
	end
	BlackListOptions[optionName] = value;
	
	-- Clear warning cache when whisper options change
	if optionName == "preventWhispers" or optionName == "warnWhispers" then
		Already_Warned_For["WHISPER"] = {};
	end
	if optionName == "warnNameplate" then
		Already_Warned_For["NAMEPLATE"] = {};
	end
	if optionName == "showFloatingQuickButton" and self.RefreshFloatingQuickButtonVisibility then
		self:RefreshFloatingQuickButtonVisibility()
	end
end

function BlackList:GetOption(optionName, defaultValue)
	if (not BlackListOptions) then
		BlackListOptions = {};
	end
	if (BlackListOptions[optionName] == nil) then
		return defaultValue;
	end
	return BlackListOptions[optionName];
end

function BlackList:UpdateOptionsUI()
	-- Set default values if not set
	getglobal("BlackListOptionsCheckButton2"):SetChecked(self:GetOption("warnTarget", true));
	getglobal("BlackListOptionsCheckButton3"):SetChecked(self:GetOption("preventWhispers", true));
	getglobal("BlackListOptionsCheckButton4"):SetChecked(self:GetOption("warnWhispers", true));
	getglobal("BlackListOptionsCheckButton5"):SetChecked(self:GetOption("preventInvites", false));
	getglobal("BlackListOptionsCheckButton6"):SetChecked(self:GetOption("preventMyInvites", true));
	getglobal("BlackListOptionsCheckButton7"):SetChecked(self:GetOption("warnPartyJoin", true));
end

function BlackList:SaveFloatingQuickButtonPosition(btn)
	if not btn then
		return
	end
	local p, _, rp, x, y = btn:GetPoint(1)
	if not p then
		return
	end
	if not BlackListOptions then
		BlackListOptions = {}
	end
	BlackListOptions.floatingQuickButtonPos = {
		point = p,
		relPoint = rp,
		x = x,
		y = y,
	}
end

function BlackList:ApplyFloatingQuickButtonSavedPosition(btn)
	if not btn then
		return
	end
	btn:ClearAllPoints()
	local s = BlackListOptions and BlackListOptions.floatingQuickButtonPos
	if s and s.point then
		btn:SetPoint(s.point, UIParent, s.relPoint or s.point, s.x or 0, s.y or 0)
	else
		btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function BlackList:RefreshFloatingQuickButtonVisibility()
	local btn = _G.BlackListFloatingQuickButton
	if not btn then
		return
	end
	if self:GetOption("showFloatingQuickButton", true) then
		btn:Show()
	else
		btn:Hide()
	end
end

--- Ctrl+left-click: add/edit target with edit window; minimap and normal clicks: left list, right options.
function BlackList:FloatingQuickButtonAddTargetAndEdit()
	if not UnitExists("target") or not UnitIsPlayer("target") then
		return
	end
	local nm = UnitName("target")
	if not nm or nm == "" then
		return
	end
	local idx = self:GetIndexByName(nm)
	if idx > 0 then
		self:SetSelectedBlackList(idx)
	else
		self:AddPlayer("target")
		idx = self:GetIndexByName(nm)
		if idx <= 0 then
			return
		end
		self:SetSelectedBlackList(idx)
	end
	local fr = getglobal("BlackListStandaloneFrame")
	if fr and not fr:IsVisible() and self.ToggleStandaloneWindow then
		self:ToggleStandaloneWindow()
	end
	if self.UpdateStandaloneUI then
		self:UpdateStandaloneUI()
	end
	if self.ShowStandaloneDetails then
		self:ShowStandaloneDetails()
	end
end

--- Floating button: like minimap (left list, right options); Ctrl+click add; Alt+drag moves.
function BlackList:CreateFloatingQuickButton()
	if _G.BlackListFloatingQuickButton then
		self:ApplyFloatingQuickButtonSavedPosition(_G.BlackListFloatingQuickButton)
		self:ApplyFloatingQuickButtonSize()
		self:RefreshFloatingQuickButtonVisibility()
		return _G.BlackListFloatingQuickButton
	end
	local initSz = tonumber(self:GetOption("floatingQuickButtonSize", U.floatBtnDefaultSize)) or U.floatBtnDefaultSize
	initSz = math.max(U.floatBtnSizeMin, math.min(U.floatBtnSizeMax, math.floor(initSz)))
	local btn = CreateFrame("Button", "BlackListFloatingQuickButton", UIParent)
	btn:SetSize(initSz, initSz)
	btn:SetFrameStrata("MEDIUM")
	btn:SetFrameLevel(85)
	btn:SetMovable(true)
	btn:SetClampedToScreen(true)
	btn:EnableMouse(true)
	btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	local iconSz = math.max(16, math.floor(initSz * 0.875))
	icon:SetSize(iconSz, iconSz)
	icon:SetPoint("CENTER", 0, 0)
	icon:SetTexture(U.assetsButton)
	btn.blackListFloatingIcon = icon

	btn:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and IsAltKeyDown() and not IsControlKeyDown() then
			self.blackListFloatAltDrag = true
			self:StartMoving()
		end
	end)
	btn:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.blackListFloatAltDrag then
			self:StopMovingOrSizing()
			self.blackListFloatAltDrag = false
			self.blackListFloatSkipLeftClick = true
			BlackList:SaveFloatingQuickButtonPosition(self)
		end
	end)
	btn:SetScript("OnClick", function(self, button)
		if button == "LeftButton" and self.blackListFloatSkipLeftClick then
			self.blackListFloatSkipLeftClick = false
			return
		end
		if button == "LeftButton" and IsControlKeyDown() then
			BlackList:FloatingQuickButtonAddTargetAndEdit()
			return
		end
		if button == "RightButton" and IsControlKeyDown() then
			if UnitExists("target") and UnitIsPlayer("target") then
				BlackList:AddPlayer("target")
				if BlackList.UpdateStandaloneUI then
					BlackList:UpdateStandaloneUI()
				end
			end
			return
		end
		if button == "LeftButton" then
			BlackList:ToggleStandaloneWindow()
		elseif button == "RightButton" then
			BlackList:ShowNewOptions()
		end
	end)
	btn:SetScript("OnEnter", function(self)
		local ic = self.blackListFloatingIcon
		if ic then
			ic:SetScale(1.06)
		end
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:ClearLines()
		local leftAction = tostring(L["TOOLTIP_FLOAT_RIGHT_LIST"] or L["MINIMAP_TOOLTIP_RIGHT_LIST"] or "Open list"):gsub("^[^:：]+[:：]%s*", "")
		local rightAction = tostring(L["TOOLTIP_FLOAT_LEFT_OPTIONS"] or L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] or "Open options"):gsub("^[^:：]+[:：]%s*", "")
		GameTooltip:AddLine("|cffffff00" .. string.format(tostring(L["MINIMAP_TOOLTIP_LEFT_CLICK"] or "Left-click: %s"), leftAction) .. "|r", 1, 1, 1, false)
		GameTooltip:AddLine("|cffffff00" .. string.format(tostring(L["MINIMAP_TOOLTIP_RIGHT_CLICK"] or "Right-click: %s"), rightAction) .. "|r", 1, 1, 1, false)
		GameTooltip:AddLine(" ", 1, 1, 1, false)
		GameTooltip:AddLine("|cff22cc22" .. (L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] or "") .. "|r", 1, 1, 1, false)
		GameTooltip:AddLine("|cff22cc22" .. (L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] or "") .. "|r", 1, 1, 1, false)
		GameTooltip:AddLine(" ", 1, 1, 1, false)
		GameTooltip:AddLine("|cff5599ff" .. (L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] or L["TOOLTIP_FLOATING_QUICK_DRAG"] or "") .. "|r", 1, 1, 1, false)
		GameTooltip:Show()
		local n = 0
		pcall(function()
			local c = GameTooltip:NumLines()
			if type(c) == "number" then
				n = c
			end
		end)
		for i = 1, n do
			local line = _G["GameTooltipTextLeft" .. i]
			if line and line.SetFontObject then
				line:SetFontObject(GameFontNormal)
			end
		end
	end)
	btn:SetScript("OnLeave", function(self)
		local ic = self.blackListFloatingIcon
		if ic then
			ic:SetScale(1)
		end
		GameTooltip_Hide()
	end)

	self:ApplyFloatingQuickButtonSavedPosition(btn)
	self:ApplyFloatingQuickButtonSize()
	self:RefreshFloatingQuickButtonVisibility()
	return btn
end