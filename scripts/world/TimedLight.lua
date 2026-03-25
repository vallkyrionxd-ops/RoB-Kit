-- ============================================
-- TimedLight | RoB-Kit
-- ============================================
-- A light that automatically turns on and off on a schedule.
-- Good for flickering hazards, disco effects, or ambience.
--
-- WHERE TO PUT IT:
--   Insert a Script inside a Part that has a PointLight or SpotLight inside it.
--
-- WHAT TO CHANGE:
--   ON_TIME    = seconds the light stays on
--   OFF_TIME   = seconds the light stays off
--   FLICKER    = set to true for a random flicker effect instead of a clean cycle
-- ============================================

local ON_TIME  = 2      -- seconds light stays on
local OFF_TIME = 2      -- seconds light stays off
local FLICKER  = false  -- true = random flicker, false = clean on/off cycle

local part  = script.Parent
local light = part:FindFirstChildWhichIsA("Light")

if not light then
	warn("[TimedLight] No Light found inside this part. Add a PointLight or SpotLight.")
	return
end

while true do
	light.Enabled = true

	if FLICKER then
		-- random flicker: rapidly toggle the light
		local flickerDuration = ON_TIME
		local elapsed = 0
		while elapsed < flickerDuration do
			local wait = math.random(5, 15) / 100   -- 0.05 to 0.15 seconds
			light.Enabled = not light.Enabled
			task.wait(wait)
			elapsed = elapsed + wait
		end
	else
		task.wait(ON_TIME)
	end

	light.Enabled = false
	task.wait(OFF_TIME)
end
