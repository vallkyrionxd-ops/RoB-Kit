-- ============================================
-- CheckpointSystem | RoB-Kit
-- ============================================
-- Saves the player's progress through your obby.
-- When they die, they respawn at the last checkpoint they touched.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService (not in a brick).
--
-- HOW TO SET UP CHECKPOINTS:
--   1. Create bricks in your Workspace for each stage
--   2. Put them all inside a Folder named "Checkpoints"
--   3. Name each brick "1", "2", "3", etc. in order
--   4. The script will detect them automatically
--
-- WHAT TO CHANGE:
--   FOLDER_NAME = the name of the folder holding your checkpoint bricks
--   SPAWN_HEIGHT = how high above the checkpoint to respawn the player
-- ============================================

local Players    = game:GetService("Players")
local FOLDER_NAME  = "Checkpoints"  -- name of the folder in Workspace
local SPAWN_HEIGHT = 5              -- studs above checkpoint on respawn

-- stores each player's current checkpoint position
local checkpointData = {}

local folder = game.Workspace:FindFirstChild(FOLDER_NAME)

if not folder then
	warn("[CheckpointSystem] No folder named '" .. FOLDER_NAME .. "' found in Workspace.")
	warn("[CheckpointSystem] Create a Folder in Workspace and name it '" .. FOLDER_NAME .. "'.")
	return
end

-- sort checkpoints by their name (1, 2, 3...)
local function getCheckpoints()
	local list = {}
	for _, part in ipairs(folder:GetChildren()) do
		if part:IsA("BasePart") then
			table.insert(list, part)
		end
	end
	table.sort(list, function(a, b)
		return tonumber(a.Name) < tonumber(b.Name)
	end)
	return list
end

-- called when a player touches a checkpoint brick
local function onCheckpointTouched(checkpoint, player)
	local stageNumber = tonumber(checkpoint.Name)

	-- only save if this is a higher stage than what they already have
	if not checkpointData[player.UserId] or stageNumber > checkpointData[player.UserId].stage then
		checkpointData[player.UserId] = {
			stage    = stageNumber,
			position = checkpoint.Position + Vector3.new(0, SPAWN_HEIGHT, 0),
		}

		-- update their Stage on the leaderboard if it exists
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats and leaderstats:FindFirstChild("Stage") then
			leaderstats.Stage.Value = stageNumber
		end
	end
end

-- hook up touch events for every checkpoint
local function setupCheckpoints()
	for _, checkpoint in ipairs(getCheckpoints()) do
		checkpoint.Touched:Connect(function(hit)
			local character = hit.Parent
			local player    = Players:GetPlayerFromCharacter(character)
			if player then
				onCheckpointTouched(checkpoint, player)
			end
		end)
	end
end

-- when a player respawns, move them to their last checkpoint
local function onCharacterAdded(character, player)
	-- small wait so the character fully loads before we move it
	task.wait(0.1)

	local data     = checkpointData[player.UserId]
	local rootPart = character:WaitForChild("HumanoidRootPart")

	if data then
		rootPart.CFrame = CFrame.new(data.position)
	end
end

Players.PlayerAdded:Connect(function(player)
	-- set their starting stage to 1
	checkpointData[player.UserId] = { stage = 1, position = nil }

	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(character, player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	-- clean up memory when they leave
	checkpointData[player.UserId] = nil
end)

setupCheckpoints()
