-- Script in ServerScriptService
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent for toggling invincibility
local toggleEvent = Instance.new("RemoteEvent")
toggleEvent.Name = "ToggleInvincible"
toggleEvent.Parent = ReplicatedStorage

local invinciblePlayers = {}

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
