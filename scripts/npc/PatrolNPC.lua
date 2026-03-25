-- ============================================
-- PatrolNPC | RoB-Kit
-- ============================================
-- An NPC that walks between a set of waypoints in order.
-- Good for guards, patrol enemies, or roaming characters.
--
-- WHERE TO PUT IT:
--   Insert a Script inside your NPC model.
--
-- HOW TO SET UP WAYPOINTS:
--   1. Create Parts in Workspace for each patrol stop
--   2. Put them all inside a Folder named "PatrolWaypoints" (or change WAYPOINTS_FOLDER below)
--   3. Name them "1", "2", "3" in the order the NPC should visit them
--
-- WHAT TO CHANGE:
--   WAYPOINTS_FOLDER = name of the folder holding your waypoint parts
--   WAIT_AT_WAYPOINT = seconds the NPC pauses at each stop
--   MOVE_SPEED       = how fast it walks
-- ============================================

local WAYPOINTS_FOLDER  = "PatrolWaypoints"
local WAIT_AT_WAYPOINT  = 1.5
local MOVE_SPEED        = 10

local npc      = script.Parent
local humanoid = npc:FindFirstChildWhichIsA("Humanoid")

if not humanoid then
	warn("[PatrolNPC] NPC is missing a Humanoid.")
	return
end

humanoid.WalkSpeed = MOVE_SPEED

local folder = game.Workspace:FindFirstChild(WAYPOINTS_FOLDER)
if not folder then
	warn("[PatrolNPC] No folder named '" .. WAYPOINTS_FOLDER .. "' in Workspace.")
	return
end

-- sort waypoints by their name number
local waypoints = {}
for _, part in ipairs(folder:GetChildren()) do
	if part:IsA("BasePart") then
		table.insert(waypoints, part)
	end
end
table.sort(waypoints, function(a, b)
	return tonumber(a.Name) < tonumber(b.Name)
end)

if #waypoints == 0 then
	warn("[PatrolNPC] No waypoint parts found inside '" .. WAYPOINTS_FOLDER .. "'.")
	return
end

-- walk the patrol route forever
local index = 1
while true do
	local target = waypoints[index]
	humanoid:MoveTo(target.Position)
	humanoid.MoveToFinished:Wait()
	task.wait(WAIT_AT_WAYPOINT)
	index = (index % #waypoints) + 1
end
