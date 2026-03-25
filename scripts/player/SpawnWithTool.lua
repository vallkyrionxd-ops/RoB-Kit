-- ============================================
-- SpawnWithTool | RoB-Kit
-- ============================================
-- Gives every player a specific tool when they join or respawn.
-- The tool must already exist somewhere in the game (ServerStorage works best).
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--
-- HOW TO SET UP:
--   1. Build or get a Tool from the Toolbox
--   2. Put the Tool inside ServerStorage
--   3. Change TOOL_NAME below to match the Tool's exact name
--
-- WHAT TO CHANGE:
--   TOOL_NAME = the exact name of the Tool in ServerStorage
-- ============================================

local Players       = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local TOOL_NAME     = "Sword"   -- change this to your tool's name

local function giveToolToPlayer(player)
	-- find the tool template in ServerStorage
	local toolTemplate = ServerStorage:FindFirstChild(TOOL_NAME)

	if not toolTemplate then
		warn("[SpawnWithTool] No tool named '" .. TOOL_NAME .. "' found in ServerStorage.")
		return
	end

	-- wait for the character to fully load
	local character = player.Character or player.CharacterAdded:Wait()
	task.wait(0.2)

	-- check they don't already have it (prevents duplicates on respawn)
	local backpack = player:FindFirstChild("Backpack")
	if backpack and not backpack:FindFirstChild(TOOL_NAME) then
		local toolClone = toolTemplate:Clone()
		toolClone.Parent = backpack
	end
end

Players.PlayerAdded:Connect(function(player)
	giveToolToPlayer(player)

	-- also re-give the tool every time they respawn
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		giveToolToPlayer(player)
	end)
end)
