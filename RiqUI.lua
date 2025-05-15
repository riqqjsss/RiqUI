--[[
    Advanced Cheat UI Framework (Rayfield/Fluent Style)
    Author: ChatGPT
    Description: Modular cheat-style UI with toggle and slider support.
--]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "CheatUI"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local TitleBar = Instance.new("TextLabel", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Text = title or "Cheat UI"
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextSize = 16
    TitleBar.BorderSizePixel = 0
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(0, 120, 1, -40)
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabHolder.BorderSizePixel = 0
    Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 6)

    local ContentFrame = Instance.new("Frame", Main)
    ContentFrame.Size = UDim2.new(1, -130, 1, -60)
    ContentFrame.Position = UDim2.new(0, 130, 0, 50)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContentFrame.BorderSizePixel = 0
    Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

    local UIList = Instance.new("UIListLayout", TabHolder)
    UIList.Padding = UDim.new(0, 5)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local Window = {}
    Window.Tabs = {}
    Window.Content = ContentFrame

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.BorderSizePixel = 0
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local TabFrame = Instance.new("ScrollingFrame", ContentFrame)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.Visible = false
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 4

        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0, 10)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder

        local Tab = {}

        function Tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("TextButton", TabFrame)
            Toggle.Size = UDim2.new(0, 200, 0, 40)
            Toggle.Text = text
            Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.BorderSizePixel = 0
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

            local toggled = default or false
            local function update()
                Toggle.Text = (toggled and "✔ " or "✖ ") .. text
                local color = toggled and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(40, 40, 40)
                TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
            end

            Toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                update()
                if callback then callback(toggled) end
            end)

            update()
        end

        function Tab:AddSlider(text, config, callback)
            local Label = Instance.new("TextLabel", TabFrame)
            Label.Size = UDim2.new(0, 200, 0, 20)
            Label.Text = text .. ": " .. config.default
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local SliderBack = Instance.new("Frame", TabFrame)
            SliderBack.Size = UDim2.new(0, 200, 0, 8)
            SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderBack.BorderSizePixel = 0
            local corner = Instance.new("UICorner", SliderBack)
            corner.CornerRadius = UDim.new(0, 4)

            local Fill = Instance.new("Frame", SliderBack)
            Fill.Size = UDim2.new((config.default - config.min)/(config.max - config.min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
            Fill.BorderSizePixel = 0
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)

            local dragging = false

            local function update(inputX)
                local rel = math.clamp((inputX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                local value = math.floor(config.min + (config.max - config.min) * rel)
                Fill.Size = UDim2.new(rel, 0, 1, 0)
                Label.Text = text .. ": " .. value
                if callback then callback(value) end
            end

            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input.Position.X)
                end
            end)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            TabFrame.Visible = true
        end)

        Tab.Frame = TabFrame
        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

return setmetatable({}, Library)
