-- Variable 
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local localroot = character:WaitForChild("HumanoidRootPart")

local function UpdateChar()
    character = player.Character or player.CharacterAdded:Wait()
    localroot = character:WaitForChild("HumanoidRootPart")
end

game.Players.LocalPlayer.CharacterAdded:Connect(UpdateChar)

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

OrionLib:MakeNotification({
	Name = "Loaded :3",
	Content = "Loaded, Good Luck!",
	Image = "rbxassetid://4483345998",
	Time = 5
})

local Window = OrionLib:MakeWindow({Name = "Doomspire Brickbattles", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tabxx = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tabxx:AddParagraph("Welcome!!", "Welcome, " .. player.Name)

local Section = Tabxx:AddSection({
	Name = "X, Y, Z I think"
})

local selectedY = 0
local selectedX = 0
local selectedZ = -10

Tabxx:AddTextbox({
    Name = "Position X (left/right, using negative number/nonneg)",
    Default = "0",
    TextDisappear = false,
    Callback = function(Value)
        selectedX = tonumber(Value)
    end
})

Tabxx:AddTextbox({
    Name = "Position Y (Up/Down, using negative number/nonneg)",
    Default = "0",
    TextDisappear = false,
    Callback = function(Value)
        selectedY = tonumber(Value)
    end
})

Tabxx:AddTextbox({
    Name = "Position Z (Foward/Backward, using negative number/nonneg",
    Default = "-10",
    TextDisappear = false,
    Callback = function(Value)
        selectedZ = tonumber(Value)
    end
})

Tabxx:AddParagraph("One up this text is recommended from -5 to -10", " ")
Tabxx:AddParagraph("", "")

local TogglePlayerOnly = false
local function bringPlayerOnly()
    if TogglePlayerOnly and selectedX and selectedY and selectedZ then
        spawn(function()
            while TogglePlayerOnly do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        local JNR = v.Character:FindFirstChild("HumanoidRootPart")
                        if JNR then
                            JNR.CFrame = localroot.CFrame * CFrame.new(selectedX, selectedY, selectedZ)
                            game:GetService("RunService").Heartbeat:Wait()
                        end
                    end
                end
            end
        end)
    end
end

local tablePlayer = {}
local function UpdatePlayerList()
    tablePlayer = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name and v.Name ~= player.Name and v.Character then
            table.insert(tablePlayer, v.Name)
        end
    end
end

UpdatePlayerList()

game.Players.PlayerAdded:Connect(UpdatePlayerList)
game.Players.PlayerRemoving:Connect(UpdatePlayerList)

local selectedPlayer = nil
Tabxx:AddDropdown({
    Name = "Select Player(s)",
    Default = "",
    Options = tablePlayer,
    Callback = function(Value)
        selectedPlayer = Value
    end
})

local ToggleSelectedPlayer = false
local function bringSelectedPlayer()
    if selectedPlayer and selectedX and selectedY and selectedZ then
        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        if targetPlayer and targetPlayer.Character then
            spawn(function()
                while ToggleSelectedPlayer do
                    local JNR = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if JNR then
                        JNR.CFrame = localroot.CFrame * CFrame.new(selectedX, selectedY, selectedZ)
                        game:GetService("RunService").Heartbeat:Wait()
                    end
                end
            end)
        end
    end
end

Tabxx:AddToggle({
    Name = "Bring Selected Player",
    Default = false,
    Callback = function(state)
        ToggleSelectedPlayer = state
        if ToggleSelectedPlayer then
            bringSelectedPlayer()
        end
    end
})

Tabxx:AddToggle({
    Name = "Bring All Players",
    Default = false,
    Callback = function(state)
        TogglePlayerOnly = state
        if TogglePlayerOnly then
            bringPlayerOnly()
        end
    end
})

local function BringNonTeamOnly()
    if selectedX and selectedY and selectedZ then
        spawn(function()
            while TogglePlayerOnly do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v.Team ~= player.Team and v.Character then
                        local enemyRoot = v.Character:FindFirstChild("HumanoidRootPart")
                        if enemyRoot then
                            enemyRoot.CFrame = localroot.CFrame * CFrame.new(selectedX, selectedY, selectedZ)
                            wait()
                        end
                    end
                end
            end
        end)
    end
end

Tabxx:AddToggle({
    Name = "Bring All Player But With Team Check",
    Default = false,
    Callback = function(state)
        TogglePlayerOnly = state
        if TogglePlayerOnly then
            BringNonTeamOnly()
        end
    end
})
Tabxx:AddParagraph("readme", "warning: the one up this text MIGHT CRASH")
Tabxx:AddParagraph("", "")

local function CreateSafeZone()
    local part = Instance.new("Part")
    part.Position = Vector3.new(1000, 1000, 1000)
    part.Size = Vector3.new(10000, 2, 10000)
    part.Color = Color3.new(1, 1, 1)
    part.Parent = game.Workspace
    part.Name = "SafePart"
    part.Anchored = true
    localroot.CFrame = part.CFrame * CFrame.new(0, 10, 0)
end

Tabxx:AddButton({
    Name = "Go to SafeZone (Far away from the map)",
    Callback = function()
        CreateSafeZone()
    end
})

Tabxx:AddParagraph("", "")

-- Player Tab
local Tabxax = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://16395722595",
    PremiumOnly = false
})

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local humanoid
local noclip = false
local infiniteJumpEnabled = false
local flying = false

-- Function to setup character
local function setupCharacter(character)
    humanoid = character:WaitForChild("Humanoid")

    -- Set default values for walk speed and jump power
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50

    -- Noclip logic
    runService.Stepped:Connect(function()
        if noclip then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false -- Disable collision for all parts of the character
                end
            end
        else
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true -- Re-enable collision when noclip is off
                end
            end
        end
    end)
end

-- Connect character added event to setup character when it spawns
player.CharacterAdded:Connect(setupCharacter)

-- Initial setup for existing character if it exists
if player.Character then
    setupCharacter(player.Character)
end

-- Walk Speed Slider in the GUI
Tabxax:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 3000,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        humanoid.WalkSpeed = value -- Update walk speed based on slider value
    end
})

-- Jump Power Slider in the GUI
Tabxax:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 3000,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        humanoid.JumpPower = value -- Update jump power based on slider value
    end
})

-- Noclip Toggle Checkbox in the GUI
Tabxax:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        noclip = state -- Set noclip state based on checkbox value
    end
})

-- Infinite Jump Toggle Checkbox in the GUI
Tabxax:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infiniteJumpEnabled = state -- Set infinite jump state based on checkbox value
    end
})

-- Infinite Jump Logic: Allow jumping continuously if enabled
userInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState("Jumping") -- Force the humanoid to jump again when requested
    end
end)

-- Fly Toggle Feature 
Tabxax:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        flying = state
        
        if flying then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- Set upward velocity for flying
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000) -- Adjust force to keep the player in the air
            
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")

            runService.RenderStepped:Connect(function()
                if flying then 
                    bodyVelocity.Velocity= Vector3.new(0, 50, 0) -- Maintain upward velocity 
                else 
                    bodyVelocity:Destroy() -- Remove BodyVelocity when not flying 
                end 
            end)
        else 
            local bodyVelocity= character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyVelocity") 
            if bodyVelocity then bodyVelocity:Destroy() end -- Stop flying by removing BodyVelocity 
        end 
   end 
})


-- Scripts Tab for additional functionalities.
local Tabonx= Window:MakeTab({Name= "Scripts", Icon= "rbxassetid://11348590105", PremiumOnly= false})

local camera = game.Workspace.CurrentCamera

Tabonx:AddSlider({
    Name = "Field of View",
    Min = 60,      -- Minimum FOV
    Max = 120,     -- Maximum FOV
    Default = 70,  -- Default starting FOV
    Increment = 1, -- Step size for the slider
    Callback = function(value)
        camera.FieldOfView = value -- Update the camera's Field of View based on slider value
    end
})

Tabonx:AddButton({
    Name = "Load Moon Yield!!",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pkplaysrblx/moon-yield/refs/heads/main/script.lua"))()
        print("MIY loaded successfully!")
    end
})

local antiAFKActive = false

Tabonx:AddToggle({
    Name = "Enable Anti-AFK",
    Default = false,
    Callback = function(state)
        antiAFKActive = state
        local humanoid = player.Character:WaitForChild("Humanoid")

        if antiAFKActive then
            while antiAFKActive do
                wait(1)
                humanoid:ChangeState("Jumping") -- Simulate jumping to prevent AFK status
            end
        end
    end
})

local nightVisionActive = false

Tabonx:AddToggle({
    Name = "Toggle Night Vision",
    Default = false,
    Callback = function(state)
        nightVisionActive = state
        local lighting = game:GetService("Lighting")

        if nightVisionActive then
            lighting.Ambient = Color3.new(0.1, 0.5, 0.1) -- Set a greenish ambient color for night vision
            lighting.Brightness = 2 -- Increase brightness for better visibility in dark areas
        else
            lighting.Ambient = Color3.new(1, 1, 1) -- Reset to default ambient color
            lighting.Brightness = 1 -- Reset brightness to normal
        end
    end
})

local screenEffectActive = false

Tabonx:AddToggle({
    Name = "Toggle Screen Blur",
    Default = false,
    Callback = function(state)
        screenEffectActive = state

        if screenEffectActive then
            local blurEffect = Instance.new("BlurEffect")
            blurEffect.Size = 10 -- Adjust blur size as needed (0 to higher values)
            blurEffect.Parent = game:GetService("Lighting") -- Apply the blur effect to Lighting for global effect.
        else 
            for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do 
                if effect:IsA("BlurEffect") then 
                    effect:Destroy() 
                end 
            end 
        end 
    end 
})

local TabMOM = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://5680175192",
    PremiumOnly = false
})

TabMOM:AddParagraph("creds:", "swqss main, joke.xx alt on discord")

TabMOM:AddButton({
    Name = "Copy discord in clipboard",
    Callback = function()
        local starterGui = Services.StarterGui
        setclipboard([[https://discord.gg/2YVa83gCV2]])
        starterGui:SetCore("SendNotification", {
            Title = "Copied!",
            Text = "Copied Discord link in clipboard!",
            Duration = 5
        })
        print("Copied successfully!")
    end
})
