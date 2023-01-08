local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Response = game:HttpGet("https://raw.githubusercontent.com/0x580x540x43/ScammerList/main/List.json")
local List = game:GetService("HttpService"):JSONDecode(Response)
local Scammers = List.Scammers
local Bots = List.Bots
local ScriptEnabled = true

local Arguments = {...}
local DisableKey = Arguments[1] or Enum.KeyCode.RightControl
-------------------------------------------------------------------------------

local ScammerBillboard = Instance.new("BillboardGui", ReplicatedStorage)
ScammerBillboard.Name = "ScammerBillboard"
ScammerBillboard.Active = true
ScammerBillboard.Size = UDim2.new(UDim.new(0,200), UDim.new(0,50))
ScammerBillboard.ExtentsOffset = Vector3.new(0,4,0)
ScammerBillboard.Name = "ScammerBillboard"
local ScammerText = Instance.new("TextLabel", ScammerBillboard)
ScammerText.Name = "ScammerText"
ScammerText.Active = true
ScammerText.Text = "Known Scammer!"
ScammerText.TextScaled = true
ScammerText.BackgroundTransparency = 1
ScammerText.TextColor3 = Color3.fromRGB(255, 0, 0)
ScammerText.FontFace = Font.fromName("Bangers")

-------------------------------------------------------------------------------

local BotBillboard = ScammerBillboard:Clone()
BotBillboard.Parent = ReplicatedStorage
BotBillboard.Name = "BotBillboard"
local BotText = BotBillboard:WaitForChild("ScammerText")
BotText.Active = true
BotText.Name = "BotText"
BotText.Parent = BotBillboard
BotText.Text = "Known Bot!"
BotText.TextColor3 = Color3.fromRGB(0, 238, 255)

-------------------------------------------------------------------------------

local function addBillboard(Character, Type)
    if ScriptEnabled == false then return end
    local Head = Character:WaitForChild("Head")
    if Head:FindFirstChildWhichIsA("BillboardGui") ~= nil then
        Head:FindFirstChildWhichIsA("BillboardGui"):Destroy()
    end
    local BillboardGui, TextLabel
    if Type == "Bot" then
        task.wait()
        BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "BotBillboard"
        BillboardGui.Size = UDim2.new(0,100,0,150)
        BillboardGui.StudsOffset = Vector3.new(0,1,0)
        BillboardGui.Parent = Head
        BillboardGui.Adornee = Head
        
        TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "BotText"
        TextLabel.Parent = BillboardGui
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0,0,0,-50)
        TextLabel.Size = UDim2.new(0,100,0,100)
        TextLabel.Font = "Bangers"
        TextLabel.FontSize = "Size48"
        TextLabel.Text = "Known Bot!"
        TextLabel.TextStrokeColor3 = Color3.new(255,255,255)
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextYAlignment = "Bottom"
    elseif Type == "Scammer" then
        task.wait()
        BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ScammerBillboard"
        BillboardGui.Size = UDim2.new(0,100,0,150)
        BillboardGui.StudsOffset = Vector3.new(0,2,0)
        BillboardGui.Parent = Head
        BillboardGui.Adornee = Head
        
        TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "ScammerText"
        TextLabel.Parent = BillboardGui
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0,0,0,-50)
        TextLabel.Size = UDim2.new(0,100,0,100)
        TextLabel.Font = "Bangers"
        TextLabel.FontSize = "Size48"
        TextLabel.Text = "Known Scammer!"
        TextLabel.TextStrokeColor3 = Color3.new(255,255,255)
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextYAlignment = "Bottom"
    end
end

local function SearchForUserId(UserId)
    if table.find(Scammers, UserId) then
        return "Scammer"
    end

    if table.find(Bots, UserId) then
        return "Bot"
    end

    return false
end

for _, Player in pairs(Players:GetPlayers()) do
    local IsMatch = SearchForUserId(Player.UserId)
    if IsMatch == "Scammer" or IsMatch == "Bot" then
        Player.CharacterAdded:Connect(function(Character)
            addBillboard(Character, IsMatch)
        end)
        addBillboard(Player.Character, IsMatch)
    end
end

Players.PlayerAdded:Connect(function(Player)
    local IsMatch = SearchForUserId(Player.UserId)
    if IsMatch == "Scammer" or IsMatch == "Bot" then
        Player.CharacterAdded:Connect(function(Character)
            addBillboard(Character, IsMatch)
        end)
    end
end)

local function ShowOrHideBillboards()
    for _, Player in pairs(Players:GetPlayers()) do
        local Character = Player.Character
        local Head = Character:WaitForChild("Head")

        local Billboard = Head:FindFirstChildWhichIsA("BillboardGui") or nil

        if Billboard ~= nil then
            print("Found it")
            if ScriptEnabled == true then
                Billboard.Active = true
                Billboard:FindFirstChildWhichIsA("TextLabel").Visible = true
            elseif ScriptEnabled == false then
                Billboard.Active = false
                Billboard:FindFirstChildWhichIsA("TextLabel").Visible = false
            end
        end
    end
end


UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Keyboard then
        if Input.KeyCode == DisableKey then
            print(Input.KeyCode)
            if ScriptEnabled == true then
                ScriptEnabled = false
                ShowOrHideBillboards()
            else
                ScriptEnabled = true
                ShowOrHideBillboards()
            end
        end
    end
end)
