--[[
    TopbarPlus Extended v1.3
    Fix: background icon bị mất — giờ có dark bg mặc định
    Thêm: inner button glow, image background, style đẹp hơn
]]

local BASE_URL = "https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus.lua"
local tp   = loadstring(game:HttpGet(BASE_URL))()
local Icon = tp.get()
assert(Icon, "[TopbarPlusEx] Failed to load TopbarPlus!")

local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")

-- ─────────────────────────────────────────────────────────────
-- DEFAULT STYLE — áp dụng ngay khi load
-- Fix lỗi background bị transparent
-- ─────────────────────────────────────────────────────────────
Icon.modifyBaseTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(15, 15, 18)},
    {"Widget",      "BackgroundTransparency", 0.15},   -- hơi trong, không đặc hoàn toàn
    {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
    {"IconGradient","Enabled",                false},
    {"IconLabel",   "TextColor3",             Color3.fromRGB(230, 230, 230)},
    {"IconLabel",   "TextSize",               14},
})

-- ─────────────────────────────────────────────────────────────
-- INTERNAL HELPERS
-- ─────────────────────────────────────────────────────────────
local function getButton(icon)
    local w = icon.widget
    return w and w:FindFirstChild("IconButton", true)
end

local function getWidget(icon)
    return icon.widget
end

-- Tạo inner background frame (nút nhỏ sáng hơn bên trong)
local function makeInnerBg(parent, config)
    config = config or {}
    local color  = config.color  or Color3.fromRGB(40, 40, 50)
    local alpha  = config.alpha  or 0.35
    local radius = config.radius or 8
    local pad    = config.pad    or 4

    local frame = Instance.new("Frame")
    frame.Name                  = "InnerBg"
    frame.BackgroundColor3      = color
    frame.BackgroundTransparency = alpha
    frame.BorderSizePixel       = 0
    frame.ZIndex                = parent.ZIndex + 1
    frame.AnchorPoint           = Vector2.new(0.5, 0.5)
    frame.Position              = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size                  = UDim2.new(1, -pad * 2, 1, -pad * 2)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = frame

    -- Subtle gradient inside
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(70, 70, 85)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(20, 20, 28)),
    })
    grad.Rotation = 90
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0.7),
    })
    grad.Parent = frame

    frame.Parent = parent
    return frame
end

-- Tạo image background (ảnh mờ phía sau)
local function makeImageBg(parent, imageId, alpha)
    alpha = alpha or 0.75
    local img = Instance.new("ImageLabel")
    img.Name                   = "BgImage"
    img.BackgroundTransparency = 1
    img.Image                  = type(imageId) == "number"
        and ("rbxassetid://" .. tostring(imageId))
        or tostring(imageId)
    img.ImageTransparency      = alpha
    img.ScaleType              = Enum.ScaleType.Crop
    img.Size                   = UDim2.new(1, 0, 1, 0)
    img.ZIndex                 = parent.ZIndex
    img.AnchorPoint            = Vector2.new(0.5, 0.5)
    img.Position               = UDim2.new(0.5, 0, 0.5, 0)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = img

    img.Parent = parent
    return img
end

-- ─────────────────────────────────────────────────────────────
local Ex = {}

-- ═══════════════════════════════════════════════════════════
-- [1] applyStyle — Style đẹp cho bất kỳ icon nào
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.applyStyle(icon, config?)

    Áp dụng visual style đẹp: outer bg tối + inner bg sáng hơn
    + optional image background.

    config = {
        outerColor  : Color3?   — màu outer bg (default đen tối)
        outerAlpha  : number?   — transparency outer (default 0.15)
        innerColor  : Color3?   — màu inner bg (default xám tối)
        innerAlpha  : number?   — transparency inner (default 0.35)
        innerPad    : number?   — padding inner so với outer (default 4)
        innerRadius : number?   — bo góc inner (default 8)
        bgImage     : number?   — asset ID ảnh nền (optional)
        bgAlpha     : number?   — transparency ảnh nền (default 0.75)
        radius      : number?   — bo góc outer (default 10)
    }

    Returns: icon (chainable)

    Examples:
        Ex.applyStyle(icon)
        Ex.applyStyle(icon, {bgImage = 12345678, bgAlpha = 0.8})
        Ex.applyStyle(icon, {
            outerColor = Color3.fromRGB(10,10,20),
            outerAlpha = 0.1,
            innerColor = Color3.fromRGB(50,50,70),
            innerAlpha = 0.3,
        })
]]
function Ex.applyStyle(icon, config)
    config = config or {}

    local outerColor  = config.outerColor  or Color3.fromRGB(12, 12, 16)
    local outerAlpha  = config.outerAlpha  or 0.15
    local innerColor  = config.innerColor  or Color3.fromRGB(38, 38, 50)
    local innerAlpha  = config.innerAlpha  or 0.35
    local innerPad    = config.innerPad    or 4
    local innerRadius = config.innerRadius or 8
    local bgImage     = config.bgImage
    local bgAlpha     = config.bgAlpha     or 0.75
    local radius      = config.radius      or 10

    -- Outer widget bg
    icon:modifyTheme({
        {"Widget",      "BackgroundColor3",       outerColor},
        {"Widget",      "BackgroundTransparency", outerAlpha},
        {"IconCorners", "CornerRadius",           UDim.new(0, radius)},
        {"IconGradient","Enabled",                false},
    })

    task.defer(function()
        local btn = getButton(icon)
        if not btn then return end

        -- Remove old style elements
        for _, v in ipairs(btn:GetChildren()) do
            if v.Name == "InnerBg" or v.Name == "BgImage" then
                v:Destroy()
            end
        end

        -- Optional image background (behind everything)
        if bgImage then
            makeImageBg(btn, bgImage, bgAlpha)
        end

        -- Inner bright background
        makeInnerBg(btn, {
            color  = innerColor,
            alpha  = innerAlpha,
            radius = innerRadius,
            pad    = innerPad,
        })
    end)

    return icon
end

-- ═══════════════════════════════════════════════════════════
-- [2] WATERMARK — Real-time, không ảnh hưởng icon khác
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.watermark(config)

    config = {
        text     : string?    — text tĩnh hoặc có {fps}/{time}/{ping}/{player}
        imageId  : number?    — asset ID (optional)
        align    : string?    — "Left"|"Center"|"Right" (default "Right")
        color    : Color3?    — màu chữ
        size     : number?    — font size (default 13)
        realtime : bool?      — tự update
        interval : number?    — giây giữa update (default 1)
        format   : function?  — hàm tùy chỉnh trả về string
        bg       : bool?      — có background không (default false, watermark trong suốt)
    }

    Returns: { icon, setText, setColor, setSize, setFormat, stop, start, destroy }
]]
function Ex.watermark(config)
    config = config or {}
    local text     = config.text     or ""
    local imageId  = config.imageId
    local align    = config.align    or "Right"
    local color    = config.color    or Color3.fromRGB(200, 200, 200)
    local size     = config.size     or 13
    local realtime = config.realtime or false
    local interval = config.interval or 1
    local formatFn = config.format
    local hasBg    = config.bg       or false

    local icon = Icon.new()
        :lock()
        :disableStateOverlay(true)
        :align(align)

    if imageId then icon:setImage(imageId) end

    -- Block click interaction
    task.defer(function()
        local cr = icon:getInstance("ClickRegion")
        if cr then
            cr.AutoButtonColor = false
            cr.Active          = false
            cr.Selectable      = false
        end
    end)

    if hasBg then
        -- Watermark với background nhẹ
        icon:modifyTheme({
            {"Widget",       "BackgroundColor3",       Color3.fromRGB(15, 15, 18)},
            {"Widget",       "BackgroundTransparency", 0.3},
            {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
            {"IconGradient", "Enabled",                false},
            {"IconLabel",    "TextColor3",             color},
            {"IconLabel",    "TextSize",               size},
        })
    else
        -- Watermark trong suốt hoàn toàn (chỉ chữ)
        icon:modifyTheme({
            {"Widget",       "BackgroundTransparency", 1},
            {"IconButton",   "BackgroundTransparency", 1},
            {"IconGradient", "Enabled",                false},
            {"IconLabel",    "TextColor3",             color},
            {"IconLabel",    "TextSize",               size},
        })
    end

    -- FPS smoother
    local lastFPS = 60
    local fpsConn = RunService.RenderStepped:Connect(function(dt)
        lastFPS = math.floor(0.9 * lastFPS + 0.1 * (1 / dt))
    end)

    local function resolveFast(str)
        if not str then return "" end
        str = str:gsub("{fps}",    tostring(lastFPS))
        str = str:gsub("{time}",   os.date("%H:%M:%S"))
        str = str:gsub("{player}", game.Players.LocalPlayer.Name)
        local ok, ping = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        str = str:gsub("{ping}", ok and tostring(math.floor(ping)) or "?")
        return str
    end

    -- Initial label
    icon:setLabel(formatFn and formatFn() or resolveFast(text))

    -- Realtime loop
    local running = true
    local loopThread

    local function startLoop()
        running = true
        loopThread = task.spawn(function()
            while running do
                task.wait(interval)
                if not running then break end
                icon:setLabel(formatFn and formatFn() or resolveFast(text))
            end
        end)
    end

    if realtime or formatFn then startLoop() end

    local wm = {}
    wm.icon = icon

    function wm.setText(t)  text = t; icon:setLabel(resolveFast(t)) end
    function wm.setFormat(fn) formatFn = fn; icon:setLabel(fn()) end
    function wm.setColor(c) icon:modifyTheme({{"IconLabel","TextColor3",c}}) end
    function wm.setSize(s)  icon:modifyTheme({{"IconLabel","TextSize",s}}) end

    function wm.stop()
        running = false
        pcall(function() fpsConn:Disconnect() end)
        if loopThread then pcall(task.cancel, loopThread) end
    end

    function wm.start()
        if not running then
            fpsConn = RunService.RenderStepped:Connect(function(dt)
                lastFPS = math.floor(0.9 * lastFPS + 0.1 * (1 / dt))
            end)
            startLoop()
        end
    end

    function wm.destroy()
        wm.stop()
        icon:destroy()
    end

    return wm
end

-- ═══════════════════════════════════════════════════════════
-- [3] HIGHLIGHT
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.highlight(icon, config?)
    config = { style, color, thickness, animated }
    styles: "border" | "glow" | "premium" | "accent"
    Ex.removeHighlight(icon)
]]
function Ex.highlight(icon, config)
    config = config or {}
    local style     = config.style     or "border"
    local color     = config.color     or Color3.fromRGB(255, 255, 255)
    local thickness = config.thickness or 2
    local animated  = config.animated  or false

    task.defer(function()
        local btn = getButton(icon)
        if not btn then return end

        for _, v in ipairs(btn:GetChildren()) do
            if v.Name:find("HighlightStroke") or v.Name == "HighlightGradient" then
                v:Destroy()
            end
        end

        if style == "border" then
            local s = Instance.new("UIStroke")
            s.Name = "HighlightStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = color; s.Thickness = thickness; s.Transparency = 0
            s.Parent = btn

        elseif style == "glow" then
            local outer = Instance.new("UIStroke")
            outer.Name = "HighlightStrokeOuter"
            outer.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            outer.Color = color; outer.Thickness = thickness + 2
            outer.Transparency = 0.3; outer.Parent = btn

            local inner = Instance.new("UIStroke")
            inner.Name = "HighlightStroke"
            inner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            inner.Color = color; inner.Thickness = thickness
            inner.Transparency = 0; inner.Parent = btn

            if animated then
                task.spawn(function()
                    local t = 0
                    while btn and btn.Parent do
                        t += task.wait(0.05)
                        outer.Transparency = 0.3 + ((math.sin(t * 2) + 1) / 2) * 0.5
                    end
                end)
            end

        elseif style == "premium" then
            local s = Instance.new("UIStroke")
            s.Name = "HighlightStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = Color3.fromRGB(255, 215, 0)
            s.Thickness = thickness; s.Transparency = 0; s.Parent = btn

            local g = Instance.new("UIGradient")
            g.Name = "HighlightGradient"
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 215, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 0)),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 215, 0)),
            })
            g.Rotation = 45
            g.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,   0.7),
                NumberSequenceKeypoint.new(0.5, 0.5),
                NumberSequenceKeypoint.new(1,   0.7),
            })
            g.Parent = btn

            if animated then
                task.spawn(function()
                    while btn and btn.Parent do
                        task.wait(0.03)
                        g.Rotation = (g.Rotation + 1) % 360
                    end
                end)
            end

            icon:modifyTheme({
                {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 22, 5)},
                {"Widget", "BackgroundTransparency", 0.1},
            })

        elseif style == "accent" then
            local s = Instance.new("UIStroke")
            s.Name = "HighlightStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = color; s.Thickness = thickness
            s.Transparency = 0; s.Parent = btn

            icon:modifyTheme({
                {"Widget", "BackgroundColor3", Color3.fromRGB(
                    math.clamp(math.round(color.R * 25), 8, 50),
                    math.clamp(math.round(color.G * 25), 8, 50),
                    math.clamp(math.round(color.B * 25), 8, 50)
                )},
                {"Widget", "BackgroundTransparency", 0.1},
            })
        end
    end)

    return icon
end

function Ex.removeHighlight(icon)
    task.defer(function()
        local btn = getButton(icon)
        if not btn then return end
        for _, v in ipairs(btn:GetChildren()) do
            if v.Name:find("HighlightStroke") or v.Name == "HighlightGradient" then
                v:Destroy()
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- [4] MENU + DROPDOWN COMBO
-- ═══════════════════════════════════════════════════════════
function Ex.menuWithDropdowns(config)
    config = config or {}
    local label   = config.label        or "Menu"
    local align   = config.align        or "Left"
    local maxMenu = config.maxMenuIcons or 4
    local items   = config.items        or {}
    local hl      = config.highlight

    local menuItems = {}
    for _, item in ipairs(items) do
        local child = Icon.new():setLabel(item.label or "Item")
        if item.image then child:setImage(item.image) end
        if item.dropdown then
            local dd = item.dropdown
            child:modifyTheme({{"Dropdown","MaxIcons", dd.maxIcons or 5}})
                 :modifyChildTheme({{"Widget","MinimumWidth", dd.minWidth or 160}})
                 :setDropdown(dd.items or {})
        elseif item.onSelect then
            child.selected:Connect(item.onSelect)
        end
        table.insert(menuItems, child)
    end

    local parent = Icon.new()
        :setLabel(label)
        :align(align)
        :modifyTheme({
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(12, 12, 16)},
            {"Widget",      "BackgroundTransparency", 0.12},
            {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
            {"IconGradient","Enabled",                false},
            {"Menu",        "MaxIcons",               maxMenu},
        })
        :modifyChildTheme({
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(18, 18, 24)},
            {"Widget",      "BackgroundTransparency", 0.12},
            {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
            {"IconGradient","Enabled",                false},
        })
        :setMenu(menuItems)

    if hl then Ex.highlight(parent, hl) end

    return parent
end

-- ═══════════════════════════════════════════════════════════
-- [5] NATIVE OVERRIDE
-- ═══════════════════════════════════════════════════════════
function Ex.setNativeOverride(mode)
    if mode == "hide" then
        local ok, err = pcall(function()
            game:GetService("StarterGui"):SetCore("TopbarEnabled", false)
        end)
        if not ok then warn("[TopbarPlusEx] setNativeOverride hide failed:", err) end
    end
end

-- ═══════════════════════════════════════════════════════════
-- [6] SEPARATOR
-- ═══════════════════════════════════════════════════════════
function Ex.separator(width, align)
    return Icon.new()
        :setWidth(width or 10)
        :lock()
        :disableStateOverlay(true)
        :align(align or "Left")
        :modifyTheme({
            {"Widget",      "BackgroundTransparency", 1},
            {"IconButton",  "BackgroundTransparency", 1},
            {"IconGradient","Enabled",                false},
        })
end

-- ─────────────────────────────────────────────────────────────
-- THEME PRESETS
-- ─────────────────────────────────────────────────────────────
--[[
    Dùng với:
        Icon.modifyBaseTheme(tpx.Presets.dark)
        icon:modifyTheme(tpx.Presets.glass)

    dark    — đen tối, bo góc 10
    light   — trắng sáng
    glass   — trong mờ
    gold    — vàng
    deep    — xanh đen đậm
    neon    — đen + text neon xanh
]]
local Presets = {
    dark = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(15, 15, 18)},
        {"Widget",      "BackgroundTransparency", 0.15},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(225, 225, 225)},
    },
    light = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(235, 235, 240)},
        {"Widget",      "BackgroundTransparency", 0.05},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(30, 30, 30)},
    },
    glass = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(200, 200, 220)},
        {"Widget",      "BackgroundTransparency", 0.6},
        {"IconCorners", "CornerRadius",           UDim.new(0, 12)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(255, 255, 255)},
    },
    gold = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(35, 25, 5)},
        {"Widget",      "BackgroundTransparency", 0.1},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(255, 215, 0)},
    },
    deep = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(8, 12, 22)},
        {"Widget",      "BackgroundTransparency", 0.1},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(180, 210, 255)},
    },
    neon = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(5, 5, 5)},
        {"Widget",      "BackgroundTransparency", 0.05},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(0, 255, 180)},
    },
}

return { Icon = Icon, Ex = Ex, Presets = Presets }
