-- ============================================
-- WanderNPC | RoB-Kit
-- ============================================
-- An NPC that walks around randomly on its own.
-- No setup needed. Just drop it in and it wanders.
--
-- WHERE TO PUT IT:
--   Insert a Script inside your NPC model.
--
-- WHAT TO CHANGE:
--   WANDER_RADIUS = how far from the starting point it can roam (studs)
--   WAIT_TIME     = seconds it pauses before picking a new direction
--   MOVE_SPEED    = how fast it walks
-- ============================================

local WANDER_RADIUS = 30
local WAIT_TIME     = 2
local MOVE_SPEED    = 8

local npc       = script.Parent
local humanoid  = npc:FindFirstChildWhichIsA("Humanoid")
local rootPart  = npc:FindFirstChild("HumanoidRootPart")

if not humanoid or not rootPart then
	warn("[WanderNPC] NPC is missing a Humanoid or HumanoidRootPart.")
	return
end

humanoid.WalkSpeed = MOVE_SPEED

-- remember where the NPC started so it doesn't wander too far
local origin = rootPart.Position

while true do
	-- pick a random spot within the wander radius
	local angle    = math.random() * math.pi * 2
	local distance = math.random(5, WANDER_RADIUS)
	local target   = origin + Vector3.new(
		math.cos(angle) * distance,
		0,
		math.sin(angle) * distance
	)

	humanoid:MoveTo(target)
	humanoid.MoveToFinished:Wait()
	task.wait(WAIT_TIME)
end
