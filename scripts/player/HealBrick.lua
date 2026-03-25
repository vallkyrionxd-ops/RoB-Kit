-- ============================================
-- HealBrick | RoB-Kit
-- ============================================
-- Restores HP to any player who touches this brick.
-- Good for health pads, healing zones, or reward areas.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   HEAL_AMOUNT = how much HP to restore per touch
--   COOLDOWN    = seconds before the same player can be healed again
-- ============================================

local HEAL_AMOUNT = 25   -- HP to restore
local COOLDOWN    = 3    -- seconds before healing the same player again

local brick    = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true

		-- only heal if they actually need it
		if humanoid.Health < humanoid.MaxHealth then
			humanoid.Health = math.min(humanoid.Health + HEAL_AMOUNT, humanoid.MaxHealth)
		end

		task.wait(COOLDOWN)
		debounce[character.Name] = nil
	end
end)
