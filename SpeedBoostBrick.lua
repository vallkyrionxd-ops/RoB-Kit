-- ============================================
-- ShopSystem | RoB-Kit
-- ============================================
-- A simple coin-based shop. Players touch a shop brick to buy items.
-- Works with the LeaderboardSetup and DataSaver scripts.
--
-- WHERE TO PUT IT:
--   Put this Script inside ServerScriptService.
--   Then place shop bricks in Workspace, each named to match an item below.
--
-- HOW TO SET UP:
--   1. Create bricks in Workspace and name them exactly as shown in SHOP_ITEMS
--      (e.g. a brick named "BuySpeed" sells the Speed Boost item)
--   2. Players touch the brick to buy the item
--
-- WHAT TO CHANGE:
--   SHOP_ITEMS = add or remove items here
--   Each item has a BrickName, Price (in Coins), and what it does
-- ============================================

local Players = game:GetService("Players")

local SHOP_ITEMS = {
	{
		BrickName   = "BuySpeed",
		Price       = 50,
		Description = "Speed Boost (10 seconds)",
		OnPurchase  = function(player)
			local character = player.Character
			local humanoid  = character and character:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 40
				task.wait(10)
				humanoid.WalkSpeed = 16
			end
		end,
	},
	{
		BrickName   = "BuyHealth",
		Price       = 30,
		Description = "Full HP restore",
		OnPurchase  = function(player)
			local character = player.Character
			local humanoid  = character and character:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid.Health = humanoid.MaxHealth
			end
		end,
	},
}

-- helper to get a player's coin value
local function getCoins(player)
	local ls = player:FindFirstChild("leaderstats")
	return ls and ls:FindFirstChild("Coins")
end

-- hook up each shop brick
for _, item in ipairs(SHOP_ITEMS) do
	local brick = game.Workspace:FindFirstChild(item.BrickName)

	if not brick then
		warn("[ShopSystem] No brick named '" .. item.BrickName .. "' found in Workspace.")
		continue
	end

	local debounce = {}

	brick.Touched:Connect(function(hit)
		local character = hit.Parent
		local player    = Players:GetPlayerFromCharacter(character)

		if not player or debounce[player.UserId] then return end
		debounce[player.UserId] = true

		local coins = getCoins(player)

		if coins and coins.Value >= item.Price then
			-- deduct coins and run the purchase effect
			coins.Value = coins.Value - item.Price
			item.OnPurchase(player)
			print("[ShopSystem] " .. player.Name .. " bought " .. item.Description)
		else
			warn("[ShopSystem] " .. player.Name .. " can't afford " .. item.Description)
		end

		task.wait(1)
		debounce[player.UserId] = nil
	end)
end
