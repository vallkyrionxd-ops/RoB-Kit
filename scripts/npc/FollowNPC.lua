-- ============================================
-- FollowNPC | RoB-Kit
-- ============================================
-- An NPC that chases the nearest player.
-- It stops when it gets close enough, and gives damage on contact.
--
-- WHERE TO PUT IT:
--   Insert a Script inside your NPC model.
--   The NPC needs a Humanoid and a HumanoidRootPart (any Roblox rig works).
--
-- WHAT TO CHANGE:
--   MOVE_SPEED      = how fast the NPC walks
--   DAMAGE          = how much HP it takes when it touches a player
--   STOP_DISTANCE   = how close it gets before stopping
--   DAMAGE_COOLDOWN = seconds between each damage hit
-- ============================================

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")

local MOVE_SPEED      = 12    -- NPC walk speed
local DAMAGE          = 10    -- damage dealt on contact
local STOP_DISTANCE   = 4     -- studs away to stop chasing
local DAMAGE_COOLDOWN = 1     -- seconds between damage ticks

local npc       = script.Parent
local humanoid  = npc:FindFirstChildWhichIsA("Humanoid")
local rootPart  = npc:FindFirstChild("HumanoidRootPart")

if not humanoid or not rootPart then
	warn("[FollowNPC] NPC is missing a Humanoid or HumanoidRootPart.")
	return
end

humanoid.WalkSpeed = MOVE_SPEED

local lastDamageTime = {}

-- find the closest player in the game
local function getNearestPlayer()
	local nearest, shortestDist = nil, math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local targetRoot = character and character:FindFirstChild("HumanoidRootPart")

		if targetRoot then
			local dist = (targetRoot.Position - rootPart.Position).Magnitude
			if dist < shortestDist then
				nearest     = character
				shortestDist = dist
			end
		end
	end

	return nearest, shortestDist
end

-- damage a player on contact
npc.Touched:Connect(function(hit)
	local character = hit.Parent
	local player    = Players:GetPlayerFromCharacter(character)
	if not player then return end

	local now = tick()
	if not lastDamageTime[player.UserId] or now - lastDamageTime[player.UserId] >= DAMAGE_COOLDOWN then
		lastDamageTime[player.UserId] = now
		local targetHumanoid = character:FindFirstChildWhichIsA("Humanoid")
		if targetHumanoid then
			targetHumanoid:TakeDamage(DAMAGE)
		end
	end
end)

-- chase loop
RunService.Heartbeat:Connect(function()
	local target, dist = getNearestPlayer()

	if target and dist > STOP_DISTANCE then
		local targetRoot = target:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			humanoid:MoveTo(targetRoot.Position)
		end
	else
		humanoid:MoveTo(rootPart.Position) -- stand still
	end
end)
