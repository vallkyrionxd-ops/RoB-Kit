-- ============================================
-- FogZone | RoB-Kit
-- ============================================
-- Adds thick fog when a player enters this zone and removes it when they leave.
-- Good for haunted areas, caves, swamps, or horror sections.
--
-- WHERE TO PUT IT:
--   Insert a Script inside the zone brick.
--   Set the brick's CanCollide to OFF and Transparency to around 0.8.
--
-- WHAT TO CHANGE:
--   FOG_START   = where fog starts rendering (studs from camera, lower = fog starts closer)
--   FOG_END     = where fog becomes completely opaque (studs from camera)
--   FOG_COLOR   = the color of the fog (R, G, B values from 0 to 1)
--   NORMAL_END  = what FogEnd to restore when the player leaves (default Roblox = 100000)
-- ============================================

local Players    = game:GetService("Players")
local Lighting   = game:GetService("Lighting")

local FOG_START  = 5
local FOG_END    = 40
local FOG_COLOR  = Color3.new(0.5, 0.5, 0.5)   -- grey fog
local NORMAL_END = 100000

local zone             = script.Parent
zone.CanCollide        = false

local playersInZone    = {}

zone.Touched:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if not player or playersInZone[player.UserId] then return end

	playersInZone[player.UserId] = true
	Lighting.FogStart  = FOG_START
	Lighting.FogEnd    = FOG_END
	Lighting.FogColor  = FOG_COLOR
end)

zone.TouchEnded:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end

	playersInZone[player.UserId] = nil

	-- restore only if no one else is still in the zone
	if next(playersInZone) == nil then
		Lighting.FogEnd = NORMAL_END
	end
end)
