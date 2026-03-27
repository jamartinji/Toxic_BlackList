local _, Addon = ...
local L = Addon.L
BlackList = BlackList or {}

--- Single saved list for the whole WoW account (not per realm).
local ACCOUNT_LIST_KEY = "__ACCOUNT__"

local function NormalizePlayerName(name)
	if not name or name == "" then
		return nil
	end
	local s = Ambiguate and Ambiguate(name, "none") or name
	if GetLocale() ~= "zhTW" and GetLocale() ~= "zhCN" and GetLocale() ~= "koKR" then
		return string.lower(s)
	end
	return s
end

--- Lowercase trimmed realm for comparisons; empty = unknown / manual name-only.
local function NormalizeRealmKey(realm)
	return strtrim(tostring(realm or "")):lower()
end

--- Copy API strings to plain literals (Retail "secret string" taint from UnitName/GetRealmName, etc.).
local function SanitizeApiString(s)
	if s == nil then
		return ""
	end
	return strtrim(string.format("%s", s))
end

--- Merge legacy per-realm buckets into one account list (dedupe by name+realm). Safe to call repeatedly after migration flag is set.
function BlackList:MigrateToAccountWideList()
	if not BlackListedPlayers then
		return
	end
	local hadLegacy = false
	for k in pairs(BlackListedPlayers) do
		if k ~= ACCOUNT_LIST_KEY and type(k) == "string" then
			hadLegacy = true
			break
		end
	end
	if not hadLegacy then
		if not BlackListedPlayers[ACCOUNT_LIST_KEY] then
			BlackListedPlayers[ACCOUNT_LIST_KEY] = {}
		end
		return
	end
	local merged = {}
	local seen = {}
	local function entryDedupeKey(e)
		if type(e) ~= "table" or not e.name then
			return nil
		end
		local n = NormalizePlayerName(e.name) or ""
		local r = string.lower(strtrim(tostring(e.realm or "")))
		return n .. "|" .. r
	end
	local function appendEntry(e)
		local dk = entryDedupeKey(e)
		if not dk or seen[dk] then
			return
		end
		seen[dk] = true
		table.insert(merged, e)
	end
	for k, v in pairs(BlackListedPlayers) do
		if type(v) == "table" and type(k) == "string" then
			for _, e in ipairs(v) do
				appendEntry(e)
			end
		end
	end
	for k in pairs(BlackListedPlayers) do
		BlackListedPlayers[k] = nil
	end
	BlackListedPlayers[ACCOUNT_LIST_KEY] = merged
	if BlackListOptions then
		BlackListOptions.accountWideListMigrated = true
	end
end

function BlackList:GetAccountList()
	if not BlackListedPlayers then
		BlackListedPlayers = {}
	end
	self:MigrateToAccountWideList()
	if not BlackListedPlayers[ACCOUNT_LIST_KEY] then
		BlackListedPlayers[ACCOUNT_LIST_KEY] = {}
	end
	return BlackListedPlayers[ACCOUNT_LIST_KEY]
end

--- Ensure new fields on legacy entries (realm, guild, faction, updatedAt, manualAdd).
--- True when realm was never resolved (manual add or not yet seen in-game).
function BlackList:IsRealmUnknown(player)
	if not player then
		return true
	end
	self:EnsureEntryFields(player)
	return strtrim(tostring(player.realm or "")) == ""
end

function BlackList:EnsureEntryFields(player)
	if not player then
		return
	end
	if player.realm == nil then
		player.realm = ""
	end
	if player.guild == nil then
		player.guild = ""
	end
	if player.faction == nil then
		player.faction = ""
	end
	if player.level == nil then
		player.level = ""
	else
		player.level = tostring(player.level)
	end
	if player.class == nil then
		player.class = ""
	end
	if player.race == nil then
		player.race = ""
	end
	if player.raceToken == nil then
		player.raceToken = ""
	end
	if player.manualAdd == nil then
		if strtrim(tostring(player.level or "")) == "" and strtrim(tostring(player.class or "")) == "" then
			player.manualAdd = true
		else
			player.manualAdd = false
		end
	end
	if player.muted == nil then
		player.muted = false
	end
end

function BlackList:MigrateAllBlacklistedEntries()
	if not BlackListedPlayers then
		return
	end
	self:MigrateToAccountWideList()
	local list = self:GetAccountList()
	if not list then
		return
	end
	for _, entry in ipairs(list) do
		self:EnsureEntryFields(entry)
	end
end

function BlackList:SameLocalCalendarDay(t1, t2)
	if type(t1) ~= "number" or type(t2) ~= "number" then
		return false
	end
	local d1 = date("*t", t1)
	local d2 = date("*t", t2)
	return d1.year == d2.year and d1.month == d2.month and d1.day == d2.day
end

--- No level or class (name-only entry or data not filled yet).
function BlackList:PlayerEntryNeedsInfo(player)
	if not player then
		return true
	end
	self:EnsureEntryFields(player)
	return strtrim(tostring(player.level or "")) == "" and strtrim(tostring(player.class or "")) == ""
end

--- Refresh at most once per day; exception: missing info (manual add without data).
function BlackList:ShouldRefreshEntryFromUnit(player)
	if not player then
		return false
	end
	self:EnsureEntryFields(player)
	if self:PlayerEntryNeedsInfo(player) then
		return true
	end
	if not player.updatedAt or type(player.updatedAt) ~= "number" then
		return true
	end
	if self:SameLocalCalendarDay(player.updatedAt, time()) then
		return false
	end
	return true
end

local function unitLevelString(unit)
	if not unit then
		return ""
	end
	local lvl
	if UnitEffectiveLevel then
		local ok, v = pcall(UnitEffectiveLevel, unit)
		if ok and v and v > 0 then
			lvl = v
		end
	end
	if not lvl or lvl <= 0 then
		local ok, v = pcall(UnitLevel, unit)
		if ok and v and v > 0 then
			lvl = v
		end
	end
	if lvl and lvl > 0 then
		return tostring(lvl)
	end
	return ""
end

--- Fill field table from a player unit token.
function BlackList:CollectPlayerFieldsFromUnit(unit)
	if not unit then
		return nil
	end
	local okExists, unitExists = pcall(UnitExists, unit)
	if not okExists or unitExists ~= true then
		return nil
	end
	local okPl, isPl = pcall(UnitIsPlayer, unit)
	if not okPl or isPl ~= true then
		return nil
	end
	local level = unitLevelString(unit)
	local locClass, classToken = UnitClass(unit)
	local class = (classToken and classToken ~= "") and classToken or (locClass or "")
	local raceLoc, raceEn = UnitRace(unit)
	local race = raceLoc and SanitizeApiString(raceLoc) or ""
	local raceToken = raceEn and SanitizeApiString(raceEn) or ""
	local _, realmRaw = UnitName(unit)
	local realm = SanitizeApiString(realmRaw)
	if realm == "" then
		realm = SanitizeApiString(GetRealmName())
	end
	local guildName = ""
	local okG, g1 = pcall(GetGuildInfo, unit)
	if okG and g1 then
		guildName = tostring(g1)
	end
	local fg = nil
	local okF, fgv = pcall(UnitFactionGroup, unit)
	if okF then
		fg = fgv
	end
	local factionStr = ""
	if fg == "Alliance" then
		factionStr = L["ALLIANCE"] or "Alliance"
	elseif fg == "Horde" then
		factionStr = L["HORDE"] or "Horde"
	else
		factionStr = L["UNKNOWN"] or "Unknown"
	end
	return {
		level = level,
		class = class,
		race = race,
		raceToken = raceToken,
		realm = realm,
		guild = guildName,
		faction = factionStr,
	}
end

function BlackList:ApplyUnitDataToPlayerEntry(player, data)
	if not player or not data then
		return
	end
	if data.level and data.level ~= "" then
		player.level = data.level
	end
	if data.class and data.class ~= "" then
		player.class = data.class
	end
	if data.race and data.race ~= "" then
		player.race = data.race
	end
	if data.raceToken and data.raceToken ~= "" then
		player.raceToken = data.raceToken
	end
	if data.realm and data.realm ~= "" then
		player.realm = data.realm
	end
	player.guild = data.guild or ""
	if data.faction and data.faction ~= "" then
		player.faction = data.faction
	end
	player.updatedAt = time()
	if not self:PlayerEntryNeedsInfo(player) then
		player.manualAdd = false
	end
end

--- Remove duplicate name-only rows after this entry gained a real realm (same name, empty realm).
function BlackList:RemoveOtherUnknownSameNameEntries(keepName, keepIndex)
	if not keepName or not keepIndex or keepIndex < 1 then
		return
	end
	local norm = NormalizePlayerName(keepName)
	if not norm then
		return
	end
	local list = self:GetAccountList()
	for i = #list, 1, -1 do
		if i ~= keepIndex then
			local p = list[i]
			if p and NormalizePlayerName(p.name) == norm and self:IsRealmUnknown(p) then
				table.remove(list, i)
			end
		end
	end
end

--- If the unit is blacklisted and a refresh is due, merge live data (realm, guild, faction, etc.).
function BlackList:TryUpdateBlacklistedPlayerFromUnit(unit)
	if not unit then
		return
	end
	local okExists, unitExists = pcall(UnitExists, unit)
	if not okExists or unitExists ~= true then
		return
	end
	local okPl, isPl = pcall(UnitIsPlayer, unit)
	if not okPl or isPl ~= true then
		return
	end
	local okU, isSelf = pcall(UnitIsUnit, unit, "player")
	if okU and isSelf == true then
		return
	end
	local name = UnitName(unit)
	if not name then
		return
	end
	local data = self:CollectPlayerFieldsFromUnit(unit)
	if not data then
		return
	end
	local idx = self:FindEntryIndexForUnit(name, data.realm)
	if idx <= 0 then
		return
	end
	local player = self:GetPlayerByIndex(idx)
	if not player then
		return
	end
	self:EnsureEntryFields(player)
	if not self:ShouldRefreshEntryFromUnit(player) then
		return
	end
	local prevRealm = strtrim(tostring(player.realm or ""))
	self:ApplyUnitDataToPlayerEntry(player, data)
	if prevRealm == "" and strtrim(tostring(player.realm or "")) ~= "" then
		self:RemoveOtherUnknownSameNameEntries(player.name, idx)
	end
	local standaloneFrame = getglobal("BlackListStandaloneFrame")
	if standaloneFrame and standaloneFrame:IsVisible() and self.UpdateStandaloneUI then
		self:UpdateStandaloneUI()
		local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
		if detailsFrame and detailsFrame:IsVisible() and detailsFrame.currentPlayerIndex == idx and self.ShowStandaloneDetails then
			self:ShowStandaloneDetails()
		end
	end
end

function BlackList:MaybeRefreshBlacklistedUnit(unit)
	self:TryUpdateBlacklistedPlayerFromUnit(unit)
end

function BlackList:AddPlayer(player, reason)

	local name, level, class, race, raceEn, raceToken, added
	local realm, guild, faction, manualAdd, updatedAt
	local dataFromUnit = nil

	-- handle player
	if (player == "" or player == nil) then
		return;
	elseif (player == "target") then
		if (UnitIsPlayer("target")) then
			name = UnitName("target");
			level = unitLevelString("target");
			if level == "" then
				level = UnitLevel("target") .. "";
			end
			local locC, classToken = UnitClass("target");
			class = (classToken and classToken ~= "") and classToken or (locC or "");
			race, raceEn = UnitRace("target");
			manualAdd = false
			updatedAt = time()
			dataFromUnit = self:CollectPlayerFieldsFromUnit("target")
			if dataFromUnit then
				if dataFromUnit.level ~= "" then
					level = dataFromUnit.level
				end
				if dataFromUnit.class ~= "" then
					class = dataFromUnit.class
				end
				if dataFromUnit.race ~= "" then
					race = dataFromUnit.race
				end
				realm = dataFromUnit.realm or ""
				guild = dataFromUnit.guild or ""
				faction = dataFromUnit.faction or ""
			else
				realm = ""
				guild = ""
				faction = ""
			end
		else
			if BlackList.ShowAddPlayerDialog then
				BlackList:ShowAddPlayerDialog()
			end
			return
		end
	else
		name = player;
		level = "";
		class = "";
		race = "";
		raceToken = "";
		realm = "";
		guild = "";
		faction = "";
		manualAdd = true
		updatedAt = nil
	end
	-- handle reason
	if (reason == nil) then
		reason = "";
	end

	-- timestamp
	added = time();

	-- lower the name and upper the first letter, not for chinese and korean though
	if ((GetLocale() ~= "zhTW") and (GetLocale() ~= "zhCN") and (GetLocale() ~= "koKR")) then
		local _, len = string.find(name, "[%z\1-\127\194-\244][\128-\191]*");
		if len then
			name = string.upper(string.sub(name, 1, len)) .. string.lower(string.sub(name, len + 1));
		end
	end

	-- Duplicate check / merge: manual entries use empty realm; target merge fills unknown row.
	if (player == "target") then
		if dataFromUnit then
			realm = dataFromUnit.realm or realm or ""
		end
		local idxExact = self:GetIndexByNameAndRealm(name, realm or "")
		local idxUnk = self:GetIndexByNameAndRealm(name, "")
		if idxExact > 0 then
			local p = self:GetPlayerByIndex(idxExact)
			self:AddMessage(self:FormatChatTagLine(p, L["ALREADY_BLACKLISTED"], "listAdd"), "styled")
			return
		end
		if idxUnk > 0 and dataFromUnit then
			local p = self:GetPlayerByIndex(idxUnk)
			self:ApplyUnitDataToPlayerEntry(p, dataFromUnit)
			self:RemoveOtherUnknownSameNameEntries(p.name, idxUnk)
			self:AddMessage(self:FormatChatTagLine(p, L["BLACKLIST_MERGED_UPDATE"] or "Entry updated with realm and details.", "listAdd"), "styled")
			local standaloneFrame = getglobal("BlackListStandaloneFrame")
			if standaloneFrame and standaloneFrame:IsVisible() then
				self:SetSelectedBlackList(idxUnk)
				self:UpdateStandaloneUI()
				if self.ShowStandaloneDetails then
					self:ShowStandaloneDetails()
				end
			end
			return
		end
		if idxUnk > 0 and not dataFromUnit then
			local p = self:GetPlayerByIndex(idxUnk)
			self:AddMessage(self:FormatChatTagLine(p, L["ALREADY_BLACKLISTED"], "listAdd"), "styled")
			return
		end
	else
		if (self:GetIndexByNameAndRealm(name, "") > 0) then
			local p = self:GetPlayerByIndex(self:GetIndexByNameAndRealm(name, ""))
			self:AddMessage(self:FormatChatTagLine(p, L["ALREADY_BLACKLISTED"], "listAdd"), "styled")
			return
		end
	end
	
	raceToken = ""
	if player == "target" then
		if dataFromUnit and dataFromUnit.raceToken and dataFromUnit.raceToken ~= "" then
			raceToken = dataFromUnit.raceToken
		elseif raceEn and tostring(raceEn) ~= "" then
			raceToken = tostring(raceEn)
		end
	end
	local entry = {
		["name"] = name,
		["reason"] = reason,
		["added"] = added,
		["level"] = level,
		["class"] = class,
		["race"] = race,
		["raceToken"] = raceToken or "",
		["realm"] = realm or "",
		["guild"] = guild or "",
		["faction"] = faction or "",
		["manualAdd"] = manualAdd,
		["updatedAt"] = updatedAt,
		["muted"] = false,
	}
	self:EnsureEntryFields(entry)
	table.insert(self:GetAccountList(), entry);

	local newIdx = self:GetIndexByNameAndRealm(name, realm or "")
	local pAdded = newIdx > 0 and self:GetPlayerByIndex(newIdx) or self:GetPlayerByIndex(self:GetIndexByName(name))
	self:AddMessage(self:FormatChatTagLine(pAdded, L["ADDED_TO_BLACKLIST"], "listAdd"), "styled")

	-- Update standalone UI if it exists; open details so the user can set/edit reason
	local standaloneFrame = getglobal("BlackListStandaloneFrame")
	if standaloneFrame and standaloneFrame:IsVisible() then
		local idx = self:GetIndexByNameAndRealm(name, realm or "")
		if idx <= 0 then
			idx = self:GetIndexByName(name)
		end
		if idx and idx > 0 then
			self:SetSelectedBlackList(idx)
		end
		self:UpdateStandaloneUI()
		if self.ShowStandaloneDetails then
			self:ShowStandaloneDetails()
		end
	end

end

--- Add from right-click menu (name + realm + optional class/race from context). `unitToken` fills guild/level/etc.
function BlackList:AddPlayerFromContextMenu(name, realm, classToken, race, unitToken)
	if not name or name == "" then
		return
	end
	realm = realm or ""
	if self:IsContextPlayerSelf(name, realm) then
		return
	end
	local dataFromUnit = nil
	if unitToken then
		local okEx, exU = pcall(UnitExists, unitToken)
		local okIp, isPl = pcall(UnitIsPlayer, unitToken)
		if okEx and exU == true and okIp and isPl == true then
			dataFromUnit = self:CollectPlayerFieldsFromUnit(unitToken)
		end
	end
	local realmFinal = realm
	if dataFromUnit and dataFromUnit.realm and strtrim(dataFromUnit.realm) ~= "" then
		realmFinal = dataFromUnit.realm
	end
	local idxExact = self:GetIndexByNameAndRealm(name, realmFinal)
	if idxExact > 0 then
		local p = self:GetPlayerByIndex(idxExact)
		self:AddMessage(self:FormatChatTagLine(p, L["ALREADY_BLACKLISTED"], "listAdd"), "styled")
		return
	end
	local idxUnk = self:GetIndexByNameAndRealm(name, "")
	if idxUnk > 0 and dataFromUnit then
		local p = self:GetPlayerByIndex(idxUnk)
		self:ApplyUnitDataToPlayerEntry(p, dataFromUnit)
		self:RemoveOtherUnknownSameNameEntries(p.name, idxUnk)
		self:AddMessage(self:FormatChatTagLine(p, L["BLACKLIST_MERGED_UPDATE"] or "Entry updated with realm and details.", "listAdd"), "styled")
		local standaloneFrame = getglobal("BlackListStandaloneFrame")
		if standaloneFrame and standaloneFrame:IsVisible() then
			self:SetSelectedBlackList(idxUnk)
			if self.UpdateStandaloneUI then
				self:UpdateStandaloneUI()
			end
			if self.ShowStandaloneDetails then
				self:ShowStandaloneDetails()
			end
		end
		return
	end
	if ((GetLocale() ~= "zhTW") and (GetLocale() ~= "zhCN") and (GetLocale() ~= "koKR")) then
		local _, len = string.find(name, "[%z\1-\127\194-\244][\128-\191]*")
		if len then
			name = string.upper(string.sub(name, 1, len)) .. string.lower(string.sub(name, len + 1))
		end
	end
	local reason = ""
	local added = time()
	local entry
	if dataFromUnit then
		entry = {
			["name"] = name,
			["reason"] = reason,
			["added"] = added,
			["level"] = dataFromUnit.level or "",
			["class"] = (dataFromUnit.class ~= "" and dataFromUnit.class) or (classToken or ""),
			["race"] = (dataFromUnit.race ~= "" and dataFromUnit.race) or (race or ""),
			["raceToken"] = (dataFromUnit.raceToken and dataFromUnit.raceToken ~= "" and dataFromUnit.raceToken) or "",
			["realm"] = dataFromUnit.realm or realm or "",
			["guild"] = dataFromUnit.guild or "",
			["faction"] = dataFromUnit.faction or "",
			["manualAdd"] = false,
			["updatedAt"] = time(),
			["muted"] = false,
		}
	else
		entry = {
			["name"] = name,
			["reason"] = reason,
			["added"] = added,
			["level"] = "",
			["class"] = classToken or "",
			["race"] = race or "",
			["raceToken"] = "",
			["realm"] = realm or "",
			["guild"] = "",
			["faction"] = "",
			["manualAdd"] = false,
			["updatedAt"] = time(),
			["muted"] = false,
		}
	end
	self:EnsureEntryFields(entry)
	table.insert(self:GetAccountList(), entry)
	local newIdx = self:GetIndexByNameAndRealm(name, entry.realm or "")
	local pAdded = newIdx > 0 and self:GetPlayerByIndex(newIdx) or self:GetPlayerByIndex(self:GetIndexByName(name))
	if pAdded then
		self:AddMessage(self:FormatChatTagLine(pAdded, L["ADDED_TO_BLACKLIST"], "listAdd"), "styled")
	end
	local standaloneFrame = getglobal("BlackListStandaloneFrame")
	if standaloneFrame and standaloneFrame:IsVisible() then
		local idx = newIdx > 0 and newIdx or self:GetIndexByName(name)
		if idx and idx > 0 then
			self:SetSelectedBlackList(idx)
		end
		if self.UpdateStandaloneUI then
			self:UpdateStandaloneUI()
		end
		if self.ShowStandaloneDetails then
			self:ShowStandaloneDetails()
		end
	end
end

--- Match chat `author` string (Name or Name-Realm) to a stored entry.
function BlackList:EntryMatchesChatAuthor(p, authorRaw)
	if not p or not authorRaw then
		return false
	end
	self:EnsureEntryFields(p)
	local a = strtrim(tostring(authorRaw))
	if a == "" then
		return false
	end
	a = a:lower()
	local an, ar
	local dashPos = a:find("-", nil, true)
	if dashPos then
		an = strtrim(string.sub(a, 1, dashPos - 1))
		ar = strtrim(string.sub(a, dashPos + 1))
	else
		an = a
	end
	ar = ar and strtrim(ar):lower() or ""
	if ar == "" then
		ar = (GetRealmName() and GetRealmName():lower()) or ""
	end
	local pr = strtrim(tostring(p.realm or "")):lower()
	if pr == "" then
		pr = (GetRealmName() and GetRealmName():lower()) or ""
	end
	local pn = NormalizePlayerName(p.name)
	local anorm = NormalizePlayerName(an)
	if not pn or not anorm then
		return false
	end
	return pn == anorm and pr == ar
end

--- True if this author should be hidden in chat (per-entry muted flag).
function BlackList:IsChatMutedAuthor(author)
	if not author or author == "" then
		return false
	end
	for i = 1, self:GetNumBlackLists() do
		local p = self:GetPlayerByIndex(i)
		if p and p.muted and self:EntryMatchesChatAuthor(p, author) then
			return true
		end
	end
	return false
end

function BlackList:IsContextPlayerSelf(name, realm)
	if not name then
		return false
	end
	local myName = UnitName("player")
	if not myName then
		return false
	end
	local n1 = NormalizePlayerName(name)
	local n2 = NormalizePlayerName(myName)
	if not n1 or not n2 or n1 ~= n2 then
		return false
	end
	local r = strtrim(tostring(realm or "")):lower()
	local mr = strtrim(tostring(GetRealmName() or "")):lower()
	return r == mr
end

function BlackList:RemovePlayer(player)

	local name, index

	-- handle player
	if (player == "target") then
		name = UnitName("target");
	else
		name = player;
	end

	if (name == nil) then
		index = self:GetSelectedBlackList();
	else
		index = self:GetIndexByName(name);
	end

	if (index == 0) then
		self:AddMessage(self:FormatChatTagPlain(L["PLAYER_NOT_FOUND"], "listNeutral"), "styled")
		return;
	end

	local pRem = self:GetPlayerByIndex(index)
	name = self:GetNameByIndex(index);

	table.remove(self:GetAccountList(), index);

	self:AddMessage(self:FormatChatTagLine(pRem, L["REMOVED_FROM_BLACKLIST"], "listRemove"), "styled")

	-- Update standalone UI if it exists
	local standaloneFrame = getglobal("BlackListStandaloneFrame")
	if standaloneFrame and standaloneFrame:IsVisible() then
		self:UpdateStandaloneUI()
		-- Close details window if no players left or if removed player was selected
		local detailsFrame = getglobal("BlackListStandaloneDetailsFrame")
		if detailsFrame and detailsFrame:IsVisible() then
			if self:GetNumBlackLists() == 0 then
				detailsFrame:Hide()
			end
		end
	end

end

function BlackList:UpdateDetails(index, reason)

	-- update player
	local player = self:GetPlayerByIndex(index);
	if not player then
		return;
	end
	-- for old version i have to convert old name format (there was no format...) in new "Name" format
	if ((GetLocale() ~= "zhTW") and (GetLocale() ~= "zhCN") and (GetLocale() ~= "koKR")) then
		local _, len = string.find(player["name"], "[%z\1-\127\194-\244][\128-\191]*");
		if len then
			player["name"] = string.upper(string.sub(player["name"], 1, len)) .. string.lower(string.sub(player["name"], len + 1));
		end
	end
	if (reason ~= nil) then
		player["reason"] = reason;
	end

	local list = self:GetAccountList()
	table.remove(list, index);
	table.insert(list, index, player);

end

-- Returns the number of blacklisted players
function BlackList:GetNumBlackLists()
	local list = self:GetAccountList()
	if not list then return 0 end
	return #list

end

--- Index for exact name + realm (empty realm = manual / unknown bucket).
function BlackList:GetIndexByNameAndRealm(name, realm)
	local norm = NormalizePlayerName(name)
	if not norm then
		return 0
	end
	local rr = NormalizeRealmKey(realm)
	for i = 1, self:GetNumBlackLists() do
		local p = self:GetPlayerByIndex(i)
		if not p then
			break
		end
		if NormalizePlayerName(p.name) == norm and NormalizeRealmKey(p.realm) == rr then
			return i
		end
	end
	return 0
end

--- Pick list row for a live unit: exact realm match, else same-name unknown realm row.
function BlackList:FindEntryIndexForUnit(name, realmFromUnit)
	if not name then
		return 0
	end
	local norm = NormalizePlayerName(name)
	if not norm then
		return 0
	end
	local ur = NormalizeRealmKey(realmFromUnit)
	local bestUnknown = 0
	for i = 1, self:GetNumBlackLists() do
		local p = self:GetPlayerByIndex(i)
		if not p then
			break
		end
		if NormalizePlayerName(p.name) == norm then
			local pr = NormalizeRealmKey(p.realm)
			if ur ~= "" then
				if pr == ur then
					return i
				end
				if pr == "" then
					bestUnknown = i
				end
			else
				if pr == "" then
					return i
				end
			end
		end
	end
	if bestUnknown > 0 then
		return bestUnknown
	end
	return 0
end

-- Returns the index of the player given by name
function BlackList:GetIndexByName(name)
	local norm = NormalizePlayerName(name)
	if not norm then
		return 0
	end
	for i = 1, self:GetNumBlackLists() do
		local stored = self:GetNameByIndex(i)
		if stored and NormalizePlayerName(stored) == norm then
			return i
		end
	end
	return 0
end

-- Returns the name of the player given by index
function BlackList:GetNameByIndex(index)

	if (index < 1 or index > self:GetNumBlackLists()) then
		return nil;
	end

	local list = self:GetAccountList()
	local p = list and list[index];
	return p and p["name"];

end

-- Returns the player object given by index
function BlackList:GetPlayerByIndex(index)

	if (index < 1 or index > self:GetNumBlackLists()) then
		return nil
	end

	local list = self:GetAccountList()
	return list and list[index];

end
