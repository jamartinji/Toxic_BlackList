local _, Addon = ...
local L = Addon.L

local classNamesById = {
	"WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN",
	"MAGE", "WARLOCK", "MONK", "DRUID", "DEMONHUNTER", "EVOKER",
}

local function formatNameRealm(fullname)
	if not fullname then
		return nil, nil
	end
	local name, realm
	if fullname:find("-", nil, true) then
		name, realm = strsplit("-", fullname)
	else
		name = fullname
	end
	if not realm or realm == "" then
		realm = GetRealmName()
	end
	return name, realm
end

local function classToToken(c)
	if type(c) == "number" and c >= 1 and c <= #classNamesById then
		return classNamesById[c]
	end
	return c
end

local function getLFGInfo(owner)
	local resultID = owner.resultID
	if resultID then
		local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
		if not searchResultInfo or not searchResultInfo.leaderName then
			return
		end
		local name, realm = formatNameRealm(searchResultInfo.leaderName)
		local class
		for i = 1, searchResultInfo.numMembers do
			local _, c, _, _, isLeader = C_LFGList.GetSearchResultMemberInfo(resultID, i)
			if isLeader then
				class = classToToken(c)
				break
			end
		end
		return name, realm, class
	end
	local memberIdx = owner.memberIdx
	if not memberIdx then
		return
	end
	local parent = owner:GetParent()
	if not parent then
		return
	end
	local applicantID = parent.applicantID
	if not applicantID then
		return
	end
	local fullName, class = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
	if not fullName then
		return
	end
	local name, realm = formatNameRealm(fullName)
	return name, realm, classToToken(class)
end

function BlackList:RegisterContextMenu()
	if self._ctxMenuRegistered then
		return
	end
	if not (Menu and Menu.ModifyMenu) then
		return
	end
	self._ctxMenuRegistered = true

	local function isValidContextName(contextData)
		return contextData.name and strsub(contextData.name, 1, 1) ~= "|"
	end

	local function handler(owner, rootDescription, contextData)
		local name, realm, class, race

		if not contextData then
			local tag = rootDescription.tag
			if tag == "MENU_LFG_FRAME_SEARCH_ENTRY" or tag == "MENU_LFG_FRAME_MEMBER_APPLY" then
				name, realm, class = getLFGInfo(owner)
			else
				return
			end
		else
			if not isValidContextName(contextData) then
				return
			end
			realm = contextData.server or GetRealmName()
			name = contextData.name
			local guid
			if contextData.lineID then
				if tonumber(contextData.lineID) < 4000000000 then
					guid = C_ChatInfo.GetChatLineSenderGUID(contextData.lineID)
				else
					class = classNamesById[tonumber(contextData.lineID) - 4000000000]
				end
			elseif contextData.unit then
				guid = UnitGUID(contextData.unit)
			elseif contextData.guid then
				guid = contextData.guid
			else
				return
			end
			if guid then
				local _, c, locRace = GetPlayerInfoByGUID(guid)
				if not class then
					class = c
				end
				race = locRace
			end
			-- Friends list → Recent Allies: no unit token; use API character data if GUID lookup missed class/race
			local raChar = contextData.recentAllyData and contextData.recentAllyData.characterData
			if raChar then
				if not class and raChar.classID and C_CreatureInfo and C_CreatureInfo.GetClassInfo then
					local ci = C_CreatureInfo.GetClassInfo(raChar.classID)
					if ci then
						class = ci.classFile
					end
				end
				if (not race or race == "") and raChar.raceID and C_CreatureInfo and C_CreatureInfo.GetRaceInfo then
					local ri = C_CreatureInfo.GetRaceInfo(raChar.raceID)
					if ri then
						race = ri.raceName
					end
				end
			end
		end

		if not name or name == "" then
			return
		end
		if self:IsContextPlayerSelf(name, realm) then
			return
		end

		local onList = self:GetIndexByName(name) > 0
		local title = L["BLACKLIST"] or "Toxic BlackList"
		local addTxt = L["CONTEXT_ADD_BLACKLIST"] or "Add to blacklist"
		local rmTxt = L["CONTEXT_REMOVE_BLACKLIST"] or "Remove from blacklist"

		rootDescription:CreateDivider()
		rootDescription:CreateTitle(title)
		rootDescription:CreateButton(onList and rmTxt or addTxt, function()
			if onList then
				BlackList:RemovePlayer(name)
			else
				BlackList:AddPlayerFromContextMenu(name, realm, class, race, contextData.unit)
			end
		end)
	end

	local tags = {
		"MENU_UNIT_PLAYER",
		"MENU_UNIT_ENEMY_PLAYER",
		"MENU_UNIT_PARTY",
		"MENU_UNIT_RAID_PLAYER",
		"MENU_UNIT_FRIEND",
		"MENU_UNIT_COMMUNITIES_GUILD_MEMBER",
		"MENU_UNIT_COMMUNITIES_MEMBER",
		-- Friends frame → Recent Allies (right-click on a recent ally row)
		"MENU_UNIT_RECENT_ALLY",
		"MENU_UNIT_RECENT_ALLY_OFFLINE",
		"MENU_LFG_FRAME_SEARCH_ENTRY",
		"MENU_LFG_FRAME_MEMBER_APPLY",
	}

	for i = 1, #tags do
		Menu.ModifyMenu(tags[i], handler)
	end
end
