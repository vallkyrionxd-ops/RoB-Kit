-- ============================================
-- IceBrick | RoB-Kit
-- ============================================
-- Makes the player slide when walking on this brick.
-- Simulates ice or a slippery surface. Hard to stop or turn on.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   FRICTION = how slippery the surface is (0 = full ice, 1 = normal)
--              Lower values = more slippery
-- ============================================

local FRICTION = 0    -- 0 is maximum ice, closer to 1 = less slippery

local brick = script.Parent

-- PhysicalProperties controls how the surface behaves with physics
brick.CustomPhysicalProperties = PhysicalProperties.new(
	0.3,        -- Density
	FRICTION,   -- Friction (this is what makes it icy)
	0.1,        -- Elasticity (bounciness)
	0,          -- FrictionWeight
	0           -- ElasticityWeight
)
