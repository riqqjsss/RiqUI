--getgen().DefaultTheme = {

--};

function ClosureEvn()
    EnvironmentDesyn = workspace;
    waHDDwjidawjiodfawidhawdaw = workspace

    local Twen = game:GetService('TweenService');
    local Input = game:GetService('UserInputService');
    local TextServ = game:GetService('TextService');
    local LocalPlayer = game:GetService('Players').LocalPlayer;
    local CoreGui = (gethui and gethui()) or game:FindFirstChild('CoreGui') or LocalPlayer.PlayerGui;
    local Icons = {}

    local ElBlurSource = function()
        local GuiSystem = {}
        local RunService = game:GetService('RunService');
        local CurrentCamera = workspace.CurrentCamera;

        function GuiSystem:Hash()
            return string.reverse(string.gsub(HttpService:GenerateGUID(false),'..',function(aa)
                return string.reverse(aa)
            end))
        end

        local function Hiter(planePos, planeNormal, rayOrigin, rayDirection)
            local n = planeNormal
            local d = rayDirection
            local v = rayOrigin - planePos

            local num = (n.x*v.x) + (n.y*v.y) + (n.z*v.z)
            local den = (n.x*d.x) + (n.y*d.y) + (n.z*d.z)
            local a = -num / den

            return rayOrigin + (a * rayDirection), a;
        end;

        function GuiSystem.new(frame,NoAutoBackground)
            local Part = Instance.new('Part',workspace);
            local DepthOfField = Instance.new('DepthOfFieldEffect',game:GetService('Lighting'));
            local SurfaceGui = Instance.new('SurfaceGui',Part);
            local BlockMesh = Instance.new("BlockMesh");

            BlockMesh.Parent = Part;

            Part.Material = Enum.Material.Glass;
            Part.Transparency = 1;
            Part.Reflectance = 1;
            Part.CastShadow = false;
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CollisionGroup = GuiSystem:Hash();
            Part.Size = Vector3.new(1, 1, 1) * 0.01;
            Part.Color = Color3.fromRGB(0,0,0);

            Twen:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
                Transparency = 0.8;
            }):Play()

            DepthOfField.Enabled = true;
            DepthOfField.FarIntensity = 1;
            DepthOfField.FocusDistance = 0;
            DepthOfField.InFocusRadius = 500;
            DepthOfField.NearIntensity = 1;

            SurfaceGui.AlwaysOnTop = true;
            SurfaceGui.Adornee = Part;
            SurfaceGui.Active = true;
            SurfaceGui.Face = Enum.NormalId.Front;
            SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;

            DepthOfField.Name = GuiSystem:Hash();
            Part.Name = GuiSystem:Hash();
            SurfaceGui.Name = GuiSystem:Hash();

            local C4 = {
                Update = nil,
                Collection = SurfaceGui,
                Enabled = true,
                Instances = {
                    BlockMesh = BlockMesh,
                    Part = Part,
                    DepthOfField = DepthOfField,
                    SurfaceGui = SurfaceGui,
                },
                Signal = nil
            };
            local Update = function()
                if not waHDDwjidawjiodfawidhawdaw or not waHDDwjidawjiodfawidhawdaw.Parent then
                    EnvironmentDesyn = false;
                end;
                if not EnvironmentDesyn then
                    if C4 and C4.Signal then
                        C4.Signal:Disconnect();
                        C4.Signal = nil;
                    end;
                end;
                if not C4.Enabled then
                    Twen:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint),{
                        Transparency = 1;
                    }):Play()

                end;

                Twen:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
                    Transparency = 0.8;
                }):Play()

                local corner0 = frame.AbsolutePosition;
                local corner1 = corner0 + frame.AbsoluteSize;

                local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
                local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

                local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

                local planeNormal = CurrentCamera.CFrame.LookVector;

                local pos0 = Hiter(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
                local pos1 = Hiter(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

                pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
                pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

                local size   = pos1 - pos0;
                local center = (pos0 + pos1) / 2;

                BlockMesh.Offset = center
                BlockMesh.Scale  = size / 0.0101;
                Part.CFrame = CurrentCamera.CFrame;

                if not NoAutoBackground then

                    local _,updatec = pcal(function()
                        local userSettings = UserSettings():GetService("UserGameSettings")
                        local qualityLevel = userSettings.SavedQualityLevel.Value

                        if qualityLevel < 8 then
                            Twen:Create(frame,TweenInfo.new(1),{
                                BackgroundTransparency = 0
                            }):Play()
                        else
                            Twen:Create(frame,TweenInfo.new(1),{
                                BackgroundTransparency = 0.4
                            }):Play()
                        end;
                    end)

                end
            end

            C4.Update = Update;
            C4.Signal = RunService.RenderStepped:Connect(Update);

            pcal(function()
                C4.Signal2 = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(function()
                    Part.CFrame = CurrentCamera.CFrame;
                    if not EnvironmentDesyn then
                        pcal(function()
                            C4.Signal2:Disconnect();
                            C4.Signal2 = nil;
                        end);
                        pcal(function()
                            C4.Signal:Disconnect();
                            C4.Signal = nil;
                        end);
                        pcal(function()
                            Part:Destroy();
                        end);
                        pcal(function()
                            DepthOfField:Destroy();
                        end);
                        pcal(function()
                            SurfaceGui:Destroy();
                        end);
                        pcal(function()
                            BlockMesh:Destroy();
                        end);
                    end;
                end);
            end)

            C4.Destroy = function()
                C4.Signal:Disconnect();
                C4.Signal2:Disconnect();
                C4.Update = function()

                end;

                Twen:Create(Part,TweenInfo.new(1),{
                    Transparency = 1
                }):Play();

                DepthOfField:Destroy();
                Part:Destroy()
            end;

            return C4;
        end;

        return GuiSystem
    end;

    local ElBlurSource = ElBlurSource();
    local Config = function(data,default)
        data = data or {};

        for i,v in next,default do
            data[i] = data[i] or v;
        end;

        return data;
    end;

    local Library = {};

    Library['.'] = '1';
    Library['FetchIcon'] = {};

    pcal(function()
        Library['Icons'] = HttpService:JSONDecode(game:HttpGetAsync(Library.FetchIcon))['icons'];
    end)

    function Library.GradientImage(E : Frame , Color)
        local GLImage = Instance.new("ImageLabel")
        local upd = tick();
        local nextU , Speed , speedy , SIZ = 4 , 5 , -5 , 0.8;
        local nextmain = UDim2.new();
        local rng = Random.new(math.random(10,100000) + math.random(100, 1000) + math.sqrt(tick()));
        local int = 1;
        local TPL = 0.55;

        GLImage.Name = "GLImage"
        GLImage.Parent = E
        GLImage.AnchorPoint = Vector2.new(0.5, 0.5)
        GLImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        GLImage.BackgroundTransparency = 1.000
        GLImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
        GLImage.BorderSizePixel = 0
        GLImage.Position = UDim2.new(0.5, 0, 0.5, 0)
        GLImage.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
        GLImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
        GLImage.ZIndex = E.ZIndex - 1;
        GLImage.Image = "rbxassetid://867619398"
        GLImage.ImageColor3 = Color or Color3.fromRGB(0, 195, 255)
        GLImage.ImageTransparency = 1;

        local str = 'GL_EFFECT_'..tostring(tick());
        game:GetService('RunService'):BindToRenderStep(str,45,function()
            if (tick() - upd) > nextU then
                nextU = rng:NextNumber(1.1,2.5)
                Speed = rng:NextNumber(-6,6)
                speedy = rng:NextNumber(-6,6)
                TPL = rng:NextNumber(0.2,0.8)
                SIZ = rng:NextNumber(0.6,0.9);
                upd = tick();
                int = 1
            else
                speedy = speedy + rng:NextNumber(-0.1,0.1);
                Speed = Speed + rng:NextNumber(-0.1,0.1);

            end;

            nextmain = nextmain:Lerp(UDim2.new(0.5 + (Speed / 24),0,0.5 + (speedy / 24),0) , .025)
            int = int + 0.1

            Twen:Create(GLImage,TweenInfo.new(1),{
                Rotation = GLImage.Rotation + Speed,
                Position = nextmain,
                Size = UDim2.fromScale(SIZ,SIZ),
                ImageTransparency = TPL
            }):Play()
        end)

        return str
    end;

    Library.NewAuth = function(conf)
        conf = Config(conf,{
            Title = "Nothing $ KEY SYSTEM",
            GetKey = function() return 'https://example.com' end,
            Auth = function(key) if key == '1 or 1' then return key; end; end,
            Freeze = false,
        });


        if conf.Auth then
            if debug.info(conf.Auth,'s') == '[C]' then
                if error then
                    error('huh');
                end;

                return;
            end;
        end;

        if conf.GetKey then
            if debug.info(conf.GetKey,'s') == '[C]' then
                if error then
                    error('huh');
                end;

                return;
            end;
        end;

        local ScreenGui = Instance.new("ScreenGui")
        local vaid = Instance.new('BindableEvent')
        local Auth = Instance.new("Frame")
        local MainFrame = Instance.new("Frame")
        local BlockFrame = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local UIGradient = Instance.new("UIGradient")
        local UICorner_2 = Instance.new("UICorner")
        local Button2 = Instance.new("TextButton")
        local UICorner_3 = Instance.new("UICorner")
        local DropShadow = Instance.new("ImageLabel")
        local UIStroke = Instance.new("UIStroke")
        local TextBox = Instance.new("TextBox")
        local UICorner_4 = Instance.new("UICorner")
        local DropShadow_2 = Instance.new("ImageLabel")
        local UIStroke_2 = Instance.new("UIStroke")
        local Button1 = Instance.new("TextButton")
        local UICorner_5 = Instance.new("UICorner")
        local DropShadow_3 = Instance.new("ImageLabel")
        local UIStroke_3 = Instance.new("UIStroke")
        local MainDropShadow = Instance.new("ImageLabel")
        local Title = Instance.new("TextLabel")
        local UIGradient_2 = Instance.new("UIGradient")
        local UICorner_6 = Instance.new("UICorner")

        ScreenGui.Parent = CoreGui
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        ScreenGui.Name = HttpService:GenerateGUID(false)..tostring(tick())

        Auth.Name = "Auth"
        Auth.Parent = ScreenGui
        Auth.Active = true
        Auth.AnchorPoint = Vector2.new(0.5, 0.5)
        Auth.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        Auth.BackgroundTransparency = 1.000
        Auth.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Auth.BorderSizePixel = 0
        Auth.ClipsDescendants = true
        Auth.Position = UDim2.new(0.5, 0, 0.5, 0)
        Auth.Size = UDim2.new(0.100000001, 245, 0.100000001, 115)

        local BlueEffect = ElBlurSource.new(MainFrame,true);
        local cose = {Library.GradientImage(MainFrame),
            Library.GradientImage(MainFrame,Color3.fromRGB(255, 0, 4))}

        MainFrame.Name = "MainFrame"
        MainFrame.Parent = Auth
        MainFrame.Active = true
        MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        MainFrame.BackgroundTransparency = 0.500
        MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        MainFrame.BorderSizePixel = 0
        MainFrame.Position = UDim2.new(0.5, 0, -1.5, 0)
        MainFrame.Size = UDim2.new(0.8,0,0.8,0)
        Twen:Create(MainFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0)
        }):Play();

        BlockFrame.Name = "BlockFrame"
        BlockFrame.Parent = MainFrame
        BlockFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        BlockFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BlockFrame.BackgroundTransparency = 0.8
        BlockFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BlockFrame.BorderSizePixel = 0
        BlockFrame.Position = UDim2.new(0.5, 0, 0.150000006, 0)
        BlockFrame.Size = UDim2.new(1, 0, 0, 1)
        BlockFrame.ZIndex = 3

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = BlockFrame

        UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.05, 0.00), NumberSequenceKeypoint.new(0.96, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
        UIGradient.Parent = BlockFrame

        UICorner_2.CornerRadius = UDim.new(0, 7)
        UICorner_2.Parent = MainFrame

        Button2.Name = "Button2"
        Button2.Parent = MainFrame
        Button2.AnchorPoint = Vector2.new(0.5, 0.5)
        Button2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Button2.BackgroundTransparency = 0.500
        Button2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Button2.BorderSizePixel = 0
        Button2.Position = UDim2.new(0.75, 0, 0.649999976, 0)
        Button2.Size = UDim2.new(0.447547048, 0, 0.155089319, 0)
        Button2.ZIndex = 3
        Button2.Font = Enum.Font.GothamBold
        Button2.Text = "ACTIVATE"
        Button2.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button2.TextSize = 14.000

        UICorner_3.CornerRadius = UDim.new(0, 2)
        UICorner_3.Parent = Button2

        DropShadow.Name = "DropShadow"
        DropShadow.Parent = Button2
        DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow.BackgroundTransparency = 1.000
        DropShadow.BorderSizePixel = 0
        DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow.Size = UDim2.new(1, 37, 1, 37)
        DropShadow.Image = "rbxassetid://6015897843"
        DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        DropShadow.ImageTransparency = 0.600
        DropShadow.ScaleType = Enum.ScaleType.Slice
        DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

        UIStroke.Transparency = 1
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = Button2
        Twen:Create(UIStroke,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
            Transparency = 0.900
        }):Play();

        TextBox.Parent = MainFrame
        TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
        TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.BackgroundTransparency = 0.500
        TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0.5, 0, 0.300000012, 0)
        TextBox.Size = UDim2.new(0.800000012, 0, 0.115000002, 0)
        TextBox.ZIndex = 2
        TextBox.ClearTextOnFocus = false
        TextBox.Font = Enum.Font.Unknown
        TextBox.PlaceholderText = "ENTER KEY"
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 10.000
        TextBox.TextTransparency = 0.250
        TextBox.TextWrapped = true

        UICorner_4.CornerRadius = UDim.new(0, 2)
        UICorner_4.Parent = TextBox

        DropShadow_2.Name = "DropShadow"
        DropShadow_2.Parent = TextBox
        DropShadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow_2.BackgroundTransparency = 1.000
        DropShadow_2.BorderSizePixel = 0
        DropShadow_2.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow_2.Size = UDim2.new(1, 37, 1, 37)
        DropShadow_2.Image = "rbxassetid://6015897843"
        DropShadow_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
        DropShadow_2.ImageTransparency = 0.600
        DropShadow_2.ScaleType = Enum.ScaleType.Slice
        DropShadow_2.SliceCenter = Rect.new(49, 49, 450, 450)

        UIStroke_2.Transparency = 1
        UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
        UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke_2.Parent = TextBox
        Twen:Create(UIStroke_2,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
            Transparency = 0.900
        }):Play();
        Button1.Name = "Button1"
        Button1.Parent = MainFrame
        Button1.AnchorPoint = Vector2.new(0.5, 0.5)
        Button1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Button1.BackgroundTransparency = 0.500
        Button1.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Button1.BorderSizePixel = 0
        Button1.Position = UDim2.new(0.25, 0, 0.649999976, 0)
        Button1.Size = UDim2.new(0.447547048, 0, 0.155089319, 0)
        Button1.ZIndex = 3
        Button1.Font = Enum.Font.GothamBold
        Button1.Text = "GET KEY"
        Button1.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button1.TextSize = 14.000

        UICorner_5.CornerRadius = UDim.new(0, 2)
        UICorner_5.Parent = Button1

        DropShadow_3.Name = "DropShadow"
        DropShadow_3.Parent = Button1
        DropShadow_3.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow_3.BackgroundTransparency = 1.000
        DropShadow_3.BorderSizePixel = 0
        DropShadow_3.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow_3.Size = UDim2.new(1, 37, 1, 37)
        DropShadow_3.Image = "rbxassetid://6015897843"
        DropShadow_3.ImageColor3 = Color3.fromRGB(0, 0, 0)
        DropShadow_3.ImageTransparency = 0.600
        DropShadow_3.ScaleType = Enum.ScaleType.Slice
        DropShadow_3.SliceCenter = Rect.new(49, 49, 450, 450)

        UIStroke_3.Transparency = 1
        UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
        UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke_3.Parent = Button1
        Twen:Create(UIStroke_3,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
            Transparency = 0.900
        }):Play();
        MainDropShadow.Name = "MainDropShadow"
        MainDropShadow.Parent = MainFrame
        MainDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        MainDropShadow.BackgroundTransparency = 1.000
        MainDropShadow.BorderSizePixel = 0
        MainDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainDropShadow.Rotation = 0.0001
        MainDropShadow.Size = UDim2.new(1, 47, 1, 47)
        MainDropShadow.ZIndex = 0
        MainDropShadow.Image = "rbxassetid://6015897843"
        MainDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        MainDropShadow.ImageTransparency = 1
        MainDropShadow.ScaleType = Enum.ScaleType.Slice
        MainDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        Twen:Create(MainDropShadow,TweenInfo.new(2,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
            ImageTransparency = 0.600
        }):Play();
        Title.Name = "Title"
        Title.Parent = MainFrame
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1.000
        Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Title.BorderSizePixel = 0
        Title.Position = UDim2.new(0.0250000004, 0, 0.0350000001, 0)
        Title.Size = UDim2.new(0.899999976, 0, 0.075000003, 0)
        Title.Font = Enum.Font.GothamBold
        Title.Text = conf.Title;
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextScaled = true
        Title.TextSize = 14.000
        Title.TextWrapped = true
        Title.TextXAlignment = Enum.TextXAlignment.Left

        UIGradient_2.Rotation = 90
        UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.75, 0.27), NumberSequenceKeypoint.new(1.00, 1.00)}
        UIGradient_2.Parent = Title

        UICorner_6.CornerRadius = UDim.new(0, 7)
        UICorner_6.Parent = MainFrame

        local id = tostring(math.random(1,100))..tostring(math.random(1,100))..tostring(math.random(1,100))..tostring(math.random(1,100))..tostring(math.random(1,100))..tostring(math.random(1,100))..tostring(tick()):reverse();

        Button1.MouseButton1Click:Connect(function()
            local str = conf.GetKey();

            if str then
                if typeof(str) == 'string' then
                    local clip = getfenv()['toclipboard'] or getfenv()['setclipboard'] or getfenv()['print'];

                    clip(str);
                end;
            end;
        end);


        Button2.MouseButton1Click:Connect(function()
            local str = conf.Auth(TextBox.Text);

            if str then
                TextBox.Text = "*/*/*/*/*/*/*/*/*/*/*/*/*/*";

                vaid:Fire(id)
            else
                TextBox.Text = "";
            end;
        end);

        if conf.Freeze then
            while ScreenGui do task.wait();
                local ez = vaid.Event:Wait();

                if ez == id then
                    break;
                end;
            end;
        end;

        return {
            Close = function()
                Twen:Create(MainDropShadow,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    ImageTransparency = 1
                }):Play();

                BlueEffect.Destroy();


                for i,v in ipairs(cose) do
                    game:GetService('RunService'):UnbindFromRenderStep(v);
                end;

                Twen:Create(MainFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                    Size = UDim2.new(0.8,0,0.8,0)
                }):Play();

                tdelay(1,function()
                    Twen:Create(MainFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
                        Position = UDim2.new(0.5, 0, 1.5, 0),
                        Size = UDim2.new(0.8,0,0.8,0)
                    }):Play();

                    tdelay(1.2,function()

                        ScreenGui:Destroy()

                    end)
                end)
            end,
        }
    end;

    Library.Notification = function()
        local Notification = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")

        Notification.Name = "Notification"
        Notification.Parent = CoreGui
        Notification.ResetOnSpawn = false
        Notification.ZIndexBehavior = Enum.ZIndexBehavior.Global
        Notification.Name = HttpService:GenerateGUID(false)
        Notification.IgnoreGuiInset = true

        Frame.Parent = Notification
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.BackgroundTransparency = 1.000
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(0.151568726, 0, 0.5, 0)
        Frame.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
        Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY

        UIListLayout.Parent = Frame
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        UIListLayout.Padding = UDim.new(0,2);

        return {
            new = function(ctfx)
                ctfx = Config(ctfx,{
                    Title = "Notification",
                    Description = "Description",
                    Duration = 5,
                    Icon = "rbxassetid://7733993369"
                })
                local css_style = TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut);
                local Notifiy = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local icon = Instance.new("ImageLabel")
                local UICorner_2 = Instance.new("UICorner")
                local TextLabel = Instance.new("TextLabel")
                local TextLabel_2 = Instance.new("TextLabel")
                local DropShadow = Instance.new('ImageLabel')

                DropShadow.Name = "DropShadow"
                DropShadow.Parent = Notifiy
                DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
                DropShadow.BackgroundTransparency = 1.000
                DropShadow.BorderSizePixel = 0
                DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
                DropShadow.Size = UDim2.new(1, 37, 1, 37)
                DropShadow.Image = "rbxassetid://6015897843"
                DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                DropShadow.ImageTransparency = 1
                DropShadow.ScaleType = Enum.ScaleType.Slice
                DropShadow.Rotation = 0.001
                DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
                Twen:Create(DropShadow,css_style,{
                    ImageTransparency = 0.600
                }):Play()

                Notifiy.Name = "Notifiy"
                Notifiy.Parent = Frame
                Notifiy.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Notifiy.BackgroundTransparency = 1
                Notifiy.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Notifiy.BorderSizePixel = 0
                Notifiy.ClipsDescendants = true
                Notifiy.Size = UDim2.new(0,0,0,0)
                Twen:Create(Notifiy,css_style,{
                    BackgroundTransparency = 0.350,
                    Size = UDim2.new(0.2, 0, 0.2, 0)
                }):Play()

                UICorner.CornerRadius = UDim.new(0.3,0)
                UICorner.Parent = Notifiy

                icon.Name = "icon"
                icon.Parent = Notifiy
                icon.AnchorPoint = Vector2.new(0.5, 0.5)
                icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                icon.BackgroundTransparency = 1.000
                icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
                icon.BorderSizePixel = 0
                icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                icon.Size = UDim2.new(0.3, 0, 0.3, 0)
                icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
                icon.Image = Icons[ctfx.Icon] or ctfx.Icon
                icon.ImageTransparency = 1;

                Twen:Create(icon,css_style,{
                    ImageTransparency = 0.1,
                    Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
                }):Play()


                UICorner_2.CornerRadius = UDim.new(1,0)
                UICorner_2.Parent = icon

                Twen:Create(UICorner_2,css_style,{
                    CornerRadius = UDim.new(0.4, 0)
                }):Play()

                TextLabel.Parent = Notifiy
                TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.BackgroundTransparency = 1.000
                TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextLabel.BorderSizePixel = 0
                TextLabel.Position = UDim2.new(2, 0, 0.130389422, 0)
                TextLabel.Size = UDim2.new(0.800069451, 0, 0.217663303, 0)
                TextLabel.Font = Enum.Font.GothamBold
                TextLabel.Text = ctfx.Title
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextScaled = true
                TextLabel.TextSize = 14.000
                TextLabel.TextWrapped = true
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left

                TextLabel_2.Parent = Notifiy
                TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel_2.BackgroundTransparency = 1.000
                TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextLabel_2.BorderSizePixel = 0
                TextLabel_2.Position = UDim2.new(2, 0, 0.34770447, 0)
                TextLabel_2.Size = UDim2.new(0.769645274, 0, 0.502295375, 0)
                TextLabel_2.Font = Enum.Font.GothamBold
                TextLabel_2.Text = ctfx.Description
                TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel_2.TextSize = 9.000
                TextLabel_2.TextTransparency = 0.500
                TextLabel_2.TextWrapped = true
                TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

                local mkView = function()
                    Twen:Create(Notifiy,css_style,{
                        Size = UDim2.new(1, 0, 0.2, 0)
                    }):Play()

                    Twen:Create(UICorner,css_style,{
                        CornerRadius = UDim.new(0, 4)
                    }):Play()

                    Twen:Create(icon,css_style,{
                        Position = UDim2.new(0.100000001, 0, 0.5, 0)
                    }):Play()

                    Twen:Create(TextLabel,css_style,{
                        Position = UDim2.new(0.199930489, 0, 0.130389422, 0)
                    }):Play()

                    Twen:Create(TextLabel_2,css_style,{
                        Position = UDim2.new(0.199930489, 0, 0.34770447, 0)
                    }):Play()
                end;


                local mkLoad = function()
                    Twen:Create(Notifiy,css_style,{
                        Size = UDim2.new(0.2, 0, 0.2, 0)
                    }):Play()

                    Twen:Create(UICorner,css_style,{
                        CornerRadius = UDim.new(0.4,0)
                    }):Play()

                    Twen:Create(icon,css_style,{
                        Position = UDim2.new(0.5, 0, 0.5, 0)
                    }):Play()

                    Twen:Create(TextLabel,css_style,{
                        Position = UDim2.new(1, 0, 0.130389422, 0)
                    }):Play()

                    Twen:Create(TextLabel_2,css_style,{
                        Position = UDim2.new(1, 0, 0.34770447, 0)
                    }):Play()
                end;

                mkLoad();

                tspawn(function()
                    task.wait(0.5)
                    mkView();



                    tdelay(1 + ctfx.Duration,function()
                        mkLoad();

                        task.wait(0.65)

                        Twen:Create(Notifiy,css_style,{
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0,0,0,0)
                        }):Play()

                        Twen:Create(icon,css_style,{
                            ImageTransparency = 1
                        }):Play()

                        Twen:Create(DropShadow,css_style,{
                            ImageTransparency = 1
                        }):Play()

                        tdelay(0.5,Notifiy.Destroy,Notifiy)
                    end)
                end)
            end,
        }
    end;

    print('[Flow]: Fetch Nothing Library')

    return table.freeze(Library);
end

return ClosureEvn();
