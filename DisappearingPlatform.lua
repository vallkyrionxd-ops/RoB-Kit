-- ============================================
-- MovingPlatform | RoB-Kit
-- ============================================
-- A brick that moves back and forth between two positions.
-- Works great as a floating platform, moving hazard, or elevator.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   MOVE_DISTANCE = how far the platform travels from its start point (studs)
--   MOVE_SPEED    = how fast it moves (seconds to complete one trip)
--   DIRECTION     = which direction it moves
-- ============================================

local MOVE_DISTANCE = 20                   -- studs to travel
local MOVE_SPEED    = 2                    -- seconds per trip
local DIRECTION     = Vector3.new(1, 0, 0) -- X=sideways, Y=up/down, Z=forward/back

local brick      = script.Parent
local startPos   = brick.Position
local endPos     = startPos + (DIRECTION * MOVE_DISTANCE)

brick.Anchored = true

-- move back and forth in a loop forever
while true do
	-- move to end position
	local steps = 30
	for i = 1, steps do
		local t = i / steps
		brick.CFrame = CFrame.new(startPos:Lerp(endPos, t))
		task.wait(MOVE_SPEED / steps)
	end

	-- move back to start position
	for i = 1, steps do
		local t = i / steps
		brick.CFrame = CFrame.new(endPos:Lerp(startPos, t))
		task.wait(MOVE_SPEED / steps)
	end
end
