local _, Addon = ...
local L = Addon.L
BlackList = BlackList or {}

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

--- Ensure new fields on legacy entries (realm, guild, faction, updatedAt, manualAdd).
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
	if player.manualAdd == nil then
		if strtrim(tostring(player.level or "")) == "" and strtrim(tostring(player.class or "")) == "" then
			player.manualAdd = true
		else
			player.manualAdd = false
		end
	end
end

function BlackList:MigrateAllBlacklistedEntries()
	if not BlackListedPlayers then
		return
	end
	for _, list in pairs(BlackListedPlayers) do
		if type(list) == "table" then
			for _, entry in ipairs(list) do
				self:EnsureEntryFields(entry)
			end
		end
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
	local okExists = pcall(UnitExists, unit)
	if not okExists or not UnitExists(unit) then
		return nil
	end
	local okPl, isPl = pcall(UnitIsPlayer, unit)
	if not okPl or not isPl then
		return nil
	end
	local level = unitLevelString(unit)
	local locClass, classToken = UnitClass(unit)
	local class = (classToken and classToken ~= "") and classToken or (locClass or "")
	local race = select(1, UnitRace(unit)) or ""
	local _, realm = UnitName(unit)
	if not realm or realm == "" then
		realm = GetRealmName() or ""
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

--- If the unit is blacklisted and a refresh is due, merge live data (realm, guild, faction, etc.).
function BlackList:TryUpdateBlacklistedPlayerFromUnit(unit)
	if not unit then
		return
	end
	local okExists = pcall(UnitExists, unit)
	if not okExists or not UnitExists(unit) then
		return
	end
	local okPl, isPl = pcall(UnitIsPlayer, unit)
	if not okPl or not isPl then
		return
	end
	if pcall(UnitIsUnit, unit, "player") and UnitIsUnit(unit, "player") then
		return
	end
	local name = UnitName(unit)
	if not name then
		return
	end
	local idx = self:GetIndexByName(name)
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
	local data = self:CollectPlayerFieldsFromUnit(unit)
	if not data then
		return
	end
	self:ApplyUnitDataToPlayerEntry(player, data)
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

	local name, level, class, race, raceEn, added
	local realm, guild, faction, manualAdd, updatedAt

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
			local data = self:CollectPlayerFieldsFromUnit("target")
			if data then
				if data.level ~= "" then
					level = data.level
				end
				if data.class ~= "" then
					class = data.class
				end
				if data.race ~= "" then
					race = data.race
				end
				realm = data.realm or ""
				guild = data.guild or ""
				faction = data.faction or ""
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
		realm = "";
		guild = "";
		faction = "";
		manualAdd = true
		updatedAt = nil
	end
	if (self:GetIndexByName(name) > 0) then
		local p = self:GetPlayerByIndex(self:GetIndexByName(name))
		self:AddMessage(self:FormatChatTagLine(p, L["ALREADY_BLACKLISTED"], "listAdd"), "styled")
		return;
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
	
	local entry = {
		["name"] = name,
		["reason"] = reason,
		["added"] = added,
		["level"] = level,
		["class"] = class,
		["race"] = race,
		["realm"] = realm or "",
		["guild"] = guild or "",
		["faction"] = faction or "",
		["manualAdd"] = manualAdd,
		["updatedAt"] = updatedAt,
	}
	self:EnsureEntryFields(entry)
	table.insert(BlackListedPlayers[GetRealmName()], entry);

	local pAdded = self:GetPlayerByIndex(self:GetIndexByName(name))
	self:AddMessage(self:FormatChatTagLine(pAdded, L["ADDED_TO_BLACKLIST"], "listAdd"), "styled")

	-- Update standalone UI if it exists; open details so the user can set/edit reason
	local standaloneFrame = getglobal("BlackListStandaloneFrame")
	if standaloneFrame and standaloneFrame:IsVisible() then
		local idx = self:GetIndexByName(name)
		if idx and idx > 0 then
			self:SetSelectedBlackList(idx)
		end
		self:UpdateStandaloneUI()
		if self.ShowStandaloneDetails then
			self:ShowStandaloneDetails()
		end
	end

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

	table.remove(BlackListedPlayers[GetRealmName()], index);

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

	table.remove(BlackListedPlayers[GetRealmName()], index);
	table.insert(BlackListedPlayers[GetRealmName()], index, player);

end

-- Returns the number of blacklisted players
function BlackList:GetNumBlackLists()
	if not BlackListedPlayers[GetRealmName()] then return 0 end
	return #BlackListedPlayers[GetRealmName()];

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

	local p = BlackListedPlayers[GetRealmName()][index];
	return p["name"];

end

-- Returns the player object given by index
function BlackList:GetPlayerByIndex(index)

	if (index < 1 or index > self:GetNumBlackLists()) then
		return nil
	end

	local p = BlackListedPlayers[GetRealmName()][index];
	return p;

end
