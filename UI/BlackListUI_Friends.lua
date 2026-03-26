local _, Addon = ...
local L = Addon.L
local U = Addon.UI

function BlackList:ClickBlackList(button)

	local index = button:GetID();

	self:SetSelectedBlackList(index);

	self:UpdateUI();

	self:ShowDetails();

end

function BlackList:SetSelectedBlackList(index)

	U.selectedIndex = index;

end

function BlackList:GetSelectedBlackList()

	return U.selectedIndex;

end

function BlackList:ShowTab()

	if not BlackListFrame then
		self:ToggleStandaloneWindow();
		return;
	end
	if FriendsFrameTopLeft then
		FriendsFrameTopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
		FriendsFrameTopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
		FriendsFrameBottomLeft:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-BotLeft");
		FriendsFrameBottomRight:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-BotRight");
	end
	if FriendsFrameTitleText then
		FriendsFrameTitleText:SetText(L["BLACKLIST"]);
	end
	if FriendsFrame_ShowSubFrame then
		FriendsFrame_ShowSubFrame("BlackListFrame");
	else
		BlackListFrame:Show();
	end
	self:UpdateUI();

end

function BlackList:ToggleTab()

	if ToggleFriendsFrame then
		ToggleFriendsFrame();
	end

	if BlackListFrame and BlackListFrame:IsVisible() then
		BlackListFrame:Hide();
	else
		BlackList:ShowTab();
	end

end

function BlackList:ShowDetails()

	-- get player
	local player = self:GetPlayerByIndex(self:GetSelectedBlackList());
	if not player then
		return
	end

	-- update details
	getglobal("BlackListDetailsName"):SetText(L["DETAILS_WINDOW_TITLE"] or (L["BLACKLIST"] or "Toxic BlackList"));

	getglobal("BlackListDetailsLevel"):SetText(self:FormatPlayerDetailsMainBlock(player));
	getglobal("BlackListDetailsRace"):SetText("");
	getglobal("BlackListDetailsRace"):Hide();

	getglobal("BlackListDetailsFactionInsignia"):SetTexture(0, 0, 0, 0);

	local lbl = getglobal("BlackListDetailsBlackListedLabel")
	if lbl then
		lbl:Hide()
	end
	local lvl = getglobal("BlackListDetailsLevel")
	local dt = getglobal("BlackListDetailsBlackListedText")
	if dt and self.FormatPlayerDetailsRichDateBlock then
		dt:SetText(self:FormatPlayerDetailsRichDateBlock(player))
		if lvl then
			dt:ClearAllPoints()
			dt:SetPoint("TOPLEFT", lvl, "BOTTOMLEFT", 0, -6)
		end
	end
	local rl = getglobal("BlackListDetailsReasonLabel")
	if rl then
		rl:SetText(L["REASON_HEADER"] or L["REASON"] or "Reason:")
		rl:SetTextColor(1, 1, 0.41)
		if dt then
			rl:ClearAllPoints()
			rl:SetPoint("TOPLEFT", dt, "BOTTOMLEFT", 0, -10)
		end
	end
	local reasonBg = getglobal("BlackListDetailsFrameReasonTextBackground")
	if reasonBg and rl then
		reasonBg:ClearAllPoints()
		reasonBg:SetPoint("TOPLEFT", rl, "BOTTOMLEFT", 0, -6)
		reasonBg:SetPoint("BOTTOMRIGHT", getglobal("BlackListDetailsFrame"), "BOTTOMRIGHT", -16, 36)
	end

	-- update reason
	getglobal("BlackListDetailsFrameReasonTextBox"):SetText(player["reason"]);

	getglobal("BlackListDetailsFrame"):Show();

end

function BlackList_Update()

	BlackList:UpdateUI();

end

function BlackList:UpdateUI()

	if not FriendsFrameBlackListScrollFrame or not FriendsFrameRemovePlayerButton then
		return;
	end

	local numBlackLists = BlackList:GetNumBlackLists();
	local nameText, name;
	local blacklistButton;
	local selectedBlackList = self:GetSelectedBlackList();

	if (numBlackLists > 0) then
		if (selectedBlackList == 0 or selectedBlackList > numBlackLists) then
			self:SetSelectedBlackList(1);
			selectedBlackList = 1;
		end
		FriendsFrameRemovePlayerButton:Enable();
	else
		FriendsFrameRemovePlayerButton:Disable();
	end

	local blacklistOffset = FauxScrollFrame_GetOffset(FriendsFrameBlackListScrollFrame);
	local blacklistIndex;
	for i=1, BLACKLISTS_TO_DISPLAY, 1 do
		blacklistIndex = i + blacklistOffset;
		nameText = getglobal("FriendsFrameBlackListButton" .. i .. "ButtonTextName");
		blacklistButton = getglobal("FriendsFrameBlackListButton" .. i);
		blacklistButton:SetID(blacklistIndex);

		if (blacklistIndex > numBlackLists) then
			blacklistButton:Hide();
		else
			local player = self:GetPlayerByIndex(blacklistIndex);
			nameText:SetText(self:FormatPlayerNameWithClassColor(player));
			blacklistButton:Show();
			blacklistButton:UnlockHighlight();
			if blacklistButton.SelectedTexture then
				blacklistButton.SelectedTexture:SetShown(blacklistIndex == selectedBlackList);
			end
		end
	end

	-- ScrollFrame stuff
	FauxScrollFrame_Update(FriendsFrameBlackListScrollFrame, numBlackLists, BLACKLISTS_TO_DISPLAY, FRIENDS_FRAME_BLACKLIST_HEIGHT);

end
