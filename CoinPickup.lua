-- ============================================
-- RoundSystem | RoB-Kit
-- ============================================
-- A full lobby-to-game round loop.
-- Players wait in a lobby, a countdown begins, they get teleported to the map,
-- the round runs, then everyone returns to the lobby.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--
-- HOW TO SET UP:
--   1. Create a Part in Workspace named "LobbySpawn" (players wait here)
--   2. Create a Part in Workspace named "GameSpawn" (players go here during the round)
--   3. Optional: add a Folder in Workspace named "GameArea" with your map inside
--
-- WHAT TO CHANGE:
--   LOBBY_WAIT_TIME = seconds players wait in the lobby before the round starts
--   ROUND_TIME      = how long the actual round lasts
--   MIN_PLAYERS     = minimum players needed to start a round
-- ============================================

local Players        = game:GetService("Players")
local LOBBY_WAIT_TIME = 15    -- seconds in lobby before round starts
local ROUND_TIME      = 120   -- seconds a round lasts
local MIN_PLAYERS     = 2     -- minimum players to start (set to 1 for solo testing)

-- status value that UI scripts can read to show countdowns
local statusValue       = Instance.new("StringValue")
statusValue.Name        = "RoundStatus"
statusValue.Value       = "Waiting for players..."
statusValue.Parent      = game.ReplicatedStorage

local function teleportAllTo(partName)
	local destination = game.Workspace:FindFirstChild(partName)
	if not destination then
		warn("[RoundSystem] No Part named '" .. partName .. "' found in Workspace.")
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local rootPart  = character and character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.CFrame = CFrame.new(destination.Position + Vector3.new(0, 5, 0))
		end
	end
end

local function runRound()
	-- countdown phase
	for i = LOBBY_WAIT_TIME, 1, -1 do
		statusValue.Value = "Round starts in " .. i .. "s"
		task.wait(1)
	end

	-- send everyone to the game area
	statusValue.Value = "Round started!"
	teleportAllTo("GameSpawn")

	-- round timer
	for i = ROUND_TIME, 1, -1 do
		statusValue.Value = "Round ends in " .. i .. "s"
		task.wait(1)
	end

	-- round over, send back to lobby
	statusValue.Value = "Round over! Returning to lobby..."
	task.wait(3)
	teleportAllTo("LobbySpawn")
	task.wait(3)
end

-- main loop
while true do
	statusValue.Value = "Waiting for players... (" .. #Players:GetPlayers() .. "/" .. MIN_PLAYERS .. ")"

	-- wait until enough players join
	while #Players:GetPlayers() < MIN_PLAYERS do
		statusValue.Value = "Waiting for players... (" .. #Players:GetPlayers() .. "/" .. MIN_PLAYERS .. ")"
		task.wait(2)
	end

	runRound()
end
