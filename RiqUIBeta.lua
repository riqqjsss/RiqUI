-- RiqUI - Versão simples para loadstring
local RiqUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function create(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then
                obj.Parent = v
            else
                obj[k] = v
            end
        end
    end
    return obj
end

function RiqUI:CreateWindow(title)
    local selfWindow = {}

    local screenGui = create("ScreenGui", {
        Name = "RiqUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui"),
    })

    local mainFrame = create("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })

    local titleLabel = create("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        TextColor3 = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Text = title,
        BorderSizePixel = 0,
    })

    local tabButtonsFrame = create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BorderSizePixel = 0,
    })

    local tabContentFrame = create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(18, 18, 25),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })

    local tabs = {}
    local activeTab = nil

    local function clearTabContent()
        for _, child in ipairs(tabContentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
    end

    function selfWindow:CreateTab(name)
        local tabButton = create("TextButton", {
            Parent = tabButtonsFrame,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
            BorderSizePixel = 0,
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(180, 180, 180),
        })

        local tabPage = create("Frame", {
            Parent = tabContentFrame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
        })

        local layout = create("UIListLayout", {
            Parent = tabPage,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local padding = create("UIPadding", {
            Parent = tabPage,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
        })

        tabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(tabButtonsFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
                    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

            clearTabContent()
            tabPage.Visible = true
            activeTab = tabPage
        end)

        if #tabs == 0 then
            tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabPage.Visible = true
            activeTab = tabPage
        end

        local tab = {}

        function tab:AddToggle(name, default, callback)
            local container = create("Frame", {
                Parent = tabPage,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = #tabPage:GetChildren(),
            })

            local label = create("TextLabel", {
                Parent = container,
                Size = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                Font = Enum.Font.Gotham,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local toggleBtn = create("TextButton", {
                Parent = container,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(0.75, 0, 0.15, 0),
                BackgroundColor3 = default and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(150, 150, 150),
                BorderSizePixel = 0,
                Text = default and "ON" or "OFF",
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                AutoButtonColor = false,
                ClipsDescendants = true,
            })

            local toggled = default
            local function updateToggle()
                if toggled then
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
                    toggleBtn.Text = "ON"
                else
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                    toggleBtn.Text = "OFF"
                end
                callback(toggled)
            end

            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)

            updateToggle()

            return container
        end

        function tab:AddSlider(name, opts, callback)
            local container = create("Frame", {
                Parent = tabPage,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                LayoutOrder = #tabPage:GetChildren(),
            })

            local label = create("TextLabel", {
                Parent = container,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = name .. ": " .. tostring(opts.default),
                TextColor3 = Color3.fromRGB(220, 220, 220),
                Font = Enum.Font.Gotham,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local sliderFrame = create("Frame", {
                Parent = container,
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                ClipsDescendants = true,
            })

            local sliderBar = create("Frame", {
                Parent = sliderFrame,
                Size = UDim2.new((opts.default - opts.min) / (opts.max - opts.min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(100, 180, 250),
                BorderSizePixel = 0,
            })

            local dragging = false

            local function updateValue(inputPosX)
                local relativeX = math.clamp(inputPosX - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
                local value = (relativeX / sliderFrame.AbsoluteSize.X) * (opts.max - opts.min) + opts.min
                value = math.floor(value)
                sliderBar.Size = UDim2.new(relativeX / sliderFrame.AbsoluteSize.X, 0, 1, 0)
                label.Text = name .. ": " .. tostring(value)
                callback(value)
            end

            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateValue(input.Position.X)
                end
            end)

            sliderFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input.Position.X)
                end
            end)

            return container
        end

        table.insert(tabs, tab)

        return tab
    end

    function selfWindow:Destroy()
        screenGui:Destroy()
    end

    return selfWindow
end

return RiqUI
