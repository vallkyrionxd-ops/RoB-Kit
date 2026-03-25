-- ============================================
-- DialogueNPC | RoB-Kit
-- ============================================
-- Click the NPC to open a simple dialogue box with a message.
-- Good for quest givers, shopkeepers, or story characters.
--
-- WHERE TO PUT IT:
--   Insert a Script inside your NPC model.
--   The NPC needs a part named "Head" for the click detector to attach to.
--
-- WHAT TO CHANGE:
--   NPC_NAME    = the name shown at the top of the dialogue box
--   DIALOGUE    = the lines of text the NPC says (one per click)
--   After the last line, the dialogue resets to the beginning.
-- ============================================

local NPC_NAME = "Old Man"

local DIALOGUE = {
	"Hello there, adventurer!",
	"This obby is full of dangers. Be careful.",
	"If you find the golden coin, bring it back to me.",
	"Good luck out there!",
}

local npc  = script.Parent
local head = npc:FindFirstChild("Head")

if not head then
	warn("[DialogueNPC] NPC has no part named 'Head'.")
	return
end

-- track each player's current line in the dialogue
local playerLine = {}

-- create the ClickDetector on the NPC's head
local clickDetector       = Instance.new("ClickDetector")
clickDetector.MaxActivationDistance = 10
clickDetector.Parent      = head

-- show a dialogue message above the NPC's head using a BillboardGui
local function showMessage(player, text)
	-- remove any existing dialogue bubble first
	local existing = npc:FindFirstChild("DialogueBubble")
	if existing then existing:Destroy() end

	local billboard            = Instance.new("BillboardGui")
	billboard.Name             = "DialogueBubble"
	billboard.Size             = UDim2.new(0, 250, 0, 80)
	billboard.StudsOffset      = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop      = true
	billboard.Parent           = npc:FindFirstChild("Head") or npc

	local background           = Instance.new("Frame")
	background.Size            = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	background.BackgroundTransparency = 0.2
	background.BorderSizePixel = 0
	background.Parent          = billboard

	local nameLabel            = Instance.new("TextLabel")
	nameLabel.Size             = UDim2.new(1, 0, 0.35, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text             = NPC_NAME
	nameLabel.TextColor3       = Color3.fromRGB(255, 200, 50)
	nameLabel.TextScaled       = true
	nameLabel.Font             = Enum.Font.GothamBold
	nameLabel.Parent           = background

	local textLabel            = Instance.new("TextLabel")
	textLabel.Size             = UDim2.new(1, -10, 0.6, 0)
	textLabel.Position         = UDim2.new(0, 5, 0.38, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text             = text
	textLabel.TextColor3       = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled       = true
	textLabel.TextWrapped      = true
	textLabel.Font             = Enum.Font.Gotham
	textLabel.Parent           = background

	-- auto-close after 5 seconds
	task.delay(5, function()
		if billboard and billboard.Parent then
			billboard:Destroy()
		end
	end)
end

clickDetector.MouseClick:Connect(function(player)
	if not playerLine[player.UserId] then
		playerLine[player.UserId] = 1
	end

	local line = DIALOGUE[playerLine[player.UserId]]
	showMessage(player, line)

	-- advance to next line, loop back at the end
	playerLine[player.UserId] = (playerLine[player.UserId] % #DIALOGUE) + 1
end)
