-- ============================================
-- RainWeather | RoB-Kit
-- ============================================
-- Adds a rain effect to your game using Roblox's ParticleEmitter.
-- Toggle rain on/off from any other script using the RemoteEvent.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--
-- HOW IT WORKS:
--   Rain particles are attached to each player's character overhead.
--   Fire the "ToggleRain" RemoteEvent from a LocalScript or another
--   Script to turn rain on or off for everyone.
--
-- WHAT TO CHANGE:
--   RAIN_HEIGHT     = how far above the player the rain starts
--   PARTICLE_RATE   = how heavy the rain is (particles per second)
-- ============================================

local Players      = game:GetService("Players")
local RAIN_HEIGHT  = 20
local PARTICLE_RATE = 200

local isRaining = false

-- create a RemoteEvent so you can toggle rain from other scripts
local remoteEvent      = Instance.new("RemoteEvent")
remoteEvent.Name       = "ToggleRain"
remoteEvent.Parent     = game.ReplicatedStorage

local function createRainPart(character)
	local rootPart = character:WaitForChild("HumanoidRootPart")

	local rainPart        = Instance.new("Part")
	rainPart.Name         = "RainEmitter"
	rainPart.Size         = Vector3.new(20, 1, 20)
	rainPart.Transparency = 1
	rainPart.CanCollide   = false
	rainPart.Anchored     = false

	-- weld it above the player's head
	local weld            = Instance.new("WeldConstraint")
	weld.Part0            = rainPart
	weld.Part1            = rootPart
	weld.Parent           = rainPart
	rainPart.CFrame       = rootPart.CFrame + Vector3.new(0, RAIN_HEIGHT, 0)
	rainPart.Parent       = character

	-- add the particle emitter
	local emitter                  = Instance.new("ParticleEmitter")
	emitter.Name                   = "RainParticles"
	emitter.Rate                   = 0           -- start off
	emitter.Lifetime               = NumberRange.new(1, 2)
	emitter.Speed                  = NumberRange.new(40, 60)
	emitter.Rotation               = NumberRange.new(0, 0)
	emitter.RotSpeed               = NumberRange.new(0, 0)
	emitter.Size                   = NumberSequence.new(0.03)
	emitter.Transparency           = NumberSequence.new(0.3)
	emitter.LightEmission          = 0.1
	emitter.Direction              = Vector3.new(0, -1, 0)
	emitter.EmissionDirection      = Enum.NormalId.Bottom
	emitter.Color                  = ColorSequence.new(Color3.fromRGB(180, 210, 255))
	emitter.Parent                 = rainPart

	return emitter
end

local playerEmitters = {}

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		local emitter = createRainPart(character)
		playerEmitters[player.UserId] = emitter
		if isRaining then
			emitter.Rate = PARTICLE_RATE
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	playerEmitters[player.UserId] = nil
end)

-- listen for toggle requests
remoteEvent.OnServerEvent:Connect(function()
	isRaining = not isRaining

	for _, emitter in pairs(playerEmitters) do
		emitter.Rate = isRaining and PARTICLE_RATE or 0
	end
end)
