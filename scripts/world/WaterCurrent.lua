-- ============================================
-- WaterCurrent | RoB-Kit
-- ============================================
-- Pushes players in a direction while they are inside this zone.
-- Simulates a river current, wind, or a push zone.
--
-- WHERE TO PUT IT:
--   Insert a Script inside a transparent, non-collidable brick covering the water/wind area.
--
-- WHAT TO CHANGE:
--   PUSH_DIRECTION = which way to push players (change the numbers to change direction)
--   PUSH_FORCE     = how strong the push is
-- ============================================

local PUSH_DIRECTION = Vector3.new(1, 0, 0)   -- X=right, Z=forward, Y=up
local PUSH_FORCE     = 30

local zone = script.Parent
zone.CanCollide = false

local touching = {}

zone.Touched:Connect(function(hit)
	local rootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
	local humanoid = hit.Parent:FindFirstChildWhichIsA("Humanoid")
	if not rootPart or not humanoid then return end

	local name = hit.Parent.Name
	if touching[name] then return end
	touching[name] = true

	-- keep applying force while the player is inside
	while touching[name] do
		rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + (PUSH_DIRECTION * PUSH_FORCE * 0.05)
		task.wait(0.05)
	end
end)

zone.TouchEnded:Connect(function(hit)
	touching[hit.Parent.Name] = nil
end)
