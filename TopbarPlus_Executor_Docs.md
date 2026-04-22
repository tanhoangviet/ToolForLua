# TopbarPlus — Executor Docs

<div align="center">

![TopbarPlus](https://img.shields.io/badge/TopbarPlus-v3-5865F2?style=for-the-badge)
![Extended](https://img.shields.io/badge/Extended-v1.2-F59E0B?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-Executor-7B52AB?style=for-the-badge)

**[🇺🇸 English](#-english) · [🇻🇳 Tiếng Việt](#-tiếng-việt)**

</div>

---

# 🇺🇸 English

## Quick Start

```lua
-- ① Load Core only
local tp   = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus.lua"))()
local Icon = tp.get()

-- ② Load Extended (includes Core — use this if you want watermark/highlight/etc.)
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon   -- same as tp.get()
local Ex   = tpx.Ex     -- extra features
```

> **Use Extended** — it loads Core automatically. No need to load both.

---

## Table of Contents

- [Core Concepts](#core-concepts)
- [Step-by-Step Guide](#step-by-step-guide)
  - [1. Create an Icon](#1-create-an-icon)
  - [2. Add Image and Label](#2-add-image-and-label)
  - [3. Position on Screen](#3-position-on-screen)
  - [4. Listen to Clicks](#4-listen-to-clicks)
  - [5. Toggle a Feature ON/OFF](#5-toggle-a-feature-onoff)
  - [6. Different Look When ON/OFF](#6-different-look-when-onoff)
  - [7. Show/Hide a GUI Frame](#7-showhide-a-gui-frame)
  - [8. Keyboard Shortcut](#8-keyboard-shortcut)
  - [9. Tooltip on Hover](#9-tooltip-on-hover)
  - [10. Notification Badge](#10-notification-badge)
  - [11. Single-Click Button](#11-single-click-button)
  - [12. Lock / Cooldown](#12-lock--cooldown)
  - [13. Change the Look (Theme)](#13-change-the-look-theme)
  - [14. Dropdown — Vertical List](#14-dropdown--vertical-list)
  - [15. Menu — Horizontal Row](#15-menu--horizontal-row)
  - [16. Build Icons from a Table](#16-build-icons-from-a-table)
  - [17. Colored Text in Label](#17-colored-text-in-label)
  - [18. Destroy an Icon](#18-destroy-an-icon)
- [Extended Features](#extended-features)
  - [Watermark — Static](#watermark--static)
  - [Watermark — Real-time (FPS, Time, Ping)](#watermark--real-time-fps-time-ping)
  - [Watermark — Custom Function](#watermark--custom-function)
  - [Watermark — Update on the Fly](#watermark--update-on-the-fly)
  - [Separator](#separator)
  - [Highlight — Border](#highlight--border)
  - [Highlight — Glow (Animated)](#highlight--glow-animated)
  - [Highlight — Premium Gold](#highlight--premium-gold)
  - [Highlight — Accent Color](#highlight--accent-color)
  - [Menu + Dropdown Combo](#menu--dropdown-combo)
  - [Theme Presets](#theme-presets)
- [Full API Reference](#full-api-reference)
- [Full Example Script](#full-example-script)
- [Troubleshooting](#troubleshooting)
- [Bug Fixes](#bug-fixes)

---

## Core Concepts

**What is TopbarPlus?**  
A library that adds custom clickable icons to the Roblox topbar (the black bar at the top of the screen).

**Chaining** — Most methods return the icon so you can call them one after another:
```lua
local icon = Icon.new()
    :setImage(12345678)   -- set image
    :setLabel("Shop")     -- set text
    :align("Right")       -- position right
```

**Icon States** — An icon has states. Some methods accept an optional `iconState` to apply only in that state:

| State | When |
|-------|------|
| `nil` | Always (default) |
| `"Deselected"` | When NOT clicked |
| `"Selected"` | When clicked/active |
| `"Viewing"` | While hovering |

---

## Step-by-Step Guide

### 1. Create an Icon

```lua
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon

-- Empty icon (shows as a blank square on topbar)
local icon = Icon.new()
```

---

### 2. Add Image and Label

```lua
-- Image + text
local icon = Icon.new()
    :setImage(6031068420)   -- Roblox asset ID
    :setLabel("Shop")

-- Text only
local icon = Icon.new():setLabel("Shop")

-- Image only
local icon = Icon.new():setImage(6031068420)

-- Customize image size
icon:setImageScale(0.7)   -- bigger image (default 0.5)
icon:setImageRatio(1)     -- keep square (default 1)
```

---

### 3. Position on Screen

```lua
icon:align("Left")    -- left side (default)
icon:align("Center")  -- center
icon:align("Right")   -- right side (near Roblox buttons)
```

---

### 4. Listen to Clicks

```lua
local icon = Icon.new():setLabel("Click Me"):align("Right")

-- When clicked ON
icon.selected:Connect(function()
    print("Icon turned ON")
end)

-- When clicked OFF
icon.deselected:Connect(function()
    print("Icon turned OFF")
end)

-- One handler for both
icon.toggled:Connect(function(isOn)
    if isOn then
        print("ON")
    else
        print("OFF")
    end
end)

-- While hovering
icon.viewingStarted:Connect(function() print("hovering") end)
icon.viewingEnded:Connect(function()   print("done")     end)
```

---

### 5. Toggle a Feature ON/OFF

```lua
local featureEnabled = false

local icon = Icon.new():setLabel("Feature"):align("Right")

icon.toggled:Connect(function(isOn)
    featureEnabled = isOn
    if isOn then
        -- enable your feature
    else
        -- disable your feature
    end
end)
```

---

### 6. Different Look When ON/OFF

```lua
local icon = Icon.new()
    :setLabel("OFF", "Deselected")   -- shows "OFF" when not clicked
    :setLabel("ON",  "Selected")     -- shows "ON" when clicked
    :align("Right")

-- Different colors
icon:setTextColor(Color3.fromRGB(150, 150, 150), "Deselected")  -- gray when off
icon:setTextColor(Color3.fromRGB(100, 255, 100), "Selected")    -- green when on

-- Different images
icon:setImage(111111, "Deselected")
icon:setImage(222222, "Selected")
```

---

### 7. Show/Hide a GUI Frame

The frame automatically shows when the icon is selected and hides when deselected:

```lua
local myFrame = game.Players.LocalPlayer
    .PlayerGui.ScreenGui.Frame

local icon = Icon.new()
    :setLabel("Open Menu")
    :align("Right")
    :bindToggleItem(myFrame)   -- that's it!

-- Remove later:
icon:unbindToggleItem(myFrame)
```

---

### 8. Keyboard Shortcut

```lua
local icon = Icon.new()
    :setLabel("ESP")
    :bindToggleKey(Enum.KeyCode.X)   -- press X to toggle

-- Remove:
icon:unbindToggleKey(Enum.KeyCode.X)
```

---

### 9. Tooltip on Hover

```lua
local icon = Icon.new()
    :setLabel("Shop")
    :setCaption("Open Shop")                 -- tooltip text
    :setCaptionHint(Enum.KeyCode.B)          -- optional: show "B" as hint

-- Remove tooltip:
icon:setCaption(nil)
```

---

### 10. Notification Badge

```lua
local icon = Icon.new():setLabel("Inbox"):align("Right")

icon:notify()                    -- show badge (+1)
icon:notify(icon.deselected)     -- +1, auto-clears when icon is opened
icon:clearNotices()              -- remove all

print(icon.totalNotices)         -- read count
```

---

### 11. Single-Click Button

Clicks once → triggers → auto-deselects:

```lua
local icon = Icon.new()
    :setLabel("Use Ability")
    :oneClick()
    :align("Right")

icon.deselected:Connect(function()
    print("Ability used!")
    -- your code here
end)
```

---

### 12. Lock / Cooldown

```lua
icon:lock()     -- user can't click (your code still can)
icon:unlock()   -- allow clicks again

-- Cooldown: lock for N seconds then unlock
-- ⚠️ Must use task.spawn — debounce yields!
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(5)   -- 5 second cooldown
    end)
    print("Used!")
end)
```

---

### 13. Change the Look (Theme)

```lua
-- Single change
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30, 30, 30)})

-- Multiple changes
icon:modifyTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget",      "BackgroundTransparency", 0},          -- 0 = solid
    {"IconCorners", "CornerRadius",           UDim.new(0, 8)},   -- rounded
    {"IconGradient","Enabled",                false},       -- no gradient
    {"IconLabel",   "TextSize",               14},
})

-- Different color when selected
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(0, 120, 255), "Selected"})
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(25, 25, 30),  "Deselected"})

-- Apply to dropdown/menu children
icon:modifyChildTheme({{"Widget", "MinimumWidth", 180}})

-- Apply to ALL icons globally
Icon.modifyBaseTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(18, 18, 22)},
    {"Widget",      "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient","Enabled",                false},
})
```

**Theme Targets:**

| Name | What it styles |
|------|---------------|
| `"Widget"` | Main icon container |
| `"IconCorners"` | Corner rounding |
| `"IconGradient"` | Gradient overlay |
| `"IconLabel"` | Text label |
| `"IconImage"` | Image element |
| `"Dropdown"` | Dropdown container |
| `"Menu"` | Menu container |

---

### 14. Dropdown — Vertical List

Opens a list below the icon when clicked:

```lua
-- Create child icons
local opt1 = Icon.new():setLabel("Option A")
local opt2 = Icon.new():setLabel("Option B")
local opt3 = Icon.new():setLabel("Option C")

opt1.selected:Connect(function() print("A!") end)
opt2.selected:Connect(function() print("B!") end)

-- Attach to parent
local drop = Icon.new()
    :setLabel("Choose")
    :modifyTheme({{"Dropdown", "MaxIcons", 3}})       -- 3 visible, scroll for more
    :modifyChildTheme({{"Widget", "MinimumWidth", 160}})
    :setDropdown({opt1, opt2, opt3})

-- Remove dropdown:
drop:setDropdown({})
```

---

### 15. Menu — Horizontal Row

Opens a horizontal row inside the icon:

```lua
local item1 = Icon.new():setLabel("Fly")
local item2 = Icon.new():setLabel("Speed")
local item3 = Icon.new():setLabel("Noclip")

local menu = Icon.new()
    :setLabel("Movement")
    :modifyTheme({{"Menu", "MaxIcons", 2}})
    :setMenu({item1, item2, item3})
```

**Fixed menu** (always open, no close button):

```lua
Icon.new()
    :setFixedMenu({
        Icon.new():setLabel("Home"),
        Icon.new():setLabel("Shop"),
        Icon.new():setLabel("Settings"),
    })
```

---

### 16. Build Icons from a Table

```lua
-- Toggle feature helper
local function makeToggle(label, callback)
    local c = Icon.new()
        :setLabel("✗ " .. label)
        :setWidth(175)
        :autoDeselect(false)
    c.toggled:Connect(function(isOn)
        c:setLabel((isOn and "✓ " or "✗ ") .. label)
        callback(isOn)
    end)
    return c
end

-- Button helper
local function makeButton(label, callback)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(callback)
    return c
end

-- Build from data
local features = {
    {label = "Fly",           fn = function(on) print("Fly:", on) end},
    {label = "Speed Hack",    fn = function(on) print("Speed:", on) end},
    {label = "Noclip",        fn = function(on) print("Noclip:", on) end},
    {label = "Infinite Jump", fn = function(on) print("Jump:", on) end},
}

local children = {}
for _, f in ipairs(features) do
    table.insert(children, makeToggle(f.label, f.fn))
end

Icon.new()
    :setLabel("Features")
    :align("Left")
    :modifyTheme({{"Dropdown","MaxIcons",5}})
    :modifyChildTheme({{"Widget","MinimumWidth",185}})
    :setDropdown(children)
```

---

### 17. Colored Text in Label

Use Roblox RichText inside a label — must use `task.defer`:

```lua
local child = Icon.new()

task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    -- colored requirement text
    lbl.Text = 'Dark Aura   <font color="#FF5050">5,600 KILLS</font>'
end)

-- Locked item (gray + lock emoji)
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = string.format('🔒 <font color="#888888">%s</font>', "Custom Cape")
end)

-- Block click when locked
child.selected:Connect(function()
    child:deselect()
end)
```

---

### 18. Destroy an Icon

```lua
-- Remove icon from topbar and clean up everything
icon:destroy()

-- Run code when destroyed
icon:addToJanitor(function()
    print("cleaned up!")
end)
```

---

## Extended Features

Load Extended module first:
```lua
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
local Pre  = tpx.Presets
```

---

### Watermark — Static

Non-clickable decorative text/icon on the topbar.

```lua
-- Text only
local wm = Ex.watermark({text = "v1.0 | MyScript"})

-- Right side with custom color
local wm = Ex.watermark({
    text  = "v1.0 | MyScript",
    align = "Right",
    color = Color3.fromRGB(200, 200, 200),
    size  = 13,
})

-- Image + text
local wm = Ex.watermark({
    text    = "PREMIUM",
    imageId = 6031068420,
    align   = "Right",
})
```

---

### Watermark — Real-time (FPS, Time, Ping)

Use `{fps}`, `{time}`, `{ping}`, `{player}` placeholders. Set `realtime = true` to auto-update.

```lua
-- FPS counter
local wm = Ex.watermark({
    text     = "FPS: {fps}",
    realtime = true,
    interval = 0.5,   -- update every 0.5 seconds
})

-- FPS + time
local wm = Ex.watermark({
    text     = "v1.0 | FPS: {fps} | {time}",
    realtime = true,
    interval = 1,
})

-- All placeholders
local wm = Ex.watermark({
    text     = "{player} | FPS: {fps} | Ping: {ping}ms | {time}",
    realtime = true,
    interval = 1,
    align    = "Right",
    color    = Color3.fromRGB(180, 220, 255),
})
```

---

### Watermark — Custom Function

Provide a `format` function for full control:

```lua
local kills = 0

local wm = Ex.watermark({
    realtime = true,
    interval = 1,
    format   = function()
        return string.format("v1.0 | Kills: %d | FPS: %d", kills, 60)
    end,
})

-- Update kills from game event
game:GetService("ReplicatedStorage").KillEvent.OnClientEvent:Connect(function()
    kills += 1
end)
```

---

### Watermark — Update on the Fly

The watermark returns an object with methods to update it live:

```lua
local wm = Ex.watermark({
    text     = "Loading...",
    realtime = true,
    interval = 1,
    format   = function() return "v1.0 | FPS: {fps}" end,
})

-- Change text immediately
wm.setText("v2.0 | Ready!")

-- Change color
wm.setColor(Color3.fromRGB(255, 215, 0))

-- Change size
wm.setSize(16)

-- Change format function
wm.setFormat(function()
    return string.format("Kills: %d", kills)
end)

-- Stop / start realtime loop
wm.stop()
wm.start()

-- Destroy completely
wm.destroy()
```

---

### Separator

Invisible gap between icons:

```lua
Ex.separator()              -- 10px, left side
Ex.separator(20)            -- 20px
Ex.separator(15, "Right")   -- 15px, right side
```

Common usage:

```lua
-- Layout: [ESP icon] [gap] [watermark]
local esp = Icon.new():setLabel("ESP"):align("Right")
Ex.separator(8, "Right")
local wm = Ex.watermark({text = "v1.0", align = "Right"})
```

---

### Highlight — Border

Clean thin outline around the icon:

```lua
-- Default white border
Ex.highlight(icon)

-- Custom color and thickness
Ex.highlight(icon, {
    style     = "border",
    color     = Color3.fromRGB(100, 200, 255),
    thickness = 3,
})
```

---

### Highlight — Glow (Animated)

Double-stroke soft glow effect:

```lua
-- Static glow
Ex.highlight(icon, {
    style = "glow",
    color = Color3.fromRGB(0, 200, 255),
})

-- Animated pulsing glow
Ex.highlight(icon, {
    style    = "glow",
    color    = Color3.fromRGB(100, 255, 100),
    animated = true,
})
```

---

### Highlight — Premium Gold

Gold border + rotating gradient shimmer:

```lua
-- Static gold
Ex.highlight(icon, {style = "premium"})

-- Animated shimmer rotation
Ex.highlight(icon, {
    style    = "premium",
    animated = true,
})
```

---

### Highlight — Accent Color

Colored border + auto-tinted background:

```lua
Ex.highlight(icon, {style = "accent", color = Color3.fromRGB(255, 80, 80)})   -- red
Ex.highlight(icon, {style = "accent", color = Color3.fromRGB(100, 255, 100)}) -- green
Ex.highlight(icon, {style = "accent", color = Color3.fromRGB(255, 215, 0)})   -- gold
Ex.highlight(icon, {style = "accent", color = Color3.fromRGB(100, 150, 255)}) -- blue

-- Remove highlight
Ex.removeHighlight(icon)
```

---

### Menu + Dropdown Combo

Horizontal menu tabs, each tab opens its own vertical dropdown:

```lua
local function toggle(label, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(180):autoDeselect(false)
    c.toggled:Connect(function(on)
        c:setLabel((on and "✓ " or "✗ ")..label)
        fn(on)
    end)
    return c
end

local function button(label, fn)
    local c = Icon.new():setLabel(label):setWidth(165):oneClick()
    c.deselected:Connect(fn)
    return c
end

Ex.menuWithDropdowns({
    label        = "Hub",
    align        = "Left",
    maxMenuIcons = 4,
    highlight    = {style = "accent", color = Color3.fromRGB(100, 150, 255)},
    items = {
        {
            label = "⚔ Combat",
            dropdown = {
                maxIcons = 5,
                minWidth = 185,
                items    = {
                    toggle("Aimbot",     function(on) end),
                    toggle("Silent Aim", function(on) end),
                    toggle("ESP",        function(on) end),
                    toggle("Chams",      function(on) end),
                    toggle("No Recoil",  function(on) end),
                },
            },
        },
        {
            label = "🏃 Move",
            dropdown = {
                maxIcons = 4,
                minWidth = 180,
                items    = {
                    toggle("Fly",       function(on) end),
                    toggle("Speed Hack",function(on) end),
                    toggle("Noclip",    function(on) end),
                    toggle("Inf Jump",  function(on) end),
                },
            },
        },
        {
            label    = "Rejoin",
            onSelect = function()
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end,
        },
    },
})
```

---

### Theme Presets

```lua
local Pre = tpx.Presets

-- Apply to all icons at once
Icon.modifyBaseTheme(Pre.dark)    -- dark background
Icon.modifyBaseTheme(Pre.light)   -- light background
Icon.modifyBaseTheme(Pre.glass)   -- transparent glass
Icon.modifyBaseTheme(Pre.gold)    -- gold theme

-- Apply to one icon only
icon:modifyTheme(Pre.dark)
```

---

## Full API Reference

### Icon Methods

| Method | Chainable | Description |
|--------|-----------|-------------|
| `:setImage(id, state?)` | ✅ | Image asset ID or `"rbxassetid://..."` |
| `:setLabel(text, state?)` | ✅ | Text label |
| `:setWidth(n, state?)` | ✅ | Minimum width px (default 44) |
| `:setImageScale(n, state?)` | ✅ | Image size ratio (default 0.5) |
| `:setImageRatio(n, state?)` | ✅ | Aspect ratio (default 1) |
| `:setCornerRadius(s, o, state?)` | ✅ | Corner rounding |
| `:setTextSize(n, state?)` | ✅ | Font size (default 16) |
| `:setTextColor(Color3, state?)` | ✅ | Text color |
| `:setTextFont(f, w?, s?, state?)` | ✅ | Font name/enum/ID |
| `:setOrder(n, state?)` | ✅ | Position order on topbar |
| `:align(str)` | ✅ | `"Left"` / `"Center"` / `"Right"` |
| `:setName(name)` | ✅ | Name for `Icon.getIcon()` |
| `:setEnabled(bool)` | ✅ | Show/hide icon |
| `:select()` | ✅ | Force-select by code |
| `:deselect()` | ✅ | Force-deselect by code |
| `:lock()` | ✅ | Block user clicks |
| `:unlock()` | ✅ | Allow user clicks |
| `:debounce(sec)` | ✅⏸ | Lock → wait → unlock (**yields!**) |
| `:autoDeselect(bool)` | ✅ | Deselect when other icon clicked (default true) |
| `:oneClick()` | ✅ | Auto-deselect after select |
| `:notify(event?)` | ✅ | Add badge (+1). Optional auto-clear event |
| `:clearNotices()` | ✅ | Remove all badges |
| `:bindToggleItem(gui)` | ✅ | Frame auto shows/hides |
| `:unbindToggleItem(gui)` | ✅ | Remove frame binding |
| `:bindToggleKey(KeyCode)` | ✅ | Keyboard toggle |
| `:unbindToggleKey(KeyCode)` | ✅ | Remove keybind |
| `:setCaption(text)` | ✅ | Hover tooltip |
| `:setCaptionHint(KeyCode)` | ✅ | Show key hint without binding |
| `:setDropdown(icons)` | ✅ | Vertical dropdown |
| `:setMenu(icons)` | ✅ | Horizontal menu |
| `:setFixedMenu(icons)` | ✅ | Always-open menu |
| `:joinDropdown(parent)` | ✅ | Add to parent's dropdown |
| `:joinMenu(parent)` | ✅ | Add to parent's menu |
| `:leave()` | ✅ | Exit current dropdown/menu |
| `:modifyTheme(mods)` | ✅ | Theme modifications |
| `:modifyChildTheme(mods)` | ✅ | Theme for children |
| `:disableStateOverlay(bool)` | ✅ | Disable hover/press shade |
| `:call(func)` | ✅ | `task.spawn(func(icon))` while chainable |
| `:bindEvent(name, cb)` | ✅ | Connect event by name string |
| `:unbindEvent(name)` | ✅ | Disconnect event |
| `:addToJanitor(ud)` | ✅ | Clean up on destroy |
| `:getInstance(name)` | ❌ | Get widget child by name |
| `:destroy()` | ✅ | Destroy icon + all connections |

### Icon Events

```lua
icon.selected:Connect(function(fromSource) end)       -- clicked ON
icon.deselected:Connect(function(fromSource) end)     -- clicked OFF
icon.toggled:Connect(function(isOn, fromSource) end)  -- both
icon.viewingStarted:Connect(function() end)           -- hover start
icon.viewingEnded:Connect(function() end)             -- hover end
icon.notified:Connect(function() end)                 -- new badge
```

### Icon Properties (read-only)

```lua
icon.name          -- string: widget name
icon.isSelected    -- bool: currently selected?
icon.isEnabled     -- bool: visible?
icon.totalNotices  -- number: badge count
icon.locked        -- bool: user input blocked?
```

### Global Functions

```lua
Icon.new()                        -- create icon
Icon.getIcon("name")              -- find by name
Icon.getIcons()                   -- all icons {[uid]=icon}
Icon.setTopbarEnabled(bool)       -- show/hide all
Icon.modifyBaseTheme(mods)        -- theme all icons
Icon.setDisplayOrder(int)         -- ScreenGui order
```

### Extended API

```lua
-- Watermark
local wm = Ex.watermark({text, imageId?, align?, color?, size?, realtime?, interval?, format?})
wm.setText("new text")
wm.setFormat(function() return "..." end)
wm.setColor(Color3)
wm.setSize(number)
wm.stop()
wm.start()
wm.destroy()
wm.icon   -- the underlying Icon

-- Highlight
Ex.highlight(icon, {style?, color?, thickness?, animated?})
Ex.removeHighlight(icon)

-- Menu + Dropdown
Ex.menuWithDropdowns({label, align?, maxMenuIcons?, highlight?, items})

-- Separator
Ex.separator(width?, align?)

-- Native override
Ex.setNativeOverride("dodge")   -- default
Ex.setNativeOverride("hide")    -- hide Roblox topbar

-- Presets (use with modifyBaseTheme or modifyTheme)
tpx.Presets.dark
tpx.Presets.light
tpx.Presets.glass
tpx.Presets.gold
```

---

## Full Example Script

```lua
-- ══════════════════════════════════════════════════════════════
-- TOPBARPLUS FULL EXAMPLE SCRIPT
-- ══════════════════════════════════════════════════════════════

-- Load Extended (includes everything)
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
local Pre  = tpx.Presets

-- ── 1. Global dark theme ──────────────────────────────────────
Icon.modifyBaseTheme(Pre.dark)

-- ── 2. Helpers ───────────────────────────────────────────────
local function toggle(label, width, fn)
    local c = Icon.new()
        :setLabel("✗ " .. label)
        :setWidth(width or 175)
        :autoDeselect(false)
    c.toggled:Connect(function(isOn)
        c:setLabel((isOn and "✓ " or "✗ ") .. label)
        if fn then fn(isOn) end
    end)
    return c
end

local function btn(label, fn)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(function() if fn then fn() end end)
    return c
end

-- ── 3. Script Hub (Menu + Dropdown combo) ────────────────────
Ex.menuWithDropdowns({
    label        = "⚡ Hub",
    align        = "Left",
    maxMenuIcons = 4,
    highlight    = {style = "accent", color = Color3.fromRGB(100, 150, 255)},
    items = {
        {
            label    = "⚔ Combat",
            dropdown = {
                maxIcons = 6,
                minWidth = 185,
                items    = {
                    toggle("Aimbot",      185, function(on) print("Aimbot:", on) end),
                    toggle("Silent Aim",  185, function(on) print("Silent:", on) end),
                    toggle("ESP",         185, function(on) print("ESP:", on)    end),
                    toggle("Chams",       185, function(on) print("Chams:", on)  end),
                    toggle("No Recoil",   185, function(on) print("Recoil:", on) end),
                    toggle("Rapid Fire",  185, function(on) print("Rapid:", on)  end),
                },
            },
        },
        {
            label    = "🏃 Move",
            dropdown = {
                maxIcons = 5,
                minWidth = 180,
                items    = {
                    toggle("Fly",           180, function(on) print("Fly:", on)   end),
                    toggle("Speed Hack",    180, function(on) print("Speed:", on) end),
                    toggle("Noclip",        180, function(on) print("Clip:", on)  end),
                    toggle("Infinite Jump", 180, function(on) print("Jump:", on)  end),
                    toggle("Anti-Gravity",  180, function(on) print("Grav:", on)  end),
                },
            },
        },
        {
            label    = "🔧 Misc",
            dropdown = {
                maxIcons = 4,
                minWidth = 165,
                items    = {
                    btn("Teleport Spawn", function()
                        local char = game.Players.LocalPlayer.Character
                        if char then char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(0, 5, 0) end
                    end),
                    btn("Rejoin", function()
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    end),
                    btn("Copy UID", function()
                        setclipboard(tostring(game.Players.LocalPlayer.UserId))
                        print("UID copied!")
                    end),
                    btn("Reset", function()
                        local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                        if h then h.Health = 0 end
                    end),
                },
            },
        },
    },
})

-- ── 4. Separator ─────────────────────────────────────────────
Ex.separator(10, "Left")

-- ── 5. Quick ESP toggle (standalone icon) ────────────────────
local espIcon = Icon.new()
    :setLabel("ESP OFF", "Deselected")
    :setLabel("ESP ON",  "Selected")
    :setTextColor(Color3.fromRGB(160, 160, 160), "Deselected")
    :setTextColor(Color3.fromRGB(100, 255, 100), "Selected")
    :align("Right")
    :setCaption("Toggle ESP  [X]")
    :bindToggleKey(Enum.KeyCode.X)
    :modifyTheme({
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(22, 22, 28)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
    })

Ex.highlight(espIcon, {
    style    = "glow",
    color    = Color3.fromRGB(100, 255, 100),
    animated = true,
})

espIcon.toggled:Connect(function(isOn)
    print("ESP:", isOn)
    -- your ESP code here
end)

-- ── 6. Separator before watermark ────────────────────────────
Ex.separator(8, "Right")

-- ── 7. Real-time watermark ───────────────────────────────────
local kills = 0
local wm = Ex.watermark({
    align    = "Right",
    realtime = true,
    interval = 1,
    format   = function()
        return string.format(
            "v1.0 | %s | FPS: {fps} | Kills: %d",
            game.Players.LocalPlayer.Name,
            kills
        )
    end,
    color = Color3.fromRGB(180, 200, 255),
    size  = 13,
})

-- Update kills from events
game:GetService("ReplicatedStorage"):WaitForChild("KillEvent", 5)
local ok = pcall(function()
    game:GetService("ReplicatedStorage").KillEvent.OnClientEvent:Connect(function()
        kills += 1
    end)
end)
if not ok then
    -- fallback: demo increment
    task.spawn(function()
        while task.wait(5) do kills += 1 end
    end)
end

-- ── 8. Notification example ──────────────────────────────────
local notifIcon = Icon.new()
    :setLabel("Alerts")
    :setImage(6031068420)
    :align("Right")
    :setCaption("Notifications")
    :modifyTheme({
        {"Widget","BackgroundColor3",Color3.fromRGB(22,22,28)},
        {"Widget","BackgroundTransparency",0},
        {"IconCorners","CornerRadius",UDim.new(0,8)},
    })

Ex.highlight(notifIcon, {style = "border", color = Color3.fromRGB(255, 200, 50)})

-- Show a notification after 3 seconds (demo)
task.delay(3, function()
    notifIcon:notify(notifIcon.deselected)
    print("Notification sent!")
end)
```

---

## Troubleshooting

### ❌ `attempt to index nil with 'new'`
`tp.get()` returned nil. Fix:
```lua
-- Make sure URL is correct
local tpx = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
print(tpx)         -- should not be nil
local Icon = tpx.Icon
print(Icon)        -- should not be nil
```

### ❌ `Failed to load sound rbxassetid://0`
You used `:setImage(0)`. Remove it or use a real asset ID.

### ❌ RichText not showing colors
Must use `task.defer`:
```lua
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Text <font color="#FF0000">Red</font>'
end)
```

### ❌ Highlight not visible
Icon needs a non-transparent background:
```lua
icon:modifyTheme({
    {"Widget","BackgroundColor3",Color3.fromRGB(25,25,30)},
    {"Widget","BackgroundTransparency",0},  -- 0 = solid
})
Ex.highlight(icon)
```

### ❌ `debounce` freezes the script
Always wrap in `task.spawn`:
```lua
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(3)  -- yields for 3s in background
    end)
end)
```

### ❌ Dropdown children are too narrow
```lua
icon:modifyChildTheme({{"Widget","MinimumWidth",200}})
```

---

## Bug Fixes

This bundle includes 2 patches over the original TopbarPlus source:

**Fix 1** — `attempt to call missing method 'clean'`  
Added camelCase aliases to Janitor so `janitor:clean()` / `janitor:add()` / `janitor:destroy()` work.

**Fix 2** — `invalid argument #2 to 'clamp' (number expected, got nil)`  
Added `or 0` / `or 36` fallbacks when `GetAttribute("MinimumWidth")` returns nil on initialization.

---
---

# 🇻🇳 Tiếng Việt

## Bắt Đầu Nhanh

```lua
-- ① Load Core only
local tp   = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus.lua"))()
local Icon = tp.get()

-- ② Load Extended (bao gồm Core — dùng cái này nếu muốn watermark/highlight/v.v.)
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
```

> **Dùng Extended** — nó tự load Core. Không cần load cả hai.

---

## Mục Lục

- [Khái Niệm Cơ Bản](#khái-niệm-cơ-bản)
- [Hướng Dẫn Từng Bước](#hướng-dẫn-từng-bước)
  - [1. Tạo Icon](#1-tạo-icon)
  - [2. Thêm Ảnh và Chữ](#2-thêm-ảnh-và-chữ)
  - [3. Vị Trí Trên Màn Hình](#3-vị-trí-trên-màn-hình)
  - [4. Lắng Nghe Click](#4-lắng-nghe-click)
  - [5. Toggle Tính Năng BẬT/TẮT](#5-toggle-tính-năng-bậttắt)
  - [6. Giao Diện Khác Nhau Khi BẬT/TẮT](#6-giao-diện-khác-nhau-khi-bậttắt)
  - [7. Hiện/Ẩn Frame GUI](#7-hiệnẩn-frame-gui)
  - [8. Phím Tắt](#8-phím-tắt)
  - [9. Tooltip Khi Hover](#9-tooltip-khi-hover)
  - [10. Badge Thông Báo](#10-badge-thông-báo)
  - [11. Nút Single-Click](#11-nút-single-click)
  - [12. Khóa / Cooldown](#12-khóa--cooldown)
  - [13. Thay Đổi Giao Diện](#13-thay-đổi-giao-diện)
  - [14. Dropdown — Danh Sách Dọc](#14-dropdown--danh-sách-dọc)
  - [15. Menu — Hàng Ngang](#15-menu--hàng-ngang)
  - [16. Tạo Icon Từ Bảng Dữ Liệu](#16-tạo-icon-từ-bảng-dữ-liệu)
  - [17. Chữ Có Màu Trong Label](#17-chữ-có-màu-trong-label)
  - [18. Xóa Icon](#18-xóa-icon)
- [Tính Năng Extended](#tính-năng-extended)
  - [Watermark — Tĩnh](#watermark--tĩnh)
  - [Watermark — Real-time (FPS, Giờ, Ping)](#watermark--real-time-fps-giờ-ping)
  - [Watermark — Hàm Tùy Chỉnh](#watermark--hàm-tùy-chỉnh)
  - [Watermark — Cập Nhật Trực Tiếp](#watermark--cập-nhật-trực-tiếp)
  - [Separator](#separator-1)
  - [Highlight — Border](#highlight--border-1)
  - [Highlight — Glow (Có Animation)](#highlight--glow-có-animation)
  - [Highlight — Premium Gold](#highlight--premium-gold-1)
  - [Highlight — Accent Màu](#highlight--accent-màu)
  - [Menu + Dropdown Combo](#menu--dropdown-combo-1)
  - [Theme Presets](#theme-presets-1)
- [Script Ví Dụ Đầy Đủ](#script-ví-dụ-đầy-đủ)
- [Xử Lý Lỗi](#xử-lý-lỗi)

---

## Khái Niệm Cơ Bản

**TopbarPlus là gì?**  
Thư viện tạo icon tùy chỉnh trên thanh topbar của Roblox (thanh đen trên cùng màn hình).

**Chaining (Nối chuỗi)** — Hầu hết method trả về icon nên gọi được liên tiếp:
```lua
local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Shop")
    :align("Right")
```

**Icon States (Trạng thái)** — Icon có trạng thái. Một số method nhận `iconState` tùy chọn:

| Trạng thái | Khi nào |
|------------|---------|
| `nil` | Luôn luôn (mặc định) |
| `"Deselected"` | Khi CHƯA click |
| `"Selected"` | Khi ĐANG click/bật |
| `"Viewing"` | Khi đang hover |

---

## Hướng Dẫn Từng Bước

### 1. Tạo Icon

```lua
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon

local icon = Icon.new()   -- icon trống xuất hiện trên topbar
```

---

### 2. Thêm Ảnh và Chữ

```lua
-- Cả ảnh lẫn chữ
local icon = Icon.new()
    :setImage(6031068420)   -- Roblox asset ID
    :setLabel("Shop")

-- Chỉ chữ
local icon = Icon.new():setLabel("Shop")

-- Chỉ ảnh
local icon = Icon.new():setImage(6031068420)

-- Tùy chỉnh kích thước ảnh
icon:setImageScale(0.7)   -- to hơn (mặc định 0.5)
```

---

### 3. Vị Trí Trên Màn Hình

```lua
icon:align("Left")    -- bên trái (mặc định)
icon:align("Center")  -- giữa màn hình
icon:align("Right")   -- bên phải (cạnh nút Roblox)
```

---

### 4. Lắng Nghe Click

```lua
local icon = Icon.new():setLabel("Click Tôi"):align("Right")

-- Khi click BẬT
icon.selected:Connect(function()
    print("Icon BẬT")
end)

-- Khi click TẮT
icon.deselected:Connect(function()
    print("Icon TẮT")
end)

-- Xử lý cả hai cùng lúc
icon.toggled:Connect(function(isOn)
    if isOn then
        print("BẬT")
    else
        print("TẮT")
    end
end)
```

---

### 5. Toggle Tính Năng BẬT/TẮT

```lua
local tinhNangBat = false

local icon = Icon.new():setLabel("Tính Năng"):align("Right")

icon.toggled:Connect(function(isOn)
    tinhNangBat = isOn
    if isOn then
        -- code bật tính năng
    else
        -- code tắt tính năng
    end
end)
```

---

### 6. Giao Diện Khác Nhau Khi BẬT/TẮT

```lua
local icon = Icon.new()
    :setLabel("TẮT", "Deselected")   -- hiện "TẮT" khi chưa click
    :setLabel("BẬT", "Selected")     -- hiện "BẬT" khi click
    :align("Right")

-- Màu chữ khác nhau
icon:setTextColor(Color3.fromRGB(150,150,150), "Deselected")  -- xám khi tắt
icon:setTextColor(Color3.fromRGB(100,255,100), "Selected")    -- xanh khi bật

-- Ảnh khác nhau
icon:setImage(111111, "Deselected")
icon:setImage(222222, "Selected")
```

---

### 7. Hiện/Ẩn Frame GUI

Frame tự hiện khi icon bật, tự ẩn khi tắt:

```lua
local frame = game.Players.LocalPlayer
    .PlayerGui.ScreenGui.Frame

local icon = Icon.new()
    :setLabel("Mở Menu")
    :align("Right")
    :bindToggleItem(frame)   -- một dòng là xong!

-- Gỡ sau này:
icon:unbindToggleItem(frame)
```

---

### 8. Phím Tắt

```lua
local icon = Icon.new()
    :setLabel("ESP")
    :bindToggleKey(Enum.KeyCode.X)   -- nhấn X để toggle

-- Gỡ:
icon:unbindToggleKey(Enum.KeyCode.X)
```

---

### 9. Tooltip Khi Hover

```lua
local icon = Icon.new()
    :setLabel("Shop")
    :setCaption("Mở Cửa Hàng")
    :setCaptionHint(Enum.KeyCode.B)   -- gợi ý phím "B"

-- Xóa:
icon:setCaption(nil)
```

---

### 10. Badge Thông Báo

```lua
local icon = Icon.new():setLabel("Hộp Thư"):align("Right")

icon:notify()                    -- hiện badge (+1)
icon:notify(icon.deselected)     -- +1, tự xóa khi mở
icon:clearNotices()              -- xóa tất cả

print(icon.totalNotices)         -- đọc số badge
```

---

### 11. Nút Single-Click

Click một lần → kích hoạt → tự deselect:

```lua
local icon = Icon.new()
    :setLabel("Hồi Máu")
    :oneClick()
    :align("Right")

icon.deselected:Connect(function()
    print("Đã hồi máu!")
    -- code của bạn
end)
```

---

### 12. Khóa / Cooldown

```lua
icon:lock()     -- người dùng không click được
icon:unlock()   -- cho phép lại

-- Cooldown: khóa N giây rồi tự mở
-- ⚠️ Phải dùng task.spawn vì debounce yields!
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(5)   -- khóa 5 giây
    end)
    print("Đã dùng!")
end)
```

---

### 13. Thay Đổi Giao Diện

```lua
-- Một thay đổi
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30)})

-- Nhiều thay đổi
icon:modifyTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(20,20,25)},
    {"Widget",      "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",           UDim.new(0,8)},
    {"IconGradient","Enabled",                false},
    {"IconLabel",   "TextSize",               14},
})

-- Khác nhau theo trạng thái
icon:modifyTheme({"Widget","BackgroundColor3", Color3.fromRGB(0,120,255), "Selected"})
icon:modifyTheme({"Widget","BackgroundColor3", Color3.fromRGB(25,25,30),  "Deselected"})

-- Áp dụng cho icon con (dropdown/menu)
icon:modifyChildTheme({{"Widget","MinimumWidth",180}})

-- Áp dụng toàn bộ icon
Icon.modifyBaseTheme({
    {"Widget","BackgroundColor3",Color3.fromRGB(18,18,22)},
    {"Widget","BackgroundTransparency",0},
    {"IconCorners","CornerRadius",UDim.new(0,8)},
    {"IconGradient","Enabled",false},
})
```

---

### 14. Dropdown — Danh Sách Dọc

```lua
local opt1 = Icon.new():setLabel("Lựa Chọn A")
local opt2 = Icon.new():setLabel("Lựa Chọn B")
local opt3 = Icon.new():setLabel("Lựa Chọn C")

opt1.selected:Connect(function() print("A!") end)

local drop = Icon.new()
    :setLabel("Chọn")
    :modifyTheme({{"Dropdown","MaxIcons",3}})
    :modifyChildTheme({{"Widget","MinimumWidth",160}})
    :setDropdown({opt1, opt2, opt3})

-- Xóa:
drop:setDropdown({})
```

---

### 15. Menu — Hàng Ngang

```lua
local i1 = Icon.new():setLabel("Bay")
local i2 = Icon.new():setLabel("Tốc Độ")
local i3 = Icon.new():setLabel("Xuyên Tường")

local menu = Icon.new()
    :setLabel("Di Chuyển")
    :modifyTheme({{"Menu","MaxIcons",2}})
    :setMenu({i1, i2, i3})
```

**Fixed menu** (luôn mở):
```lua
Icon.new():setFixedMenu({
    Icon.new():setLabel("Trang Chủ"),
    Icon.new():setLabel("Cửa Hàng"),
    Icon.new():setLabel("Cài Đặt"),
})
```

---

### 16. Tạo Icon Từ Bảng Dữ Liệu

```lua
local function toggle(label, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(175):autoDeselect(false)
    c.toggled:Connect(function(on)
        c:setLabel((on and "✓ " or "✗ ")..label)
        if fn then fn(on) end
    end)
    return c
end

local function btn(label, fn)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(function() if fn then fn() end end)
    return c
end

local tinhNang = {
    {ten = "Bay",          hanh = function(on) print("Bay:", on)   end},
    {ten = "Hack Tốc Độ", hanh = function(on) print("Speed:", on) end},
    {ten = "Xuyên Tường", hanh = function(on) print("Clip:", on)  end},
}

local children = {}
for _, f in ipairs(tinhNang) do
    table.insert(children, toggle(f.ten, f.hanh))
end

Icon.new()
    :setLabel("Tính Năng")
    :align("Left")
    :modifyTheme({{"Dropdown","MaxIcons",5}})
    :modifyChildTheme({{"Widget","MinimumWidth",185}})
    :setDropdown(children)
```

---

### 17. Chữ Có Màu Trong Label

```lua
local child = Icon.new()

-- Phải dùng task.defer!
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Dark Aura   <font color="#FF5050">5,600 KILLS</font>'
end)

-- Item bị khóa
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = string.format('🔒 <font color="#888888">%s</font>', "Custom Cape")
end)
child.selected:Connect(function() child:deselect() end)
```

---

### 18. Xóa Icon

```lua
icon:destroy()   -- xóa khỏi topbar và dọn dẹp mọi thứ

-- Chạy code khi bị xóa
icon:addToJanitor(function()
    print("đã xóa!")
end)
```

---

## Tính Năng Extended

Load Extended:
```lua
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
local Pre  = tpx.Presets
```

---

### Watermark — Tĩnh

```lua
-- Chỉ chữ
local wm = Ex.watermark({text = "v1.0 | MyScript"})

-- Tùy chỉnh
local wm = Ex.watermark({
    text  = "v1.0 | MyScript",
    align = "Right",
    color = Color3.fromRGB(200,200,200),
    size  = 13,
})

-- Ảnh + chữ
local wm = Ex.watermark({
    text    = "PREMIUM",
    imageId = 6031068420,
    align   = "Right",
})
```

---

### Watermark — Real-time (FPS, Giờ, Ping)

Dùng `{fps}`, `{time}`, `{ping}`, `{player}` trong text. Đặt `realtime = true` để tự cập nhật.

```lua
-- Đếm FPS
local wm = Ex.watermark({
    text     = "FPS: {fps}",
    realtime = true,
    interval = 0.5,
})

-- Nhiều thông tin
local wm = Ex.watermark({
    text     = "v1.0 | FPS: {fps} | {time}",
    realtime = true,
    interval = 1,
})

-- Đầy đủ
local wm = Ex.watermark({
    text     = "{player} | FPS: {fps} | Ping: {ping}ms | {time}",
    realtime = true,
    interval = 1,
    align    = "Right",
    color    = Color3.fromRGB(180,220,255),
})
```

---

### Watermark — Hàm Tùy Chỉnh

```lua
local kills = 0

local wm = Ex.watermark({
    realtime = true,
    interval = 1,
    format   = function()
        return string.format("v1.0 | Kills: %d | FPS: {fps}", kills)
    end,
})
```

---

### Watermark — Cập Nhật Trực Tiếp

```lua
local wm = Ex.watermark({text = "Đang tải...", realtime = true, interval = 1})

wm.setText("v2.0 | Sẵn sàng!")              -- đổi text ngay
wm.setColor(Color3.fromRGB(255,215,0))       -- đổi màu
wm.setSize(16)                               -- đổi cỡ chữ
wm.setFormat(function() return "..." end)    -- đổi hàm
wm.stop()                                    -- dừng realtime
wm.start()                                   -- chạy lại
wm.destroy()                                 -- xóa hoàn toàn
wm.icon                                      -- icon bên dưới
```

---

### Separator

```lua
Ex.separator()              -- 10px, căn trái
Ex.separator(20)            -- 20px
Ex.separator(15, "Right")   -- 15px, căn phải
```

---

### Highlight — Border

```lua
Ex.highlight(icon)   -- viền trắng mặc định

Ex.highlight(icon, {
    style     = "border",
    color     = Color3.fromRGB(100,200,255),
    thickness = 3,
})
```

---

### Highlight — Glow (Có Animation)

```lua
-- Tĩnh
Ex.highlight(icon, {style="glow", color=Color3.fromRGB(0,200,255)})

-- Nhấp nháy
Ex.highlight(icon, {style="glow", color=Color3.fromRGB(100,255,100), animated=true})
```

---

### Highlight — Premium Gold

```lua
Ex.highlight(icon, {style="premium"})
Ex.highlight(icon, {style="premium", animated=true})  -- shimmer xoay
```

---

### Highlight — Accent Màu

```lua
Ex.highlight(icon, {style="accent", color=Color3.fromRGB(255,80,80)})    -- đỏ
Ex.highlight(icon, {style="accent", color=Color3.fromRGB(100,255,100)})  -- xanh
Ex.highlight(icon, {style="accent", color=Color3.fromRGB(255,215,0)})    -- vàng

Ex.removeHighlight(icon)   -- xóa
```

---

### Menu + Dropdown Combo

```lua
local function toggle(label, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(180):autoDeselect(false)
    c.toggled:Connect(function(on)
        c:setLabel((on and "✓ " or "✗ ")..label)
        if fn then fn(on) end
    end)
    return c
end

Ex.menuWithDropdowns({
    label        = "Hub",
    align        = "Left",
    maxMenuIcons = 4,
    highlight    = {style="accent", color=Color3.fromRGB(100,150,255)},
    items = {
        {
            label = "⚔ Chiến Đấu",
            dropdown = {
                maxIcons=5, minWidth=185,
                items = {
                    toggle("Aimbot",      function(on) end),
                    toggle("Silent Aim",  function(on) end),
                    toggle("ESP",         function(on) end),
                    toggle("Không Giật",  function(on) end),
                    toggle("Bắn Nhanh",  function(on) end),
                },
            },
        },
        {
            label = "🏃 Di Chuyển",
            dropdown = {
                maxIcons=4, minWidth=180,
                items = {
                    toggle("Bay",           function(on) end),
                    toggle("Hack Tốc Độ",  function(on) end),
                    toggle("Xuyên Tường",  function(on) end),
                    toggle("Nhảy Vô Hạn", function(on) end),
                },
            },
        },
        {
            label    = "Rejoin",
            onSelect = function()
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end,
        },
    },
})
```

---

### Theme Presets

```lua
local Pre = tpx.Presets

Icon.modifyBaseTheme(Pre.dark)    -- tối
Icon.modifyBaseTheme(Pre.light)   -- sáng
Icon.modifyBaseTheme(Pre.glass)   -- kính mờ
Icon.modifyBaseTheme(Pre.gold)    -- vàng
```

---

## Script Ví Dụ Đầy Đủ

> Code giống hệt phần [Full Example Script](#full-example-script) tiếng Anh — copy paste trực tiếp.

```lua
-- Load Extended (bao gồm tất cả)
local tpx  = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
local Pre  = tpx.Presets

-- Theme toàn cục
Icon.modifyBaseTheme(Pre.dark)

-- Helpers
local function toggle(label, width, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(width or 175):autoDeselect(false)
    c.toggled:Connect(function(on) c:setLabel((on and "✓ " or "✗ ")..label); if fn then fn(on) end end)
    return c
end

local function btn(label, fn)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(function() if fn then fn() end end)
    return c
end

-- Script Hub
Ex.menuWithDropdowns({
    label="⚡ Hub", align="Left", maxMenuIcons=4,
    highlight={style="accent", color=Color3.fromRGB(100,150,255)},
    items={
        {label="⚔ Chiến Đấu", dropdown={maxIcons=6,minWidth=185,items={
            toggle("Aimbot",185,nil), toggle("Silent Aim",185,nil),
            toggle("ESP",185,nil), toggle("Chams",185,nil),
            toggle("Không Giật",185,nil), toggle("Bắn Nhanh",185,nil),
        }}},
        {label="🏃 Di Chuyển", dropdown={maxIcons=5,minWidth=180,items={
            toggle("Bay",180,nil), toggle("Hack Tốc Độ",180,nil),
            toggle("Xuyên Tường",180,nil), toggle("Nhảy Vô Hạn",180,nil),
        }}},
        {label="🔧 Misc", dropdown={maxIcons=4,minWidth=165,items={
            btn("Về Spawn",nil), btn("Rejoin",nil),
            btn("Copy UID",nil), btn("Reset",nil),
        }}},
    },
})

-- ESP toggle riêng
local esp = Icon.new()
    :setLabel("ESP TẮT","Deselected"):setLabel("ESP BẬT","Selected")
    :setTextColor(Color3.fromRGB(160,160,160),"Deselected")
    :setTextColor(Color3.fromRGB(100,255,100),"Selected")
    :align("Right")
    :bindToggleKey(Enum.KeyCode.X)
Ex.highlight(esp,{style="glow",color=Color3.fromRGB(100,255,100),animated=true})
esp.toggled:Connect(function(on) print("ESP:",on) end)

-- Watermark real-time
Ex.separator(8,"Right")
local wm = Ex.watermark({
    align="Right", realtime=true, interval=1,
    format=function()
        return string.format("v1.0 | %s | FPS: {fps}", game.Players.LocalPlayer.Name)
    end,
    color=Color3.fromRGB(180,200,255), size=13,
})
```

---

## Xử Lý Lỗi

| Lỗi | Nguyên nhân | Cách fix |
|-----|-------------|---------|
| `attempt to index nil with 'new'` | URL sai hoặc load thất bại | Kiểm tra URL và print `tpx` |
| `Failed to load sound rbxassetid://0` | Dùng `:setImage(0)` | Xóa hoặc dùng ID hợp lệ |
| RichText không có màu | Không dùng `task.defer` | Wrap trong `task.defer(function() ... end)` |
| Highlight không hiện | Nền trong suốt | Set `BackgroundTransparency = 0` trước |
| `debounce` đơ script | Không dùng `task.spawn` | Wrap trong `task.spawn(function() icon:debounce(n) end)` |
| Dropdown quá hẹp | Thiếu MinimumWidth | `modifyChildTheme({{"Widget","MinimumWidth",200}})` |

