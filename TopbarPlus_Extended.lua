--[[
╔══════════════════════════════════════════════════════════╗
║         TopbarPlus Extended v1.4 — Executor Build        ║
║  Core source: TopbarPlus.lua (bundled from same repo)    ║
║  Fixes: {fps} placeholder in format fn, clean style      ║
╚══════════════════════════════════════════════════════════╝

USAGE:
    local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
    local Icon = tpx.Icon
    local Ex   = tpx.Ex
    local Pre  = tpx.Presets
]]

-- ─────────────────────────────────────────────────────────────
-- LOAD CORE (bundled from same repo — no separate load needed)
-- ─────────────────────────────────────────────────────────────
local _CORE_URL = "https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus.lua"

local _ok, _result = pcall(function()
    return loadstring(game:HttpGet(_CORE_URL))()
end)

if not _ok or not _result then
    error("[TopbarPlus Extended] Failed to load Core from: " .. _CORE_URL .. "\nError: " .. tostring(_result))
end

local Icon = _result.get()
assert(Icon, "[TopbarPlus Extended] tp.get() returned nil — core bundle may be broken")

-- ─────────────────────────────────────────────────────────────
-- SERVICES
-- ─────────────────────────────────────────────────────────────
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local Stats        = game:GetService("Stats")
local StarterGui   = game:GetService("StarterGui")
local LocalPlayer  = Players.LocalPlayer

-- ─────────────────────────────────────────────────────────────
-- DEFAULT BASE THEME — áp ngay khi load Extended
-- Đảm bảo tất cả icons đều có background
-- ─────────────────────────────────────────────────────────────
Icon.modifyBaseTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(14, 14, 18)},
    {"Widget",      "BackgroundTransparency", 0.12},
    {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
    {"IconGradient","Enabled",                false},
    {"IconLabel",   "TextColor3",             Color3.fromRGB(228, 228, 228)},
    {"IconLabel",   "TextSize",               14},
})

-- ─────────────────────────────────────────────────────────────
-- INTERNAL HELPERS
-- ─────────────────────────────────────────────────────────────
local function _getBtn(icon)
    local w = icon.widget
    return w and w:FindFirstChild("IconButton", true)
end

-- Shared FPS sampler — single RenderStepped for whole module
local _fps = 60
RunService.RenderStepped:Connect(function(dt)
    _fps = math.floor(0.9 * _fps + 0.1 * (1 / dt))
end)

-- Ping sampler
local _ping = 0
task.spawn(function()
    while true do
        task.wait(2)
        local ok, v = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok then _ping = math.floor(v) end
    end
end)

-- Resolve placeholders in a string
local function _resolve(str)
    if not str then return "" end
    str = str:gsub("{fps}",    tostring(_fps))
    str = str:gsub("{ping}",   tostring(_ping))
    str = str:gsub("{time}",   os.date("%H:%M:%S"))
    str = str:gsub("{player}", LocalPlayer.Name)
    return str
end

-- ─────────────────────────────────────────────────────────────
local Ex = {}

-- ═══════════════════════════════════════════════════════════
-- [1] WATERMARK
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.watermark(config) → WatermarkObject

    config = {
        text     : string?    -- static text hoặc có {fps}/{time}/{ping}/{player}
        format   : function?  -- function() return string end (ưu tiên hơn text)
        imageId  : number?    -- asset ID ảnh kèm theo
        align    : string?    -- "Left"|"Center"|"Right" (default "Right")
        color    : Color3?    -- màu chữ
        size     : number?    -- font size (default 13)
        realtime : bool?      -- tự cập nhật (default false)
        interval : number?    -- giây giữa update (default 1)
        bg       : bool?      -- có background nhẹ không (default false = trong suốt)
    }

    WatermarkObject = {
        icon      : Icon         -- icon gốc (full API available)
        setText   : fn(string)   -- đổi text ngay
        setFormat : fn(function) -- đổi format function
        setColor  : fn(Color3)   -- đổi màu chữ
        setSize   : fn(number)   -- đổi cỡ chữ
        stop      : fn()         -- dừng realtime
        start     : fn()         -- chạy lại realtime
        destroy   : fn()         -- xóa hoàn toàn
    }

    Placeholders:
        {fps}    → FPS hiện tại (smooth)
        {ping}   → Ping ms
        {time}   → HH:MM:SS
        {player} → tên player

    Examples:
        -- Static
        Ex.watermark({text = "v1.0 | Script"})

        -- Real-time FPS + time
        Ex.watermark({
            text     = "v1.0 | FPS: {fps} | {time}",
            realtime = true,
            interval = 1,
        })

        -- Custom format (placeholders CŨNG hoạt động trong format fn)
        local kills = 0
        local wm = Ex.watermark({
            realtime = true,
            format   = function()
                return string.format("v1.0 | Kills: %d | FPS: {fps}", kills)
            end,
        })

        -- Update runtime
        wm.setText("v2.0 | Updated!")
        wm.setColor(Color3.fromRGB(255, 215, 0))
        wm.stop()
        wm.start()
        wm.destroy()
]]
function Ex.watermark(config)
    config = config or {}

    local text     = config.text     or ""
    local formatFn = config.format
    local imageId  = config.imageId
    local align    = config.align    or "Right"
    local color    = config.color    or Color3.fromRGB(210, 210, 210)
    local size     = config.size     or 13
    local realtime = config.realtime or false
    local interval = config.interval or 1
    local hasBg    = config.bg       or false

    local icon = Icon.new()
        :lock()
        :disableStateOverlay(true)
        :align(align)

    if imageId then icon:setImage(imageId) end

    -- Block input
    task.defer(function()
        local cr = icon:getInstance("ClickRegion")
        if cr then
            cr.AutoButtonColor = false
            cr.Active          = false
            cr.Selectable      = false
        end
    end)

    -- Style: bg hoặc trong suốt
    if hasBg then
        icon:modifyTheme({
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(14, 14, 18)},
            {"Widget",      "BackgroundTransparency", 0.25},
            {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
            {"IconGradient","Enabled",                false},
            {"IconLabel",   "TextColor3",             color},
            {"IconLabel",   "TextSize",               size},
        })
    else
        -- Chỉ chữ, không có background — nhưng không ảnh hưởng icon khác
        task.defer(function()
            local btn = _getBtn(icon)
            if btn then
                btn.BackgroundTransparency = 1
                -- Remove gradient nếu có
                local grad = btn:FindFirstChildOfClass("UIGradient")
                if grad then grad.Enabled = false end
            end
            -- Widget container cũng trong suốt
            local w = icon.widget
            if w then w.BackgroundTransparency = 1 end
        end)
        icon:modifyTheme({
            {"IconLabel","TextColor3", color},
            {"IconLabel","TextSize",   size},
        })
    end

    -- Compute label text (resolve placeholders — kể cả output của formatFn)
    local function computeLabel()
        local raw = formatFn and formatFn() or text
        return _resolve(raw)   -- FIX: luôn resolve dù từ format hay text
    end

    -- Set initial
    icon:setLabel(computeLabel())

    -- Realtime loop
    local running = false
    local loopThread

    local function startLoop()
        running = true
        loopThread = task.spawn(function()
            while running do
                task.wait(interval)
                if not running then break end
                icon:setLabel(computeLabel())
            end
        end)
    end

    if realtime or formatFn then startLoop() end

    -- Public object
    local wm = {}
    wm.icon = icon

    function wm.setText(t)
        text = t
        formatFn = nil  -- clear format fn khi set text
        icon:setLabel(_resolve(t))
    end

    function wm.setFormat(fn)
        formatFn = fn
        icon:setLabel(computeLabel())
    end

    function wm.setColor(c)
        icon:modifyTheme({{"IconLabel","TextColor3",c}})
    end

    function wm.setSize(s)
        icon:modifyTheme({{"IconLabel","TextSize",s}})
    end

    function wm.stop()
        running = false
        if loopThread then pcall(task.cancel, loopThread) end
    end

    function wm.start()
        if not running then startLoop() end
    end

    function wm.destroy()
        wm.stop()
        icon:destroy()
    end

    return wm
end

-- ═══════════════════════════════════════════════════════════
-- [2] APPLY STYLE — outer bg + inner bright button
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.applyStyle(icon, config?) → icon

    Áp dụng visual đẹp:
    - Outer: frame tối mờ
    - Inner: frame nhỏ hơn sáng hơn tạo hiệu ứng "nút nổi"
    - Optional: ảnh nền mờ phía sau

    config = {
        outerColor  : Color3?   default (12,12,16)
        outerAlpha  : number?   default 0.12
        innerColor  : Color3?   default (42,42,55)
        innerAlpha  : number?   default 0.30
        innerPad    : number?   default 5
        innerRadius : number?   default 8
        radius      : number?   default 10
        bgImage     : number?   asset ID (optional)
        bgAlpha     : number?   default 0.78
    }
]]
function Ex.applyStyle(icon, config)
    config = config or {}
    local outerColor  = config.outerColor  or Color3.fromRGB(12, 12, 16)
    local outerAlpha  = config.outerAlpha  or 0.12
    local innerColor  = config.innerColor  or Color3.fromRGB(42, 42, 55)
    local innerAlpha  = config.innerAlpha  or 0.30
    local innerPad    = config.innerPad    or 5
    local innerRadius = config.innerRadius or 8
    local radius      = config.radius      or 10
    local bgImage     = config.bgImage
    local bgAlpha     = config.bgAlpha     or 0.78

    icon:modifyTheme({
        {"Widget",      "BackgroundColor3",       outerColor},
        {"Widget",      "BackgroundTransparency", outerAlpha},
        {"IconCorners", "CornerRadius",           UDim.new(0, radius)},
        {"IconGradient","Enabled",                false},
    })

    task.defer(function()
        local btn = _getBtn(icon)
        if not btn then return end

        -- Clean old
        for _, v in ipairs(btn:GetChildren()) do
            if v.Name == "ExInnerBg" or v.Name == "ExBgImage" then
                v:Destroy()
            end
        end

        -- Background image (lowest layer)
        if bgImage then
            local img = Instance.new("ImageLabel")
            img.Name                   = "ExBgImage"
            img.BackgroundTransparency = 1
            img.Image                  = "rbxassetid://" .. tostring(bgImage)
            img.ImageTransparency      = bgAlpha
            img.ScaleType              = Enum.ScaleType.Crop
            img.Size                   = UDim2.new(1, 0, 1, 0)
            img.ZIndex                 = btn.ZIndex
            img.AnchorPoint            = Vector2.new(0.5, 0.5)
            img.Position               = UDim2.new(0.5, 0, 0.5, 0)
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, radius)
            img.Parent = btn
        end

        -- Inner bright frame (nút nổi)
        local inner = Instance.new("Frame")
        inner.Name                   = "ExInnerBg"
        inner.BackgroundColor3       = innerColor
        inner.BackgroundTransparency = innerAlpha
        inner.BorderSizePixel        = 0
        inner.ZIndex                 = btn.ZIndex + 1
        inner.AnchorPoint            = Vector2.new(0.5, 0.5)
        inner.Position               = UDim2.new(0.5, 0, 0.5, 0)
        inner.Size                   = UDim2.new(1, -innerPad*2, 1, -innerPad*2)

        local ic = Instance.new("UICorner")
        ic.CornerRadius = UDim.new(0, innerRadius)
        ic.Parent = inner

        -- Inner subtle gradient
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(80, 80, 100)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(18, 18, 26)),
        })
        g.Rotation    = 90
        g.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0.55),
            NumberSequenceKeypoint.new(1,   0.72),
        })
        g.Parent = inner
        inner.Parent = btn
    end)

    return icon
end

-- ═══════════════════════════════════════════════════════════
-- [3] HIGHLIGHT
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.highlight(icon, config?) → icon
    Ex.removeHighlight(icon)

    config = {
        style     : "border"|"glow"|"premium"|"accent"  (default "border")
        color     : Color3   (default trắng)
        thickness : number   (default 2)
        animated  : bool     (default false)
    }
]]
function Ex.highlight(icon, config)
    config    = config or {}
    local style     = config.style     or "border"
    local color     = config.color     or Color3.fromRGB(255, 255, 255)
    local thickness = config.thickness or 2
    local animated  = config.animated  or false

    task.defer(function()
        local btn = _getBtn(icon)
        if not btn then return end

        -- Remove old
        for _, v in ipairs(btn:GetChildren()) do
            if v.Name:find("_HLStroke") or v.Name == "_HLGrad" then v:Destroy() end
        end

        if style == "border" then
            local s          = Instance.new("UIStroke")
            s.Name           = "_HLStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color           = color
            s.Thickness       = thickness
            s.Transparency    = 0
            s.Parent          = btn

        elseif style == "glow" then
            local so         = Instance.new("UIStroke")
            so.Name          = "_HLStrokeOuter"
            so.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            so.Color          = color
            so.Thickness      = thickness + 2
            so.Transparency   = 0.35
            so.Parent         = btn

            local si         = Instance.new("UIStroke")
            si.Name          = "_HLStroke"
            si.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            si.Color          = color
            si.Thickness      = thickness
            si.Transparency   = 0
            si.Parent         = btn

            if animated then
                task.spawn(function()
                    local t = 0
                    while btn and btn.Parent do
                        t += task.wait(0.05)
                        so.Transparency = 0.3 + ((math.sin(t * 2) + 1) * 0.5) * 0.45
                    end
                end)
            end

        elseif style == "premium" then
            local s          = Instance.new("UIStroke")
            s.Name           = "_HLStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color           = Color3.fromRGB(255, 215, 0)
            s.Thickness       = thickness
            s.Transparency    = 0
            s.Parent          = btn

            local g     = Instance.new("UIGradient")
            g.Name      = "_HLGrad"
            g.Color     = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 220, 60)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 0)),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 220, 60)),
            })
            g.Rotation   = 45
            g.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,   0.65),
                NumberSequenceKeypoint.new(0.5, 0.45),
                NumberSequenceKeypoint.new(1,   0.65),
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
                {"Widget","BackgroundColor3",       Color3.fromRGB(32, 22, 4)},
                {"Widget","BackgroundTransparency", 0.1},
            })

        elseif style == "accent" then
            local s          = Instance.new("UIStroke")
            s.Name           = "_HLStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color           = color
            s.Thickness       = thickness
            s.Transparency    = 0
            s.Parent          = btn

            local r = math.clamp(math.round(color.R * 22), 6, 45)
            local g2 = math.clamp(math.round(color.G * 22), 6, 45)
            local b  = math.clamp(math.round(color.B * 22), 6, 45)

            icon:modifyTheme({
                {"Widget","BackgroundColor3",       Color3.fromRGB(r, g2, b)},
                {"Widget","BackgroundTransparency", 0.1},
            })
        end
    end)

    return icon
end

function Ex.removeHighlight(icon)
    task.defer(function()
        local btn = _getBtn(icon)
        if not btn then return end
        for _, v in ipairs(btn:GetChildren()) do
            if v.Name:find("_HLStroke") or v.Name == "_HLGrad" then v:Destroy() end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- [4] MENU + DROPDOWN COMBO
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.menuWithDropdowns(config) → Icon

    config = {
        label        : string
        align        : "Left"|"Center"|"Right"  (default "Left")
        maxMenuIcons : number  (default 4)
        highlight    : table?  config cho Ex.highlight
        items : array of {
            label    : string
            image    : number|string?
            onSelect : function?       -- nút đơn
            dropdown : {               -- nếu có → mở dropdown dọc
                maxIcons : number?     (default 5)
                minWidth : number?     (default 160)
                items    : Icon[]
            }?
        }
    }
]]
function Ex.menuWithDropdowns(config)
    config    = config or {}
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
            {"Widget",      "BackgroundTransparency", 0.1},
            {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
            {"IconGradient","Enabled",                false},
            {"Menu",        "MaxIcons",               maxMenu},
        })
        :modifyChildTheme({
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(18, 18, 24)},
            {"Widget",      "BackgroundTransparency", 0.1},
            {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
            {"IconGradient","Enabled",                false},
        })
        :setMenu(menuItems)

    if hl then Ex.highlight(parent, hl) end
    return parent
end

-- ═══════════════════════════════════════════════════════════
-- [5] SEPARATOR
-- ═══════════════════════════════════════════════════════════
function Ex.separator(width, align)
    local icon = Icon.new()
        :setWidth(width or 8)
        :lock()
        :disableStateOverlay(true)
        :align(align or "Left")

    task.defer(function()
        local btn = _getBtn(icon)
        if btn then btn.BackgroundTransparency = 1 end
        local w = icon.widget
        if w then w.BackgroundTransparency = 1 end
    end)

    icon:modifyTheme({{"IconGradient","Enabled",false}})
    return icon
end

-- ═══════════════════════════════════════════════════════════
-- [6] NATIVE OVERRIDE
-- ═══════════════════════════════════════════════════════════
function Ex.setNativeOverride(mode)
    if mode == "hide" then
        local ok, err = pcall(StarterGui.SetCore, StarterGui, "TopbarEnabled", false)
        if not ok then warn("[TopbarPlusEx] hide failed:", err) end
    end
    -- "dodge" = handled by TopbarPlus automatically
end

-- ─────────────────────────────────────────────────────────────
-- THEME PRESETS
-- ─────────────────────────────────────────────────────────────
--[[
    Dùng với:
        Icon.modifyBaseTheme(Pre.dark)   -- áp cho tất cả
        icon:modifyTheme(Pre.glass)      -- áp cho 1 icon
]]
local Presets = {
    -- Đen tối, rounded, sạch sẽ
    dark = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(14, 14, 18)},
        {"Widget",      "BackgroundTransparency", 0.12},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(228, 228, 228)},
    },
    -- Trắng sáng
    light = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(235, 235, 240)},
        {"Widget",      "BackgroundTransparency", 0.05},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(25, 25, 25)},
    },
    -- Kính mờ
    glass = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(200, 210, 230)},
        {"Widget",      "BackgroundTransparency", 0.58},
        {"IconCorners", "CornerRadius",           UDim.new(0, 12)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(255, 255, 255)},
    },
    -- Vàng premium
    gold = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(32, 22, 4)},
        {"Widget",      "BackgroundTransparency", 0.1},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(255, 215, 0)},
    },
    -- Xanh đen đậm
    deep = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(6, 10, 20)},
        {"Widget",      "BackgroundTransparency", 0.08},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(170, 205, 255)},
    },
    -- Đen + text neon xanh
    neon = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(4, 4, 6)},
        {"Widget",      "BackgroundTransparency", 0.05},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(0, 255, 180)},
    },
}

-- ─────────────────────────────────────────────────────────────
-- RETURN
-- ─────────────────────────────────────────────────────────────
return {
    Icon     = Icon,
    Ex       = Ex,
    Presets  = Presets,
    _version = "1.4",
}
