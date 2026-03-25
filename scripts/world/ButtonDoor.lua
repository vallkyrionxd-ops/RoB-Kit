-- ============================================
-- ButtonDoor | RoB-Kit
-- ============================================
-- A button that opens or closes a door when touched.
-- Touch again to toggle it back.
--
-- WHERE TO PUT IT:
--   Insert a Script inside the BUTTON brick (not the door).
--
-- HOW TO SET UP:
--   1. Create your door brick in Workspace and name it "Door"
--   2. Create your button brick in Workspace
--   3. Insert this Script inside the button brick
--   4. Change DOOR_NAME if your door has a different name
--
-- WHAT TO CHANGE:
--   DOOR_NAME   = the exact name of the door brick in Workspace
--   OPEN_TIME   = seconds the door stays open before auto-closing (0 = manual toggle only)
-- ============================================

local DOOR_NAME  = "Door"
local OPEN_TIME  = 0     -- set to e.g. 5 to auto-close after 5 seconds

local button   = script.Parent
local door     = game.Workspace:FindFirstChild(DOOR_NAME)
local debounce = false

if not door then
	warn("[ButtonDoor] No brick named '" .. DOOR_NAME .. "' found in Workspace.")
	return
end

local isOpen = false

local function openDoor()
	isOpen             = true
	door.Transparency  = 0.8
	door.CanCollide    = false
end

local function closeDoor()
	isOpen             = false
	door.Transparency  = 0
	door.CanCollide    = true
end

button.Touched:Connect(function(hit)
	local humanoid = hit.Parent:FindFirstChildWhichIsA("Humanoid")
	if not humanoid or debounce then return end

	debounce = true

	if isOpen then
		closeDoor()
	else
		openDoor()
		-- auto-close if OPEN_TIME is set
		if OPEN_TIME > 0 then
			task.wait(OPEN_TIME)
			closeDoor()
		end
	end

	task.wait(0.5)
	debounce = false
end)
