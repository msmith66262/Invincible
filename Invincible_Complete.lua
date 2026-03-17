-- ============================================
-- COMBINED INVINCIBLE TOGGLE SYSTEM
-- Server + Client in one organized module
-- ============================================

-- ============================================
-- SERVER-SIDE CODE (Script in ServerScriptService)
-- ============================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent for toggling invincibility
local toggleEvent = Instance.new("RemoteEvent")
toggleEvent.Name = "ToggleInvincible"
toggleEvent.Parent = ReplicatedStorage

local invinciblePlayers = {}

-- Handle new players joining
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- If invincible toggle is on, keep them invincible
        if invinciblePlayers[player] then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge

            humanoid.HealthChanged:Connect(function()
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
    end)
end)

-- Listen for toggle from player
toggleEvent.OnServerEvent:Connect(function(player)
    invinciblePlayers[player] = not invinciblePlayers[player]
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if invinciblePlayers[player] then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end)

-- ============================================
-- CLIENT-SIDE CODE (LocalScript in StarterGui)
-- ============================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local toggleEvent = ReplicatedStorage:WaitForChild("ToggleInvincible")

-- Create simple toggle button
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.Text = "Toggle Invincible"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    toggleEvent:FireServer() -- tells server to toggle invincibility
end)