local CORRECT_KEY = "Lunx-9ıkjk2-mjudflk1a"

local Themes = {
    ["Scout"] = {
        Background      = Color3.fromRGB(15, 20, 30),
        Surface         = Color3.fromRGB(22, 30, 45),
        SurfaceAlt      = Color3.fromRGB(30, 40, 60),
        Accent          = Color3.fromRGB(80, 160, 255),
        AccentSecondary = Color3.fromRGB(220, 240, 255),
        Text            = Color3.fromRGB(240, 245, 250),
        TextMuted       = Color3.fromRGB(150, 165, 185),
        Border          = Color3.fromRGB(45, 65, 95),
        Error           = Color3.fromRGB(220, 80, 80),
        Warning         = Color3.fromRGB(240, 180, 60),
        GradientStart   = Color3.fromRGB(180, 220, 255),
        GradientEnd     = Color3.fromRGB(40, 100, 200),
        MascotImage     = "rbxassetid://125067064175903",
    },
    ["Mimi Typh"] = {
        Background      = Color3.fromRGB(24, 20, 18),
        Surface         = Color3.fromRGB(36, 30, 26),
        SurfaceAlt      = Color3.fromRGB(50, 42, 36),
        Accent          = Color3.fromRGB(190, 130, 95),
        AccentSecondary = Color3.fromRGB(245, 235, 220),
        Text            = Color3.fromRGB(250, 245, 240),
        TextMuted       = Color3.fromRGB(175, 160, 150),
        Border          = Color3.fromRGB(70, 55, 45),
        Error           = Color3.fromRGB(210, 85, 85),
        Warning         = Color3.fromRGB(220, 160, 70),
        GradientStart   = Color3.fromRGB(245, 235, 220),
        GradientEnd     = Color3.fromRGB(140, 85, 55),
        MascotImage     = "https://raw.githubusercontent.com/LUNXCHEAT/00000000000000000000000000000000000000000000000000/refs/heads/main/mimityph.png",
    },
    ["CSG"] = {
        Background      = Color3.fromRGB(15, 15, 15),
        Surface         = Color3.fromRGB(24, 24, 24),
        SurfaceAlt      = Color3.fromRGB(35, 35, 35),
        Accent          = Color3.fromRGB(220, 40, 40),
        AccentSecondary = Color3.fromRGB(245, 245, 245),
        Text            = Color3.fromRGB(255, 255, 255),
        TextMuted       = Color3.fromRGB(160, 160, 160),
        Border          = Color3.fromRGB(55, 55, 55),
        Error           = Color3.fromRGB(255, 50, 50),
        Warning         = Color3.fromRGB(240, 170, 40),
        GradientStart   = Color3.fromRGB(255, 255, 255),
        GradientEnd     = Color3.fromRGB(180, 20, 20),
        MascotImage     = "https://raw.githubusercontent.com/LUNXCHEAT/00000000000000000000000000000000000000000000000000/refs/heads/main/CSG.png",
    },
    ["PovHuso"] = {
        Background      = Color3.fromRGB(15, 15, 15),
        Surface         = Color3.fromRGB(24, 24, 24),
        SurfaceAlt      = Color3.fromRGB(35, 35, 35),
        Accent          = Color3.fromRGB(220, 40, 40),
        AccentSecondary = Color3.fromRGB(245, 245, 245),
        Text            = Color3.fromRGB(255, 255, 255),
        TextMuted       = Color3.fromRGB(160, 160, 160),
        Border          = Color3.fromRGB(55, 55, 55),
        Error           = Color3.fromRGB(255, 50, 50),
        Warning         = Color3.fromRGB(240, 170, 40),
        GradientStart   = Color3.fromRGB(255, 255, 255),
        GradientEnd     = Color3.fromRGB(180, 20, 20),
        MascotImage     = "https://raw.githubusercontent.com/LUNXCHEAT/00000000000000000000000000000000000000000000000000/refs/heads/main/Kuzen.png",
    },
}

-- Eksik theme key'lerini otomatik tamamla (nil crash koruması)
for _, t in pairs(Themes) do
    if not t.AccentAlt then t.AccentAlt = t.Accent:Lerp(Color3.new(1, 1, 1), 0.35) end
    if not t.Success then t.Success = Color3.fromRGB(90, 220, 140) end
    if not t.AccentSecondary then t.AccentSecondary = Color3.new(1, 1, 1) end
end

local ActiveThemeName = "Mimi Typh"
local UI_TOGGLE_KEY = Enum.KeyCode.K

local CoreGui           = game:GetService("CoreGui")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

local LocalPlayer = game.Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

local function GetCamera()
    return workspace.CurrentCamera
end

-- Çözünürlük bazlı ölçek (mascot ve UI için)
local function GetViewportScale()
    local cam = GetCamera()
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    if vp.X <= 0 or vp.Y <= 0 then vp = Vector2.new(1920, 1080) end
    return math.clamp(math.min(vp.X / 1920, vp.Y / 1080), 0.5, 2)
end

local function GetMascotSize()
    return math.floor(170 * GetViewportScale())
end

-- Temizlik
for _, name in ipairs({"LunxAdvanced", "LunxAdvancedTooltips", "LunxKeySystem", "LunxMascot", "LunxNotifications", "LunxLoading"}) do
    local old = CoreGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local function GetTheme()
    return Themes[ActiveThemeName] or Themes["Mimi Typh"]
end

local function Tween(obj, props, duration, style, direction)
    if not obj or not obj.Parent then return nil end
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local ok, tw = pcall(function()
        local t = TweenService:Create(obj, info, props)
        t:Play()
        return t
    end)
    return ok and tw or nil
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    for _, child in ipairs(children or {}) do
        pcall(function() child.Parent = inst end)
    end
    if props and props.Parent then
        pcall(function() inst.Parent = props.Parent end)
    end
    return inst
end

local KeySystemPassed = false

local function RunKeySystem(onSuccess)
    local theme = GetTheme()

    local keyGui = Create("ScreenGui", {
        Name = "LunxKeySystem",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })

    local overlay = Create("Frame", {
        Name = "Overlay",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Parent = keyGui,
    })

    local card = Create("Frame", {
        Name = "Card",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.55),
        Size = UDim2.new(0, 360, 0, 240),
        Parent = overlay,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = card })
    Create("UIStroke", { Color = theme.Accent, Thickness = 1.5, Transparency = 0.4, Parent = card })

    local cardGlow = Create("Frame", {
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        ZIndex = -1,
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 20), Parent = cardGlow })

    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "🔐 Authentication",
        TextColor3 = theme.Text,
        TextSize = 18,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 20),
        Parent = card,
    })

    local subtitle = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "Enter your Lunx access key",
        TextColor3 = theme.TextMuted,
        TextSize = 12,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 52),
        Parent = card,
    })

    local inputOuter = Create("Frame", {
        BackgroundColor3 = theme.SurfaceAlt,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 92),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0.85, 0, 0, 42),
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = inputOuter })
    local inputStroke = Create("UIStroke", { Color = theme.Border, Thickness = 1.5, Parent = inputOuter })

    local keyInput = Create("TextBox", {
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        Font = Enum.Font.GothamBold,
        PlaceholderText = "Lunx-XXXX-XXXXX",
        PlaceholderColor3 = theme.TextMuted,
        Text = "",
        TextColor3 = theme.Text,
        TextSize = 13,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Parent = inputOuter,
    })

    local errorLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "",
        TextColor3 = theme.Error,
        TextSize = 11,
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 10, 0, 144),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    local submitBtn = Create("TextButton", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "🔓 Verify Key",
        TextColor3 = Color3.fromRGB(20, 20, 20),
        TextSize = 13,
        Size = UDim2.new(0.85, 0, 0, 42),
        Position = UDim2.new(0.5, 0, 1, -62),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = submitBtn })

    Tween(overlay, { BackgroundTransparency = 0.7 }, 0.4, Enum.EasingStyle.Sine)
    card.Position = UDim2.fromScale(0.5, 0.7)
    card.BackgroundTransparency = 1
    Tween(card, { Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0 }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local function Shake()
        local base = UDim2.fromScale(0.5, 0.5)
        for i = 1, 8 do
            local offset = (i % 2 == 0) and 10 or -10
            Tween(card, { Position = base + UDim2.new(0, offset, 0, 0) }, 0.04, Enum.EasingStyle.Sine)
            task.wait(0.04)
        end
        Tween(card, { Position = base }, 0.2, Enum.EasingStyle.Quint)
    end

    local verifying = false
    local function Verify()
        if verifying then return end
        verifying = true
        local entered = keyInput.Text

        if entered == CORRECT_KEY then
            errorLabel.Text = ""
            Tween(submitBtn, { BackgroundColor3 = theme.Success }, 0.2, Enum.EasingStyle.Sine)
            submitBtn.Text = "✅ Access Granted"
            task.wait(0.5)
            Tween(card, { Position = UDim2.fromScale(0.5, 0.3), BackgroundTransparency = 1 }, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(overlay, { BackgroundTransparency = 1 }, 0.5, Enum.EasingStyle.Sine)
            task.wait(0.5)
            keyGui:Destroy()
            KeySystemPassed = true
            onSuccess()
        else
            errorLabel.Text = "❌ Invalid key. Please try again."
            Shake()
            Tween(inputStroke, { Color = theme.Error, Thickness = 2 }, 0.1, Enum.EasingStyle.Sine)
            task.wait(0.4)
            Tween(inputStroke, { Color = theme.Border, Thickness = 1.5 }, 0.3, Enum.EasingStyle.Sine)
            keyInput.Text = ""
            verifying = false
        end
    end

    submitBtn.MouseButton1Click:Connect(Verify)
    keyInput.FocusLost:Connect(function(enter)
        if enter then Verify() end
    end)

    submitBtn.MouseEnter:Connect(function()
        Tween(submitBtn, { BackgroundColor3 = theme.AccentAlt }, 0.15, Enum.EasingStyle.Sine)
    end)
    submitBtn.MouseLeave:Connect(function()
        Tween(submitBtn, { BackgroundColor3 = theme.Accent }, 0.15, Enum.EasingStyle.Sine)
    end)
    keyInput.Focused:Connect(function()
        Tween(inputStroke, { Color = theme.Accent, Thickness = 2 }, 0.15, Enum.EasingStyle.Sine)
    end)
    keyInput.FocusLost:Connect(function()
        Tween(inputStroke, { Color = theme.Border, Thickness = 1.5 }, 0.15, Enum.EasingStyle.Sine)
    end)
end

local library = {
    Flags = {},
    _flagSetters = {},
    _themeTargets = {},
    _dropdownTracker = {},
    ChangingKeybind = false,
    ScreenGui = nil,
    MainFrame = nil,
    MascotGui = nil,
    Mascot = nil,
    Visible = false,
    ActiveModule = "Hub Alpha",
    Notifications = {},
}

local TabSelected = nil
local EditOpened = false
local ColorElements = {}

task.spawn(function()
    while true do
        if EditOpened then
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            for frame, v in pairs(ColorElements) do
                if v.Enabled and frame and frame.Parent then
                    pcall(function()
                        if frame:IsA("Frame") then
                            frame.BackgroundColor3 = color
                        elseif frame:IsA("ImageLabel") or frame:IsA("ImageButton") then
                            frame.ImageColor3 = color
                        elseif frame:IsA("UIStroke") then
                            frame.Color = color
                        end
                    end)
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

function library:GetXY(GuiObject)
    local maxX, maxY = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    if maxX == 0 or maxY == 0 then return 0, 0 end
    local px = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, maxX)
    local py = math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, maxY)
    return px / maxX, py / maxY
end

function library:RegisterThemeTarget(instance, key, prop)
    if not instance then return end
    table.insert(library._themeTargets, { Instance = instance, Key = key, Prop = prop })
end

function library:ApplyTheme(themeName)
    if themeName and Themes[themeName] then
        ActiveThemeName = themeName
    end
    local t = GetTheme()

    for i = #library._themeTargets, 1, -1 do
        local entry = library._themeTargets[i]
        local inst = entry.Instance
        if inst and inst.Parent then
            local color = t[entry.Key]
            pcall(function()
                if entry.Key == "MascotImage" then
                    if inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
                        inst.Image = color
                    end
                elseif inst:IsA("UIGradient") then
                    -- Gradient'leri tema ile güncelle
                    inst.Color = ColorSequence.new(t.GradientStart, t.GradientEnd)
                elseif entry.Prop then
                    inst[entry.Prop] = color
                elseif entry.Key == "Text" or entry.Key == "TextMuted" then
                    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                        inst.TextColor3 = color
                    end
                elseif entry.Key == "Border" then
                    if inst:IsA("UIStroke") then
                        inst.Color = color
                    else
                        inst.BackgroundColor3 = color
                    end
                else
                    if color then
                        if inst:IsA("UIStroke") then
                            inst.Color = color
                        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
                            inst.ImageColor3 = color
                        elseif inst:IsA("Frame") or inst:IsA("ScrollingFrame") then
                            inst.BackgroundColor3 = color
                        elseif inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                            inst.BackgroundColor3 = color
                        end
                    end
                end
            end)
        else
            table.remove(library._themeTargets, i)
        end
    end

    if library.Mascot and library.Mascot.Parent then
        pcall(function()
            library.Mascot.Image = t.MascotImage
        end)
    end

    for _, tr in pairs(library._dropdownTracker) do
        if tr.updateTheme then pcall(tr.updateTheme) end
    end

    if not EditOpened then
        for frame, v in pairs(ColorElements) do
            if v.Enabled and v.Type ~= "Toggle" and frame and frame.Parent then
                pcall(function()
                    if frame:IsA("Frame") then
                        Tween(frame, { BackgroundColor3 = t.Accent }, 0.3, Enum.EasingStyle.Sine)
                    elseif frame:IsA("UIStroke") then
                        Tween(frame, { Color = t.Accent }, 0.3, Enum.EasingStyle.Sine)
                    end
                end)
            end
        end
    end
end

function library:SetVisible(state)
    if not library.MainFrame or not library.ScreenGui then return end
    library.Visible = state
    local ms = GetMascotSize()

    if state then
        library.ScreenGui.Enabled = true
        library.MainFrame.Visible = true
        library.MainFrame.Size = UDim2.new(0, 500, 0, 320)
        library.MainFrame.BackgroundTransparency = 1
        
        Tween(library.MainFrame, {
            Size = UDim2.new(0, 500, 0, 380),
            BackgroundTransparency = 0,
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        if library.MascotGui and library.Mascot then
            library.MascotGui.Enabled = true
            library.Mascot.ImageTransparency = 1
            library.Mascot.Size = UDim2.new(0, math.floor(ms * 0.6), 0, math.floor(ms * 0.6))
            Tween(library.Mascot, { 
                ImageTransparency = 0, 
                Size = UDim2.new(0, ms, 0, ms) 
            }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    else
        if library.Mascot then
            Tween(library.Mascot, { 
                ImageTransparency = 1, 
                Size = UDim2.new(0, math.floor(ms * 0.6), 0, math.floor(ms * 0.6)) 
            }, 0.3, Enum.EasingStyle.Sine)
            task.delay(0.3, function()
                if not library.Visible and library.MascotGui then
                    library.MascotGui.Enabled = false
                end
            end)
        end
        
        Tween(library.MainFrame, {
            Size = UDim2.new(0, 500, 0, 320),
            BackgroundTransparency = 1,
        }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.3, function()
            if not library.Visible and library.MainFrame then
                library.MainFrame.Visible = false
                library.ScreenGui.Enabled = false
            end
        end)
    end
end

function library:ToggleUI()
    library:SetVisible(not library.Visible)
end

-- Notification sistemi
local notifGui = Create("ScreenGui", {
    Name = "LunxNotifications",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui,
})

local notifContainer = Create("Frame", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -20, 0, 20),
    Size = UDim2.new(0, 300, 1, -40),
    Parent = notifGui,
})
Create("UIListLayout", { 
    SortOrder = Enum.SortOrder.LayoutOrder, 
    Padding = UDim.new(0, 8),
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Parent = notifContainer 
})

function library:Notify(title, message, duration, color)
    duration = duration or 3
    local t = GetTheme()
    if typeof(color) ~= "Color3" then color = t.Accent end
    
    local notif = Create("Frame", {
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = notifContainer,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = notif })
    Create("UIStroke", { Color = color, Thickness = 1.5, Transparency = 0.3, Parent = notif })
    
    local bar = Create("Frame", {
        BackgroundColor3 = color,
        Size = UDim2.new(0, 4, 1, 0),
        Parent = notif,
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "● " .. title,
        TextColor3 = t.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 14, 0, 10),
        Size = UDim2.new(1, -20, 0, 16),
        Parent = notif,
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = t.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Position = UDim2.new(0, 14, 0, 30),
        Size = UDim2.new(1, -20, 0, 24),
        Parent = notif,
    })
    
    Tween(notif, { BackgroundTransparency = 0 }, 0.3, Enum.EasingStyle.Sine)
    Tween(bar, { Size = UDim2.new(0, 4, 0, 0) }, duration, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Tween(notif, { BackgroundTransparency = 1, Size = UDim2.new(0, 250, 0, 60) }, 0.3, Enum.EasingStyle.Sine)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Loading overlay
local loadingGui = Create("ScreenGui", {
    Name = "LunxLoading",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui,
})

function library:ShowLoading(text)
    local t = GetTheme()
    local overlay = Create("Frame", {
        Name = "LoadingOverlay",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        Size = UDim2.fromScale(1, 1),
        Parent = loadingGui,
    })
    
    local card = Create("Frame", {
        BackgroundColor3 = t.Surface,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 200, 0, 80),
        Parent = overlay,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = card })
    Create("UIStroke", { Color = t.Accent, Thickness = 1, Parent = card })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = text or "Loading...",
        TextColor3 = t.Text,
        TextSize = 13,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 15),
        Parent = card,
    })
    
    local spinner = Create("Frame", {
        BackgroundColor3 = t.Accent,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.7),
        Size = UDim2.new(0, 24, 0, 24),
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = spinner })
    
    task.spawn(function()
        while spinner and spinner.Parent do
            Tween(spinner, { Rotation = spinner.Rotation + 360 }, 0.8, Enum.EasingStyle.Linear)
            task.wait(0.8)
        end
    end)
    
    return function()
        Tween(overlay, { BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Sine)
        task.wait(0.3)
        overlay:Destroy()
    end
end

local ModuleContainers = {}

function library:SwitchModule(moduleName)
    library.ActiveModule = moduleName
    for name, containers in pairs(ModuleContainers) do
        local show = (name == moduleName)
        for _, c in ipairs(containers) do
            if c and c.Parent then
                if show then
                    c.Visible = true
                    c.BackgroundTransparency = 1
                    Tween(c, { BackgroundTransparency = 0 }, 0.3, Enum.EasingStyle.Sine)
                else
                    Tween(c, { BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Sine)
                    task.delay(0.2, function()
                        if library.ActiveModule ~= name and c.Parent then
                            c.Visible = false
                        end
                    end)
                end
            end
        end
    end
    library:Notify("Module Switched", "Now using: " .. moduleName, 2, GetTheme().Success)
end

function library:Window(Info)
    Info = Info or {}
    Info.Text = Info.Text or "Lunx Advanced"

    local theme = GetTheme()
    local window = {}
    local TabRegistry = {} -- Tab durumlarını tek elden yönet

    local LunxGui = Create("ScreenGui", {
        Name = "LunxAdvanced",
        ResetOnSpawn = false,
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
    library.ScreenGui = LunxGui

    local tooltipGui = Create("ScreenGui", {
        Name = "LunxAdvancedTooltips",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })

    local function AddTooltip(element, text)
        local tip = Create("Frame", {
            BackgroundColor3 = theme.Surface,
            Visible = false,
            Size = UDim2.new(0, 100, 0, 26),
            ZIndex = 100,
            Parent = tooltipGui,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tip })
        Create("UIStroke", { Color = theme.Accent, Thickness = 1, Transparency = 0.4, Parent = tip })
        local tipText = Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = text,
            TextColor3 = theme.Text,
            TextSize = 11,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            Parent = tip,
        })
        task.defer(function()
            if tipText and tipText.Parent then
                local bounds = tipText.TextBounds
                tip.Size = UDim2.new(0, bounds.X + 18, 0, 26)
            end
        end)

        local hovered = false
        element.MouseEnter:Connect(function()
            hovered = true
            task.delay(0.5, function()
                if hovered and tip and tip.Parent then
                    tip.Visible = true
                    tip.BackgroundTransparency = 1
                    Tween(tip, { BackgroundTransparency = 0 }, 0.15, Enum.EasingStyle.Sine)
                end
            end)
        end)
        element.MouseLeave:Connect(function()
            hovered = false
            if tip and tip.Parent then tip.Visible = false end
        end)
        element.MouseMoved:Connect(function()
            if not tip or not tip.Parent then return end
            local cam = GetCamera()
            local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
            local pos = UserInputService:GetMouseLocation()
            local tipW = tip.AbsoluteSize.X
            local tipH = tip.AbsoluteSize.Y
            local x = math.clamp(pos.X + 10, 4, math.max(4, vp.X - tipW - 4))
            local y = math.clamp(pos.Y + 15, 4, math.max(4, vp.Y - tipH - 4))
            tip.Position = UDim2.new(x / vp.X, 0, y / vp.Y, 0)
        end)
    end

    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.3, 0, 0.25, 0),
        Size = UDim2.new(0, 500, 0, 380),
        Visible = false,
        Parent = LunxGui,
    })
    library.MainFrame = main
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = main })
    local mainStroke = Create("UIStroke", { Color = theme.Accent, Thickness = 1.5, Transparency = 0.5, Parent = main })
    library:RegisterThemeTarget(main, "Background")
    library:RegisterThemeTarget(mainStroke, "Accent")

    -- MASCOT (çözünürlüğe otomatik uyum)
    local mascotGui = Create("ScreenGui", {
        Name = "LunxMascot",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 10,
        Parent = CoreGui,
    })
    library.MascotGui = mascotGui

    local mascotSize = GetMascotSize()
    
    local function getGithubImage(url)
        if type(url) == "string" and url:match("^https?://") then
            local success, res = pcall(function()
                return game:HttpGet(url)
            end)
            if success and res and writefile and getcustomasset then
                local fileName = "lunx_temp_mascot_" .. tick() .. ".png"
                writefile(fileName, res)
                local assetPath = getcustomasset(fileName)
                return assetPath
            end
        end
        return url
    end

    local mascot = Create("ImageLabel", {
        Name = "Mascot",
        BackgroundTransparency = 1,
        Image = getGithubImage(theme.MascotImage),
        ScaleType = Enum.ScaleType.Fit,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10), -- Tam sağ aşağıda (kenardan 10 piksel içeride)
        Size = UDim2.new(0, mascotSize, 0, mascotSize),
        ZIndex = 10,
        ImageTransparency = 1,
        Parent = mascotGui,
    })
    
    local ratio = Instance.new("UIAspectRatioConstraint")
    ratio.AspectRatio = 1
    ratio.Parent = mascot

    -- Her seferinde boyut değişimlerini otomatik kontrol edip güncelleyen döngü
    task.spawn(function()
        while mascot and mascot.Parent do
            local newSize = GetMascotSize()
            if mascot.Size ~= UDim2.new(0, newSize, 0, newSize) then
                mascot.Size = UDim2.new(0, newSize, 0, newSize)
            end
            task.wait(0.5) -- Her yarım saniyede bir boyutu kontrol eder
        end
    end)

    library.Mascot = mascot
    library:RegisterThemeTarget(mascot, "MascotImage")

    -- Çözünürlük değişince mascot boyutunu canlı güncelle
    local cam0 = GetCamera()
    if cam0 then
        cam0:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if library.Mascot and library.Mascot.Parent and library.Visible then
                local s = GetMascotSize()
                library.Mascot.Size = UDim2.new(0, s, 0, s)
            end
        end)
    end

    -- Topbar
    local topbar = Create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 5,
        Parent = main,
    })
    library:RegisterThemeTarget(topbar, "Surface")
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = topbar })
    
    local topGradient = Create("UIGradient", {
        Color = ColorSequence.new(theme.GradientStart, theme.GradientEnd),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = topbar,
    })
    library:RegisterThemeTarget(topGradient, "GradientStart")

    -- Drag logic
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then updateDrag(input) end
    end)

    local titleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "",
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 220, 1, 0),
        Parent = topbar,
    })
    library:RegisterThemeTarget(titleLabel, "Text")

    task.spawn(function()
        local titleText = Info.Text
        while main and main.Parent do
            for i = 1, #titleText do
                if not main or not main.Parent then break end
                titleLabel.Text = titleText:sub(1, i) .. "▌"
                task.wait(0.07)
            end
            for t = 1, 4 do
                if not main or not main.Parent then break end
                titleLabel.Text = titleText .. (t % 2 == 1 and "▌" or " ")
                task.wait(0.4)
            end
            for i = #titleText, 0, -1 do
                if not main or not main.Parent then break end
                titleLabel.Text = titleText:sub(1, i) .. "▌"
                task.wait(0.04)
            end
            for t = 1, 4 do
                if not main or not main.Parent then break end
                titleLabel.Text = (t % 2 == 1 and "▌" or " ")
                task.wait(0.4)
            end
        end
    end)

    local function makeControl(name, text, pos, isImage, imageId)
        if isImage then
            local btn = Create("ImageButton", {
                Name = name,
                Image = imageId,
                ImageColor3 = theme.Text,
                BackgroundTransparency = 1,
                Position = pos,
                Size = UDim2.new(0, 20, 0, 20),
                ZIndex = 6,
                Parent = topbar,
            })
            btn.MouseEnter:Connect(function() Tween(btn, { ImageColor3 = theme.Warning }, 0.15, Enum.EasingStyle.Sine) end)
            btn.MouseLeave:Connect(function() Tween(btn, { ImageColor3 = theme.Text }, 0.15, Enum.EasingStyle.Sine) end)
            return btn
        else
            local btn = Create("TextButton", {
                Name = name,
                Text = text,
                Font = Enum.Font.GothamBold,
                TextSize = 22,
                TextColor3 = theme.Text,
                BackgroundTransparency = 1,
                Position = pos,
                Size = UDim2.new(0, 28, 0, 28),
                ZIndex = 6,
                Parent = topbar,
            })
            btn.MouseEnter:Connect(function() Tween(btn, { TextColor3 = theme.Error }, 0.15, Enum.EasingStyle.Sine) end)
            btn.MouseLeave:Connect(function() Tween(btn, { TextColor3 = theme.Text }, 0.15, Enum.EasingStyle.Sine) end)
            return btn
        end
    end

    local closeBtn = makeControl("Close", "×", UDim2.new(1, -34, 0.5, -14), false)
    closeBtn.MouseButton1Click:Connect(function() library:SetVisible(false) end)

    local minimizeBtn = makeControl("Minimize", "", UDim2.new(1, -66, 0.5, -10), true, "rbxassetid://10664064072")
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(main, { Size = minimized and UDim2.new(0, 500, 0, 40) or UDim2.new(0, 500, 0, 380) }, 0.35, Enum.EasingStyle.Quint)
        for _, v in pairs(main:GetChildren()) do
            if v.Name == "TabContainer" or v.Name == "LeftContainer" or v.Name == "RightContainer" then
                v.Visible = not minimized
            end
        end
        if library.MascotGui then library.MascotGui.Enabled = not minimized and library.Visible end
    end)

    local editBtn = Create("TextButton", {
        Name = "EditButton",
        Text = "🎨",
        BackgroundColor3 = theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(1, -98, 0.5, -10),
        Size = UDim2.new(0, 24, 0, 24),
        ZIndex = 6,
        Parent = topbar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = editBtn })
    library:RegisterThemeTarget(editBtn, "Accent")
    
    local editGradient = Create("UIGradient", {
        Enabled = false,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255)),
        }),
        Parent = editBtn,
    })

    task.spawn(function()
        while editBtn and editBtn.Parent do
            if editGradient and editGradient.Enabled then
                local loop = tick() % 2 / 2
                local colors = {}
                for i = 1, 8 do
                    local h = loop - ((i - 1) / 7)
                    if h < 0 then h += 1 end
                    table.insert(colors, ColorSequenceKeypoint.new((i - 1) / 7, Color3.fromHSV(h, 1, 1)))
                end
                editGradient.Color = ColorSequence.new(colors)
            end
            RunService.Heartbeat:Wait()
        end
    end)

    editBtn.MouseButton1Click:Connect(function()
        EditOpened = not EditOpened
        editGradient.Enabled = EditOpened
        local t = GetTheme()
        if not EditOpened then
            for frame, v in pairs(ColorElements) do
                if v.Enabled and frame and frame.Parent then
                    if frame:IsA("Frame") then
                        Tween(frame, { BackgroundColor3 = t.Accent }, 0.2, Enum.EasingStyle.Sine)
                    elseif frame:IsA("UIStroke") then
                        Tween(frame, { Color = t.Accent }, 0.2, Enum.EasingStyle.Sine)
                    end
                end
            end
            library:Notify("Edit Mode", "Disabled - Theme restored", 2, t.Accent)
        else
            for _, v in pairs(ColorElements) do
                if v.Type ~= "Toggle" then v.Enabled = true end
            end
            library:Notify("Edit Mode", "Enabled - Rainbow cycling", 2, t.Warning)
        end
    end)

    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = theme.Surface,
        ClipsDescendants = true, -- Köşelerden taşmayı engelle
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 130, 0, 340),
        Parent = main,
    })
    library:RegisterThemeTarget(tabContainer, "Surface")
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = tabContainer })

    local scrollTabs = Create("ScrollingFrame", {
        Name = "ScrollingContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = tabContainer,
    })
    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = scrollTabs })
    Create("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = scrollTabs })

    function window:Tab(Info)
        Info = Info or {}
        Info.Text = Info.Text or "Tab"
        Info.Icon = Info.Icon or "◆"
        local tab = {}
        local t = GetTheme()

        local tabBtn = Create("Frame", {
            Name = "TabButton",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            Parent = scrollTabs,
        })

        local tabFrame = Create("Frame", {
            Name = "TabFrame",
            BackgroundColor3 = t.SurfaceAlt,
            BackgroundTransparency = 0.95,
            Size = UDim2.new(1, 0, 0, 34),
            Parent = tabBtn,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = tabFrame })
        local tabStroke = Create("UIStroke", { Color = t.Border, Transparency = 0.7, Thickness = 1, Parent = tabFrame })

        local activeBar = Create("Frame", {
            Name = "ActiveBar", -- İsim verildi (registry lookup için)
            BackgroundColor3 = t.Accent,
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Parent = tabFrame,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = activeBar })
        library:RegisterThemeTarget(activeBar, "Accent")

        local tabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = Info.Icon .. "  " .. Info.Text,
            TextColor3 = t.TextMuted,
            TextSize = 11,
            Size = UDim2.new(1, -6, 1, 0),
            Position = UDim2.new(0, 6, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabFrame,
        })

        local tabClick = Create("TextButton", {
            BackgroundTransparency = 1,
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 2,
            Parent = tabFrame,
        })

        -- Registry'ye kaydet
        local registryEntry = { Frame = tabFrame, Stroke = tabStroke, Label = tabLabel, Bar = activeBar }
        table.insert(TabRegistry, registryEntry)

        local leftContainer = Create("ScrollingFrame", {
            Name = "LeftContainer",
            BackgroundColor3 = t.Background,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = t.Border,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Position = UDim2.new(0.27, 0, 0, 40),
            Size = UDim2.new(0, 178, 0, 340),
            Visible = false,
            Parent = main,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = leftContainer })
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = leftContainer })
        Create("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = leftContainer })

        local rightContainer = Create("ScrollingFrame", {
            Name = "RightContainer",
            BackgroundColor3 = t.Background,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = t.Border,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Position = UDim2.new(0.64, 0, 0, 40),
            Size = UDim2.new(0, 178, 0, 340),
            Visible = false,
            Parent = main,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = rightContainer })
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = rightContainer })
        Create("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = rightContainer })

        if Info.Module then
            if not ModuleContainers[Info.Module] then
                ModuleContainers[Info.Module] = {}
            end
            table.insert(ModuleContainers[Info.Module], leftContainer)
            table.insert(ModuleContainers[Info.Module], rightContainer)
        end

        local function selectTab()
            TabSelected = tabFrame
            for _, v in pairs(main:GetChildren()) do
                if v.Name == "LeftContainer" or v.Name == "RightContainer" then
                    v.Visible = false
                end
            end
            -- Registry üzerinden TÜM tabları temizle (çift seçim bug'ı bitti)
            for _, entry in ipairs(TabRegistry) do
                if entry.Frame ~= tabFrame and entry.Frame.Parent then
                    Tween(entry.Frame, { BackgroundTransparency = 0.95 }, 0.2, Enum.EasingStyle.Sine)
                    Tween(entry.Stroke, { Transparency = 0.7, Color = GetTheme().Border, Thickness = 1 }, 0.2, Enum.EasingStyle.Sine)
                    Tween(entry.Label, { TextColor3 = GetTheme().TextMuted }, 0.2, Enum.EasingStyle.Sine)
                    Tween(entry.Bar, { BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Sine)
                end
            end
            Tween(tabFrame, { BackgroundTransparency = 0.8 }, 0.25, Enum.EasingStyle.Quint)
            Tween(tabStroke, { Transparency = 0.1, Color = GetTheme().Accent, Thickness = 1.5 }, 0.25, Enum.EasingStyle.Sine)
            Tween(tabLabel, { TextColor3 = GetTheme().Text }, 0.25, Enum.EasingStyle.Sine)
            Tween(activeBar, { BackgroundTransparency = 0 }, 0.25, Enum.EasingStyle.Sine)
            leftContainer.Visible = true
            rightContainer.Visible = true
            leftContainer.BackgroundTransparency = 1
            rightContainer.BackgroundTransparency = 1
            Tween(leftContainer, { BackgroundTransparency = 0 }, 0.3, Enum.EasingStyle.Sine)
            Tween(rightContainer, { BackgroundTransparency = 0 }, 0.3, Enum.EasingStyle.Sine)
        end

        tabClick.MouseButton1Click:Connect(selectTab)
        tabFrame.MouseEnter:Connect(function()
            if TabSelected ~= tabFrame then
                Tween(tabFrame, { BackgroundTransparency = 0.88 }, 0.15, Enum.EasingStyle.Sine)
                Tween(tabLabel, { TextColor3 = GetTheme().Text }, 0.15, Enum.EasingStyle.Sine)
            end
        end)
        tabFrame.MouseLeave:Connect(function()
            if TabSelected ~= tabFrame then
                Tween(tabFrame, { BackgroundTransparency = 0.95 }, 0.15, Enum.EasingStyle.Sine)
                Tween(tabLabel, { TextColor3 = GetTheme().TextMuted }, 0.15, Enum.EasingStyle.Sine)
            end
        end)

        function tab:Select() selectTab() end

        function tab:Section(Info)
            Info = Info or {}
            Info.Text = Info.Text or "Section"
            Info.Side = Info.Side or "Left"
            local sectionApi = {}
            local side = Info.Side == "Left" and leftContainer or rightContainer
            local th = GetTheme()

            local SECTION_HEADER_H = 32
            local SECTION_BOTTOM_PAD = 6

            local section = Create("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, SECTION_HEADER_H + SECTION_BOTTOM_PAD),
                Parent = side,
            })

            local sectionFrame = Create("Frame", {
                Name = "SectionFrame",
                BackgroundColor3 = th.SurfaceAlt,
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, SECTION_HEADER_H),
                Parent = section,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = sectionFrame })
            Create("UIStroke", { Color = th.Border, Thickness = 1, Parent = sectionFrame })
            local listLayout = Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = sectionFrame })
            Create("UIPadding", { PaddingTop = UDim.new(0, SECTION_HEADER_H), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, SECTION_BOTTOM_PAD), Parent = sectionFrame })

            local sectionName = Create("TextLabel", {
                Name = "SectionName",
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = "◆ " .. Info.Text,
                TextColor3 = th.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -10, 0, 28),
                ZIndex = 2,
                Parent = section,
            })
            library:RegisterThemeTarget(sectionName, "Accent", "TextColor3") -- Prop ile kayıt (bg dolmaz)

            -- DOĞRU boyut hesabı: header + içerik + bottom padding
            local function updateSectionSize()
                if not sectionFrame or not sectionFrame.Parent then return end
                local contentH = listLayout.AbsoluteContentSize.Y
                local h = contentH + SECTION_HEADER_H + SECTION_BOTTOM_PAD
                Tween(sectionFrame, { Size = UDim2.new(1, 0, 0, h) }, 0.3, Enum.EasingStyle.Quint)
                Tween(section, { Size = UDim2.new(1, 0, 0, h + SECTION_BOTTOM_PAD) }, 0.3, Enum.EasingStyle.Quint)
            end
            
            task.defer(updateSectionSize)
            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)

            function sectionApi:Label(Info)
                Info = Info or {}
                local lbl = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = Info.Text or "Label",
                    TextColor3 = Info.Color or GetTheme().TextMuted,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Size = UDim2.new(1, 0, 0, 24),
                    Parent = sectionFrame,
                })
                if Info.Tooltip then AddTooltip(lbl, Info.Tooltip) end
                local api = {}
                function api:Set(d)
                    pcall(function()
                        lbl.Text = d.Text or lbl.Text
                        lbl.TextColor3 = d.Color or lbl.TextColor3
                    end)
                end
                return api
            end

            function sectionApi:Toggle(Info)
                Info = Info or {}
                local toggled = Info.Default or false
                if Info.Flag then library.Flags[Info.Flag] = toggled end
                local th2 = GetTheme()

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Toggle",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -48, 1, 0), Position = UDim2.new(0, 4, 0, 0), Parent = row,
                })
                local track = Create("Frame", {
                    BackgroundColor3 = th2.Border, Size = UDim2.new(0, 34, 0, 18),
                    Position = UDim2.new(1, -40, 0.5, -9), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
                ColorElements[track] = { Type = "Toggle", Enabled = false }
                local knob = Create("Frame", {
                    BackgroundColor3 = th2.Text, Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 2, 0.5, -7), Parent = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
                
                local pulse = Create("Frame", {
                    BackgroundColor3 = th2.Accent,
                    BackgroundTransparency = 0.7,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 2, 0.5, -7),
                    Parent = track,
                    Visible = false,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = pulse })
                
                local click = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0), Parent = row })

                local api = {}
                function api:Set(v)
                    toggled = v
                    if Info.Flag then library.Flags[Info.Flag] = v end
                    ColorElements[track].Enabled = v
                    Tween(knob, { Position = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }, 0.25, Enum.EasingStyle.Quint)
                    Tween(track, { BackgroundColor3 = v and GetTheme().Accent or GetTheme().Border }, 0.25, Enum.EasingStyle.Sine)
                    Tween(knob, { BackgroundColor3 = v and GetTheme().AccentSecondary or GetTheme().Text }, 0.25, Enum.EasingStyle.Sine)
                    
                    pulse.Visible = v
                    if v then
                        task.spawn(function()
                            while toggled and pulse and pulse.Parent do
                                Tween(pulse, { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, -2, 0.5, -11), BackgroundTransparency = 1 }, 0.8, Enum.EasingStyle.Sine)
                                task.wait(0.8)
                                if not toggled or not pulse or not pulse.Parent then break end
                                pulse.Size = UDim2.new(0, 14, 0, 14)
                                pulse.Position = UDim2.new(0, 2, 0.5, -7)
                                pulse.BackgroundTransparency = 0.7
                            end
                        end)
                    end
                    
                    pcall(Info.Callback, v)
                end
                click.MouseButton1Click:Connect(function() api:Set(not toggled) end)
                if toggled then task.defer(function() api:Set(true) end) end
                if Info.Flag then library._flagSetters[Info.Flag] = api.Set end
                if Info.Tooltip then AddTooltip(row, Info.Tooltip) end
                return api
            end

            function sectionApi:Button(Info)
                Info = Info or {}
                local th2 = GetTheme()
                local btn = Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = th2.Surface,
                    Font = Enum.Font.GothamBold,
                    Text = Info.Text or "Button",
                    TextColor3 = th2.Text,
                    TextSize = 11,
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = sectionFrame,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })
                local btnStroke = Create("UIStroke", { Color = th2.Border, Thickness = 1, Parent = btn })
                
                btn.MouseEnter:Connect(function()
                    Tween(btn, { BackgroundColor3 = GetTheme().Accent, TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.2, Enum.EasingStyle.Sine)
                    Tween(btnStroke, { Color = GetTheme().Accent, Transparency = 0 }, 0.2, Enum.EasingStyle.Sine)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, { BackgroundColor3 = GetTheme().Surface, TextColor3 = GetTheme().Text }, 0.2, Enum.EasingStyle.Sine)
                    Tween(btnStroke, { Color = GetTheme().Border, Transparency = 0 }, 0.2, Enum.EasingStyle.Sine)
                end)
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, { Size = UDim2.new(0.96, 0, 0, 30) }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    task.delay(0.08, function()
                        Tween(btn, { Size = UDim2.new(1, 0, 0, 32) }, 0.2, Enum.EasingStyle.Back)
                    end)
                    task.spawn(function() pcall(Info.Callback) end)
                end)
                if Info.Tooltip then AddTooltip(btn, Info.Tooltip) end
            end

            function sectionApi:Slider(Info)
                Info = Info or {}
                local min, max = Info.Minimum or 0, Info.Maximum or 100
                if min > max then min, max = max, min end
                local val = math.clamp(Info.Default or 50, min, max)
                if Info.Flag then library.Flags[Info.Flag] = val end
                local th2 = GetTheme()

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Slider",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(0.6, 0, 0, 18), Position = UDim2.new(0, 4, 0, 2), Parent = row,
                })
                local valBox = Create("TextBox", {
                    BackgroundColor3 = th2.Surface, Text = tostring(val) .. (Info.Postfix or ""),
                    TextColor3 = th2.Text, Font = Enum.Font.GothamBold, TextSize = 10,
                    Size = UDim2.new(0, 48, 0, 18), Position = UDim2.new(1, -52, 0, 2), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = valBox })
                Create("UIStroke", { Color = th2.Border, Thickness = 1, Parent = valBox })

                local outer = Create("Frame", {
                    BackgroundColor3 = th2.SurfaceAlt, Size = UDim2.new(1, -8, 0, 6),
                    Position = UDim2.new(0, 4, 0, 30), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = outer })
                local inner = Create("Frame", {
                    BackgroundColor3 = th2.Accent,
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0), Parent = outer,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = inner })
                ColorElements[inner] = { Type = "Slider", Enabled = true }
                library:RegisterThemeTarget(inner, "Accent")
                
                local thumb = Create("Frame", {
                    BackgroundColor3 = th2.AccentSecondary,
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
                    ZIndex = 2,
                    Parent = outer,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })
                Create("UIStroke", { Color = th2.Accent, Thickness = 2, Parent = thumb })
                library:RegisterThemeTarget(thumb, "AccentSecondary")

                local function setValue(v)
                    val = math.clamp(math.floor(v), min, max)
                    if Info.Flag then library.Flags[Info.Flag] = val end
                    local scale = (val - min) / (max - min)
                    Tween(inner, { Size = UDim2.new(scale, 0, 1, 0) }, 0.2, Enum.EasingStyle.Quint)
                    Tween(thumb, { Position = UDim2.new(scale, 0, 0.5, 0) }, 0.2, Enum.EasingStyle.Quint)
                    valBox.Text = tostring(val) .. (Info.Postfix or "")
                    task.spawn(function() pcall(Info.Callback, val) end)
                end

                -- Görünmez drag hit alanı (takılma yok)
                local dragActive = false
                local function onMove()
                    local px = select(1, library:GetXY(outer))
                    setValue(min + (max - min) * px)
                end
                local hit = Create("TextButton", {
                    BackgroundTransparency = 1, Text = "",
                    Size = UDim2.new(1, -8, 0, 20), Position = UDim2.new(0, 4, 0, 23),
                    ZIndex = 3, Parent = row,
                })
                hit.MouseButton1Down:Connect(function()
                    dragActive = true
                    onMove()
                    Tween(thumb, { Size = UDim2.new(0, 16, 0, 16) }, 0.15, Enum.EasingStyle.Sine)
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragActive and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        onMove()
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if dragActive and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
                        dragActive = false
                        Tween(thumb, { Size = UDim2.new(0, 14, 0, 14) }, 0.15, Enum.EasingStyle.Sine)
                    end
                end)
                
                valBox.FocusLost:Connect(function()
                    local n = tonumber(valBox.Text:gsub("[^%d%-%.]", ""))
                    if n then setValue(n) else valBox.Text = tostring(val) .. (Info.Postfix or "") end
                end)
                valBox.Focused:Connect(function()
                    valBox.Text = tostring(val)
                end)
                
                if Info.Flag then library._flagSetters[Info.Flag] = setValue end
                task.defer(function() pcall(Info.Callback, val) end)
                if Info.Tooltip then AddTooltip(row, Info.Tooltip) end
            end

            function sectionApi:Dropdown(Info)
                Info = Info or {}
                local list = Info.List or {}
                local opened = false
                local dropH = 0
                local th2 = GetTheme()

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = false, Parent = sectionFrame, ZIndex = 1 })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Dropdown",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 4, 0, 0), Parent = row, ZIndex = 2,
                })
                local arrow = Create("TextLabel", {
                    BackgroundTransparency = 1, Text = "▼", Font = Enum.Font.GothamBold,
                    TextColor3 = th2.TextMuted, TextSize = 10,
                    Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -18, 0, 9), Parent = row, ZIndex = 2,
                })
                
                local container = Create("Frame", {
                    BackgroundColor3 = th2.Surface,
                    ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 32), Parent = row,
                    Visible = true, ZIndex = 5,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })
                Create("UIStroke", { Color = th2.Border, Thickness = 1, Parent = container })

                local selectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Info.Default or "Select...",
                    TextColor3 = th2.TextMuted, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -36, 0, 32), Position = UDim2.new(0, 8, 0, 0), Parent = row, ZIndex = 2,
                })

                local headerBtn = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 32), ZIndex = 3, Parent = row })
                Create("UIStroke", { Color = th2.Border, Thickness = 1, Transparency = 0.5, Parent = headerBtn })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = headerBtn })

                local trackerIdx = #library._dropdownTracker + 1
                local optionButtons = {}
                
                library._dropdownTracker[trackerIdx] = {
                    isOpened = function() return opened end,
                    close = function()
                        if not opened then return end
                        opened = false
                        Tween(row, { Size = UDim2.new(1, 0, 0, 32) }, 0.3, Enum.EasingStyle.Quint)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
                        Tween(arrow, { Rotation = 0 }, 0.3, Enum.EasingStyle.Quint)
                    end,
                    updateTheme = function()
                        local t = GetTheme()
                        pcall(function()
                            container.BackgroundColor3 = t.Surface
                            local cs = container:FindFirstChildOfClass("UIStroke")
                            if cs then cs.Color = t.Border end
                            arrow.TextColor3 = opened and t.Accent or t.TextMuted
                            selectedLabel.TextColor3 = t.TextMuted
                            for _, opt in pairs(optionButtons) do
                                if opt and opt.Parent then opt.TextColor3 = t.Text end
                            end
                        end)
                    end
                }

                local api = {}
                function api:Add(text)
                    dropH += 28
                    local opt = Create("TextButton", {
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "  " .. text,
                        TextColor3 = th2.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 28), Parent = container, ZIndex = 6,
                    })
                    table.insert(optionButtons, opt)
                    opt.MouseEnter:Connect(function()
                        Tween(opt, { BackgroundColor3 = GetTheme().Accent, BackgroundTransparency = 0.8, TextColor3 = GetTheme().Text }, 0.12, Enum.EasingStyle.Sine)
                    end)
                    opt.MouseLeave:Connect(function()
                        Tween(opt, { BackgroundTransparency = 1, TextColor3 = GetTheme().Text }, 0.12, Enum.EasingStyle.Sine)
                    end)
                    opt.MouseButton1Click:Connect(function()
                        selectedLabel.Text = text
                        if Info.Flag then library.Flags[Info.Flag] = text end
                        task.spawn(function() pcall(Info.Callback, text) end)
                        library._dropdownTracker[trackerIdx].close()
                    end)
                end

                function api:Refresh(d)
                    for _, c in container:GetChildren() do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    optionButtons = {}
                    dropH = 0
                    for _, v in (d.List or list) do api:Add(v) end
                end

                for _, v in list do api:Add(v) end

                headerBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        for i, tr in pairs(library._dropdownTracker) do
                            if i ~= trackerIdx and tr.isOpened() then
                                tr.close()
                            end
                        end
                    end
                    
                    local targetH = opened and dropH or 0
                    Tween(row, { Size = UDim2.new(1, 0, 0, 32 + targetH) }, 0.35, Enum.EasingStyle.Quint)
                    Tween(container, { Size = UDim2.new(1, 0, 0, targetH) }, 0.35, Enum.EasingStyle.Quint)
                    Tween(arrow, { Rotation = opened and 180 or 0, TextColor3 = opened and GetTheme().Accent or GetTheme().TextMuted }, 0.3, Enum.EasingStyle.Quint)
                end)

                if Info.Flag then
                    library._flagSetters[Info.Flag] = function(v)
                        selectedLabel.Text = tostring(v)
                        pcall(Info.Callback, v)
                    end
                end
                if Info.Tooltip then AddTooltip(row, Info.Tooltip) end
                return api
            end
            
            function sectionApi:ThemeDropdown(Info)
                Info = Info or {}
                local themeNames = {}
                for name in pairs(Themes) do table.insert(themeNames, name) end
                table.sort(themeNames)

                return sectionApi:Dropdown({
                    Text = Info.Text or "Theme",
                    List = themeNames,
                    Default = ActiveThemeName,
                    Flag = Info.Flag,
                    Tooltip = Info.Tooltip or "Change UI theme live",
                    Callback = function(name)
                        library:ApplyTheme(name)
                        library:Notify("Theme Changed", "Switched to " .. name, 2, GetTheme().Accent)
                    end,
                })
            end

            function sectionApi:CountDropdown(Info)
                Info = Info or {}
                local modules = Info.Modules or { "Hub Alpha", "Hub Beta", "Hub Gamma" }
                library.ActiveModule = Info.Default or modules[1]

                return sectionApi:Dropdown({
                    Text = Info.Text or "Module Hub",
                    List = modules,
                    Default = library.ActiveModule,
                    Flag = Info.Flag,
                    Tooltip = Info.Tooltip or "Switch between hub layouts",
                    Callback = function(name)
                        library:SwitchModule(name)
                        pcall(Info.Callback, name)
                    end,
                })
            end

            function sectionApi:Input(Info)
                Info = Info or {}
                local th2 = GetTheme()
                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Input",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 4, 0, 2), Parent = row,
                })
                local outer = Create("Frame", {
                    BackgroundColor3 = th2.Surface, Size = UDim2.new(1, -8, 0, 22),
                    Position = UDim2.new(0, 4, 0, 20), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = outer })
                local outerStroke = Create("UIStroke", { Color = th2.Border, Thickness = 1, Parent = outer })
                local box = Create("TextBox", {
                    BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "",
                    PlaceholderText = Info.Placeholder or "Input...", PlaceholderColor3 = th2.TextMuted,
                    TextColor3 = th2.Text, TextSize = 11, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = outer,
                })
                box.Focused:Connect(function()
                    Tween(outerStroke, { Color = th2.Accent, Thickness = 1.5 }, 0.15, Enum.EasingStyle.Sine)
                end)
                box.FocusLost:Connect(function(enterPressed)
                    Tween(outerStroke, { Color = th2.Border, Thickness = 1 }, 0.15, Enum.EasingStyle.Sine)
                    if Info.Flag then library.Flags[Info.Flag] = box.Text end
                    task.spawn(function() pcall(Info.Callback, box.Text, enterPressed) end)
                end)
                if Info.Tooltip then AddTooltip(row, Info.Tooltip) end
            end

            function sectionApi:Keybind(Info)
                Info = Info or {}
                local pressKey = Info.Default or Enum.KeyCode.Unknown
                local pressInputType = nil
                local mode = Info.Mode or "Toggle"
                local holding = false
                local changing = false
                if Info.Flag then
                    library.Flags[Info.Flag] = { Key = pressKey == Enum.KeyCode.Unknown and "" or pressKey.Name, Mode = mode }
                end
                local th2 = GetTheme()

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Keybind",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -72, 1, 0), Position = UDim2.new(0, 4, 0, 0), Parent = row,
                })
                local keyFrame = Create("Frame", {
                    BackgroundColor3 = th2.SurfaceAlt, Size = UDim2.new(0, 64, 0, 22),
                    Position = UDim2.new(1, -68, 0.5, -11), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = keyFrame })
                local keyStroke = Create("UIStroke", { Color = th2.Border, Thickness = 1, Parent = keyFrame })
                local keyText = Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
                    Text = pressKey == Enum.KeyCode.Unknown and "None" or pressKey.Name,
                    TextColor3 = th2.Text, TextSize = 9, Size = UDim2.new(1, 0, 1, 0), Parent = keyFrame,
                })
                local keyBtn = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0), Parent = keyFrame })

                local conn
                keyBtn.MouseButton1Click:Connect(function()
                    if conn then conn:Disconnect() end
                    changing = true
                    library.ChangingKeybind = true
                    keyText.Text = "..."
                    Tween(keyStroke, { Color = th2.Accent, Thickness = 1.5 }, 0.15, Enum.EasingStyle.Sine)
                    conn = UserInputService.InputBegan:Connect(function(k)
                        if k.UserInputType == Enum.UserInputType.MouseMovement then return end
                        conn:Disconnect()
                        Tween(keyStroke, { Color = th2.Border, Thickness = 1 }, 0.15, Enum.EasingStyle.Sine)
                        if k.KeyCode == Enum.KeyCode.Escape then
                            pressKey = Enum.KeyCode.Unknown
                            pressInputType = nil
                            keyText.Text = "None"
                        elseif k.UserInputType ~= Enum.UserInputType.Keyboard then
                            pressInputType = k.UserInputType
                            pressKey = Enum.KeyCode.Unknown
                            keyText.Text = k.UserInputType.Name
                        else
                            pressKey = k.KeyCode
                            pressInputType = nil
                            keyText.Text = k.KeyCode.Name
                        end
                        if Info.Flag then
                            library.Flags[Info.Flag] = { Key = keyText.Text == "None" and "" or keyText.Text, Mode = mode }
                        end
                        changing = false
                        library.ChangingKeybind = false
                    end)
                end)

                UserInputService.InputBegan:Connect(function(k, gp)
                    if changing or library.ChangingKeybind then return end
                    if gp and not Info.BypassGameProcessed then return end
                    local match = (pressInputType and k.UserInputType == pressInputType) or (pressKey ~= Enum.KeyCode.Unknown and k.KeyCode == pressKey)
                    if match then
                        if mode == "Toggle" then
                            holding = not holding
                            task.spawn(function() pcall(Info.Callback, holding) end)
                        else
                            holding = true
                            task.spawn(function() pcall(Info.Callback, true) end)
                        end
                    end
                end)
                UserInputService.InputEnded:Connect(function(k)
                    local match = (pressInputType and k.UserInputType == pressInputType) or (pressKey ~= Enum.KeyCode.Unknown and k.KeyCode == pressKey)
                    if match and mode == "Hold" and holding then
                        holding = false
                        task.spawn(function() pcall(Info.Callback, false) end)
                    end
                end)
                if Info.Tooltip then AddTooltip(row, Info.Tooltip) end
            end

            return sectionApi
        end

        return tab
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for _, tr in pairs(library._dropdownTracker) do
                if tr.isOpened() then tr.close() end
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == UI_TOGGLE_KEY then
            library:ToggleUI()
        end
    end)

    return window
end

return library
