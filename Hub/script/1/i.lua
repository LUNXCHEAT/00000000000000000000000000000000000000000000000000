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

local ActiveThemeName = "Scout"
local UI_TOGGLE_KEY = Enum.KeyCode.K

local CoreGui           = game:GetService("CoreGui")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

local LocalPlayer = game.Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

if CoreGui:FindFirstChild("LunxAdvanced") then
    CoreGui.LunxAdvanced:Destroy()
end
if CoreGui:FindFirstChild("LunxAdvancedTooltips") then
    CoreGui.LunxAdvancedTooltips:Destroy()
end
if CoreGui:FindFirstChild("LunxKeySystem") then
    CoreGui.LunxKeySystem:Destroy()
end

local function GetTheme()
    return Themes[ActiveThemeName] or Themes["Scout"]
end

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function CheckTable(tbl)
    local n = 0
    for _ in pairs(tbl) do n += 1 end
    return n
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
        Size = UDim2.new(0, 340, 0, 220),
        Parent = overlay,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = card })
    Create("UIStroke", { Color = theme.Border, Thickness = 1, Parent = card })

    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "Authentication Required",
        TextColor3 = theme.Text,
        TextSize = 16,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 12),
        Parent = card,
    })

    local subtitle = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "Enter your access key to continue",
        TextColor3 = theme.TextMuted,
        TextSize = 12,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 44),
        Parent = card,
    })

    local inputOuter = Create("Frame", {
        BackgroundColor3 = theme.SurfaceAlt,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 88),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0.85, 0, 0, 36),
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = inputOuter })
    Create("UIStroke", { Color = theme.Border, Parent = inputOuter })

    local keyInput = Create("TextBox", {
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        Font = Enum.Font.GothamBold,
        PlaceholderText = "Access Key...",
        PlaceholderColor3 = theme.TextMuted,
        Text = "",
        TextColor3 = theme.Text,
        TextSize = 13,
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Parent = inputOuter,
    })

    local errorLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = theme.Error,
        TextSize = 11,
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 10, 0, 130),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    local submitBtn = Create("TextButton", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Verify Key",
        TextColor3 = Color3.fromRGB(20, 20, 20),
        TextSize = 13,
        Size = UDim2.new(0.85, 0, 0, 36),
        Position = UDim2.new(0.5, 0, 1, -52),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = submitBtn })

    Tween(overlay, { BackgroundTransparency = 0.45 }, 0.4)
    card.Position = UDim2.fromScale(0.5, 0.65)
    card.BackgroundTransparency = 1
    Tween(card, { Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0 }, 0.55, Enum.EasingStyle.Back)

    local function Shake()
        local base = UDim2.fromScale(0.5, 0.5)
        for i = 1, 6 do
            local offset = (i % 2 == 0) and 8 or -8
            Tween(card, { Position = base + UDim2.new(0, offset, 0, 0) }, 0.04, Enum.EasingStyle.Linear)
            task.wait(0.04)
        end
        Tween(card, { Position = base }, 0.1)
    end

    local verifying = false
    local function Verify()
        if verifying then return end
        verifying = true
        local entered = keyInput.Text

        if entered == CORRECT_KEY then
            errorLabel.Text = ""
            Tween(submitBtn, { BackgroundColor3 = theme.AccentSecondary }, 0.15)
            submitBtn.Text = "Access Granted"
            task.wait(0.35)
            Tween(card, { Position = UDim2.fromScale(0.5, 0.35), BackgroundTransparency = 1 }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Tween(overlay, { BackgroundTransparency = 1 }, 0.45)
            task.wait(0.5)
            keyGui:Destroy()
            KeySystemPassed = true
            onSuccess()
        else
            errorLabel.Text = "Invalid key. Please try again."
            Shake()
            Tween(inputOuter, { BackgroundColor3 = theme.Error }, 0.1)
            task.wait(0.2)
            Tween(inputOuter, { BackgroundColor3 = theme.SurfaceAlt }, 0.25)
            keyInput.Text = ""
            verifying = false
        end
    end

    submitBtn.MouseButton1Click:Connect(Verify)
    keyInput.FocusLost:Connect(function(enter)
        if enter then Verify() end
    end)

    submitBtn.MouseEnter:Connect(function()
        Tween(submitBtn, { BackgroundColor3 = theme.AccentSecondary }, 0.12)
    end)
    submitBtn.MouseLeave:Connect(function()
        Tween(submitBtn, { BackgroundColor3 = theme.Accent }, 0.12)
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
    Mascot = nil,
    Visible = false,
    ActiveModule = "Hub Alpha",
}

local TabSelected = nil
local EditOpened = false
local ColorElements = {}

task.spawn(function()
    while true do
        if EditOpened and CheckTable(ColorElements) > 0 then
            local hue = tick() % 7 / 7
            local color = Color3.fromHSV(hue, 1, 1)
            for frame, v in pairs(ColorElements) do
                if v.Enabled then
                    if frame:IsA("Frame") then
                        frame.BackgroundColor3 = color
                    elseif frame:IsA("ImageLabel") or frame:IsA("ImageButton") then
                        frame.ImageColor3 = color
                    end
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

function library:RegisterThemeTarget(instance, key)
    table.insert(library._themeTargets, { Instance = instance, Key = key })
end

function library:ApplyTheme(themeName)
    if themeName and Themes[themeName] then
        ActiveThemeName = themeName
    end
    local t = GetTheme()

    for _, entry in ipairs(library._themeTargets) do
        local inst, key = entry.Instance, entry.Key
        if inst and inst.Parent then
            local color = t[key]
            if color then
                if inst:IsA("Frame") or inst:IsA("TextButton") or inst:IsA("TextLabel") or inst:IsA("TextBox") or inst:IsA("ScrollingFrame") then
                    if key:find("Text") then
                        inst.TextColor3 = color
                    else
                        inst.BackgroundColor3 = color
                    end
                elseif inst:IsA("UIStroke") then
                    inst.Color = color
                elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
                    if key == "MascotImage" then
                        inst.Image = color
                    else
                        inst.ImageColor3 = color
                    end
                end
            end
        end
    end

    if library.Mascot then
        library.Mascot.Image = t.MascotImage
    end

    if not EditOpened then
        for frame, v in pairs(ColorElements) do
            if v.Enabled and v.Type ~= "Toggle" then
                if frame:IsA("Frame") then
                    Tween(frame, { BackgroundColor3 = t.Accent }, 0.2)
                end
            end
        end
    end
end

function library:SetVisible(state)
    if not library.MainFrame or not library.ScreenGui then return end
    library.Visible = state

    if state then
        library.ScreenGui.Enabled = true
        library.MainFrame.Visible = true
        library.MainFrame.Size = UDim2.new(0, 450, 0, 280)
        library.MainFrame.BackgroundTransparency = 1
        Tween(library.MainFrame, {
            Size = UDim2.new(0, 450, 0, 321),
            BackgroundTransparency = 0,
        }, 0.35, Enum.EasingStyle.Back)
        if library.Mascot then
            library.Mascot.ImageTransparency = 1
            library.Mascot.Visible = true
            Tween(library.Mascot, { ImageTransparency = 0, Size = UDim2.new(0, 72, 0, 72) }, 0.4, Enum.EasingStyle.Back)
        end
    else
        if library.Mascot then
            Tween(library.Mascot, { ImageTransparency = 1, Size = UDim2.new(0, 50, 0, 50) }, 0.2)
        end
        Tween(library.MainFrame, {
            Size = UDim2.new(0, 450, 0, 280),
            BackgroundTransparency = 0.3,
        }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.25, function()
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
                    Tween(c, { BackgroundTransparency = 0 }, 0.25)
                else
                    Tween(c, { BackgroundTransparency = 1 }, 0.2)
                    task.delay(0.2, function()
                        if library.ActiveModule ~= name and c.Parent then
                            c.Visible = false
                        end
                    end)
                end
            end
        end
    end
end

function library:Window(Info)
    Info = Info or {}
    Info.Text = Info.Text or "Lunx Advanced"

    local theme = GetTheme()
    local window = {}

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
        Parent = CoreGui,
    })

    local function AddTooltip(element, text)
        local tip = Create("Frame", {
            BackgroundColor3 = theme.SurfaceAlt,
            Visible = false,
            Size = UDim2.new(0, 100, 0, 22),
            ZIndex = 50,
            Parent = tooltipGui,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = tip })
        Create("UIStroke", { Color = theme.Border, Parent = tip })
        local tipText = Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = text,
            TextColor3 = theme.Text,
            TextSize = 11,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = tip,
        })
        task.defer(function()
            local bounds = tipText.TextBounds
            tip.Size = UDim2.new(0, bounds.X + 14, 0, 22)
        end)

        local hovered = false
        element.MouseEnter:Connect(function()
            hovered = true
            task.delay(0.45, function()
                if hovered then
                    tip.Visible = true
                    tip.BackgroundTransparency = 1
                    Tween(tip, { BackgroundTransparency = 0 }, 0.15)
                end
            end)
        end)
        element.MouseLeave:Connect(function()
            hovered = false
            tip.Visible = false
        end)
        element.MouseMoved:Connect(function()
            local pos = UserInputService:GetMouseLocation()
            local vp = workspace.CurrentCamera.ViewportSize
            tip.Position = UDim2.new(pos.X / vp.X, 0, pos.Y / vp.Y, -38)
        end)
    end

    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.361, 0, 0.308, 0),
        Size = UDim2.new(0, 450, 0, 321),
        Visible = false,
        Parent = LunxGui,
    })
    library.MainFrame = main
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })
    local mainStroke = Create("UIStroke", { Color = theme.Border, Parent = main })
    library:RegisterThemeTarget(main, "Background")
    library:RegisterThemeTarget(mainStroke, "Border")

    local mascot = Create("ImageLabel", {
        Name = "Mascot",
        BackgroundTransparency = 1,
        Image = theme.MascotImage,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 8, 1, 8),
        Size = UDim2.new(0, 72, 0, 72),
        ZIndex = 10,
        ImageTransparency = 1,
        Visible = false,
        Parent = main,
    })
    library.Mascot = mascot

    local topbar = Create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        ZIndex = 5,
        Parent = main,
    })
    library:RegisterThemeTarget(topbar, "Surface")
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = topbar })

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
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Parent = topbar,
    })
    library:RegisterThemeTarget(titleLabel, "Text")

    task.spawn(function()
        local titleText = Info.Text
        while main.Parent do
            for i = 1, #titleText do
                titleLabel.Text = titleText:sub(1, i) .. "|"
                task.wait(0.06)
            end
            for t = 1, 6 do
                titleLabel.Text = titleText .. (t % 2 == 1 and "|" or " ")
                task.wait(0.25)
            end
            for i = #titleText, 0, -1 do
                titleLabel.Text = titleText:sub(1, i) .. "|"
                task.wait(0.03)
            end
            for t = 1, 6 do
                titleLabel.Text = (t % 2 == 1 and "|" or " ")
                task.wait(0.25)
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
                Size = UDim2.new(0, 18, 0, 18),
                ZIndex = 6,
                Parent = topbar,
            })
            btn.MouseEnter:Connect(function() Tween(btn, { ImageColor3 = theme.Warning }, 0.12) end)
            btn.MouseLeave:Connect(function() Tween(btn, { ImageColor3 = theme.Text }, 0.12) end)
            return btn
        else
            local btn = Create("TextButton", {
                Name = name,
                Text = text,
                Font = Enum.Font.GothamBold,
                TextSize = 20,
                TextColor3 = theme.Text,
                BackgroundTransparency = 1,
                Position = pos,
                Size = UDim2.new(0, 24, 0, 24),
                ZIndex = 6,
                Parent = topbar,
            })
            btn.MouseEnter:Connect(function() Tween(btn, { TextColor3 = theme.Error }, 0.12) end)
            btn.MouseLeave:Connect(function() Tween(btn, { TextColor3 = theme.Text }, 0.12) end)
            return btn
        end
    end

    local closeBtn = makeControl("Close", "×", UDim2.new(1, -30, 0.5, -12), false)
    closeBtn.MouseButton1Click:Connect(function() library:SetVisible(false) end)

    local minimizeBtn = makeControl("Minimize", "", UDim2.new(1, -58, 0.5, -9), true, "rbxassetid://10664064072")
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(main, { Size = minimized and UDim2.new(0, 450, 0, 34) or UDim2.new(0, 450, 0, 321) }, 0.3, Enum.EasingStyle.Quint)
        for _, v in pairs(main:GetChildren()) do
            if v.Name == "TabContainer" or v.Name == "LeftContainer" or v.Name == "RightContainer" then
                v.Visible = not minimized
            end
        end
        if mascot then mascot.Visible = not minimized and library.Visible end
    end)

    local editBtn = Create("TextButton", {
        Name = "EditButton",
        Text = "",
        BackgroundColor3 = theme.Accent,
        Position = UDim2.new(1, -86, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
        ZIndex = 6,
        Parent = topbar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = editBtn })
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
        while editBtn.Parent do
            if editGradient.Enabled then
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
                if v.Enabled and frame:IsA("Frame") then
                    Tween(frame, { BackgroundColor3 = t.Accent }, 0.15)
                end
            end
        else
            for _, v in pairs(ColorElements) do
                if v.Type ~= "Toggle" then v.Enabled = true end
            end
        end
    end)

    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = theme.Surface,
        Position = UDim2.new(0, 0, 0, 34),
        Size = UDim2.new(0, 118, 0, 287),
        Parent = main,
    })
    library:RegisterThemeTarget(tabContainer, "Surface")
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabContainer })

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
    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = scrollTabs })
    Create("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = scrollTabs })

    function window:Tab(Info)
        Info = Info or {}
        Info.Text = Info.Text or "Tab"
        local tab = {}
        local t = GetTheme()

        local tabBtn = Create("Frame", {
            Name = "TabButton",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Parent = scrollTabs,
        })

        local tabFrame = Create("Frame", {
            Name = "TabFrame",
            BackgroundColor3 = t.SurfaceAlt,
            BackgroundTransparency = 0.92,
            Size = UDim2.new(1, 0, 0, 28),
            Parent = tabBtn,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = tabFrame })
        local tabStroke = Create("UIStroke", { Color = t.Border, Transparency = 0.6, Parent = tabFrame })

        local tabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = Info.Text,
            TextColor3 = t.TextMuted,
            TextSize = 11,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = tabFrame,
        })

        local tabClick = Create("TextButton", {
            BackgroundTransparency = 1,
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 2,
            Parent = tabFrame,
        })

        local leftContainer = Create("ScrollingFrame", {
            Name = "LeftContainer",
            BackgroundColor3 = t.Background,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = t.Border,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Position = UDim2.new(0.27, 0, 0, 34),
            Size = UDim2.new(0, 158, 0, 287),
            Visible = false,
            Parent = main,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = leftContainer })
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = leftContainer })
        Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), Parent = leftContainer })

        local rightContainer = Create("ScrollingFrame", {
            Name = "RightContainer",
            BackgroundColor3 = t.Background,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = t.Border,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Position = UDim2.new(0.635, 0, 0, 34),
            Size = UDim2.new(0, 158, 0, 287),
            Visible = false,
            Parent = main,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = rightContainer })
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = rightContainer })
        Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), Parent = rightContainer })

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
            for _, v in pairs(scrollTabs:GetChildren()) do
                if v:IsA("Frame") and v ~= tabBtn then
                    Tween(v.TabFrame, { BackgroundTransparency = 0.92 }, 0.15)
                    Tween(v.TabFrame.UIStroke, { Transparency = 0.6 }, 0.15)
                    Tween(v.TabFrame.TextLabel, { TextColor3 = GetTheme().TextMuted }, 0.15)
                end
            end
            Tween(tabFrame, { BackgroundTransparency = 0.75 }, 0.2)
            Tween(tabStroke, { Transparency = 0.1, Color = GetTheme().Accent }, 0.2)
            Tween(tabLabel, { TextColor3 = GetTheme().Text }, 0.2)
            leftContainer.Visible = true
            rightContainer.Visible = true
            leftContainer.BackgroundTransparency = 1
            rightContainer.BackgroundTransparency = 1
            Tween(leftContainer, { BackgroundTransparency = 0 }, 0.25)
            Tween(rightContainer, { BackgroundTransparency = 0 }, 0.25)
        end

        tabClick.MouseButton1Click:Connect(selectTab)
        tabFrame.MouseEnter:Connect(function()
            if TabSelected ~= tabFrame then
                Tween(tabFrame, { BackgroundTransparency = 0.85 }, 0.12)
            end
        end)
        tabFrame.MouseLeave:Connect(function()
            if TabSelected ~= tabFrame then
                Tween(tabFrame, { BackgroundTransparency = 0.92 }, 0.12)
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

            local section = Create("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = side,
            })

            local sectionFrame = Create("Frame", {
                Name = "SectionFrame",
                BackgroundColor3 = th.SurfaceAlt,
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = section,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = sectionFrame })
            Create("UIStroke", { Color = th.Border, Parent = sectionFrame })
            Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = sectionFrame })
            Create("UIPadding", { PaddingTop = UDim.new(0, 26), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), Parent = sectionFrame })

            Create("TextLabel", {
                Name = "SectionName",
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = Info.Text,
                TextColor3 = th.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(1, -8, 0, 24),
                ZIndex = 2,
                Parent = section,
            })

            local function resizeSection()
                local h = 26
                local layout = sectionFrame:FindFirstChildOfClass("UIListLayout")
                local pad = layout and layout.Padding.Offset or 0
                local count = 0
                for _, ch in sectionFrame:GetChildren() do
                    if ch:IsA("Frame") then
                        h += ch.Size.Y.Offset
                        count += 1
                    end
                end
                h += math.max(0, count - 1) * pad + 4
                Tween(sectionFrame, { Size = UDim2.new(1, 0, 0, h) }, 0.2)
                Tween(section, { Size = UDim2.new(1, 0, 0, h + 4) }, 0.2)
            end
            sectionFrame.ChildAdded:Connect(resizeSection)

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
                    Size = UDim2.new(1, 0, 0, 24),
                    Parent = sectionFrame,
                })
                if Info.Tooltip then AddTooltip(lbl, Info.Tooltip) end
                local api = {}
                function api:Set(d)
                    lbl.Text = d.Text or lbl.Text
                    lbl.TextColor3 = d.Color or lbl.TextColor3
                end
                return api
            end

            function sectionApi:Toggle(Info)
                Info = Info or {}
                local toggled = Info.Default or false
                if Info.Flag then library.Flags[Info.Flag] = toggled end
                local th2 = GetTheme()

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Toggle",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 4, 0, 0), Parent = row,
                })
                local track = Create("Frame", {
                    BackgroundColor3 = th2.Border, Size = UDim2.new(0, 32, 0, 16),
                    Position = UDim2.new(1, -36, 0.5, -8), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
                ColorElements[track] = { Type = "Toggle", Enabled = false }
                local knob = Create("Frame", {
                    BackgroundColor3 = th2.Text, Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, 2, 0.5, -6), Parent = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
                local click = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0), Parent = row })

                local api = {}
                function api:Set(v)
                    toggled = v
                    if Info.Flag then library.Flags[Info.Flag] = v end
                    ColorElements[track].Enabled = v
                    Tween(knob, { Position = v and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) }, 0.18, Enum.EasingStyle.Back)
                    Tween(track, { BackgroundColor3 = v and GetTheme().Accent or GetTheme().Border }, 0.18)
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
                    Size = UDim2.new(1, 0, 0, 28),
                    Parent = sectionFrame,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btn })
                Create("UIStroke", { Color = th2.Border, Parent = btn })
                btn.MouseEnter:Connect(function()
                    Tween(btn, { BackgroundColor3 = GetTheme().Accent, TextColor3 = Color3.fromRGB(20, 20, 20) }, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, { BackgroundColor3 = GetTheme().Surface, TextColor3 = GetTheme().Text }, 0.15)
                end)
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, { Size = UDim2.new(0.97, 0, 0, 26) }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    task.delay(0.08, function()
                        Tween(btn, { Size = UDim2.new(1, 0, 0, 28) }, 0.12, Enum.EasingStyle.Back)
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

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Slider",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(0.6, 0, 0, 18), Position = UDim2.new(0, 4, 0, 0), Parent = row,
                })
                local valBox = Create("TextBox", {
                    BackgroundColor3 = th2.Surface, Text = tostring(val) .. (Info.Postfix or ""),
                    TextColor3 = th2.Text, Font = Enum.Font.GothamBold, TextSize = 10,
                    Size = UDim2.new(0, 44, 0, 18), Position = UDim2.new(1, -48, 0, 0), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = valBox })

                local outer = Create("Frame", {
                    BackgroundColor3 = th2.Border, Size = UDim2.new(1, -8, 0, 5),
                    Position = UDim2.new(0, 4, 0, 26), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = outer })
                local inner = Create("Frame", {
                    BackgroundColor3 = th2.Accent,
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0), Parent = outer,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = inner })
                ColorElements[inner] = { Type = "Slider", Enabled = true }

                local function setValue(v)
                    val = math.clamp(math.floor(v), min, max)
                    if Info.Flag then library.Flags[Info.Flag] = val end
                    local scale = (val - min) / (max - min)
                    Tween(inner, { Size = UDim2.new(scale, 0, 1, 0) }, 0.12)
                    valBox.Text = tostring(val) .. (Info.Postfix or "")
                    task.spawn(function() pcall(Info.Callback, val) end)
                end

                local dragBtn = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 22), Parent = row })
                dragBtn.MouseButton1Down:Connect(function()
                    local move, kill
                    move = Mouse.Move:Connect(function()
                        local px = select(1, library:GetXY(outer))
                        setValue(min + (max - min) * px)
                    end)
                    kill = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            move:Disconnect(); kill:Disconnect()
                        end
                    end)
                end)
                valBox.FocusLost:Connect(function()
                    local n = tonumber(valBox.Text:gsub("[^%d%-%.]", ""))
                    if n then setValue(n) else valBox.Text = tostring(val) .. (Info.Postfix or "") end
                end)
                if Info.Flag then library._flagSetters[Info.Flag] = setValue end
                task.defer(function() pcall(Info.Callback, val) end)
            end

            function sectionApi:Dropdown(Info)
                Info = Info or {}
                local list = Info.List or {}
                local opened = false
                local dropH = 28
                local th2 = GetTheme()
                local savedSizes = {}

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), ClipsDescendants = false, Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Dropdown",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 4, 0, 0), Parent = row,
                })
                local arrow = Create("TextLabel", {
                    BackgroundTransparency = 1, Text = "›", Font = Enum.Font.GothamBold,
                    TextColor3 = th2.TextMuted, TextSize = 14, Rotation = 90,
                    Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -16, 0, 7), Parent = row,
                })
                local container = Create("Frame", {
                    BackgroundColor3 = th2.Surface, BackgroundTransparency = 1,
                    ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 28), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = container })
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })

                local selectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Info.Default or "Select...",
                    TextColor3 = th2.TextMuted, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -8, 0, 28), Position = UDim2.new(0, 8, 0, 0), Parent = row,
                })

                local headerBtn = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 28), ZIndex = 3, Parent = row })

                local trackerIdx = #library._dropdownTracker + 1
                library._dropdownTracker[trackerIdx] = {
                    isOpened = function() return opened end,
                    close = function()
                        if not opened then return end
                        opened = false
                        Tween(row, { Size = UDim2.new(1, 0, 0, 28) }, 0.2)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, 0.2)
                        Tween(arrow, { Rotation = 90 }, 0.2)
                        resizeSection()
                    end,
                }

                local api = {}
                function api:Add(text)
                    dropH += 26
                    local opt = Create("TextButton", {
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text,
                        TextColor3 = th2.TextMuted, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 26), Parent = container,
                    })
                    opt.MouseEnter:Connect(function() Tween(opt, { TextColor3 = GetTheme().Text }, 0.1) end)
                    opt.MouseLeave:Connect(function() Tween(opt, { TextColor3 = GetTheme().TextMuted }, 0.1) end)
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
                    dropH = 28
                    for _, v in (d.List or list) do api:Add(v) end
                end

                for _, v in list do api:Add(v) end

                headerBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        for _, tr in pairs(library._dropdownTracker) do
                            if tr.isOpened() and tr.close ~= library._dropdownTracker[trackerIdx].close then
                                tr.close()
                            end
                        end
                    end
                    local targetH = opened and dropH or 28
                    Tween(row, { Size = UDim2.new(1, 0, 0, 28 + (opened and dropH - 28 or 0)) }, 0.22, Enum.EasingStyle.Quint)
                    Tween(container, {
                        Size = UDim2.new(1, 0, 0, targetH),
                        BackgroundTransparency = opened and 0.05 or 1,
                    }, 0.22, Enum.EasingStyle.Quint)
                    Tween(arrow, { Rotation = opened and -90 or 90, TextColor3 = opened and GetTheme().Accent or GetTheme().TextMuted }, 0.22)
                    resizeSection()
                end)

                if Info.Flag then
                    library._flagSetters[Info.Flag] = function(v)
                        selectedLabel.Text = tostring(v)
                        pcall(Info.Callback, v)
                    end
                end
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
                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), Parent = sectionFrame })
                local outer = Create("Frame", {
                    BackgroundColor3 = th2.Surface, Size = UDim2.new(1, -8, 0, 22),
                    Position = UDim2.new(0, 4, 0, 3), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = outer })
                Create("UIStroke", { Color = th2.Border, Parent = outer })
                local box = Create("TextBox", {
                    BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "",
                    PlaceholderText = Info.Placeholder or "Input...", PlaceholderColor3 = th2.TextMuted,
                    TextColor3 = th2.Text, TextSize = 11, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 6, 0, 0), Parent = outer,
                })
                box.FocusLost:Connect(function()
                    if Info.Flag then library.Flags[Info.Flag] = box.Text end
                    task.spawn(function() pcall(Info.Callback, box.Text) end)
                end)
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

                local row = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), Parent = sectionFrame })
                Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Info.Text or "Keybind",
                    TextColor3 = th2.Text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 4, 0, 0), Parent = row,
                })
                local keyFrame = Create("Frame", {
                    BackgroundColor3 = th2.SurfaceAlt, Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -40, 0.5, -9), Parent = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyFrame })
                local keyText = Create("TextLabel", {
                    BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
                    Text = pressKey == Enum.KeyCode.Unknown and "—" or pressKey.Name,
                    TextColor3 = th2.Text, TextSize = 9, Size = UDim2.new(1, 0, 1, 0), Parent = keyFrame,
                })
                local keyBtn = Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0), Parent = keyFrame })

                local conn
                keyBtn.MouseButton1Click:Connect(function()
                    if conn then conn:Disconnect() end
                    changing = true
                    library.ChangingKeybind = true
                    keyText.Text = "..."
                    conn = UserInputService.InputBegan:Connect(function(k)
                        if k.UserInputType == Enum.UserInputType.MouseMovement then return end
                        conn:Disconnect()
                        if k.KeyCode == Enum.KeyCode.Escape then
                            pressKey = Enum.KeyCode.Unknown
                            pressInputType = nil
                            keyText.Text = "—"
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
                            library.Flags[Info.Flag] = { Key = keyText.Text == "—" and "" or keyText.Text, Mode = mode }
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

--[[RunKeySystem(function()
    local Win = library:Window({ Text = "Lunx Advanced" })

    local SettingsTab = Win:Tab({ Text = "Hub Settings" })
    SettingsTab:Select()

    local themeSection = SettingsTab:Section({ Text = "Appearance", Side = "Left" })
    themeSection:ThemeDropdown({ Text = "UI Theme", Flag = "SelectedTheme" })
    themeSection:CountDropdown({
        Text = "Hub Module",
        Modules = { "Hub Alpha", "Hub Beta", "Hub Gamma" },
        Default = "Hub Alpha",
        Flag = "ActiveHub",
        Callback = function(name) print("[Lunx] Switched to:", name) end,
    })

    library:ApplyTheme(ActiveThemeName)
    library:SwitchModule("Hub Alpha")
end)]]





return library
