-- ============================================
-- ShooterNPC | RoB-Kit
-- ============================================
-- An NPC that fires projectiles at nearby players.
-- Good for shooter enemies, turrets, or boss mechanics.
--
-- WHERE TO PUT IT:
--   Insert a Script inside your NPC model.
--
-- WHAT TO CHANGE:
--   SHOOT_RANGE    = max distance to detect and shoot at players (studs)
--   SHOOT_DAMAGE   = how much damage each projectile does on hit
--   SHOOT_SPEED    = how fast the projectile travels
--   SHOOT_INTERVAL = seconds between each shot
--   PROJECTILE_COLOR = the color of the projectile ball
-- ============================================

local Players        = game:GetService("Players")
local SHOOT_RANGE    = 50
local SHOOT_DAMAGE   = 15
local SHOOT_SPEED    = 60
local SHOOT_INTERVAL = 2
local PROJECTILE_COLOR = Color3.fromRGB(255, 50, 50)

local npc      = script.Parent
local rootPart = npc:FindFirstChild("HumanoidRootPart")

if not rootPart then
	warn("[ShooterNPC] NPC is missing a HumanoidRootPart.")
	return
end

-- find the nearest player within range
local function getNearestPlayer()
	local nearest, nearestDist = nil, SHOOT_RANGE

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local dist = (targetRoot.Position - rootPart.Position).Magnitude
			if dist < nearestDist then
				nearest     = character
				nearestDist = dist
			end
		end
	end

	return nearest
end

-- shoot a projectile toward a target position
local function shootAt(targetPosition)
	local projectile              = Instance.new("Part")
	projectile.Name               = "Projectile"
	projectile.Shape              = Enum.PartType.Ball
	projectile.Size               = Vector3.new(0.8, 0.8, 0.8)
	projectile.Color              = PROJECTILE_COLOR
	projectile.Material           = Enum.Material.Neon
	projectile.CanCollide         = false
	projectile.CFrame             = CFrame.new(rootPart.Position)
	projectile.Parent             = game.Workspace

	-- aim directly at the target
	local direction               = (targetPosition - rootPart.Position).Unit
	local bv                      = Instance.new("BodyVelocity")
	bv.Velocity                   = direction * SHOOT_SPEED
	bv.MaxForce                   = Vector3.new(math.huge, math.huge, math.huge)
	bv.Parent                     = projectile

	-- damage player on hit
	projectile.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid  = character:FindFirstChildWhichIsA("Humanoid")
		local player    = Players:GetPlayerFromCharacter(character)

		if humanoid and player then
			humanoid:TakeDamage(SHOOT_DAMAGE)
			projectile:Destroy()
		end
	end)

	-- destroy projectile after 5 seconds if it hits nothing
	game:GetService("Debris"):AddItem(projectile, 5)
end

-- main shooting loop
while true do
	task.wait(SHOOT_INTERVAL)

	local target = getNearestPlayer()
	if target then
		local targetRoot = target:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			shootAt(targetRoot.Position)
		end
	end
end
