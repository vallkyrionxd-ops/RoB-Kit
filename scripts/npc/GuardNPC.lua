-- ============================================
-- GuardNPC | RoB-Kit
-- ============================================
-- A guard NPC that patrols normally, but chases and attacks
-- any player that gets too close. Backs off when the player leaves range.
--
-- WHERE TO PUT IT:
--   Insert a Script directly inside your NPC model.
--   NPC needs a Humanoid, HumanoidRootPart, and a tool/weapon in it (optional for damage).
--
-- WHAT TO CHANGE:
--   AGGRO_RANGE   = studs before the guard starts chasing
--   ATTACK_RANGE  = studs before the guard attacks
--   ATTACK_DAMAGE = HP taken per attack hit
--   WALK_SPEED    = normal patrol speed
--   CHASE_SPEED   = speed when chasing a player
-- ============================================

local Players      = game:GetService("Players")
local AGGRO_RANGE   = 30
local ATTACK_RANGE  = 5
local ATTACK_DAMAGE = 15
local WALK_SPEED    = 10
local CHASE_SPEED   = 18
local ATTACK_COOLDOWN = 1   -- seconds between attacks

local npc       = script.Parent
local humanoid  = npc:WaitForChild("Humanoid")
local rootPart  = npc:WaitForChild("HumanoidRootPart")
local origin    = rootPart.Position

humanoid.WalkSpeed = WALK_SPEED

local isAttacking = false

local function getNearestPlayer()
	local nearest  = nil
	local shortest = AGGRO_RANGE

	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			local dist = (root.Position - rootPart.Position).Magnitude
			if dist < shortest then
				shortest = dist
				nearest  = { player = player, root = root, distance = dist }
			end
		end
	end

	return nearest
end

while true do
	local target = getNearestPlayer()

	if target then
		-- chase the player
		humanoid.WalkSpeed = CHASE_SPEED
		humanoid:MoveTo(target.root.Position)

		-- attack if close enough
		if target.distance <= ATTACK_RANGE and not isAttacking then
			isAttacking = true
			local targetHumanoid = target.player.Character and target.player.Character:FindFirstChildWhichIsA("Humanoid")
			if targetHumanoid then
				targetHumanoid:TakeDamage(ATTACK_DAMAGE)
			end
			task.wait(ATTACK_COOLDOWN)
			isAttacking = false
		end
	else
		-- no player in range, return to origin
		humanoid.WalkSpeed = WALK_SPEED
		humanoid:MoveTo(origin)
	end

	task.wait(0.3)
end
