-- UI Framework
local library = {}

local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function makeDraggable(frame)
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

    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function library:CreateWindow(title)
    local ScreenGui = create("ScreenGui", {Name = "FuturisticUI", ResetOnSpawn = false, Parent = game.CoreGui})

    local Main = create("Frame", {
        Size = UDim2.new(0, 450, 0, 350),
        Position = UDim2.new(0.5, -225, 0.5, -175),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })
    makeDraggable(Main)

    local UICorner = create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})

    local Title = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(200, 200, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 18,
        Parent = Main
    })

    local TabFrame = create("Frame", {
        Size = UDim2.new(1, -20, 1, -40),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local layout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabFrame
    })

    local window = {}

    function window:CreateTab(name)
        local tab = {}

        local TabTitle = create("TextLabel", {
            Text = name,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            LayoutOrder = 0,
            Parent = TabFrame
        })

        function tab:AddToggle(text, default, callback)
            local Toggle = create("TextButton", {
                Text = text,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                LayoutOrder = 1,
                Parent = TabFrame
            })
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Toggle})
            local state = default
            Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                callback(state)
            end)
        end

        function tab:AddButton(text, callback)
            local Button = create("TextButton", {
                Text = text,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = Color3.fromRGB(60, 60, 90),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                LayoutOrder = 1,
                Parent = TabFrame
            })
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Button})
            Button.MouseButton1Click:Connect(callback)
        end

        function tab:AddSlider(text, config, callback)
            local value = config.default or config.min

            local Frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Parent = TabFrame
            })

            local Label = create("TextLabel", {
                Text = text .. ": " .. tostring(value),
                Size = UDim2.new(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Parent = Frame
            })

            local Slider = create("TextButton", {
                Text = "",
                Size = UDim2.new(1, 0, 0, 15),
                Position = UDim2.new(0, 0, 0, 18),
                BackgroundColor3 = Color3.fromRGB(100, 100, 120),
                Parent = Frame
            })
            create("UICorner", {Parent = Slider})

            local DragBar = create("Frame", {
                Size = UDim2.new((value-config.min)/(config.max-config.min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 200, 255),
                Parent = Slider
            })
            create("UICorner", {Parent = DragBar})

            Slider.MouseButton1Down:Connect(function()
                local conn
                conn = uis.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                        DragBar.Size = UDim2.new(rel, 0, 1, 0)
                        local newVal = math.floor((config.min + (config.max - config.min) * rel) + 0.5)
                        Label.Text = text .. ": " .. newVal
                        callback(newVal)
                    end
                end)
                uis.InputEnded:Wait()
                if conn then conn:Disconnect() end
            end)
        end

        function tab:AddKeybind(text, default, callback)
            local Button = create("TextButton", {
                Text = text .. ": [" .. default.Name .. "]",
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = Color3.fromRGB(40, 40, 70),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                LayoutOrder = 1,
                Parent = TabFrame
            })
            create("UICorner", {Parent = Button})

            local key = default

            Button.MouseButton1Click:Connect(function()
                Button.Text = text .. ": [Press a key]"
                local conn
                conn = uis.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        Button.Text = text .. ": [" .. key.Name .. "]"
                        conn:Disconnect()
                    end
                end)
            end)

            uis.InputBegan:Connect(function(input)
                if input.KeyCode == key then
                    callback()
                end
            end)
        end

        return tab
    end

    return window
end

return library
