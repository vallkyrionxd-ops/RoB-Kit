-- ============================================
-- LeaderboardSetup | RoB-Kit
-- ============================================
-- Creates a leaderboard visible to all players.
-- Shows Coins, Stage, and Time by default.
-- You can add, remove, or rename any of them.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--
-- WHAT TO CHANGE:
--   Add or remove entries from the STATS table.
--   Each entry has a Name (shown on leaderboard) and a StartValue.
-- ============================================

local Players = game:GetService("Players")

-- define which stats show on the leaderboard
-- Name = what players see, StartValue = what they start with
local STATS = {
	{ Name = "Stage",  StartValue = 1  },
	{ Name = "Coins",  StartValue = 0  },
	{ Name = "Wins",   StartValue = 0  },
}

Players.PlayerAdded:Connect(function(player)
	-- "leaderstats" is the magic folder name Roblox uses to show the leaderboard
	local leaderstats  = Instance.new("Folder")
	leaderstats.Name   = "leaderstats"
	leaderstats.Parent = player

	-- create each stat as an IntValue inside the folder
	for _, stat in ipairs(STATS) do
		local value       = Instance.new("IntValue")
		value.Name        = stat.Name
		value.Value       = stat.StartValue
		value.Parent      = leaderstats
	end
end)
