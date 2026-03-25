-- ============================================
-- AdminCommands | RoB-Kit
-- ============================================
-- Basic admin commands via chat. Only works for players in the ADMINS list.
-- Type commands in chat like: :kick PlayerName or :speed PlayerName 50
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--
-- WHAT TO CHANGE:
--   ADMINS = list of usernames that can use these commands (exact spelling, case-sensitive)
--
-- AVAILABLE COMMANDS:
--   :kick [name]          - kicks the player
--   :kill [name]          - kills the player's character
--   :heal [name]          - fully heals the player
--   :speed [name] [value] - sets walk speed (e.g. :speed Valk 50)
--   :jump [name] [value]  - sets jump height
--   :god [name]           - sets health to 10,000 (effectively god mode)
--   :ungod [name]         - resets health back to 100
--   :ff [name]            - gives a force field
--   :unff [name]          - removes the force field
-- ============================================

local Players = game:GetService("Players")

local ADMINS = {
	"vallkyrionxd-ops",   -- replace with your actual Roblox username
}

local function isAdmin(player)
	for _, name in ipairs(ADMINS) do
		if player.Name == name then return true end
	end
	return false
end

local function findPlayer(name)
	name = name:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():find(name, 1, true) then
			return p
		end
	end
	return nil
end

local function getHumanoid(player)
	local char = player.Character
	return char and char:FindFirstChildWhichIsA("Humanoid")
end

local COMMANDS = {
	kick = function(args, sender)
		local target = findPlayer(args[1])
		if target and target ~= sender then
			target:Kick("You were kicked by an admin.")
		end
	end,
	kill = function(args)
		local target = findPlayer(args[1])
		local h = target and getHumanoid(target)
		if h then h.Health = 0 end
	end,
	heal = function(args)
		local target = findPlayer(args[1])
		local h = target and getHumanoid(target)
		if h then h.Health = h.MaxHealth end
	end,
	speed = function(args)
		local target = findPlayer(args[1])
		local h = target and getHumanoid(target)
		if h then h.WalkSpeed = tonumber(args[2]) or 16 end
	end,
	jump = function(args)
		local target = findPlayer(args[1])
		local h = target and getHumanoid(target)
		if h then h.JumpHeight = tonumber(args[2]) or 7.2 end
	end,
	god = function(args)
		local target = findPlayer(args[1])
		local h = target and getHumanoid(target)
		if h then h.MaxHealth = 10000; h.Health = 10000 end
	end,
	ungod = function(args)
		local target = findPlayer(args[1])
		local h = target and getHumanoid(target)
		if h then h.MaxHealth = 100; h.Health = 100 end
	end,
	ff = function(args)
		local target = findPlayer(args[1])
		if target and target.Character then
			Instance.new("ForceField").Parent = target.Character
		end
	end,
	unff = function(args)
		local target = findPlayer(args[1])
		if target and target.Character then
			local ff = target.Character:FindFirstChildOfClass("ForceField")
			if ff then ff:Destroy() end
		end
	end,
}

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if not isAdmin(player) then return end
		if not message:sub(1,1) == ":" then return end

		local parts = message:sub(2):split(" ")
		local cmd   = parts[1] and parts[1]:lower()
		local args  = { table.unpack(parts, 2) }

		if COMMANDS[cmd] then
			COMMANDS[cmd](args, player)
		end
	end)
end)
