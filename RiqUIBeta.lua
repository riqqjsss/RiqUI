-- RiqUI Library
local RiqUI = {}

local function CreateInstance(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            instance[prop] = value
        end
    end
    return instance
end

function RiqUI:CreateWindow(name)
    local ScreenGui = CreateInstance("ScreenGui", {
        ResetOnSpawn = false,
        ZIndexBehavior = "Global"
    })

    local MainFrame = CreateInstance("Frame", {
        Size = UDim2.new(0, 350, 0, 400),
        Position = UDim2.new(0.5, -175, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })

    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MainFrame})
    
    -- Tabs container
    local TabButtons = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local TabListLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Parent = TabButtons
    })

    local ContentFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -10, 1, -40),
        Position = UDim2.new(0, 5, 0, 35),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local ContentLayout = CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = ContentFrame
    })

    local window = {
        Tabs = {},
        CurrentTab = nil
    }

    function window:CreateTab(name)
        local tab = {
            Name = name,
            Elements = {}
        }

        -- Tab button
        local TabButton = CreateInstance("TextButton", {
            Size = UDim2.new(0, 70, 1, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Text = name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Parent = TabButtons
        })

        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = TabButton})

        -- Tab content
        local TabContent = CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 3,
            Parent = ContentFrame
        })

        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = TabContent
        })

        function tab:Show()
            if window.CurrentTab then
                window.CurrentTab.Content.Visible = false
                window.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            window.CurrentTab = tab
        end

        function tab:AddToggle(text, default, callback)
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Parent = TabContent
            })

            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ToggleFrame})

            local ToggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = ToggleFrame
            })

            local ToggleLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.7, 0, 1, 0),
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })

            local ToggleState = CreateInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                Parent = ToggleFrame
            })

            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleState})

            local state = default
            local function UpdateToggle()
                ToggleState.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
                callback(state)
            end

            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                UpdateToggle()
            end)

            UpdateToggle()
        end

        function tab:AddSlider(text, options, callback)
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Parent = TabContent
            })

            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SliderFrame})

            local SliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                Text = text,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })

            local Track = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 5),
                Position = UDim2.new(0, 5, 1, -15),
                BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                Parent = SliderFrame
            })

            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})

            local Fill = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 170, 255),
                Parent = Track
            })

            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})

            local dragging = false
            local currentValue = options.default or options.min

            local function UpdateSlider(value)
                local percent = (value - options.min) / (options.max - options.min)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                SliderLabel.Text = text..": "..tostring(math.floor(value))
                currentValue = value
                callback(value)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local pos = input.Position.X - Track.AbsolutePosition.X
                    local value = options.min + (pos / Track.AbsoluteSize.X) * (options.max - options.min)
                    value = math.clamp(math.floor(value), options.min, options.max)
                    UpdateSlider(value)
                end
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UpdateSlider(options.default)
        end

        tab.Content = TabContent
        tab.Button = TabButton
        table.insert(window.Tabs, tab)

        if #window.Tabs == 1 then
            tab:Show()
        end

        return tab
    end

    return window
end

return function()
    return RiqUI
end
