-- ============================================
-- CoinPickup | RoB-Kit
-- ============================================
-- A coin that players can walk over to collect.
-- It disappears when picked up and respawns after a delay.
-- Works with LeaderboardSetup (adds to "Coins" leaderstats value).
--
-- WHERE TO PUT IT:
--   Insert a Script directly inside each coin part/brick.
--
-- WHAT TO CHANGE:
--   COIN_VALUE   = how many coins this pickup gives
--   RESPAWN_TIME = seconds before the coin reappears
-- ============================================

local Players     = game:GetService("Players")
local COIN_VALUE  = 1     -- coins given on pickup
local RESPAWN_TIME = 5    -- seconds until the coin comes back

local coin    = script.Parent
local active  = true

coin.Touched:Connect(function(hit)
	if not active then return end

	local character = hit.Parent
	local player    = Players:GetPlayerFromCharacter(character)

	if not player then return end

	local leaderstats = player:FindFirstChild("leaderstats")
	local coins       = leaderstats and leaderstats:FindFirstChild("Coins")

	if coins then
		active            = false
		coins.Value       = coins.Value + COIN_VALUE

		-- hide the coin
		coin.Transparency = 1
		coin.CanCollide   = false

		-- bring it back after a delay
		task.wait(RESPAWN_TIME)
		coin.Transparency = 0
		coin.CanCollide   = true
		active            = true
	end
end)
