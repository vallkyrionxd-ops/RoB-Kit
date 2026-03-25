-- ============================================
-- TreasureChest | RoB-Kit
-- ============================================
-- A chest that gives coins when a player touches/opens it.
-- Can only be opened once per player, or once globally.
--
-- WHERE TO PUT IT:
--   Insert a Script directly inside your chest model or brick.
--
-- WHAT TO CHANGE:
--   COIN_REWARD    = how many coins opening the chest gives
--   ONE_PER_PLAYER = true means each player can open it once
--                    false means the first player to open it gets the reward, then it's gone
-- ============================================

local Players       = game:GetService("Players")
local COIN_REWARD   = 50
local ONE_PER_PLAYER = true   -- true = each player can open it once, false = one-time only

local chest     = script.Parent
local opened    = {}
local globalUsed = false

chest.Touched:Connect(function(hit)
	if globalUsed then return end

	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end
	if ONE_PER_PLAYER and opened[player.UserId] then return end

	-- mark as opened
	if ONE_PER_PLAYER then
		opened[player.UserId] = true
	else
		globalUsed = true
	end

	-- give coins
	local leaderstats = player:FindFirstChild("leaderstats")
	local coins       = leaderstats and leaderstats:FindFirstChild("Coins")
	if coins then
		coins.Value = coins.Value + COIN_REWARD
	end

	-- visual feedback: make the chest glow briefly
	local originalColor  = chest.BrickColor
	chest.BrickColor     = BrickColor.new("Bright yellow")
	task.wait(0.5)
	chest.BrickColor     = originalColor

	-- chat bubble so players know it worked
	game:GetService("Chat"):Chat(chest, "+" .. COIN_REWARD .. " coins!", Enum.ChatColor.Yellow)
end)
