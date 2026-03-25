-- ============================================
-- DataSaver | RoB-Kit
-- ============================================
-- Saves and loads player data using Roblox DataStores.
-- Players keep their Coins, Stage, and Wins between sessions.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--   Also requires LeaderboardSetup.lua to already be creating the leaderstats.
--
-- IMPORTANT ROBLOX SETTING:
--   Go to Game Settings > Security > Enable Studio Access to API Services
--   This must be ON for DataStores to work, even in Studio testing.
--
-- WHAT TO CHANGE:
--   DATA_STORE_NAME = a unique name for your game's save data
--   STATS_TO_SAVE   = which leaderstats values to save and load
-- ============================================

local Players       = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DATA_STORE_NAME = "RoB-Kit-PlayerData-v1"  -- change "v1" if you reset all saves
local STATS_TO_SAVE   = { "Coins", "Stage", "Wins" }

local store = DataStoreService:GetDataStore(DATA_STORE_NAME)

-- load saved data when a player joins
local function onPlayerAdded(player)
	local leaderstats = player:WaitForChild("leaderstats", 10)

	if not leaderstats then
		warn("[DataSaver] No leaderstats found for " .. player.Name)
		return
	end

	local success, data = pcall(function()
		return store:GetAsync(tostring(player.UserId))
	end)

	if success and data then
		-- apply saved values to each stat
		for _, statName in ipairs(STATS_TO_SAVE) do
			local statValue = leaderstats:FindFirstChild(statName)
			if statValue and data[statName] then
				statValue.Value = data[statName]
			end
		end
	elseif not success then
		warn("[DataSaver] Failed to load data for " .. player.Name .. ": " .. tostring(data))
	end
end

-- save data when a player leaves
local function onPlayerRemoving(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local dataToSave = {}
	for _, statName in ipairs(STATS_TO_SAVE) do
		local statValue = leaderstats:FindFirstChild(statName)
		if statValue then
			dataToSave[statName] = statValue.Value
		end
	end

	local success, err = pcall(function()
		store:SetAsync(tostring(player.UserId), dataToSave)
	end)

	if not success then
		warn("[DataSaver] Failed to save data for " .. player.Name .. ": " .. tostring(err))
	end
end

-- also save when the server shuts down (in case of crashes)
game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerRemoving(player)
	end
end)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
