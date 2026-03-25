-- ============================================
-- GravityZone | RoB-Kit
-- ============================================
-- Changes gravity while a player is inside this zone.
-- Low gravity = moon-like floating. High gravity = heavy and slow.
-- Gravity restores to normal when they leave.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside the zone brick.
--   Set the brick's Transparency to something like 0.7 so players can see through it.
--   Make sure CanCollide is OFF on the brick so players can walk into it.
--
-- WHAT TO CHANGE:
--   ZONE_GRAVITY   = gravity inside the zone (default Roblox = 196.2)
--   NORMAL_GRAVITY = gravity to restore when leaving
-- ============================================

local ZONE_GRAVITY   = 40     -- low = floaty, high = heavy (default Roblox = 196.2)
local NORMAL_GRAVITY = 196.2  -- standard Roblox gravity

local brick   = script.Parent
local Players = game:GetService("Players")

-- make the zone non-collidable so players walk through it
brick.CanCollide = false

-- track which players are currently inside
local playersInZone = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local player    = Players:GetPlayerFromCharacter(character)

	if player and not playersInZone[player.UserId] then
		playersInZone[player.UserId] = true

		-- change gravity for this player
		local gravValue = character:FindFirstChild("GravityOverride")
		if not gravValue then
			gravValue        = Instance.new("NumberValue")
			gravValue.Name   = "GravityOverride"
			gravValue.Parent = character
		end

		game.Workspace.Gravity = ZONE_GRAVITY
	end
end)

brick.TouchEnded:Connect(function(hit)
	local character = hit.Parent
	local player    = Players:GetPlayerFromCharacter(character)

	if player and playersInZone[player.UserId] then
		playersInZone[player.UserId] = nil
		game.Workspace.Gravity = NORMAL_GRAVITY
	end
end)
