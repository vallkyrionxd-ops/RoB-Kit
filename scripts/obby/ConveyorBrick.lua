-- ============================================
-- ConveyorBrick | RoB-Kit
-- ============================================
-- Makes the brick surface move, pushing players in one direction.
-- Good for conveyor belts, moving walkways, or sliding floors.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   SPEED     = how fast the surface moves (default: 20)
--   DIRECTION = which way to push (see options below)
-- ============================================

local SPEED = 20   -- surface speed (negative = reverses direction)

-- Direction of the conveyor surface
-- Options: Vector3.new(1,0,0) = forward, Vector3.new(-1,0,0) = backward
--          Vector3.new(0,0,1) = right,   Vector3.new(0,0,-1) = left
local DIRECTION = Vector3.new(1, 0, 0)

local brick = script.Parent

-- AssemblyLinearVelocity on the surface makes it act like a conveyor
brick.AssemblyLinearVelocity = DIRECTION * SPEED

-- keep refreshing the velocity every frame so it never stops
game:GetService("RunService").Heartbeat:Connect(function()
	brick.AssemblyLinearVelocity = DIRECTION * SPEED
end)
