-- ============================================
-- DamageBrick | RoB-Kit
-- ============================================
-- Continuously damages any player touching this brick.
-- Good for lava floors, spike traps, or acid pools.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   DAMAGE   = how much HP to take each tick
--   INTERVAL = seconds between each damage hit
-- ============================================

local DAMAGE   = 10   -- HP removed per tick (default: 10)
local INTERVAL = 1    -- seconds between ticks (default: 1)

local brick    = script.Parent
local debounce = {}   -- tracks who is currently touching the brick

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	-- only run for players/NPCs, and only if not already damaging them
	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true

		-- keep looping while the player stays on the brick
		while debounce[character.Name] do
			if humanoid and humanoid.Health > 0 then
				humanoid:TakeDamage(DAMAGE)
			end
			task.wait(INTERVAL)
		end
	end
end)

brick.TouchEnded:Connect(function(hit)
	local character = hit.Parent
	-- clear the debounce so damage stops
	debounce[character.Name] = nil
end)
