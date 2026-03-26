-- Media paths for textures and addon sound files (under Media/Images and Media/Audio).
local _, Addon = ...

Addon.MEDIA_PATH = "Interface\\AddOns\\Toxic_BlackList\\Media\\Images\\"
Addon.AUDIO_PATH = "Interface\\AddOns\\Toxic_BlackList\\Media\\Audio\\"

--- Returns a full path for an image file in Media/Images.
function Addon.MediaImage(filename)
	return Addon.MEDIA_PATH .. filename
end

--- Returns a full path for an audio file in Media/Audio.
function Addon.MediaAudio(filename)
	return Addon.AUDIO_PATH .. filename
end
