-- Presets: Sound Kit IDs (Mainline) and addon files under Media/Audio (PlaySoundFile).
local _, Addon = ...
local L = Addon.L
BlackList = BlackList or {}

local ADDON_SOUND_PREFIX = Addon.AUDIO_PATH or "Interface\\AddOns\\Toxic_BlackList\\Media\\Audio\\"

BlackList_SOUND_PRESETS = {
	{ id = 8459,  key = "SOUND_PRESET_PVP_QUEUE" },
	{ id = 8959,  key = "SOUND_PRESET_RAID_WARNING" },
	{ id = 8960,  key = "SOUND_PRESET_READY_CHECK" },
	{ id = 12867, key = "SOUND_PRESET_ALARM" },
	{ id = 18019, key = "SOUND_PRESET_BNET_TOAST" },
	{ file = ADDON_SOUND_PREFIX .. "beepbeepbeep.ogg", label = "BL: Beep beep beep" },
	{ file = ADDON_SOUND_PREFIX .. "mgs.ogg", label = "BL: MGS" },
	{ file = ADDON_SOUND_PREFIX .. "pewpew.ogg", label = "BL: Pew Pew" },
	{ file = ADDON_SOUND_PREFIX .. "warning.ogg", label = "BL: Warning" },
	{ file = ADDON_SOUND_PREFIX .. "watchout.ogg", label = "BL: Watch Out" },
}

--- Default indices (alert = Pew Pew, group/raid = Beep beep beep); resolved by filename if the table is reordered.
local function findPresetIndexByFilePart(part)
	for i, p in ipairs(BlackList_SOUND_PRESETS) do
		if p.file and string.find(p.file, part, 1, true) then
			return i
		end
	end
	return nil
end

--- Defaults: silent target, mouseover Watch Out, nameplate Pew Pew, group Beep beep beep.
BlackList_SOUND_PRESET_DEFAULT_TARGET = 0
BlackList_SOUND_PRESET_DEFAULT_MOUSEOVER = findPresetIndexByFilePart("watchout.ogg") or 1
BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE = findPresetIndexByFilePart("pewpew.ogg") or 1
BlackList_SOUND_PRESET_DEFAULT_RAID = findPresetIndexByFilePart("beepbeepbeep.ogg") or 2
BlackList_SOUND_PRESET_DEFAULT_TARGETED_BY = findPresetIndexByFilePart("mgs.ogg") or 1
--- Alias for previews / legacy migration.
BlackList_SOUND_PRESET_DEFAULT_ALERT = BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE

--- 0 = no sound (not an index in BlackList_SOUND_PRESETS).
BlackList_SOUND_PRESET_INDEX_NONE = 0

function BlackList:GetSoundPresetCount()
	return #BlackList_SOUND_PRESETS
end

function BlackList:GetSoundPresetLabel(index)
	if index == 0 or index == nil then
		return L["SOUND_PRESET_NONE"] or "No sound"
	end
	local p = BlackList_SOUND_PRESETS[index]
	if not p then
		return ""
	end
	if p.label then
		return p.label
	end
	return L[p.key] or p.key
end

--- Blizzard sound kits only; nil if the preset is a custom file.
function BlackList:GetSoundKitIdForPresetIndex(index)
	if not index or index == 0 then
		return nil
	end
	local p = BlackList_SOUND_PRESETS[index]
	if not p or p.file then
		return nil
	end
	return p.id or 8459
end

--- Play the preset (Blizzard kit or file under Media/Audio).
function BlackList:PlaySoundPresetAtIndex(index)
	if not index or index == 0 then
		return
	end
	local p = BlackList_SOUND_PRESETS[index]
	if not p then
		return
	end
	if p.file then
		pcall(PlaySoundFile, p.file, "SFX")
	elseif p.id then
		pcall(PlaySound, p.id, "SFX")
	end
end

function BlackList:PlaySoundForKind(kind)
	self:MigrateSoundPresetOptions()
	local defaultIdx
	local optKey
	if kind == "raid" then
		optKey = "soundPresetRaid"
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_RAID
	elseif kind == "target" then
		optKey = "soundPresetTarget"
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_TARGET
	elseif kind == "mouseover" then
		optKey = "soundPresetMouseover"
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_MOUSEOVER
	elseif kind == "nameplate" then
		optKey = "soundPresetNameplate"
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE
	elseif kind == "targetedBy" then
		optKey = "soundPresetTargetedBy"
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_TARGETED_BY
	else
		optKey = "soundPresetTarget"
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_TARGET
	end
	local idx = self:NormalizeSoundPresetIndex(self:GetOption(optKey, defaultIdx), defaultIdx)
	self:PlaySoundPresetAtIndex(idx)
end

--- Normalize stored index: 0 = no sound, 1..N = preset.
function BlackList:NormalizeSoundPresetIndex(idx, defaultIdx)
	local n = self:GetSoundPresetCount()
	if type(idx) ~= "number" then
		idx = defaultIdx
	end
	idx = math.floor(idx + 0.5)
	if idx == 0 then
		return 0
	end
	if idx < 1 or idx > n then
		idx = defaultIdx
	end
	if idx == 0 then
		return 0
	end
	if idx < 1 or idx > n then
		if defaultIdx == 0 then
			return 0
		end
		if type(defaultIdx) == "number" and defaultIdx >= 1 and defaultIdx <= n then
			return defaultIdx
		end
		return BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE
	end
	return idx
end

--- Migrate soundPresetAlert + playSounds to per-context keys (runs once).
function BlackList:MigrateSoundPresetOptions()
	if not BlackListOptions then
		return
	end
	if BlackListOptions._blSoundSplitMigrated then
		return
	end
	local oldAlert = BlackListOptions.soundPresetAlert
	local playOff = (BlackListOptions.playSounds == false)
	if playOff then
		BlackListOptions.soundPresetTarget = 0
		BlackListOptions.soundPresetMouseover = 0
		BlackListOptions.soundPresetNameplate = 0
		BlackListOptions.soundPresetRaid = 0
		BlackListOptions.soundPresetTargetedBy = 0
	elseif type(oldAlert) == "number" and oldAlert >= 1 then
		if BlackListOptions.soundPresetTarget == nil then
			BlackListOptions.soundPresetTarget = oldAlert
		end
		if BlackListOptions.soundPresetMouseover == nil then
			BlackListOptions.soundPresetMouseover = oldAlert
		end
		if BlackListOptions.soundPresetNameplate == nil then
			BlackListOptions.soundPresetNameplate = oldAlert
		end
		if BlackListOptions.soundPresetTargetedBy == nil then
			BlackListOptions.soundPresetTargetedBy = BlackList_SOUND_PRESET_DEFAULT_TARGETED_BY
		end
	end
	BlackListOptions._blSoundSplitMigrated = true
end

function BlackList:PreviewSoundPresetIndex(index, defaultForNormalize)
	defaultForNormalize = defaultForNormalize or BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE
	index = self:NormalizeSoundPresetIndex(index, defaultForNormalize)
	self:PlaySoundPresetAtIndex(index)
end

--- Create or reuse the dropdown menu (once per dropdown).
function BlackList:BindSoundDropdown(dropdown, optionKey, defaultIdx)
	if dropdown._blackListBound then
		return
	end
	dropdown._blackListBound = true
	if type(defaultIdx) ~= "number" then
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE
	end
	dropdown.initialize = function()
		local noneInfo = UIDropDownMenu_CreateInfo()
		noneInfo.text = BlackList:GetSoundPresetLabel(0)
		noneInfo.value = 0
		noneInfo.func = function()
			BlackList:ToggleOption(optionKey, 0)
			UIDropDownMenu_SetSelectedValue(dropdown, 0)
			if UIDropDownMenu_SetText then
				UIDropDownMenu_SetText(dropdown, BlackList:GetSoundPresetLabel(0))
			end
		end
		UIDropDownMenu_AddButton(noneInfo)
		local n = BlackList:GetSoundPresetCount()
		for i = 1, n do
			local info = UIDropDownMenu_CreateInfo()
			info.text = BlackList:GetSoundPresetLabel(i)
			info.value = i
			info.func = function()
				BlackList:ToggleOption(optionKey, i)
				UIDropDownMenu_SetSelectedValue(dropdown, i)
				if UIDropDownMenu_SetText then
					UIDropDownMenu_SetText(dropdown, BlackList:GetSoundPresetLabel(i))
				end
			end
			UIDropDownMenu_AddButton(info)
		end
	end
	if dropdown.SetWidth then
		dropdown:SetWidth(280)
	end
end

function BlackList:RefreshSoundDropdown(dropdown, optionKey, defaultIdx)
	if not dropdown or not dropdown.initialize then
		return
	end
	if type(defaultIdx) ~= "number" then
		defaultIdx = BlackList_SOUND_PRESET_DEFAULT_NAMEPLATE
	end
	UIDropDownMenu_Initialize(dropdown, dropdown.initialize)
	local idx = self:NormalizeSoundPresetIndex(self:GetOption(optionKey, defaultIdx), defaultIdx)
	UIDropDownMenu_SetSelectedValue(dropdown, idx)
	if UIDropDownMenu_SetText then
		UIDropDownMenu_SetText(dropdown, self:GetSoundPresetLabel(idx))
	end
	if UIDropDownMenu_Refresh then
		UIDropDownMenu_Refresh(dropdown)
	end
end
