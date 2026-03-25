-- ============================================
-- DayNightCycle | RoB-Kit
-- ============================================
-- A smooth day/night cycle that loops forever.
-- The sky gradually shifts from dawn to dusk to night.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--
-- WHAT TO CHANGE:
--   CYCLE_MINUTES = how many real minutes it takes to complete one full day
--                   (default: 10 minutes for a full day/night cycle)
-- ============================================

local Lighting      = game:GetService("Lighting")
local CYCLE_MINUTES = 10   -- real-world minutes per full day

-- 24 in-game hours mapped to real seconds
local SECONDS_PER_DAY = CYCLE_MINUTES * 60

-- how many in-game hours pass per real second
local HOURS_PER_SECOND = 24 / SECONDS_PER_DAY

-- set a nice starting time (6am)
Lighting.TimeOfDay = "06:00:00"

while true do
	task.wait()
	Lighting.ClockTime = (Lighting.ClockTime + HOURS_PER_SECOND * task.wait()) % 24
end
