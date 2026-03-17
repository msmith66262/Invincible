-- LocalScript in StarterGui
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
