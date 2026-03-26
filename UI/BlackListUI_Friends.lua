local _, Addon = ...
local L = Addon.L
local U = Addon.UI

-- Legacy Friends-frame tab removed; keep minimal API for bindings and compat.

function BlackList:ClickBlackList(button)
	local index = button and button:GetID()
	if not index then
		return
	end
	self:SetSelectedBlackList(index)
	if self.UpdateStandaloneUI then
		self:UpdateStandaloneUI()
	end
	if self.ShowStandaloneDetails then
		self:ShowStandaloneDetails()
	end
end

function BlackList:SetSelectedBlackList(index)
	U.selectedIndex = index
end

function BlackList:GetSelectedBlackList()
	return U.selectedIndex
end

function BlackList:ShowTab()
	if self.ToggleStandaloneWindow then
		local f = getglobal("BlackListStandaloneFrame")
		if f and not f:IsVisible() then
			f:Show()
		end
		if self.UpdateStandaloneUI then
			self:UpdateStandaloneUI()
		end
	end
end

function BlackList:ToggleTab()
	if self.ToggleStandaloneWindow then
		self:ToggleStandaloneWindow()
	end
end

function BlackList:ShowDetails()
	if self.ShowStandaloneDetails then
		self:ShowStandaloneDetails()
	end
end

function BlackList_Update()
	if BlackList.UpdateStandaloneUI then
		BlackList:UpdateStandaloneUI()
	end
end

function BlackList:UpdateUI()
	if self.UpdateStandaloneUI then
		self:UpdateStandaloneUI()
	end
end
