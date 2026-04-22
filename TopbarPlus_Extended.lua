--[[
    TopbarPlus Extended v1.2
    GitHub: https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua

    Tính năng:
      - Watermark (real-time update: text, fps, time, custom)
      - Highlight (border / glow / premium / accent + animation)
      - Menu + Dropdown combo
      - Native override
      - Separator
      - Theme Presets
]]

local BASE_URL = "https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus.lua"

local tp   = loadstring(game:HttpGet(BASE_URL))()
local Icon = tp.get()
assert(Icon, "[TopbarPlusEx] Failed to load TopbarPlus!")

-- ─────────────────────────────────────────────────────────────
-- INTERNAL
-- ─────────────────────────────────────────────────────────────
local function getButton(icon)
    local w = icon.widget
    return w and w:FindFirstChild("IconButton", true)
end

local Ex = {}

-- ═══════════════════════════════════════════════════════════
-- [1] WATERMARK — Real-time update support
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.watermark(config)

    config = {
        text      : string?    — static text. Có thể dùng {fps}, {time}, {ping} placeholders
        imageId   : number?    — asset ID (optional)
        align     : string?    — "Left"|"Center"|"Right" (default "Right")
        color     : Color3?    — màu chữ (default xám nhạt)
        size      : number?    — font size (default 14)
        realtime  : bool?      — bật live update (cần text có placeholder)
        interval  : number?    — giây giữa các update (default 1)
        format    : function?  — hàm tùy chỉnh trả về string, gọi mỗi interval
                                 format = function() return "Custom: " .. tostring(value) end
    }

    Placeholders trong text:
        {fps}    — FPS hiện tại
        {time}   — giờ:phút:giây
        {ping}   — ping hiện tại (ms)
        {player} — tên player

    Returns: Watermark object {
        icon     : Icon
        setText  : function(newText)    — đổi text ngay lập tức
        setColor : function(Color3)     — đổi màu chữ
        stop     : function()           — dừng realtime loop
        start    : function()           — chạy lại realtime loop
    }

    Examples:
        -- Static
        local wm = Ex.watermark({text = "v1.0 | MyScript"})

        -- Real-time FPS + time
        local wm = Ex.watermark({
            text     = "v1.0 | FPS: {fps} | {time}",
            realtime = true,
            interval = 0.5,
        })

        -- Custom format function
        local wm = Ex.watermark({
            realtime = true,
            format   = function()
                local plr = game.Players.LocalPlayer
                return string.format("v1.0 | %s | FPS: %d", plr.Name, math.floor(1/workspace:GetRealPhysicsFPS()))
            end,
        })

        -- Đổi text sau đó
        wm.setText("v2.0 | Updated!")
        wm.setColor(Color3.fromRGB(255, 215, 0))
        wm.stop()    -- dừng realtime
        wm.start()   -- chạy lại
]]
function Ex.watermark(config)
    config = config or {}
    local text     = config.text     or ""
    local imageId  = config.imageId
    local align    = config.align    or "Right"
    local color    = config.color    or Color3.fromRGB(200, 200, 200)
    local size     = config.size     or 14
    local realtime = config.realtime or false
    local interval = config.interval or 1
    local formatFn = config.format

    local icon = Icon.new()
        :lock()
        :disableStateOverlay(true)
        :align(align)

    if imageId then icon:setImage(imageId) end

    task.defer(function()
        local cr = icon:getInstance("ClickRegion")
        if cr then
            cr.AutoButtonColor = false
            cr.Active          = false
            cr.Selectable      = false
        end
    end)

    icon:modifyTheme({
        {"Widget",       "BackgroundTransparency", 1},
        {"IconButton",   "BackgroundTransparency", 1},
        {"IconGradient", "Enabled",                false},
        {"IconLabel",    "TextColor3",             color},
        {"IconLabel",    "TextSize",               size},
    })

    -- Placeholder resolver
    local function resolve(str)
        if not str then return "" end
        local rs = game:GetService("RunService")
        local fps = math.floor(1 / rs.RenderStepped:Wait())
        -- better fps: use last frame dt stored externally if possible
        str = str:gsub("{fps}",    tostring(fps))
        str = str:gsub("{time}",   os.date("%H:%M:%S"))
        str = str:gsub("{player}", game.Players.LocalPlayer.Name)
        local ok, ping = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        str = str:gsub("{ping}", ok and tostring(math.floor(ping)) or "?")
        return str
    end

    -- FPS sampler (smoother than per-frame)
    local lastFPS = 60
    local fpsConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
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

    -- Set initial text
    if formatFn then
        icon:setLabel(formatFn())
    else
        icon:setLabel(resolveFast(text))
    end

    -- Real-time loop
    local running = true
    local loopThread = nil

    local function startLoop()
        running = true
        loopThread = task.spawn(function()
            while running do
                task.wait(interval)
                if not running then break end
                local newText = formatFn and formatFn() or resolveFast(text)
                icon:setLabel(newText)
            end
        end)
    end

    if realtime or formatFn then
        startLoop()
    end

    -- Public API
    local wm = {}
    wm.icon = icon

    function wm.setText(newText)
        text = newText
        icon:setLabel(resolveFast(newText))
    end

    function wm.setFormat(fn)
        formatFn = fn
        icon:setLabel(fn())
    end

    function wm.setColor(c)
        icon:modifyTheme({{"IconLabel","TextColor3",c}})
    end

    function wm.setSize(s)
        icon:modifyTheme({{"IconLabel","TextSize",s}})
    end

    function wm.stop()
        running = false
        fpsConn:Disconnect()
        if loopThread then task.cancel(loopThread) end
    end

    function wm.start()
        if not running then
            fpsConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
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
-- [2] HIGHLIGHT
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.highlight(icon, config?)

    config = {
        style     : "border"|"glow"|"premium"|"accent"  (default "border")
        color     : Color3   (default trắng)
        thickness : number   (default 2)
        animated  : bool     (default false)
    }

    Ex.removeHighlight(icon) — xóa highlight
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
                {"Widget", "BackgroundColor3",       Color3.fromRGB(40, 32, 10)},
                {"Widget", "BackgroundTransparency", 0},
            })

        elseif style == "accent" then
            local s = Instance.new("UIStroke")
            s.Name = "HighlightStroke"
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = color; s.Thickness = thickness
            s.Transparency = 0; s.Parent = btn

            icon:modifyTheme({
                {"Widget", "BackgroundColor3", Color3.fromRGB(
                    math.round(color.R * 30),
                    math.round(color.G * 30),
                    math.round(color.B * 30)
                )},
                {"Widget", "BackgroundTransparency", 0},
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
-- [3] MENU + DROPDOWN COMBO
-- ═══════════════════════════════════════════════════════════
--[[
    Ex.menuWithDropdowns(config)

    config = {
        label        : string
        align        : string?   "Left"|"Center"|"Right" (default "Left")
        maxMenuIcons : number?   (default 4)
        highlight    : table?    config cho Ex.highlight (optional)
        items : {
            {
                label    : string
                image    : number|string?
                onSelect : function?       — nút đơn
                dropdown : {               — nếu có thì item này có dropdown dọc
                    maxIcons : number?
                    minWidth : number?
                    items    : Icon[]
                }?
            }
        }
    }
]]
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
            child:modifyTheme({{"Dropdown", "MaxIcons", dd.maxIcons or 5}})
                 :modifyChildTheme({{"Widget", "MinimumWidth", dd.minWidth or 160}})
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
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(25, 25, 30)},
            {"Widget",      "BackgroundTransparency", 0},
            {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
            {"IconGradient","Enabled",                false},
            {"Menu",        "MaxIcons",               maxMenu},
        })
        :modifyChildTheme({
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
            {"Widget",      "BackgroundTransparency", 0},
            {"IconCorners", "CornerRadius",           UDim.new(0, 6)},
        })
        :setMenu(menuItems)

    if hl then Ex.highlight(parent, hl) end

    return parent
end

-- ═══════════════════════════════════════════════════════════
-- [4] NATIVE OVERRIDE
-- ═══════════════════════════════════════════════════════════
function Ex.setNativeOverride(mode)
    if mode == "hide" then
        local ok, err = pcall(function()
            game:GetService("StarterGui"):SetCore("TopbarEnabled", false)
        end)
        if not ok then warn("[TopbarPlusEx] Cannot hide native topbar:", err) end
    end
    -- "dodge" = TopbarPlus handles it automatically, nothing needed
end

-- ═══════════════════════════════════════════════════════════
-- [5] SEPARATOR
-- ═══════════════════════════════════════════════════════════
function Ex.separator(width, align)
    return Icon.new()
        :setWidth(width or 10)
        :lock()
        :disableStateOverlay(true)
        :align(align or "Left")
        :modifyTheme({
            {"Widget",     "BackgroundTransparency", 1},
            {"IconButton", "BackgroundTransparency", 1},
            {"IconGradient","Enabled",               false},
        })
end

-- ─────────────────────────────────────────────────────────────
-- THEME PRESETS
-- ─────────────────────────────────────────────────────────────
local Presets = {
    dark = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(18, 18, 22)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
        {"IconGradient","Enabled",                false},
    },
    light = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(240, 240, 245)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(30, 30, 30)},
    },
    glass = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(255, 255, 255)},
        {"Widget",      "BackgroundTransparency", 0.7},
        {"IconCorners", "CornerRadius",           UDim.new(0, 10)},
        {"IconGradient","Enabled",                false},
    },
    gold = {
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(40, 32, 10)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
        {"IconGradient","Enabled",                false},
        {"IconLabel",   "TextColor3",             Color3.fromRGB(255, 215, 0)},
    },
}

return { Icon = Icon, Ex = Ex, Presets = Presets }
