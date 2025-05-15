-- UI Library
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {}

local function Create(class, props)
    local inst = Instance.new(class)
    for i,v in pairs(props) do
        inst[i] = v
    end
    return inst
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "FuturisticUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })

    local Main = Create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(24, 24, 32),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })

    MakeDraggable(Main)

    local UICorner = Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    local UIStroke = Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(0, 170, 255),
        Thickness = 1.5,
        Parent = Main
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Parent = Main
    })

    local Tabs = Create("Frame", {
        Size = UDim2.new(0, 140, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(18, 18, 24),
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Tabs})

    local Content = Create("Frame", {
        Size = UDim2.new(1, -140, 1, -40),
        Position = UDim2.new(0, 140, 0, 40),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local tabButtons = {}
    local tabPages = {}

    local function switchTab(name)
        for tab, page in pairs(tabPages) do
            page.Visible = (tab == name)
        end
        for btn, _ in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end

    local function createTab(name)
        local btn = Create("TextButton", {
            Size = UDim2.new(1, -10, 0, 35),
            Position = UDim2.new(0, 5, 0, #tabButtons * 40),
            BackgroundColor3 = Color3.fromRGB(30, 30, 40),
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Tabs
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})

        local tabPage = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 2, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Parent = Content,
            ScrollBarThickness = 4
        })

        tabButtons[name] = btn
        tabPages[name] = tabPage

        btn.MouseButton1Click:Connect(function()
            switchTab(name)
        end)

        if #tabButtons == 1 then
            switchTab(name)
        end

        local Tab = {}
        local elementY = 0

        function Tab:AddToggle(text, default, callback)
            local toggle = Create("TextButton", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, elementY),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Text = text .. ": " .. (default and "On" or "Off"),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tabPage
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = toggle})
            local state = default
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = text .. ": " .. (state and "On" or "Off")
                callback(state)
            end)
            elementY += 35
        end

        function Tab:AddSlider(text, config, callback)
            local label = Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, elementY),
                BackgroundTransparency = 1,
                Text = text .. ": " .. config.default,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tabPage
            })

            local sliderBack = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, elementY + 22),
                BackgroundColor3 = Color3.fromRGB(50, 50, 60),
                BorderSizePixel = 0,
                Parent = tabPage
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = sliderBack})

            local fill = Create("Frame", {
                Size = UDim2.new((config.default-config.min)/(config.max-config.min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 170, 255),
                BorderSizePixel = 0,
                Parent = sliderBack
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = fill})

            local dragging = false

            sliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    local val = math.floor(config.min + (config.max - config.min) * rel)
                    label.Text = text .. ": " .. val
                    callback(val)
                end
            end)
            elementY += 50
        end

        function Tab:AddButton(text, callback)
            local btn = Create("TextButton", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, elementY),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Text = text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tabPage
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
            btn.MouseButton1Click:Connect(callback)
            elementY += 35
        end

        function Tab:AddKeybind(text, keycode, callback)
            local bind = keycode
            local label = Create("TextButton", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, elementY),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Text = text .. ": " .. keycode.Name,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tabPage
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = label})

            label.MouseButton1Click:Connect(function()
                label.Text = text .. ": [Press]"
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        bind = input.KeyCode
                        label.Text = text .. ": " .. bind.Name
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == bind then
                    callback()
                end
            end)
            elementY += 35
        end

        return Tab
    end

    return {CreateTab = createTab}
end

return Library
