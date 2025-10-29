local Library = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera

local function MakeDraggable(frame, dragFrame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Library:CreateWindow(title)
    local Window = {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title or "UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local OutlineStroke = Instance.new("UIStroke")
    OutlineStroke.Color = Color3.fromRGB(60, 60, 70)
    OutlineStroke.Thickness = 1
    OutlineStroke.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 8)
    TopBarFix.Position = UDim2.new(0, 0, 1, -8)
    TopBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.TextColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -45)
    ContentFrame.Position = UDim2.new(0, 10, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ContentFrame
    
    MakeDraggable(MainFrame, TopBar)
    
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    function Window:CreateSection(name)
        local Section = {}
        
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = name
        SectionFrame.Size = UDim2.new(1, -10, 0, 35)
        SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
        SectionFrame.BorderSizePixel = 0
        SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        SectionFrame.Parent = ContentFrame
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 6)
        SectionCorner.Parent = SectionFrame
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Size = UDim2.new(1, -20, 0, 30)
        SectionTitle.Position = UDim2.new(0, 10, 0, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = name
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 14
        SectionTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = SectionFrame
        
        local SectionContent = Instance.new("Frame")
        SectionContent.Name = "SectionContent"
        SectionContent.Size = UDim2.new(1, -20, 0, 0)
        SectionContent.Position = UDim2.new(0, 10, 0, 35)
        SectionContent.BackgroundTransparency = 1
        SectionContent.AutomaticSize = Enum.AutomaticSize.Y
        SectionContent.Parent = SectionFrame
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = SectionContent
        
        local Padding = Instance.new("UIPadding")
        Padding.PaddingBottom = UDim.new(0, 10)
        Padding.Parent = SectionContent
        
        function Section:AddToggle(name, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = name
            Toggle.Size = UDim2.new(1, 0, 0, 25)
            Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            Toggle.BorderSizePixel = 0
            Toggle.Parent = SectionContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = Toggle
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 12
            ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 18)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -9)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = Toggle
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(1, 0)
            ButtonCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 14, 0, 14)
            ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -7)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            local enabled = false
            ToggleButton.MouseButton1Click:Connect(function()
                enabled = not enabled
                callback(enabled)
                
                if enabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 120, 255)}):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(160, 160, 170)}):Play()
                end
            end)
        end
        
        function Section:AddSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = name
            Slider.Size = UDim2.new(1, 0, 0, 40)
            Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            Slider.BorderSizePixel = 0
            Slider.Parent = SectionContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 4)
            SliderCorner.Parent = Slider
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 15)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 12
            SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0.3, -10, 0, 15)
            SliderValue.Position = UDim2.new(0.7, 0, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 12
            SliderValue.TextColor3 = Color3.fromRGB(70, 120, 255)
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = Slider
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 1, -12)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Slider
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local dragging = false
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end
        
        function Section:AddColorPicker(name, default, callback)
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Name = name
            ColorPicker.Size = UDim2.new(1, 0, 0, 25)
            ColorPicker.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Parent = SectionContent
            
            local CPCorner = Instance.new("UICorner")
            CPCorner.CornerRadius = UDim.new(0, 4)
            CPCorner.Parent = ColorPicker
            
            local CPLabel = Instance.new("TextLabel")
            CPLabel.Size = UDim2.new(1, -50, 1, 0)
            CPLabel.Position = UDim2.new(0, 10, 0, 0)
            CPLabel.BackgroundTransparency = 1
            CPLabel.Text = name
            CPLabel.Font = Enum.Font.Gotham
            CPLabel.TextSize = 12
            CPLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            CPLabel.TextXAlignment = Enum.TextXAlignment.Left
            CPLabel.Parent = ColorPicker
            
            local ColorDisplay = Instance.new("TextButton")
            ColorDisplay.Size = UDim2.new(0, 35, 0, 18)
            ColorDisplay.Position = UDim2.new(1, -40, 0.5, -9)
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.Text = ""
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorPicker
            
            local DisplayCorner = Instance.new("UICorner")
            DisplayCorner.CornerRadius = UDim.new(0, 4)
            DisplayCorner.Parent = ColorDisplay
            
            ColorDisplay.MouseButton1Click:Connect(function()
                local r = math.random(0, 255)
                local g = math.random(0, 255)
                local b = math.random(0, 255)
                local newColor = Color3.fromRGB(r, g, b)
                ColorDisplay.BackgroundColor3 = newColor
                callback(newColor)
            end)
        end
        
        function Section:AddDropdown(name, options, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = name
            Dropdown.Size = UDim2.new(1, 0, 0, 25)
            Dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            Dropdown.BorderSizePixel = 0
            Dropdown.Parent = SectionContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 4)
            DropdownCorner.Parent = Dropdown
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = name
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextSize = 12
            DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = Dropdown
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0.5, -15, 0, 20)
            DropdownButton.Position = UDim2.new(0.5, 5, 0.5, -10)
            DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            DropdownButton.Text = options[1]
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 11
            DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 210)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Parent = Dropdown
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = DropdownButton
            
            local currentIndex = 1
            DropdownButton.MouseButton1Click:Connect(function()
                currentIndex = currentIndex % #options + 1
                DropdownButton.Text = options[currentIndex]
                callback(options[currentIndex])
            end)
        end
        
        return Section
    end
    
    return Window
end

return Library
