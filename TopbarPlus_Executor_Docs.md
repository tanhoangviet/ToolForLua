# TopbarPlus Executor Bundle + Extended

<div align="center">

![TopbarPlus](https://img.shields.io/badge/TopbarPlus-Executor%20Bundle-5865F2?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1-7B52AB?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Roblox-Executor-E02020?style=for-the-badge)
![Bundle](https://img.shields.io/badge/Bundle-v1.1-22C55E?style=for-the-badge)
![Extended](https://img.shields.io/badge/Extended-v1.1-F59E0B?style=for-the-badge)

**[🇺🇸 English](#-english) · [🇻🇳 Tiếng Việt](#-tiếng-việt)**

> Executor-ready bundle of [TopbarPlus v3](https://github.com/1ForeverHD/TopbarPlus) by Just A Arisu =W=
> + Extended module with Highlight, Watermark, Menu+Dropdown combo, and more.

</div>

---

# 🇺🇸 English

## Table of Contents

- [Files Overview](#files-overview)
- [Installation](#installation)
- [Concepts](#concepts)
  - [How It Works](#how-it-works)
  - [Chaining](#chaining)
  - [Icon States](#icon-states)
  - [Icon Order](#icon-order)
- [Core Usage — Step by Step](#core-usage--step-by-step)
  - [1. Hello World](#1-hello-world)
  - [2. Image + Label](#2-image--label)
  - [3. Alignment](#3-alignment)
  - [4. Events — All 6](#4-events--all-6)
  - [5. Toggle Logic Pattern](#5-toggle-logic-pattern)
  - [6. State-Based Appearance](#6-state-based-appearance)
  - [7. Bind a GUI Frame](#7-bind-a-gui-frame)
  - [8. Keyboard Shortcut](#8-keyboard-shortcut)
  - [9. Caption Tooltip](#9-caption-tooltip)
  - [10. Notification Badge](#10-notification-badge)
  - [11. One-Click Button](#11-one-click-button)
  - [12. Lock & Debounce & Cooldown](#12-lock--debounce--cooldown)
  - [13. Theme — Full Guide](#13-theme--full-guide)
  - [14. Dropdown — Vertical Menu](#14-dropdown--vertical-menu)
  - [15. Menu — Horizontal Menu](#15-menu--horizontal-menu)
  - [16. Fixed Menu](#16-fixed-menu)
  - [17. Dynamic Icons from Data](#17-dynamic-icons-from-data)
  - [18. RichText Labels](#18-richtext-labels)
  - [19. Global Controls](#19-global-controls)
  - [20. Chainable call()](#20-chainable-call)
  - [21. Named Icon Lookup](#21-named-icon-lookup)
  - [22. Destroy & Cleanup](#22-destroy--cleanup)
- [Extended Module — Step by Step](#extended-module--step-by-step)
  - [Loading Extended](#loading-extended)
  - [E1. Watermark](#e1-watermark)
  - [E2. Separator](#e2-separator)
  - [E3. Highlight — All 4 Styles](#e3-highlight--all-4-styles)
  - [E4. Menu with Dropdowns](#e4-menu-with-dropdowns)
  - [E5. Native Override](#e5-native-override)
  - [E6. Theme Presets](#e6-theme-presets)
- [API Reference](#api-reference)
  - [Global Functions](#global-functions)
  - [Methods — Full Table](#methods--full-table)
  - [Events](#events)
  - [Properties](#properties)
  - [Theme Targets](#theme-targets)
  - [Extended API](#extended-api)
- [Pattern Library](#pattern-library)
  - [Toggle Feature](#pattern-toggle-feature)
  - [Toggle Group (Radio)](#pattern-toggle-group-radio)
  - [Cooldown Button](#pattern-cooldown-button)
  - [Counter Display](#pattern-counter-display)
  - [Notification System](#pattern-notification-system)
- [Real-World Examples](#real-world-examples)
  - [ESP Toggle with Highlight](#esp-toggle-with-highlight)
  - [Script Hub with Menu+Dropdown](#script-hub-with-menudropdown)
  - [Watermark + Separator Layout](#watermark--separator-layout)
  - [Hide/Show Obsidian UI](#hideshow-obsidian-ui)
  - [Accessories Dropdown from GUI](#accessories-dropdown-from-gui)
  - [Full Production Script](#full-production-script)
- [Troubleshooting](#troubleshooting)
- [Known Bug Fixes](#known-bug-fixes)

---

## Files Overview

| File | Purpose |
|------|---------|
| `TopbarPlus_bundled_fixed.lua` | Core bundle — TopbarPlus v3 patched for executor |
| `TopbarPlus_Extended.lua` | Extended module — Highlight, Watermark, etc. |

You can use the core bundle alone, or load Extended which wraps it.

---

## Installation

### Core bundle only

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

if not Icon then warn("[TopbarPlus] Load failed!") return end
```

### With Extended module

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon    -- same Icon class, all original methods work
local Ex   = tpx.Ex      -- extended utilities
-- tpx.Presets            -- theme preset tables
```

### From URL

```lua
-- Core
local tp = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus.lua"))()
local Icon = tp.get()

-- Extended
local tpx = loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
```

---

## Concepts

### How It Works

TopbarPlus creates custom icons on Roblox's topbar — the black bar at the top of every experience.

Each icon is a **clickable widget** that can:
- Toggle between **selected** (clicked on) and **deselected** (clicked off) states
- Display an **image**, a **text label**, or both
- Contain a vertical **dropdown** list of child icons
- Contain a horizontal **menu** row of child icons
- **Bind** to a GUI frame so it auto shows/hides on toggle
- **Respond** to keyboard shortcuts
- Show a **notification badge** counter
- Show a **caption tooltip** on hover

Icons sit on the topbar and TopbarPlus automatically handles:
- Overflow when too many icons are created (pushes to an overflow menu)
- Mobile / gamepad / console support
- Screen inset awareness

### Chaining

Nearly every method returns `self` (the icon), enabling call chains:

```lua
-- Without chaining
local icon = Icon.new()
icon:setImage(12345678)
icon:setLabel("Shop")
icon:align("Right")
icon:setCaption("Open Shop")

-- With chaining — identical result
local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Shop")
    :align("Right")
    :setCaption("Open Shop")
```

Methods that are chainable are marked ✅ in the API Reference.

### Icon States

Some methods accept an optional `iconState` parameter that controls **when** the value is applied.

| State value | When it applies |
|-------------|----------------|
| `nil` | Applied to ALL states (default) |
| `"Deselected"` | Only when icon is not selected |
| `"Selected"` | Only when icon is selected |
| `"Viewing"` | Only while hovering/touching before release |

State names are **case-insensitive**: `"deselected"` = `"Deselected"` = `"DESELECTED"`.

```lua
-- Same label in all states (default — no iconState arg)
icon:setLabel("Shop")

-- Different label per state
icon:setLabel("Open",   "Selected")
icon:setLabel("Closed", "Deselected")
icon:setLabel("...",    "Viewing")
```

Methods that accept `iconState` are marked 🔁 in the API Reference.

### Icon Order

By default, icons appear left-to-right in the order they were created. The default order values are `1.01`, `1.02`, `1.03`, etc.

Override with `:setOrder(n)`:

```lua
local icon1 = Icon.new():setLabel("First"):setOrder(1)
local icon2 = Icon.new():setLabel("Second"):setOrder(2)
local icon3 = Icon.new():setLabel("Third"):setOrder(3)
```

---

## Core Usage — Step by Step

### 1. Hello World

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- Simplest possible icon
local icon = Icon.new()
    :setLabel("Hello!")
```

That's it. One icon appears on the left side of the topbar.

---

### 2. Image + Label

```lua
-- Both image and label
local icon = Icon.new()
    :setImage(6031068420)   -- Roblox asset ID (number)
    :setLabel("Shop")

-- Or use rbxassetid string
local icon = Icon.new()
    :setImage("rbxassetid://6031068420")
    :setLabel("Shop")

-- Image only (no label)
local icon = Icon.new()
    :setImage(6031068420)

-- Label only (no image)
local icon = Icon.new()
    :setLabel("Shop")
```

Customizing image appearance:

```lua
local icon = Icon.new()
    :setImage(6031068420)
    :setImageScale(0.7)        -- image takes 70% of icon space (default 0.5)
    :setImageRatio(1.5)        -- stretch image horizontally (default 1 = square)
```

---

### 3. Alignment

```lua
icon:align("Left")    -- left side of screen (default)
icon:align("Center")  -- center of screen
icon:align("Right")   -- right side (near Roblox home/backpack buttons)
```

Changing alignment after creation:

```lua
local icon = Icon.new():setLabel("Test"):align("Left")

-- later...
icon:align("Right")   -- repositions immediately
```

---

### 4. Events — All 6

```lua
local icon = Icon.new():setLabel("Test")

-- ① selected — fires when icon becomes selected (clicked ON)
icon.selected:Connect(function(fromSource)
    print("Selected by:", fromSource or "Unknown")
    -- fromSource values: "User" | "OneClick" | "AutoDeselect" | "HideParentFeature" | "Overflow" | nil
end)

-- ② deselected — fires when icon becomes deselected (clicked OFF)
icon.deselected:Connect(function(fromSource)
    print("Deselected by:", fromSource or "Unknown")
end)

-- ③ toggled — fires on BOTH selected and deselected
icon.toggled:Connect(function(isSelected, fromSource)
    if isSelected then
        print("Just turned ON")
    else
        print("Just turned OFF")
    end
end)

-- ④ viewingStarted — fires when mouse/touch begins hovering
icon.viewingStarted:Connect(function()
    print("Hover started")
end)

-- ⑤ viewingEnded — fires when mouse/touch stops hovering
icon.viewingEnded:Connect(function()
    print("Hover ended")
end)

-- ⑥ notified — fires when a new notice badge is added
icon.notified:Connect(function()
    print("New notice! Total:", icon.totalNotices)
end)
```

Using `bindEvent` instead of direct `.Connect`:

```lua
-- bindEvent is chainable, direct Connect is not
icon:bindEvent("selected", function(self)
    print("selected via bindEvent, self =", self.name)
end)

icon:unbindEvent("selected")   -- disconnect that binding
```

---

### 5. Toggle Logic Pattern

The standard pattern for enabling/disabling a feature:

```lua
local myFeatureEnabled = false

local icon = Icon.new()
    :setLabel("Feature")
    :align("Right")

-- Using toggled (recommended — single handler)
icon.toggled:Connect(function(isOn)
    myFeatureEnabled = isOn

    if isOn then
        -- code to ENABLE feature
    else
        -- code to DISABLE feature
    end
end)

-- Equivalent using selected + deselected
icon.selected:Connect(function()
    myFeatureEnabled = true
    -- enable
end)
icon.deselected:Connect(function()
    myFeatureEnabled = false
    -- disable
end)
```

---

### 6. State-Based Appearance

Show different visuals depending on whether the icon is selected or not:

```lua
-- Different labels
local icon = Icon.new()
    :setLabel("OFF",    "Deselected")
    :setLabel("ON",     "Selected")

-- Different images
icon:setImage(111111, "Deselected")   -- image shown when NOT selected
icon:setImage(222222, "Selected")     -- image shown when selected

-- Different text colors
icon:setTextColor(Color3.fromRGB(150, 150, 150), "Deselected")   -- gray when off
icon:setTextColor(Color3.fromRGB(100, 255, 100), "Selected")     -- green when on

-- Viewing state (while hovering, before click)
icon:setLabel("Click me!", "Viewing")

-- All three at once
local icon = Icon.new()
    :setLabel("🔴 OFF",  "Deselected")
    :setLabel("🟢 ON",   "Selected")
    :setLabel("🟡 ...",  "Viewing")
    :setImage(111111,    "Deselected")
    :setImage(222222,    "Selected")
    :setTextColor(Color3.fromRGB(180,50,50),   "Deselected")
    :setTextColor(Color3.fromRGB(50,180,50),   "Selected")
    :setTextColor(Color3.fromRGB(180,180,50),  "Viewing")
    :align("Right")
```

---

### 7. Bind a GUI Frame

Automatically show a ScreenGui frame when selected and hide it when deselected:

```lua
local frame = game.Players.LocalPlayer
    .PlayerGui.MyScreenGui.MainFrame

local icon = Icon.new()
    :setLabel("Menu")
    :align("Right")
    :bindToggleItem(frame)

-- That single line is equivalent to:
icon.selected:Connect(function()   frame.Visible = true  end)
icon.deselected:Connect(function() frame.Visible = false end)
```

Binding multiple frames:

```lua
icon:bindToggleItem(frame1)
icon:bindToggleItem(frame2)
icon:bindToggleItem(frame3)
```

Removing a binding:

```lua
icon:unbindToggleItem(frame1)
```

Making the frame start visible with the icon pre-selected:

```lua
local icon = Icon.new()
    :setLabel("Menu")
    :bindToggleItem(frame)
    :select()   -- force select at start → frame becomes visible
```

---

### 8. Keyboard Shortcut

Bind a keycode so pressing it toggles the icon:

```lua
local icon = Icon.new()
    :setLabel("ESP")
    :bindToggleKey(Enum.KeyCode.X)

-- Automatically shows an "X" hint in the caption
-- Remove:
icon:unbindToggleKey(Enum.KeyCode.X)
```

Multiple keys:

```lua
icon:bindToggleKey(Enum.KeyCode.X)
icon:bindToggleKey(Enum.KeyCode.LeftAlt)
```

Custom caption hint without actual binding:

```lua
icon:setCaption("Toggle ESP")
icon:setCaptionHint(Enum.KeyCode.X)   -- shows hint but doesn't bind
```

---

### 9. Caption Tooltip

A small tooltip that appears when the user hovers over the icon:

```lua
local icon = Icon.new()
    :setLabel("Shop")
    :setCaption("Open the Shop")          -- basic caption

icon:setCaptionHint(Enum.KeyCode.B)       -- adds keybind hint to caption
icon:setCaption(nil)                       -- remove caption entirely
```

Caption with key and custom text:

```lua
Icon.new()
    :setLabel("Shop")
    :setCaption("Open Shop")
    :bindToggleKey(Enum.KeyCode.B)        -- binding also shows hint automatically
    :align("Right")
```

---

### 10. Notification Badge

Show a red number badge on the icon (like unread notifications):

```lua
local icon = Icon.new():setLabel("Inbox")

-- Add a notice (+1 to badge)
icon:notify()
icon:notify()    -- badge now shows "2"
icon:notify()    -- badge now shows "3"

-- Auto-clear the badge when icon is deselected
icon:notify(icon.deselected)

-- Or auto-clear on a custom event
local myEvent = Instance.new("BindableEvent")
icon:notify(myEvent.Event)

-- Clear all notices manually
icon:clearNotices()

-- Read current count
print("Notices:", icon.totalNotices)

-- Respond to new notices
icon.notified:Connect(function()
    print("New notice added!")
end)
```

Simulating a notification from a RemoteEvent:

```lua
local icon = Icon.new():setLabel("Chat")
icon:notify(icon.deselected)    -- auto-clear on open

game:GetService("ReplicatedStorage").ChatMessage.OnClientEvent:Connect(function()
    if not icon.isSelected then
        icon:notify(icon.deselected)
    end
end)
```

---

### 11. One-Click Button

Convert the icon into a single-click button — it instantly deselects after being clicked:

```lua
local icon = Icon.new()
    :setLabel("Heal")
    :oneClick()

-- deselected fires right after selected
icon.deselected:Connect(function()
    print("Healed!")
    -- do your action here
end)
```

One-click with visual feedback:

```lua
local icon = Icon.new()
    :setLabel("Teleport")
    :oneClick()
    :setCaption("Click to teleport")

icon.deselected:Connect(function()
    -- your teleport code
    print("Teleporting!")
end)
```

---

### 12. Lock & Debounce & Cooldown

**Lock** prevents user clicks but code can still toggle:

```lua
icon:lock()     -- user can't click
icon:unlock()   -- user can click again

-- You can still force-select/deselect in code:
icon:lock()
icon:select()     -- works fine
icon:deselect()   -- works fine
icon:unlock()
```

**Debounce** adds a timed cooldown — locks, waits, unlocks:

> ⚠️ `debounce` **yields** — always use inside `task.spawn`

```lua
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(2)    -- lock for 2 seconds then unlock
    end)
    print("Triggered!")
end)
```

**Cooldown pattern** (debounce on fire event):

```lua
icon.selected:Connect(function()
    -- Fire remote
    game:GetService("ReplicatedStorage").UseAbility:FireServer()

    -- Start cooldown
    task.spawn(function()
        icon:debounce(5)    -- 5 second cooldown
    end)
end)
```

**Auto-deselect behaviour**:

```lua
-- Default: clicking any OTHER icon deselects this one
icon:autoDeselect(true)    -- default

-- Disable: this icon stays selected even when others are clicked
icon:autoDeselect(false)   -- useful in dropdowns for independent toggles
```

---

### 13. Theme — Full Guide

`modifyTheme` lets you change any visual property of an icon.

#### Format

```lua
-- Single change: one table with 3 values
icon:modifyTheme({"TargetName", "Property", value})

-- Multiple changes: a table of tables
icon:modifyTheme({
    {"TargetName", "Property", value},
    {"TargetName", "Property", value},
    ...
})

-- State-specific (4th value)
icon:modifyTheme({"TargetName", "Property", value, "Selected"})
```

#### Common properties

```lua
-- Background color and transparency
icon:modifyTheme({
    {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 30)},
    {"Widget", "BackgroundTransparency", 0},      -- 0 = fully opaque
})

-- Corner rounding
icon:modifyTheme({
    {"IconCorners", "CornerRadius", UDim.new(0, 8)},    -- 8px rounded
    {"IconCorners", "CornerRadius", UDim.new(0, 0)},    -- fully square
    {"IconCorners", "CornerRadius", UDim.new(0.5, 0)},  -- fully circular
})

-- Size
icon:modifyTheme({
    {"Widget", "MinimumWidth",  120},
    {"Widget", "MinimumHeight", 44},
})

-- Disable gradient
icon:modifyTheme({"IconGradient", "Enabled", false})

-- Text label
icon:modifyTheme({
    {"IconLabel", "TextSize",   18},
    {"IconLabel", "TextColor3", Color3.fromRGB(255, 255, 255)},
})

-- Dropdown max items
icon:modifyTheme({"Dropdown", "MaxIcons", 6})

-- Menu max items
icon:modifyTheme({"Menu", "MaxIcons", 4})
```

#### State-specific theme

```lua
-- Different background when selected
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(0, 120, 255),  "Selected"})
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(25, 25, 30),   "Deselected"})

-- Different text color
icon:modifyTheme({"IconLabel", "TextColor3", Color3.fromRGB(100, 255, 100), "Selected"})
icon:modifyTheme({"IconLabel", "TextColor3", Color3.fromRGB(180, 180, 180), "Deselected"})
```

#### Apply to children (dropdown/menu)

```lua
-- Applies to ALL direct child icons
icon:modifyChildTheme({
    {"Widget", "MinimumWidth",           200},
    {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",      UDim.new(0, 6)},
})
```

#### Apply to ALL icons globally

```lua
Icon.modifyBaseTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget",       "BackgroundTransparency", 0},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
})
```

#### Full dark theme example

```lua
icon:modifyTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(18, 18, 22)},
    {"Widget",       "BackgroundTransparency", 0},
    {"Widget",       "MinimumWidth",           44},
    {"Widget",       "MinimumHeight",          44},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
    {"IconLabel",    "TextSize",               14},
    {"IconLabel",    "TextColor3",             Color3.fromRGB(220, 220, 220)},
})
```

---

### 14. Dropdown — Vertical Menu

A dropdown creates a vertical scrollable list that appears below the parent icon when clicked.

```lua
-- Static dropdown (hardcoded children)
local child1 = Icon.new():setLabel("Option A")
local child2 = Icon.new():setLabel("Option B")
local child3 = Icon.new():setLabel("Option C")
local child4 = Icon.new():setLabel("Option D")
local child5 = Icon.new():setLabel("Option E")

child1.selected:Connect(function() print("A selected") end)
child2.selected:Connect(function() print("B selected") end)

local drop = Icon.new()
    :setLabel("Options")
    :modifyTheme({{"Dropdown", "MaxIcons", 3}})         -- show 3, scroll for more
    :modifyChildTheme({{"Widget", "MinimumWidth", 160}})  -- children at least 160px wide
    :setDropdown({child1, child2, child3, child4, child5})
```

Programmatically updating the dropdown:

```lua
-- Remove all children
drop:setDropdown({})

-- Set new children
local newKids = {Icon.new():setLabel("New A"), Icon.new():setLabel("New B")}
drop:setDropdown(newKids)
```

Adding / removing a single child:

```lua
local extra = Icon.new():setLabel("Extra")
extra:joinDropdown(drop)    -- add to existing dropdown
extra:leave()               -- remove from dropdown
```

> ⚠️ Icons that have a dropdown attached **cannot** be added to another dropdown. They can be added to a menu.

---

### 15. Menu — Horizontal Menu

A menu creates a horizontal row of icons inside the parent icon.

```lua
local item1 = Icon.new():setLabel("Fly")
local item2 = Icon.new():setLabel("Speed")
local item3 = Icon.new():setLabel("Noclip")
local item4 = Icon.new():setLabel("Jump")

item1.selected:Connect(function() print("Fly!") end)

local menu = Icon.new()
    :setLabel("Movement")
    :modifyTheme({{"Menu", "MaxIcons", 2}})   -- show 2, arrow for rest
    :setMenu({item1, item2, item3, item4})
```

Removing the menu:

```lua
menu:setMenu({})
```

Adding / removing a single item:

```lua
local extra = Icon.new():setLabel("Extra")
extra:joinMenu(menu)   -- add
extra:leave()          -- remove
```

---

### 16. Fixed Menu

A fixed menu is always expanded and has no close button:

```lua
Icon.new()
    :modifyTheme({
        {"Menu", "MaxIcons", 3},
        {"Widget", "MinimumHeight", 44},
    })
    :setFixedMenu({
        Icon.new():setLabel("Home"),
        Icon.new():setLabel("Shop"),
        Icon.new():setLabel("Inventory"),
        Icon.new():setLabel("Settings"),
        Icon.new():setLabel("Credits"),
    })
```

Fixed menus are useful for persistent navigation bars.

---

### 17. Dynamic Icons from Data

Build children dynamically from a Lua table:

```lua
-- Toggle feature pattern
local function makeToggle(label, onToggle)
    local c = Icon.new()
        :setLabel("✗ " .. label)
        :setWidth(170)
        :autoDeselect(false)    -- keep independent state
    c.toggled:Connect(function(isOn)
        c:setLabel((isOn and "✓ " or "✗ ") .. label)
        onToggle(isOn)
    end)
    return c
end

-- One-click button pattern
local function makeButton(label, onClick)
    local c = Icon.new()
        :setLabel(label)
        :setWidth(160)
        :oneClick()
    c.deselected:Connect(onClick)
    return c
end

-- Build from data
local features = {
    {label = "Fly",           fn = function(on) print("Fly:", on)    end},
    {label = "Speed Hack",    fn = function(on) print("Speed:", on)  end},
    {label = "Noclip",        fn = function(on) print("Clip:", on)   end},
    {label = "Infinite Jump", fn = function(on) print("Jump:", on)   end},
    {label = "Auto Farm",     fn = function(on) print("Farm:", on)   end},
}

local children = {}
for _, f in ipairs(features) do
    table.insert(children, makeToggle(f.label, f.fn))
end

Icon.new()
    :setLabel("Features")
    :align("Left")
    :modifyTheme({{"Dropdown", "MaxIcons", 5}})
    :modifyChildTheme({{"Widget", "MinimumWidth", 180}})
    :setDropdown(children)
```

From an in-game GUI:

```lua
local Array = game.Players.LocalPlayer
    .PlayerGui.AwesomeGUI.Shop.AccessoryArray.Array

local icons = {}
for _, v in pairs(Array:GetChildren()) do
    local child = Icon.new()
        :setLabel(v.Name)
        :setImage(v.Accessory.Image)
    child.selected:Connect(function()
        game:GetService("ReplicatedStorage")
            .AccessoryHandle:FireServer("Equip", v.Name, nil)
    end)
    table.insert(icons, child)
end

Icon.new()
    :setLabel("Accessories")
    :align("Right")
    :modifyTheme({{"Dropdown","MaxIcons",6}})
    :modifyChildTheme({{"Widget","MinimumWidth",220}})
    :setDropdown(icons)
```

---

### 18. RichText Labels

Inject HTML-like colored/styled text directly into an icon's label:

```lua
local child = Icon.new()

-- Must use task.defer because the label instance is created after Icon.new()
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Dark Aura   <font color="#FF5050">5,600 KILLS</font>'
end)
```

Multiple colors in one label:

```lua
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Custom Cape   <font color="#FFD700">VIP ONLY</font>'
end)
```

Locked item (grayed out + lock emoji):

```lua
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = '🔒 <font color="#888888">' .. itemName .. '</font>'
end)

-- Also prevent selection when locked
child.selected:Connect(function()
    child:deselect()
end)
```

Bold text:

```lua
lbl.Text = '<b>IMPORTANT</b>   Normal text'
```

---

### 19. Global Controls

```lua
-- Get icon by name (set with :setName())
local icon = Icon.getIcon("MyIcon")

-- Get ALL icons as a dictionary { [uid] = icon }
local all = Icon.getIcons()
for uid, ic in pairs(all) do
    print(uid, ic.name, ic.isSelected)
end

-- Hide/show ALL TopbarPlus ScreenGuis
Icon.setTopbarEnabled(false)
Icon.setTopbarEnabled(true)

-- Set DisplayOrder for TopbarPlus ScreenGuis
Icon.setDisplayOrder(15)
```

---

### 20. Chainable call()

`call` lets you run a function while staying chainable — useful for async operations or conditional setup:

```lua
local icon = Icon.new()
    :setLabel("Score")
    :setWidth(80)
    :align("Right")
    :call(function(self)
        -- self = the icon. Runs in task.spawn (non-blocking)
        while task.wait(1) do
            local score = math.random(0, 999)
            self:setLabel(tostring(score))
        end
    end)
```

With conditional logic:

```lua
Icon.new()
    :setLabel("Status")
    :call(function(self)
        local isVip = game:GetService("MarketplaceService")
            :UserOwnsGamePassAsync(
                game.Players.LocalPlayer.UserId,
                123456
            )
        if isVip then
            self:setLabel("⭐ VIP")
            self:setTextColor(Color3.fromRGB(255, 215, 0))
        end
    end)
```

---

### 21. Named Icon Lookup

```lua
-- Give the icon a name
local icon = Icon.new()
    :setLabel("My Icon")
    :setName("myIcon")   -- sets lookup name

-- Later, from anywhere in the script
local found = Icon.getIcon("myIcon")
if found then
    found:notify()
    print("isSelected:", found.isSelected)
end
```

---

### 22. Destroy & Cleanup

```lua
-- Manually destroy
icon:destroy()    -- removes all connections, instances, and the icon

-- addToJanitor: run cleanup code when icon is destroyed
icon:addToJanitor(function()
    print("icon was destroyed!")
end)

-- Add an instance to be destroyed with the icon
local conn = RunService.Heartbeat:Connect(function() end)
icon:addToJanitor(conn)    -- conn:Disconnect() called when icon:destroy()
```

---

## Extended Module — Step by Step

### Loading Extended

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon     -- identical to tp.get() — all original methods work
local Ex   = tpx.Ex       -- extended utilities
local Pre  = tpx.Presets  -- theme preset tables
```

---

### E1. Watermark

Creates a non-interactive, non-clickable decorative icon. Perfect for version labels or branding.

```lua
-- Text only
Ex.watermark("v1.0 | MyScript")

-- Text with explicit alignment
Ex.watermark("v2.0 | KillScript", nil, "Right")

-- Image + text
Ex.watermark("PREMIUM", 6031068420, "Right")

-- Image only (no text)
Ex.watermark(nil, 6031068420, "Left")

-- Custom style after creation
local wm = Ex.watermark("v1.0", nil, "Right")
wm:modifyTheme({
    {"IconLabel", "TextColor3", Color3.fromRGB(255, 215, 0)},  -- gold text
    {"IconLabel", "TextSize",   13},
})
```

Signature:
```
Ex.watermark(text?, imageId?, align?) → Icon
    text    : string?  — label text (nil for none)
    imageId : number?  — Roblox asset ID (nil for none)
    align   : string?  — "Left"|"Center"|"Right" (default "Right")
```

---

### E2. Separator

Creates an invisible spacing element between icons.

```lua
-- Small gap (default 10px)
Ex.separator()

-- Custom width
Ex.separator(20)

-- Custom width and alignment
Ex.separator(20, "Right")
Ex.separator(15, "Left")
```

Typical usage — put a gap between functional icons and a watermark:

```lua
local esp = Icon.new():setLabel("ESP"):align("Right")
Ex.separator(8, "Right")
Ex.watermark("v1.0", nil, "Right")
```

Signature:
```
Ex.separator(width?, align?) → Icon
    width : number? — pixel width (default 10)
    align : string? — "Left"|"Center"|"Right" (default "Left")
```

---

### E3. Highlight — All 4 Styles

Adds a visual highlight effect (UIStroke + optional gradient) to any icon.

#### `"border"` — Clean thin outline

```lua
local icon = Icon.new():setLabel("Test"):align("Right")

Ex.highlight(icon)
-- Defaults: style="border", color=white, thickness=2

Ex.highlight(icon, {
    style     = "border",
    color     = Color3.fromRGB(100, 200, 255),
    thickness = 3,
})
```

#### `"glow"` — Double-stroke glow effect

```lua
Ex.highlight(icon, {
    style     = "glow",
    color     = Color3.fromRGB(0, 200, 255),
    thickness = 2,
    animated  = false,    -- set true for pulsing animation
})

-- Animated version
Ex.highlight(icon, {
    style    = "glow",
    color    = Color3.fromRGB(255, 100, 100),
    animated = true,      -- outer stroke pulses in/out
})
```

#### `"premium"` — Gold gradient + gold border

```lua
Ex.highlight(icon, {style = "premium"})

-- With shimmer rotation animation
Ex.highlight(icon, {
    style    = "premium",
    animated = true,       -- gradient slowly rotates
})

-- Custom thickness
Ex.highlight(icon, {
    style     = "premium",
    thickness = 3,
    animated  = true,
})
```

#### `"accent"` — Colored border + tinted background

```lua
Ex.highlight(icon, {
    style = "accent",
    color = Color3.fromRGB(255, 80, 80),     -- red accent
})

Ex.highlight(icon, {
    style = "accent",
    color = Color3.fromRGB(100, 255, 100),   -- green accent
})

Ex.highlight(icon, {
    style = "accent",
    color = Color3.fromRGB(255, 215, 0),     -- gold accent
})
```

Removing highlight:

```lua
Ex.removeHighlight(icon)
```

Signature:
```
Ex.highlight(icon, config?) → Icon
    config.style     : "border"|"glow"|"premium"|"accent" (default "border")
    config.color     : Color3  (default white)
    config.thickness : number  (default 2)
    config.animated  : bool    (default false)

Ex.removeHighlight(icon)
```

---

### E4. Menu with Dropdowns

Creates a horizontal menu where each tab can contain its own vertical dropdown. This is the most powerful composition helper.

```lua
-- Simple version
Ex.menuWithDropdowns({
    label = "Hub",
    align = "Left",
    items = {
        {label = "Tab 1", onSelect = function() print("tab 1") end},
        {label = "Tab 2", onSelect = function() print("tab 2") end},
    }
})

-- With dropdowns inside menu items
local function makeToggle(label, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(170):autoDeselect(false)
    c.toggled:Connect(function(on) c:setLabel((on and "✓ " or "✗ ")..label); fn(on) end)
    return c
end

Ex.menuWithDropdowns({
    label        = "Script Hub",
    align        = "Left",
    maxMenuIcons = 4,
    items = {
        {
            label = "⚔ Combat",
            dropdown = {
                maxIcons = 5,
                minWidth = 180,
                items    = {
                    makeToggle("Aimbot",     function(on) end),
                    makeToggle("Silent Aim", function(on) end),
                    makeToggle("ESP",        function(on) end),
                    makeToggle("Chams",      function(on) end),
                    makeToggle("No Recoil",  function(on) end),
                }
            }
        },
        {
            label = "🏃 Move",
            dropdown = {
                maxIcons = 4,
                minWidth = 170,
                items    = {
                    makeToggle("Fly",       function(on) end),
                    makeToggle("Speed",     function(on) end),
                    makeToggle("Noclip",    function(on) end),
                    makeToggle("Inf Jump",  function(on) end),
                }
            }
        },
        {
            label    = "Rejoin",
            onSelect = function() print("rejoining!") end,
        },
    }
})
```

Signature:
```
Ex.menuWithDropdowns(config) → Icon
    config.label        : string  — parent icon label
    config.align        : string? — "Left"|"Center"|"Right" (default "Left")
    config.maxMenuIcons : number? — scroll menu after N items (default 4)
    config.items        : array of {
        label    : string
        image    : number|string?
        onSelect : function?       — for single-click items
        dropdown : {               — for items with vertical submenu
            maxIcons : number?     (default 5)
            minWidth : number?     (default 160)
            items    : Icon[]
        }?
    }
```

---

### E5. Native Override

Controls what happens when TopbarPlus icons might overlap Roblox's native buttons.

```lua
-- Default: TopbarPlus handles overflow automatically (safe, recommended)
Ex.setNativeOverride("dodge")
-- Or just don't call this — it's the default behavior

-- Hide native Roblox topbar completely
-- ⚠️ This affects the whole game session
Ex.setNativeOverride("hide")
```

> **Note:** TopbarPlus already handles overflow natively. Icons that would overlap Roblox's buttons get pushed into an overflow icon automatically. You only need `setNativeOverride("hide")` if you want to fully replace the native topbar.

---

### E6. Theme Presets

Preset theme tables ready to use with `Icon.modifyBaseTheme` or `icon:modifyTheme`:

```lua
local tpx = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Pre  = tpx.Presets

-- Apply globally to ALL icons
Icon.modifyBaseTheme(Pre.dark)
Icon.modifyBaseTheme(Pre.light)
Icon.modifyBaseTheme(Pre.glass)
Icon.modifyBaseTheme(Pre.gold)

-- Apply to a single icon
local icon = Icon.new():setLabel("Test")
icon:modifyTheme(Pre.dark)

-- Customize on top of a preset
Icon.modifyBaseTheme(Pre.dark)
Icon.modifyBaseTheme({
    {"Widget", "BackgroundColor3", Color3.fromRGB(10, 10, 15)},  -- override one value
})
```

| Preset | Description |
|--------|-------------|
| `Pre.dark` | Dark background `(18,18,22)`, rounded corners, no gradient |
| `Pre.light` | Light background `(240,240,245)`, dark text |
| `Pre.glass` | White background 70% transparent |
| `Pre.gold` | Dark gold background, gold text |

---

## API Reference

### Global Functions

| Function | Returns | Description |
|----------|---------|-------------|
| `Icon.new()` | `Icon` | Create empty 32×32 icon |
| `Icon.getIcon(nameOrUID)` | `Icon?` | Find icon by name or UID |
| `Icon.getIcons()` | `{[uid]:Icon}` | Dictionary of all active icons |
| `Icon.setTopbarEnabled(bool)` | — | Show/hide all TopbarPlus ScreenGuis |
| `Icon.modifyBaseTheme(mods)` | — | Apply theme to all icons globally |
| `Icon.setDisplayOrder(int)` | — | Base DisplayOrder for ScreenGuis |

---

### Methods — Full Table

> ✅ = Chainable &nbsp;&nbsp; 🔁 = Toggleable (accepts `iconState`) &nbsp;&nbsp; ⏸ = Yields

#### Appearance

| Method | ✅ | 🔁 | Description |
|--------|:--:|:--:|-------------|
| `:setImage(id, state?)` | ✅ | 🔁 | Image. Asset ID `number` or `"rbxassetid://..."` |
| `:setLabel(text, state?)` | ✅ | 🔁 | Text label |
| `:setWidth(min, state?)` | ✅ | 🔁 | Minimum width in pixels (default `44`) |
| `:setImageScale(n, state?)` | ✅ | 🔁 | Image size relative to icon size (default `0.5`) |
| `:setImageRatio(n, state?)` | ✅ | 🔁 | Image aspect ratio W/H (default `1` = square) |
| `:setCornerRadius(s, o, state?)` | ✅ | 🔁 | Corner rounding: scale + offset |
| `:setTextSize(n, state?)` | ✅ | 🔁 | Font size (default `16`) |
| `:setTextColor(Color3, state?)` | ✅ | 🔁 | Label text color |
| `:setTextFont(f, w?, s?, state?)` | ✅ | 🔁 | Font — `Enum.Font`, name string, or asset ID |
| `:setOrder(n, state?)` | ✅ | 🔁 | Topbar position order |
| `:disableStateOverlay(bool)` | ✅ | — | Disable press/hover shade overlay |
| `:modifyTheme(mods)` | ✅ | — | Custom theme modifications |
| `:modifyChildTheme(mods)` | ✅ | — | Theme for all dropdown/menu children |

#### Behavior

| Method | ✅ | Description |
|--------|:--:|-------------|
| `:align(str)` | ✅ | `"Left"` \| `"Center"` \| `"Right"` |
| `:setName(name)` | ✅ | Name for `Icon.getIcon()` lookup |
| `:setEnabled(bool)` | ✅ | Show (`true`) or hide (`false`) icon |
| `:select()` | ✅ | Force-select programmatically |
| `:deselect()` | ✅ | Force-deselect programmatically |
| `:lock()` | ✅ | Block user clicks (code can still toggle) |
| `:unlock()` | ✅ | Re-enable user clicks |
| `:debounce(seconds)` | ✅⏸ | Lock → wait → unlock (yields!) |
| `:autoDeselect(bool)` | ✅ | Deselect when another icon is clicked (default `true`) |
| `:oneClick(bool)` | ✅ | Auto-deselect immediately after selecting |

#### Notifications

| Method | ✅ | Description |
|--------|:--:|-------------|
| `:notify(clearEvent?)` | ✅ | Add notice badge (+1). Pass event to auto-clear |
| `:clearNotices()` | ✅ | Remove all notices |

#### Toggle Items & Keys

| Method | ✅ | Description |
|--------|:--:|-------------|
| `:bindToggleItem(gui)` | ✅ | GuiObject shows when selected, hides when deselected |
| `:unbindToggleItem(gui)` | ✅ | Remove toggle binding |
| `:bindToggleKey(KeyCode)` | ✅ | Keyboard key to toggle icon |
| `:unbindToggleKey(KeyCode)` | ✅ | Remove keybind |

#### Caption

| Method | ✅ | Description |
|--------|:--:|-------------|
| `:setCaption(text)` | ✅ | Hover tooltip text. Pass `nil` to remove |
| `:setCaptionHint(KeyCode)` | ✅ | Display key hint in caption without actually binding |

#### Dropdown & Menu

| Method | ✅ | Description |
|--------|:--:|-------------|
| `:setDropdown(icons)` | ✅ | Vertical dropdown list. `{}` to remove |
| `:joinDropdown(parent)` | ✅ | Add this icon to parent's dropdown |
| `:setMenu(icons)` | ✅ | Horizontal menu row. `{}` to remove |
| `:setFixedMenu(icons)` | ✅ | Always-open menu, no close button |
| `:joinMenu(parent)` | ✅ | Add this icon to parent's menu |
| `:leave()` | ✅ | Remove from current dropdown or menu parent |

#### Misc

| Method | ✅ | Description |
|--------|:--:|-------------|
| `:call(func)` | ✅ | `task.spawn(func(icon))` — async while chainable |
| `:addToJanitor(ud)` | ✅ | Clean up `ud` when icon is destroyed |
| `:bindEvent(name, cb)` | ✅ | Connect event by camelCase name string |
| `:unbindEvent(name)` | ✅ | Disconnect event binding |
| `:getInstance(name)` | — | Returns first widget descendant named `name` |
| `:destroy()` | ✅ | Destroy icon, all connections, all instances |

---

### Events

```lua
-- Fires when icon becomes selected
-- fromSource: "User"|"OneClick"|"AutoDeselect"|"HideParentFeature"|"Overflow"|nil
icon.selected:Connect(function(fromSource) end)

-- Fires when icon becomes deselected
icon.deselected:Connect(function(fromSource) end)

-- Fires on both selected and deselected
icon.toggled:Connect(function(isSelected, fromSource) end)

-- Fires when mouse/finger begins hovering
icon.viewingStarted:Connect(function() end)

-- Fires when mouse/finger stops hovering
icon.viewingEnded:Connect(function() end)

-- Fires when a new notice is added
icon.notified:Connect(function() end)
```

---

### Properties

All read-only. Do not assign to these directly.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon.name` | `string` | `"Widget"` | Widget instance name |
| `icon.isSelected` | `bool` | `false` | Current toggle state |
| `icon.isEnabled` | `bool` | `true` | Visibility state |
| `icon.totalNotices` | `int` | `0` | Number of active notice badges |
| `icon.locked` | `bool` | `false` | Whether user input is blocked |

---

### Theme Targets

Use these as the first value in a `modifyTheme` array:

| Target Name | What it affects |
|-------------|----------------|
| `"Widget"` | The main outer container frame |
| `"IconButton"` | The inner button frame |
| `"IconSpot"` | The icon's background spot |
| `"IconCorners"` | Corner UICorner (collective) — corner radius |
| `"IconGradient"` | The UIGradient overlay |
| `"IconLabel"` | The TextLabel showing the label text |
| `"IconImage"` | The ImageLabel showing the icon image |
| `"IconOverlay"` | The hover/press overlay |
| `"Dropdown"` | The dropdown container |
| `"Menu"` | The menu container |

**Common Widget attributes (set as attribute via modifyTheme):**

| Attribute / Property | Type | Description |
|---------------------|------|-------------|
| `BackgroundColor3` | `Color3` | Background fill color |
| `BackgroundTransparency` | `number` | 0 = solid, 1 = invisible |
| `MinimumWidth` | `number` | Minimum width in pixels |
| `MinimumHeight` | `number` | Minimum height in pixels |

**Dropdown / Menu attributes:**

| Attribute | Description |
|-----------|-------------|
| `MaxIcons` | Number of items visible before scroll activates |
| `MaxWidth` | Maximum container width |

---

### Extended API

#### Watermark

```
Ex.watermark(text?, imageId?, align?) → Icon
```
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `text` | `string?` | `nil` | Label text |
| `imageId` | `number?` | `nil` | Roblox asset ID |
| `align` | `string?` | `"Right"` | `"Left"` \| `"Center"` \| `"Right"` |

---

#### Separator

```
Ex.separator(width?, align?) → Icon
```
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `width` | `number?` | `10` | Pixel width |
| `align` | `string?` | `"Left"` | Alignment |

---

#### Highlight

```
Ex.highlight(icon, config?) → Icon
Ex.removeHighlight(icon)
```

| Config key | Type | Default | Description |
|------------|------|---------|-------------|
| `style` | `string` | `"border"` | `"border"` \| `"glow"` \| `"premium"` \| `"accent"` |
| `color` | `Color3` | white | Stroke/glow color |
| `thickness` | `number` | `2` | Stroke thickness in pixels |
| `animated` | `bool` | `false` | Enable pulsing/shimmer animation |

---

#### Menu with Dropdowns

```
Ex.menuWithDropdowns(config) → Icon
```

| Config key | Type | Default | Description |
|------------|------|---------|-------------|
| `label` | `string` | `"Menu"` | Parent icon label |
| `align` | `string?` | `"Left"` | Alignment |
| `maxMenuIcons` | `number?` | `4` | Menu items before scroll |
| `items` | `array` | `{}` | Array of item configs (see below) |

Item config:

| Key | Type | Description |
|-----|------|-------------|
| `label` | `string` | Item label |
| `image` | `number\|string?` | Asset ID |
| `onSelect` | `function?` | Callback for single-click items |
| `dropdown.maxIcons` | `number?` | Dropdown scroll threshold (default 5) |
| `dropdown.minWidth` | `number?` | Child min width (default 160) |
| `dropdown.items` | `Icon[]` | Child icons |

---

#### Native Override

```
Ex.setNativeOverride(mode?)
```

| Mode | Description |
|------|-------------|
| `"dodge"` | TopbarPlus handles overflow (default, safe) |
| `"hide"` | Hides Roblox native topbar via `SetCore` |

---

## Pattern Library

### Pattern: Toggle Feature

```lua
local enabled = false

local icon = Icon.new()
    :setLabel("✗ Feature", "Deselected")
    :setLabel("✓ Feature", "Selected")
    :setTextColor(Color3.fromRGB(180, 180, 180), "Deselected")
    :setTextColor(Color3.fromRGB(100, 255, 100), "Selected")
    :align("Right")

icon.toggled:Connect(function(isOn)
    enabled = isOn
    print("Feature:", isOn)
end)
```

---

### Pattern: Toggle Group (Radio)

Only one icon in the group can be selected at a time:

```lua
local options = {"Option A", "Option B", "Option C"}
local currentSelected = nil
local children = {}

for _, name in ipairs(options) do
    local child = Icon.new()
        :setLabel(name)
        :setWidth(120)
        :autoDeselect(false)   -- disable global autoDeselect

    child.selected:Connect(function()
        -- Deselect all others in the group
        for _, c in ipairs(children) do
            if c ~= child then c:deselect() end
        end
        currentSelected = name
        print("Selected:", name)
    end)

    table.insert(children, child)
end

Icon.new()
    :setLabel("Choose")
    :setDropdown(children)
```

---

### Pattern: Cooldown Button

Button that becomes unclickable for N seconds after use:

```lua
local COOLDOWN = 5   -- seconds

local icon = Icon.new()
    :setLabel("Use Ability")
    :oneClick()
    :align("Right")

local onCooldown = false

icon.deselected:Connect(function()
    if onCooldown then return end
    onCooldown = true

    print("Ability used!")
    -- your ability code here

    task.spawn(function()
        icon:debounce(COOLDOWN)
        onCooldown = false
    end)
end)
```

---

### Pattern: Counter Display

Show a live-updating number in an icon label:

```lua
local counterIcon = Icon.new()
    :setWidth(90)
    :align("Left")
    :lock()
    :disableStateOverlay(true)
    :modifyTheme({
        {"Widget", "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
        {"Widget", "BackgroundTransparency", 0},
    })

local count = 0

local function updateCounter()
    counterIcon:setLabel("Score: " .. count)
end

updateCounter()

-- Update from a game event
game:GetService("ReplicatedStorage").ScoreChanged.OnClientEvent:Connect(function(newScore)
    count = newScore
    updateCounter()
end)
```

---

### Pattern: Notification System

```lua
local notifIcon = Icon.new()
    :setLabel("Inbox")
    :setImage(12345678)
    :align("Right")
    :setCaption("Open Inbox")

-- When messages arrive
local function onNewMessage()
    notifIcon:notify(notifIcon.deselected)   -- badge clears when opened
end

-- Simulate new messages
task.delay(3, onNewMessage)
task.delay(7, onNewMessage)

-- When user opens inbox
notifIcon.selected:Connect(function()
    print("Opening inbox — badge will clear on close")
end)
```

---

## Real-World Examples

### ESP Toggle with Highlight

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex

local espIcon = Icon.new()
    :setLabel("ESP OFF", "Deselected")
    :setLabel("ESP ON",  "Selected")
    :setTextColor(Color3.fromRGB(160, 160, 160), "Deselected")
    :setTextColor(Color3.fromRGB(100, 255, 100), "Selected")
    :align("Right")
    :setCaption("Toggle ESP")
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
    -- toggleESP(isOn)
    print("ESP:", isOn)
end)
```

---

### Script Hub with Menu+Dropdown

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex

Icon.modifyBaseTheme(tpx.Presets.dark)

local function toggle(label, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(175):autoDeselect(false)
    c.toggled:Connect(function(on) c:setLabel((on and "✓ " or "✗ ")..label); fn(on) end)
    return c
end

local function button(label, fn)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(fn)
    return c
end

local hub = Ex.menuWithDropdowns({
    label        = "⚡ Hub",
    align        = "Left",
    maxMenuIcons = 4,
    items = {
        {
            label    = "⚔ Combat",
            dropdown = {
                maxIcons = 5, minWidth = 185,
                items    = {
                    toggle("Aimbot",     function(on) end),
                    toggle("Silent Aim", function(on) end),
                    toggle("ESP",        function(on) end),
                    toggle("Chams",      function(on) end),
                    toggle("No Recoil",  function(on) end),
                    toggle("Rapid Fire", function(on) end),
                },
            },
        },
        {
            label    = "🏃 Move",
            dropdown = {
                maxIcons = 4, minWidth = 175,
                items    = {
                    toggle("Fly",       function(on) end),
                    toggle("Speed Hack",function(on) end),
                    toggle("Noclip",    function(on) end),
                    toggle("Inf Jump",  function(on) end),
                },
            },
        },
        {
            label    = "🔧 Misc",
            dropdown = {
                maxIcons = 4, minWidth = 165,
                items    = {
                    button("Teleport Spawn", function() end),
                    button("Rejoin",         function() end),
                    button("Copy UID",       function() end),
                },
            },
        },
    },
})

Ex.highlight(hub, {style = "accent", color = Color3.fromRGB(100, 150, 255)})
Ex.separator(12, "Left")
Ex.watermark("v2.0 | MyHub", nil, "Right")
```

---

### Watermark + Separator Layout

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex

-- Left side: functional icons
local feature1 = Icon.new():setLabel("Feature 1"):align("Left")
local feature2 = Icon.new():setLabel("Feature 2"):align("Left")

Ex.separator(10, "Left")

-- Right side: toggle + watermark
local toggle = Icon.new()
    :setLabel("OFF","Deselected")
    :setLabel("ON", "Selected")
    :align("Right")
Ex.highlight(toggle, {style="border", color=Color3.fromRGB(255,255,255)})

Ex.separator(8, "Right")
Ex.watermark("MyScript v1.0", nil, "Right")
```

---

### Hide/Show Obsidian UI

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"
))()

local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex

local Window = Library:CreateWindow({
    Title    = "My Script",
    AutoShow = true,
})

Library.ShowToggleFrameInKeybinds = false  -- hide Obsidian's default toggle

local toggle = Icon.new()
    :setLabel("Hide UI", "Deselected")
    :setLabel("Show UI", "Selected")
    :align("Right")
    :modifyTheme({
        {"Widget","BackgroundColor3",Color3.fromRGB(22,22,28)},
        {"Widget","BackgroundTransparency",0},
        {"IconCorners","CornerRadius",UDim.new(0,8)},
    })

Ex.highlight(toggle, {style="border", color=Color3.fromRGB(180,180,255)})

toggle.toggled:Connect(function()
    Window:Toggle()
end)
```

---

### Accessories Dropdown from GUI

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex

local RS = game:GetService("ReplicatedStorage")
local Array = game.Players.LocalPlayer
    .PlayerGui.AwesomeGUI.Shop.AccessoryArray.Array

local icons = {}
for _, v in pairs(Array:GetChildren()) do
    local isLocked = v:FindFirstChild("Locked") and v.Locked.Visible

    local child = Icon.new()
        :setImage(v.Accessory.Image)
        :setWidth(220)
        :modifyTheme({
            {"Widget",      "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
            {"Widget",      "BackgroundTransparency", 0},
            {"IconCorners", "CornerRadius",           UDim.new(0, 6)},
        })

    task.defer(function()
        local lbl = child:getInstance("IconLabel")
        if not lbl then return end
        lbl.RichText = true
        lbl.Text = isLocked
            and string.format('🔒 <font color="#888888">%s</font>', v.Name)
            or v.Name
    end)

    child.selected:Connect(function()
        if isLocked then child:deselect() return end
        RS.AccessoryHandle:FireServer("Equip", v.Name, nil)
    end)

    table.insert(icons, child)
end

local parent = Icon.new()
    :setLabel("Accessories")
    :align("Right")
    :modifyTheme({
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(25, 25, 30)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
        {"Dropdown",    "MaxIcons",               6},
    })
    :modifyChildTheme({
        {"Widget",      "MinimumWidth",           220},
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 6)},
    })
    :setDropdown(icons)

Ex.highlight(parent, {style = "accent", color = Color3.fromRGB(180, 120, 255)})
```

---

### Full Production Script

```lua
-- ── Load ──────────────────────────────────────────────────
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex

-- ── Global theme ─────────────────────────────────────────
Icon.modifyBaseTheme(tpx.Presets.dark)

-- ── Helpers ──────────────────────────────────────────────
local function toggle(label, width, fn)
    local c = Icon.new()
        :setLabel("✗ "..label)
        :setWidth(width or 170)
        :autoDeselect(false)
    c.toggled:Connect(function(on)
        c:setLabel((on and "✓ " or "✗ ")..label)
        fn(on)
    end)
    return c
end

local function btn(label, fn)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(fn)
    return c
end

-- ── Layout ───────────────────────────────────────────────
-- Left: main hub
local hub = Ex.menuWithDropdowns({
    label        = "⚡ Hub",
    align        = "Left",
    maxMenuIcons = 4,
    items = {
        {
            label = "⚔ Combat",
            dropdown = {
                maxIcons=5, minWidth=185,
                items = {
                    toggle("Aimbot",     185, function(on) end),
                    toggle("Silent Aim", 185, function(on) end),
                    toggle("ESP",        185, function(on) end),
                    toggle("Chams",      185, function(on) end),
                    toggle("No Recoil",  185, function(on) end),
                    toggle("Rapid Fire", 185, function(on) end),
                },
            },
        },
        {
            label = "🏃 Move",
            dropdown = {
                maxIcons=4, minWidth=175,
                items = {
                    toggle("Fly",       175, function(on) end),
                    toggle("Speed Hack",175, function(on) end),
                    toggle("Noclip",    175, function(on) end),
                    toggle("Inf Jump",  175, function(on) end),
                },
            },
        },
        {
            label = "🎨 Style",
            dropdown = {
                maxIcons=4, minWidth=175,
                items = {
                    toggle("Rainbow",  175, function(on) end),
                    toggle("Trails",   175, function(on) end),
                    toggle("Particles",175, function(on) end),
                },
            },
        },
        {
            label = "🔧 Misc",
            dropdown = {
                maxIcons=4, minWidth=165,
                items = {
                    btn("Teleport Spawn", function() end),
                    btn("Rejoin",         function() end),
                    btn("Copy UID",       function() end),
                    btn("Screenshot",     function() end),
                },
            },
        },
    },
})
Ex.highlight(hub, {style="accent", color=Color3.fromRGB(100, 150, 255)})

-- Gap
Ex.separator(8, "Left")

-- Right: ESP quick toggle
local esp = Icon.new()
    :setLabel("ESP OFF","Deselected")
    :setLabel("ESP ON", "Selected")
    :setTextColor(Color3.fromRGB(160,160,160), "Deselected")
    :setTextColor(Color3.fromRGB(100,255,100), "Selected")
    :align("Right")
    :bindToggleKey(Enum.KeyCode.X)
Ex.highlight(esp, {style="glow", color=Color3.fromRGB(100,255,100), animated=true})
esp.toggled:Connect(function(on) print("ESP:", on) end)

-- Gap + watermark
Ex.separator(10, "Right")
Ex.watermark("v2.0 | AwesomeHub", nil, "Right")
```

---

## Troubleshooting

### `attempt to call missing method 'clean' of table`

This is a known bug in the original TopbarPlus — already **fixed** in `TopbarPlus_bundled_fixed.lua`. Make sure you are using the patched file.

---

### `invalid argument #2 to 'clamp' (number expected, got nil)`

Also a known bug — already **fixed** in `TopbarPlus_bundled_fixed.lua`.

---

### `attempt to index nil with 'new'` at Line 4

`tp.get()` returned `nil`. Causes:

1. Bundle file path is wrong — check `readfile("TopbarPlus_bundled_fixed.lua")` matches the actual filename
2. Bundle failed to load — add a check:

```lua
local tp = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
if not tp then warn("bundle failed to load") return end
local Icon = tp.get()
if not Icon then warn("tp.get() returned nil") return end
```

---

### `Failed to load sound rbxassetid://0`

You called `:setImage(0)`. Zero is not a valid asset ID. Remove or replace:

```lua
-- Bad
Icon.new():setLabel("Menu"):setImage(0)

-- Good — no image
Icon.new():setLabel("Menu")

-- Good — real image
Icon.new():setLabel("Menu"):setImage(6031068420)
```

---

### Dropdown children are very narrow

Set `MinimumWidth` via `modifyChildTheme`:

```lua
icon:modifyChildTheme({{"Widget", "MinimumWidth", 200}})
```

---

### RichText not working

You must use `task.defer` because the `IconLabel` instance doesn't exist yet at `Icon.new()` time:

```lua
local child = Icon.new()

-- ❌ Wrong — label doesn't exist yet
local lbl = child:getInstance("IconLabel")

-- ✅ Correct
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Hello <font color="#FF0000">World</font>'
end)
```

---

### Highlight not appearing

Make sure the icon has a non-transparent background — UIStroke is invisible on fully transparent frames:

```lua
icon:modifyTheme({
    {"Widget", "BackgroundColor3",       Color3.fromRGB(25, 25, 30)},
    {"Widget", "BackgroundTransparency", 0},    -- must be < 1
})
Ex.highlight(icon, {style="border"})
```

---

### `debounce` freezing the script

`debounce` yields. Always wrap it in `task.spawn`:

```lua
-- ❌ Wrong — freezes the event callback
icon.selected:Connect(function()
    icon:debounce(3)    -- BLOCKS here for 3 seconds
end)

-- ✅ Correct
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(3)    -- yields in background
    end)
end)
```

---

## Known Bug Fixes

This bundle patches 2 bugs from the original TopbarPlus v3 source code.

### Fix 1 — Janitor camelCase aliases

**Error:**
```
attempt to call missing method 'clean' of table  (Line ~2737)
attempt to call missing method 'add' of table
```

**Root cause:** TopbarPlus internally calls `janitor:clean()`, `janitor:add()`, `janitor:destroy()` (lowercase), but the bundled Janitor module only exposes PascalCase methods: `Clean`, `Add`, `Destroy`.

**Patch applied in `Packages/Janitor`:**
```lua
Janitor.__index.clean   = Janitor.__index.Cleanup
Janitor.__index.add     = Janitor.__index.Add
Janitor.__index.destroy = Janitor.__index.Destroy
```

---

### Fix 2 — `math.clamp` nil argument

**Error:**
```
invalid argument #2 to 'clamp' (number expected, got nil)  (Line ~1606)
```

**Root cause:** `widget:GetAttribute("MinimumWidth")` returns `nil` when the Widget attribute hasn't been set yet (timing issue at initialization). `math.clamp(value, nil, max)` crashes.

**Patch applied in `Elements/Widget`:**
```lua
-- Before:
local widgetMinimumWidth  = widget:GetAttribute("MinimumWidth")
local widgetMinimumHeight = widget:GetAttribute("MinimumHeight")

-- After:
local widgetMinimumWidth  = widget:GetAttribute("MinimumWidth")  or 0
local widgetMinimumHeight = widget:GetAttribute("MinimumHeight") or 36
```

---

<div align="center">
<br/>

Original TopbarPlus v3 by [@ForeverHD](https://github.com/1ForeverHD) & HD Admin  
Executor bundle + bug fixes + Extended module maintained separately

</div>

---
---

# 🇻🇳 Tiếng Việt

## Mục Lục

- [Tổng Quan Files](#tổng-quan-files)
- [Cài Đặt](#cài-đặt)
- [Khái Niệm](#khái-niệm)
  - [Cách Hoạt Động](#cách-hoạt-động)
  - [Chaining — Nối Chuỗi](#chaining--nối-chuỗi)
  - [Icon States — Trạng Thái](#icon-states--trạng-thái)
  - [Thứ Tự Icon](#thứ-tự-icon)
- [Hướng Dẫn Core — Từng Bước](#hướng-dẫn-core--từng-bước)
  - [1. Hello World](#1-hello-world-1)
  - [2. Ảnh + Chữ](#2-ảnh--chữ)
  - [3. Vị Trí](#3-vị-trí)
  - [4. Events — Tất Cả 6 Sự Kiện](#4-events--tất-cả-6-sự-kiện)
  - [5. Pattern Logic Bật/Tắt](#5-pattern-logic-bậttắt)
  - [6. Giao Diện Theo Trạng Thái](#6-giao-diện-theo-trạng-thái)
  - [7. Bind Frame GUI](#7-bind-frame-gui)
  - [8. Phím Tắt](#8-phím-tắt)
  - [9. Caption Tooltip](#9-caption-tooltip-1)
  - [10. Badge Thông Báo](#10-badge-thông-báo)
  - [11. Nút Single-Click](#11-nút-single-click)
  - [12. Khóa & Debounce & Cooldown](#12-khóa--debounce--cooldown)
  - [13. Theme — Hướng Dẫn Đầy Đủ](#13-theme--hướng-dẫn-đầy-đủ)
  - [14. Dropdown — Menu Dọc](#14-dropdown--menu-dọc)
  - [15. Menu — Menu Ngang](#15-menu--menu-ngang)
  - [16. Fixed Menu](#16-fixed-menu-1)
  - [17. Tạo Icon Động Từ Dữ Liệu](#17-tạo-icon-động-từ-dữ-liệu)
  - [18. RichText Trong Label](#18-richtext-trong-label)
  - [19. Điều Khiển Toàn Cục](#19-điều-khiển-toàn-cục)
  - [20. Chainable call()](#20-chainable-call-1)
  - [21. Tìm Icon Theo Tên](#21-tìm-icon-theo-tên)
  - [22. Xóa & Dọn Dẹp](#22-xóa--dọn-dẹp)
- [Extended Module — Từng Bước](#extended-module--từng-bước)
  - [Load Extended](#load-extended)
  - [E1. Watermark](#e1-watermark-1)
  - [E2. Separator](#e2-separator-1)
  - [E3. Highlight — 4 Styles](#e3-highlight--4-styles)
  - [E4. Menu + Dropdown Combo](#e4-menu--dropdown-combo)
  - [E5. Native Override](#e5-native-override-1)
  - [E6. Theme Presets](#e6-theme-presets-1)
- [Pattern Library](#pattern-library-1)
- [Ví Dụ Thực Tế](#ví-dụ-thực-tế)
- [Xử Lý Lỗi](#xử-lý-lỗi)
- [Lỗi Đã Fix](#lỗi-đã-fix)

---

## Tổng Quan Files

| File | Mục đích |
|------|---------|
| `TopbarPlus_bundled_fixed.lua` | Bundle chính — TopbarPlus v3 đã patch cho executor |
| `TopbarPlus_Extended.lua` | Module mở rộng — Highlight, Watermark, v.v. |

Có thể dùng bundle core một mình, hoặc load Extended để có thêm tính năng.

---

## Cài Đặt

### Chỉ dùng core bundle

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

if not Icon then warn("[TopbarPlus] Load thất bại!") return end
```

### Dùng Extended module

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon    -- class Icon như bình thường, đầy đủ method
local Ex   = tpx.Ex      -- tiện ích mở rộng
-- tpx.Presets            -- bảng theme preset
```

### Từ URL

```lua
-- Core
local tp = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR/REPO/main/TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- Extended
local tpx = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR/REPO/main/TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon
local Ex   = tpx.Ex
```

---

## Khái Niệm

### Cách Hoạt Động

TopbarPlus tạo icon tùy chỉnh trên thanh topbar của Roblox — thanh đen trên cùng màn hình.

Mỗi icon là **widget có thể click** với các tính năng:
- Toggle giữa **selected** (đang bật) và **deselected** (đang tắt)
- Hiển thị **ảnh**, **chữ**, hoặc cả hai
- Chứa **dropdown** dọc hoặc **menu** ngang các icon con
- **Bind** với frame GUI để tự show/hide khi toggle
- **Phản hồi** phím tắt bàn phím
- Hiển thị **badge số** thông báo
- Hiển thị **tooltip** khi hover

TopbarPlus tự xử lý:
- Overflow khi quá nhiều icon (đẩy vào overflow menu tự động)
- Hỗ trợ Mobile, Gamepad, Console
- Screen insets (SafeArea)

### Chaining — Nối Chuỗi

Hầu hết method trả về `self`, cho phép gọi liên tiếp:

```lua
-- Không chaining
local icon = Icon.new()
icon:setImage(12345678)
icon:setLabel("Shop")
icon:align("Right")

-- Có chaining — kết quả giống hệt
local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Shop")
    :align("Right")
```

### Icon States — Trạng Thái

Một số method nhận tham số `iconState` tùy chọn để chỉ định **khi nào** giá trị được áp dụng.

| Giá trị | Khi áp dụng |
|---------|-------------|
| `nil` | Luôn luôn (mặc định) |
| `"Deselected"` | Chỉ khi chưa được chọn |
| `"Selected"` | Chỉ khi đang được chọn |
| `"Viewing"` | Khi đang hover/chạm trước khi nhả |

Không phân biệt hoa thường: `"deselected"` = `"Deselected"` = `"DESELECTED"`.

```lua
-- Cùng label mọi trạng thái (mặc định)
icon:setLabel("Shop")

-- Label khác nhau theo trạng thái
icon:setLabel("Mở",  "Selected")
icon:setLabel("Đóng","Deselected")
icon:setLabel("...", "Viewing")
```

### Thứ Tự Icon

Mặc định, icons xuất hiện từ trái qua phải theo thứ tự tạo. Giá trị mặc định là `1.01`, `1.02`, `1.03`...

Ghi đè bằng `:setOrder(n)`:

```lua
local icon1 = Icon.new():setLabel("Đầu tiên"):setOrder(1)
local icon2 = Icon.new():setLabel("Thứ hai"):setOrder(2)
local icon3 = Icon.new():setLabel("Thứ ba"):setOrder(3)
```

---

## Hướng Dẫn Core — Từng Bước

### 1. Hello World

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- Icon đơn giản nhất
local icon = Icon.new()
    :setLabel("Xin chào!")
```

---

### 2. Ảnh + Chữ

```lua
-- Cả ảnh lẫn chữ
local icon = Icon.new()
    :setImage(6031068420)   -- Roblox asset ID (số)
    :setLabel("Shop")

-- Dùng chuỗi rbxassetid
local icon = Icon.new()
    :setImage("rbxassetid://6031068420")
    :setLabel("Shop")

-- Chỉ ảnh
local icon = Icon.new():setImage(6031068420)

-- Chỉ chữ
local icon = Icon.new():setLabel("Shop")
```

Tùy chỉnh ảnh:

```lua
local icon = Icon.new()
    :setImage(6031068420)
    :setImageScale(0.7)   -- ảnh chiếm 70% kích thước icon (mặc định 0.5)
    :setImageRatio(1.5)   -- kéo dài ngang (mặc định 1 = vuông)
```

---

### 3. Vị Trí

```lua
icon:align("Left")    -- bên trái (mặc định)
icon:align("Center")  -- giữa màn hình
icon:align("Right")   -- bên phải (cạnh nút Roblox)
```

---

### 4. Events — Tất Cả 6 Sự Kiện

```lua
local icon = Icon.new():setLabel("Test")

-- ① selected — khi icon được chọn (click BẬT)
icon.selected:Connect(function(fromSource)
    print("Đã chọn bởi:", fromSource or "Unknown")
    -- fromSource: "User"|"OneClick"|"AutoDeselect"|"HideParentFeature"|"Overflow"|nil
end)

-- ② deselected — khi icon bị bỏ chọn (click TẮT)
icon.deselected:Connect(function(fromSource)
    print("Đã bỏ chọn bởi:", fromSource or "Unknown")
end)

-- ③ toggled — khi cả selected lẫn deselected
icon.toggled:Connect(function(isSelected, fromSource)
    if isSelected then
        print("Vừa BẬT")
    else
        print("Vừa TẮT")
    end
end)

-- ④ viewingStarted — chuột/ngón tay bắt đầu hover
icon.viewingStarted:Connect(function()
    print("Bắt đầu hover")
end)

-- ⑤ viewingEnded — chuột/ngón tay hết hover
icon.viewingEnded:Connect(function()
    print("Hết hover")
end)

-- ⑥ notified — khi có badge thông báo mới
icon.notified:Connect(function()
    print("Thông báo mới! Tổng:", icon.totalNotices)
end)
```

Dùng `bindEvent` (chainable):

```lua
icon:bindEvent("selected", function(self)
    print("selected qua bindEvent, self =", self.name)
end)

icon:unbindEvent("selected")   -- ngắt kết nối
```

---

### 5. Pattern Logic Bật/Tắt

```lua
local tinhNangBat = false

local icon = Icon.new()
    :setLabel("Tính Năng")
    :align("Right")

-- Dùng toggled (khuyến khích — một handler duy nhất)
icon.toggled:Connect(function(isOn)
    tinhNangBat = isOn

    if isOn then
        -- code BẬT tính năng
    else
        -- code TẮT tính năng
    end
end)
```

---

### 6. Giao Diện Theo Trạng Thái

```lua
-- Label khác nhau
local icon = Icon.new()
    :setLabel("TẮT",  "Deselected")
    :setLabel("BẬT",  "Selected")

-- Ảnh khác nhau
icon:setImage(111111, "Deselected")
icon:setImage(222222, "Selected")

-- Màu chữ khác nhau
icon:setTextColor(Color3.fromRGB(150,150,150), "Deselected")
icon:setTextColor(Color3.fromRGB(100,255,100), "Selected")

-- Khi hover
icon:setLabel("Click đi!", "Viewing")

-- Cả ba cùng lúc
local icon = Icon.new()
    :setLabel("🔴 TẮT",  "Deselected")
    :setLabel("🟢 BẬT",  "Selected")
    :setLabel("🟡 ...",  "Viewing")
    :setImage(111111,    "Deselected")
    :setImage(222222,    "Selected")
    :setTextColor(Color3.fromRGB(180,50,50),  "Deselected")
    :setTextColor(Color3.fromRGB(50,180,50),  "Selected")
    :setTextColor(Color3.fromRGB(180,180,50), "Viewing")
    :align("Right")
```

---

### 7. Bind Frame GUI

Tự động show/hide frame khi icon toggle:

```lua
local frame = game.Players.LocalPlayer
    .PlayerGui.MyScreenGui.MainFrame

local icon = Icon.new()
    :setLabel("Menu")
    :align("Right")
    :bindToggleItem(frame)

-- Tương đương thủ công:
icon.selected:Connect(function()   frame.Visible = true  end)
icon.deselected:Connect(function() frame.Visible = false end)
```

Nhiều frames:

```lua
icon:bindToggleItem(frame1)
icon:bindToggleItem(frame2)
icon:bindToggleItem(frame3)
```

Gỡ binding:

```lua
icon:unbindToggleItem(frame1)
```

Mở frame ngay từ đầu:

```lua
Icon.new():setLabel("Menu"):bindToggleItem(frame):select()
```

---

### 8. Phím Tắt

```lua
local icon = Icon.new()
    :setLabel("ESP")
    :bindToggleKey(Enum.KeyCode.X)    -- nhấn X để toggle

icon:unbindToggleKey(Enum.KeyCode.X)  -- gỡ

-- Nhiều phím:
icon:bindToggleKey(Enum.KeyCode.X)
icon:bindToggleKey(Enum.KeyCode.LeftAlt)

-- Chỉ hiện gợi ý, không bind thật:
icon:setCaption("Bật ESP")
icon:setCaptionHint(Enum.KeyCode.X)
```

---

### 9. Caption Tooltip

Tooltip xuất hiện khi hover:

```lua
local icon = Icon.new()
    :setLabel("Shop")
    :setCaption("Mở Cửa Hàng")
    :setCaptionHint(Enum.KeyCode.B)   -- hiện gợi ý "B" (không bind)

icon:setCaption(nil)   -- xóa caption
```

---

### 10. Badge Thông Báo

```lua
local icon = Icon.new():setLabel("Hộp Thư")

icon:notify()                    -- +1
icon:notify()                    -- badge hiện "2"
icon:notify(icon.deselected)     -- +1, tự xóa khi mở

icon:clearNotices()              -- xóa tất cả

print("Tổng:", icon.totalNotices)

icon.notified:Connect(function()
    print("Có thông báo mới!")
end)
```

---

### 11. Nút Single-Click

Icon tự bỏ chọn ngay sau khi click:

```lua
local icon = Icon.new()
    :setLabel("Hồi Máu")
    :oneClick()

icon.deselected:Connect(function()
    -- chạy mỗi lần click
    print("Đã hồi máu!")
end)
```

---

### 12. Khóa & Debounce & Cooldown

```lua
icon:lock()     -- người dùng không click được (code vẫn toggle được)
icon:unlock()   -- mở lại

-- Cooldown (phải dùng task.spawn — debounce yields!)
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(5)    -- khóa 5 giây rồi tự mở
    end)
    print("Kích hoạt!")
end)

-- autoDeselect
icon:autoDeselect(true)    -- mặc định: tự bỏ chọn khi icon khác được click
icon:autoDeselect(false)   -- giữ trạng thái độc lập
```

---

### 13. Theme — Hướng Dẫn Đầy Đủ

```lua
-- Một thay đổi
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30)})

-- Nhiều thay đổi
icon:modifyTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(18, 18, 22)},
    {"Widget",       "BackgroundTransparency", 0},
    {"Widget",       "MinimumWidth",           80},
    {"Widget",       "MinimumHeight",          44},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
    {"IconLabel",    "TextSize",               14},
    {"IconLabel",    "TextColor3",             Color3.fromRGB(220,220,220)},
})

-- Theo trạng thái
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(0,120,255),   "Selected"})
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(25,25,30),    "Deselected"})
icon:modifyTheme({"IconLabel","TextColor3",     Color3.fromRGB(100,255,100), "Selected"})

-- Cho icon con (dropdown/menu)
icon:modifyChildTheme({
    {"Widget", "MinimumWidth",           200},
    {"Widget", "BackgroundColor3",       Color3.fromRGB(30,30,35)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners","CornerRadius",       UDim.new(0,6)},
})

-- Toàn cục
Icon.modifyBaseTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(20,20,25)},
    {"Widget",       "BackgroundTransparency", 0},
    {"IconCorners",  "CornerRadius",           UDim.new(0,8)},
    {"IconGradient", "Enabled",                false},
})
```

---

### 14. Dropdown — Menu Dọc

```lua
local c1 = Icon.new():setLabel("Lựa Chọn A")
local c2 = Icon.new():setLabel("Lựa Chọn B")
local c3 = Icon.new():setLabel("Lựa Chọn C")
local c4 = Icon.new():setLabel("Lựa Chọn D")

c1.selected:Connect(function() print("A chọn") end)

local drop = Icon.new()
    :setLabel("Lựa Chọn")
    :modifyTheme({{"Dropdown","MaxIcons",3}})
    :modifyChildTheme({{"Widget","MinimumWidth",160}})
    :setDropdown({c1, c2, c3, c4})

-- Xóa dropdown
drop:setDropdown({})

-- Thêm/xóa thủ công
c1:joinDropdown(drop)
c1:leave()
```

---

### 15. Menu — Menu Ngang

```lua
local i1 = Icon.new():setLabel("Bay")
local i2 = Icon.new():setLabel("Tốc Độ")
local i3 = Icon.new():setLabel("Xuyên Tường")

local menu = Icon.new()
    :setLabel("Di Chuyển")
    :modifyTheme({{"Menu","MaxIcons",2}})
    :setMenu({i1, i2, i3})

menu:setMenu({})     -- xóa
i1:joinMenu(menu)    -- thêm thủ công
i1:leave()           -- xóa thủ công
```

---

### 16. Fixed Menu

```lua
Icon.new()
    :modifyTheme({{"Menu","MaxIcons",3}})
    :setFixedMenu({
        Icon.new():setLabel("Trang Chủ"),
        Icon.new():setLabel("Cửa Hàng"),
        Icon.new():setLabel("Kho Đồ"),
        Icon.new():setLabel("Cài Đặt"),
    })
```

---

### 17. Tạo Icon Động Từ Dữ Liệu

```lua
local function toggle(label, fn)
    local c = Icon.new()
        :setLabel("✗ " .. label)
        :setWidth(175)
        :autoDeselect(false)
    c.toggled:Connect(function(on)
        c:setLabel((on and "✓ " or "✗ ") .. label)
        fn(on)
    end)
    return c
end

local function btn(label, fn)
    local c = Icon.new():setLabel(label):setWidth(160):oneClick()
    c.deselected:Connect(fn)
    return c
end

local features = {
    {ten = "Bay",          hanh = function(on) print("Bay:", on)   end},
    {ten = "Hack Tốc Độ", hanh = function(on) print("Speed:", on) end},
    {ten = "Xuyên Tường", hanh = function(on) print("Clip:", on)  end},
    {ten = "Nhảy Vô Hạn",hanh = function(on) print("Jump:", on)  end},
}

local children = {}
for _, f in ipairs(features) do
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

### 18. RichText Trong Label

```lua
local child = Icon.new()

-- Phải dùng task.defer vì IconLabel tạo sau Icon.new()
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Dark Aura   <font color="#FF5050">5,600 KILLS</font>'
end)

-- Nhiều màu:
lbl.Text = 'Custom Cape   <font color="#FFD700">VIP ONLY</font>'

-- Item bị khóa:
lbl.Text = string.format('🔒 <font color="#888888">%s</font>', itemName)

-- Chặn click khi bị khóa:
child.selected:Connect(function() child:deselect() end)

-- In đậm:
lbl.Text = '<b>QUAN TRỌNG</b>   Chữ bình thường'
```

---

### 19. Điều Khiển Toàn Cục

```lua
-- Tìm icon theo tên
local icon = Icon.getIcon("iconCuaToi")

-- Lấy tất cả icons
local tatCa = Icon.getIcons()
for uid, ic in pairs(tatCa) do
    print(uid, ic.name, ic.isSelected)
end

-- Ẩn/hiện toàn bộ TopbarPlus
Icon.setTopbarEnabled(false)
Icon.setTopbarEnabled(true)

-- Đặt DisplayOrder
Icon.setDisplayOrder(15)
```

---

### 20. Chainable call()

```lua
local icon = Icon.new()
    :setLabel("Điểm")
    :setWidth(80)
    :align("Right")
    :call(function(self)
        -- self = icon. Chạy trong task.spawn (không chặn)
        while task.wait(1) do
            self:setLabel(tostring(math.random(0, 999)))
        end
    end)
```

---

### 21. Tìm Icon Theo Tên

```lua
local icon = Icon.new()
    :setLabel("Icon Của Tôi")
    :setName("iconCuaToi")

-- Từ bất kỳ đâu trong script
local found = Icon.getIcon("iconCuaToi")
if found then
    found:notify()
    print("isSelected:", found.isSelected)
end
```

---

### 22. Xóa & Dọn Dẹp

```lua
icon:destroy()   -- xóa tất cả connections, instances, và icon khỏi topbar

-- Thêm code dọn dẹp chạy khi icon bị xóa
icon:addToJanitor(function()
    print("icon đã bị xóa!")
end)

-- Gắn connection để tự disconnect khi icon xóa
local conn = RunService.Heartbeat:Connect(function() end)
icon:addToJanitor(conn)
```

---

## Extended Module — Từng Bước

### Load Extended

```lua
local tpx  = loadstring(readfile("TopbarPlus_Extended.lua"))()
local Icon = tpx.Icon     -- giống tp.get() — đầy đủ method gốc
local Ex   = tpx.Ex       -- tiện ích mở rộng
local Pre  = tpx.Presets  -- bảng theme preset
```

---

### E1. Watermark

Icon không tương tác, không click được. Dùng để hiển thị version hoặc branding.

```lua
-- Chỉ chữ
Ex.watermark("v1.0 | MyScript")

-- Chữ + vị trí
Ex.watermark("v2.0 | KillScript", nil, "Right")

-- Ảnh + chữ
Ex.watermark("PREMIUM", 6031068420, "Right")

-- Chỉ ảnh
Ex.watermark(nil, 6031068420, "Left")

-- Tùy chỉnh sau khi tạo
local wm = Ex.watermark("v1.0", nil, "Right")
wm:modifyTheme({
    {"IconLabel", "TextColor3", Color3.fromRGB(255, 215, 0)},  -- chữ vàng
    {"IconLabel", "TextSize",   13},
})
```

---

### E2. Separator

Khoảng cách vô hình giữa các icons.

```lua
Ex.separator()              -- 10px mặc định, căn trái
Ex.separator(20)            -- 20px
Ex.separator(20, "Right")   -- 20px căn phải
Ex.separator(15, "Left")    -- 15px căn trái
```

Dùng để tạo layout:

```lua
local esp = Icon.new():setLabel("ESP"):align("Right")
Ex.separator(8, "Right")
Ex.watermark("v1.0", nil, "Right")
```

---

### E3. Highlight — 4 Styles

Thêm viền / glow vào bất kỳ icon nào.

```lua
-- "border" — viền mỏng sạch
Ex.highlight(icon)
Ex.highlight(icon, {color=Color3.fromRGB(100,200,255), thickness=3})

-- "glow" — double-stroke glow
Ex.highlight(icon, {style="glow", color=Color3.fromRGB(0,200,255)})
Ex.highlight(icon, {style="glow", color=Color3.fromRGB(255,100,100), animated=true})

-- "premium" — viền vàng + gradient vàng
Ex.highlight(icon, {style="premium"})
Ex.highlight(icon, {style="premium", animated=true})  -- shimmer quay

-- "accent" — viền màu + nền tối theo màu
Ex.highlight(icon, {style="accent", color=Color3.fromRGB(255,80,80)})
Ex.highlight(icon, {style="accent", color=Color3.fromRGB(100,255,100)})

-- Gỡ highlight
Ex.removeHighlight(icon)
```

---

### E4. Menu + Dropdown Combo

Menu ngang với mỗi tab có dropdown dọc riêng.

```lua
local function toggle(label, fn)
    local c = Icon.new():setLabel("✗ "..label):setWidth(175):autoDeselect(false)
    c.toggled:Connect(function(on) c:setLabel((on and "✓ " or "✗ ")..label); fn(on) end)
    return c
end

Ex.menuWithDropdowns({
    label        = "Script Hub",
    align        = "Left",
    maxMenuIcons = 4,
    items = {
        {
            label = "⚔ Chiến Đấu",
            dropdown = {
                maxIcons = 5, minWidth = 190,
                items = {
                    toggle("Aimbot",        function(on) end),
                    toggle("Silent Aim",    function(on) end),
                    toggle("ESP",           function(on) end),
                    toggle("Không giật",    function(on) end),
                }
            }
        },
        {
            label = "🏃 Di Chuyển",
            dropdown = {
                maxIcons = 4, minWidth = 180,
                items = {
                    toggle("Bay",           function(on) end),
                    toggle("Hack Tốc Độ",  function(on) end),
                    toggle("Xuyên Tường",  function(on) end),
                    toggle("Nhảy Vô Hạn", function(on) end),
                }
            }
        },
        {
            label    = "Rejoin",
            onSelect = function() print("rejoining!") end,
        },
    }
})
```

---

### E5. Native Override

```lua
-- Mặc định — TopbarPlus tự xử lý overflow, không cần làm gì
Ex.setNativeOverride("dodge")

-- Ẩn thanh Roblox native (cẩn thận!)
Ex.setNativeOverride("hide")
```

---

### E6. Theme Presets

```lua
local Pre = tpx.Presets

-- Áp dụng toàn cục
Icon.modifyBaseTheme(Pre.dark)    -- tối
Icon.modifyBaseTheme(Pre.light)   -- sáng
Icon.modifyBaseTheme(Pre.glass)   -- kính mờ
Icon.modifyBaseTheme(Pre.gold)    -- vàng

-- Áp dụng cho một icon
local icon = Icon.new():setLabel("Test")
icon:modifyTheme(Pre.dark)

-- Kết hợp preset + override
Icon.modifyBaseTheme(Pre.dark)
Icon.modifyBaseTheme({
    {"Widget","BackgroundColor3", Color3.fromRGB(10,10,15)},
})
```

---

## Pattern Library

### Toggle Feature (VI)

```lua
local batTat = false

local icon = Icon.new()
    :setLabel("✗ Tính Năng", "Deselected")
    :setLabel("✓ Tính Năng", "Selected")
    :setTextColor(Color3.fromRGB(180,180,180), "Deselected")
    :setTextColor(Color3.fromRGB(100,255,100), "Selected")
    :align("Right")

icon.toggled:Connect(function(isOn)
    batTat = isOn
    print("Tính năng:", isOn)
end)
```

### Toggle Group — Radio (VI)

```lua
local tuyCon = {"Lựa Chọn A", "Lựa Chọn B", "Lựa Chọn C"}
local dangChon = nil
local children = {}

for _, ten in ipairs(tuyCon) do
    local child = Icon.new():setLabel(ten):setWidth(130):autoDeselect(false)
    child.selected:Connect(function()
        for _, c in ipairs(children) do
            if c ~= child then c:deselect() end
        end
        dangChon = ten
        print("Đã chọn:", ten)
    end)
    table.insert(children, child)
end

Icon.new():setLabel("Chọn"):setDropdown(children)
```

### Cooldown Button (VI)

```lua
local COOLDOWN = 5

local icon = Icon.new():setLabel("Dùng Kỹ Năng"):oneClick():align("Right")
local dangCD = false

icon.deselected:Connect(function()
    if dangCD then return end
    dangCD = true
    print("Đã dùng kỹ năng!")
    task.spawn(function()
        icon:debounce(COOLDOWN)
        dangCD = false
    end)
end)
```

### Counter Display (VI)

```lua
local diem = Icon.new()
    :setWidth(100)
    :align("Left")
    :lock()
    :disableStateOverlay(true)
    :modifyTheme({
        {"Widget","BackgroundColor3",Color3.fromRGB(20,20,25)},
        {"Widget","BackgroundTransparency",0},
    })

local soDiem = 0

local function capNhat()
    diem:setLabel("Điểm: " .. soDiem)
end
capNhat()

game:GetService("ReplicatedStorage").DiemThayDoi.OnClientEvent:Connect(function(diemMoi)
    soDiem = diemMoi
    capNhat()
end)
```

---

## Ví Dụ Thực Tế

> Code các ví dụ hoàn toàn giống phần [Real-World Examples](#real-world-examples) tiếng Anh — copy paste trực tiếp được.

---

## Xử Lý Lỗi

### `attempt to call missing method 'clean' of table`
Lỗi đã được fix trong bundle. Chắc chắn bạn đang dùng `TopbarPlus_bundled_fixed.lua`.

### `invalid argument #2 to 'clamp'`
Lỗi đã được fix trong bundle.

### `attempt to index nil with 'new'` tại Line 4
`tp.get()` trả về nil. Kiểm tra:
```lua
local tp = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
print(tp)           -- không được nil
local Icon = tp.get()
print(Icon)         -- không được nil
```

### `Failed to load sound rbxassetid://0`
Xóa `:setImage(0)` — 0 không phải ID hợp lệ.

### Dropdown quá hẹp
```lua
icon:modifyChildTheme({{"Widget","MinimumWidth",200}})
```

### RichText không hoạt động
Phải dùng `task.defer`:
```lua
task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = '...'
end)
```

### Highlight không hiện
Icon phải có nền không trong suốt:
```lua
icon:modifyTheme({
    {"Widget","BackgroundColor3",Color3.fromRGB(25,25,30)},
    {"Widget","BackgroundTransparency",0},
})
Ex.highlight(icon)
```

### `debounce` làm đơ script
Phải dùng `task.spawn`:
```lua
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(3)
    end)
end)
```

---

## Lỗi Đã Fix

### Fix 1 — Janitor camelCase
```
attempt to call missing method 'clean' of table
```
TopbarPlus gọi `janitor:clean()` nhưng Janitor chỉ có `Clean`. Đã vá:
```lua
Janitor.__index.clean   = Janitor.__index.Cleanup
Janitor.__index.add     = Janitor.__index.Add
Janitor.__index.destroy = Janitor.__index.Destroy
```

### Fix 2 — `math.clamp` nil
```
invalid argument #2 to 'clamp' (number expected, got nil)
```
`widget:GetAttribute("MinimumWidth")` trả về nil. Đã vá:
```lua
local widgetMinimumWidth  = widget:GetAttribute("MinimumWidth")  or 0
local widgetMinimumHeight = widget:GetAttribute("MinimumHeight") or 36
```

---

<div align="center">
<br/>

TopbarPlus gốc bởi [@ForeverHD](https://github.com/1ForeverHD) & HD Admin  
Bundle + fix + Extended module được maintain riêng cho executor

</div>
