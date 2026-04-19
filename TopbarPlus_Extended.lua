--[[
    TopbarPlus Extended v1.1
    Nâng cấp TopbarPlus với:
      - Watermark icon (non-interactive, decorative)
      - Highlight (border / glow / premium / accent style)
      - Menu + Dropdown combo (menu ngang chứa dropdown dọc)
      - Auto-dodge / override native topbar buttons
      - Separator (khoảng cách giữa icons)
      - Theme Presets (data only)
]]

local _bundle = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon    = _bundle.get()
assert(Icon, "[TopbarPlusEx] Failed to load TopbarPlus bundle!")

local function getButton(icon)
    local widget = icon.widget
    if not widget then return nil end
    return widget:FindFirstChild("IconButton", true)
end

local Ex = {}

-- ═══════════════════════════════════════════════════════════
-- [1] WATERMARK
-- ═══════════════════════════════════════════════════════════
function Ex.watermark(text, imageId, align)
    local icon = Icon.new()
        :setEnabled(true)
        :lock()
        :disableStateOverlay(true)
        :align(align or "Right")
    if imageId then icon:setImage(imageId) end
    if text    then icon:setLabel(text)    end
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
        {"IconLabel",    "TextColor3",             Color3.fromRGB(200, 200, 200)},
    })
    return icon
end

-- ═══════════════════════════════════════════════════════════
-- [2] HIGHLIGHT
-- ═══════════════════════════════════════════════════════════
function Ex.highlight(icon, config)
    config    = config or {}
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
            s.Name = "HighlightStroke"; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = color; s.Thickness = thickness; s.Transparency = 0; s.Parent = btn

        elseif style == "glow" then
            local outer = Instance.new("UIStroke")
            outer.Name = "HighlightStrokeOuter"; outer.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            outer.Color = color; outer.Thickness = thickness + 2; outer.Transparency = 0.3; outer.Parent = btn
            local inner = Instance.new("UIStroke")
            inner.Name = "HighlightStroke"; inner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            inner.Color = color; inner.Thickness = thickness; inner.Transparency = 0; inner.Parent = btn
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
            s.Name = "HighlightStroke"; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = Color3.fromRGB(255, 215, 0); s.Thickness = thickness; s.Transparency = 0; s.Parent = btn
            local g = Instance.new("UIGradient")
            g.Name = "HighlightGradient"
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 215, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 0)),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 215, 0)),
            })
            g.Rotation = 45
            g.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7); NumberSequenceKeypoint.new(0.5, 0.5); NumberSequenceKeypoint.new(1, 0.7)
            })
            g.Parent = btn
            if animated then
                task.spawn(function()
                    while btn and btn.Parent do task.wait(0.03); g.Rotation = (g.Rotation + 1) % 360 end
                end)
            end
            icon:modifyTheme({{"Widget","BackgroundColor3",Color3.fromRGB(40,32,10)},{"Widget","BackgroundTransparency",0}})

        elseif style == "accent" then
            local s = Instance.new("UIStroke")
            s.Name = "HighlightStroke"; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Color = color; s.Thickness = thickness; s.Transparency = 0; s.Parent = btn
            icon:modifyTheme({
                {"Widget","BackgroundColor3",Color3.fromRGB(math.round(color.R*30),math.round(color.G*30),math.round(color.B*30))},
                {"Widget","BackgroundTransparency",0},
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
            if v.Name:find("HighlightStroke") or v.Name == "HighlightGradient" then v:Destroy() end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- [3] MENU + DROPDOWN COMBO
-- ═══════════════════════════════════════════════════════════
function Ex.menuWithDropdowns(config)
    config = config or {}
    local label   = config.label        or "Menu"
    local align   = config.align        or "Left"
    local maxMenu = config.maxMenuIcons or 4
    local items   = config.items        or {}
    local menuItems = {}

    for _, item in ipairs(items) do
        local child = Icon.new():setLabel(item.label or "Item")
        if item.image then child:setImage(item.image) end
        if item.dropdown then
            local dd = item.dropdown
            child:modifyTheme({{"Dropdown","MaxIcons",dd.maxIcons or 5}})
                 :modifyChildTheme({{"Widget","MinimumWidth",dd.minWidth or 160}})
                 :setDropdown(dd.items or {})
        elseif item.onSelect then
            child.selected:Connect(item.onSelect)
        end
        table.insert(menuItems, child)
    end

    return Icon.new()
        :setLabel(label)
        :align(align)
        :modifyTheme({
            {"Widget","BackgroundColor3",Color3.fromRGB(25,25,30)},
            {"Widget","BackgroundTransparency",0},
            {"IconCorners","CornerRadius",UDim.new(0,8)},
            {"IconGradient","Enabled",false},
            {"Menu","MaxIcons",maxMenu},
        })
        :modifyChildTheme({
            {"Widget","BackgroundColor3",Color3.fromRGB(30,30,35)},
            {"Widget","BackgroundTransparency",0},
            {"IconCorners","CornerRadius",UDim.new(0,6)},
        })
        :setMenu(menuItems)
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
            {"Widget","BackgroundTransparency",1},
            {"IconButton","BackgroundTransparency",1},
            {"IconGradient","Enabled",false},
        })
end

-- ─────────────────────────────────────────────────────────────
-- THEME PRESETS (data — dùng với Icon.modifyBaseTheme)
-- ─────────────────────────────────────────────────────────────
local Presets = {
    dark = {
        {"Widget","BackgroundColor3",Color3.fromRGB(18,18,22)},
        {"Widget","BackgroundTransparency",0},
        {"IconCorners","CornerRadius",UDim.new(0,8)},
        {"IconGradient","Enabled",false},
    },
    light = {
        {"Widget","BackgroundColor3",Color3.fromRGB(240,240,245)},
        {"Widget","BackgroundTransparency",0},
        {"IconCorners","CornerRadius",UDim.new(0,8)},
        {"IconGradient","Enabled",false},
        {"IconLabel","TextColor3",Color3.fromRGB(30,30,30)},
    },
    glass = {
        {"Widget","BackgroundColor3",Color3.fromRGB(255,255,255)},
        {"Widget","BackgroundTransparency",0.7},
        {"IconCorners","CornerRadius",UDim.new(0,10)},
        {"IconGradient","Enabled",false},
    },
    gold = {
        {"Widget","BackgroundColor3",Color3.fromRGB(40,32,10)},
        {"Widget","BackgroundTransparency",0},
        {"IconCorners","CornerRadius",UDim.new(0,8)},
        {"IconGradient","Enabled",false},
        {"IconLabel","TextColor3",Color3.fromRGB(255,215,0)},
    },
}

return { Icon = Icon, Ex = Ex, Presets = Presets }
