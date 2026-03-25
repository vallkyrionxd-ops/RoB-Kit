-- ============================================
-- KeyDoor | RoB-Kit
-- ============================================
-- A door that only opens if the player is carrying a specific tool (the "key").
-- Players without the key get a message and the door stays shut.
--
-- WHERE TO PUT IT:
--   Insert a Script inside the door brick.
--
-- HOW TO SET UP:
--   1. Create a Tool in your game and name it (e.g. "GoldenKey")
--   2. Set KEY_NAME below to match the tool's name exactly
--   3. Insert this Script inside the door brick
--   Players who have that Tool in their Backpack or hand can open the door.
--
-- WHAT TO CHANGE:
--   KEY_NAME     = the exact name of the Tool that acts as the key
--   OPEN_TIME    = seconds until the door closes again (0 = stays open permanently)
-- ============================================

local Players  = game:GetService("Players")
local KEY_NAME = "GoldenKey"
local OPEN_TIME = 5

local door     = script.Parent
local debounce = {}

local function playerHasKey(player)
	-- check backpack
	local backpack = player:FindFirstChild("Backpack")
	if backpack and backpack:FindFirstChild(KEY_NAME) then return true end

	-- check if they're currently holding it
	local character = player.Character
	if character and character:FindFirstChild(KEY_NAME) then return true end

	return false
end

door.Touched:Connect(function(hit)
	local character = hit.Parent
	local player    = Players:GetPlayerFromCharacter(character)

	if not player or debounce[player.UserId] then return end
	debounce[player.UserId] = true

	if playerHasKey(player) then
		door.Transparency = 0.8
		door.CanCollide   = false

		if OPEN_TIME > 0 then
			task.wait(OPEN_TIME)
			door.Transparency = 0
			door.CanCollide   = true
		end
	else
		-- briefly flash the door red to signal "no access"
		local original = door.Color
		door.Color     = Color3.fromRGB(255, 50, 50)
		task.wait(0.4)
		door.Color     = original
	end

	task.wait(1)
	debounce[player.UserId] = nil
end)
