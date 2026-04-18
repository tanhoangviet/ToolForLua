# TopbarPlus Executor Bundle

<div align="center">

![TopbarPlus](https://img.shields.io/badge/TopbarPlus-Executor%20Bundle-5865F2?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1-7B52AB?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Roblox-Executor-E02020?style=for-the-badge)
![Version](https://img.shields.io/badge/Bundle-v1.1.0-22C55E?style=for-the-badge)

**[🇺🇸 English](#-english) · [🇻🇳 Tiếng Việt](#-tiếng-việt)**

> Executor-ready bundle of [TopbarPlus v3](https://github.com/1ForeverHD/TopbarPlus) by Just A Arisu
> Includes 2 bug patches not present in the original source.

</div>

---

# 🇺🇸 English

## Table of Contents
- [Installation](#installation)
- [Concepts](#concepts)
- [Usage — Step by Step](#usage--step-by-step)
- [API Reference](#api-reference)
- [Real-World Examples](#real-world-examples)
- [Known Bug Fixes](#known-bug-fixes)

---

## Installation

```lua
-- From local file
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- From URL
local tp   = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR/REPO/main/TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- Safety check
if not Icon then
    warn("[TopbarPlus] Load failed!")
    return
end
```

---

## Concepts

### How It Works

TopbarPlus creates custom icons on Roblox's topbar (the black bar at the top). Each icon:
- Toggles selected / deselected when clicked
- Can show dropdowns or horizontal menus
- Can bind to GUI frames to auto show/hide
- Responds to keyboard shortcuts

### Chaining

Most methods return the icon itself so calls can be chained:

```lua
-- Verbose (no chaining)
local icon = Icon.new()
icon:setImage(12345678)
icon:setLabel("Shop")
icon:align("Right")

-- Clean (chaining)
local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Shop")
    :align("Right")
```

### Icon States

Methods tagged `{toggleable}` accept an optional `iconState` argument:

| State | Value | When applied |
|-------|-------|--------------|
| Both | `nil` | Always (default) |
| Deselected | `"Deselected"` | When icon is NOT clicked |
| Selected | `"Selected"` | When icon IS clicked |
| Viewing | `"Viewing"` | While hovering before release |

> Case-insensitive: `"deselected"` = `"DESELECTED"` = `"Deselected"`.

---

## Usage — Step by Step

### 1. Hello World

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

Icon.new():setLabel("Hello!")
```

---

### 2. Image + Label

```lua
-- Both
local icon = Icon.new()
    :setImage(6031068420)
    :setLabel("Shop")

-- Image only
Icon.new():setImage(6031068420)

-- Label only
Icon.new():setLabel("Shop")
```

---

### 3. Alignment

```lua
icon:align("Left")    -- default
icon:align("Center")  -- center of screen
icon:align("Right")   -- right side (near Roblox buttons)
```

---

### 4. Events

```lua
local icon = Icon.new():setLabel("Test")

-- Clicked ON
icon.selected:Connect(function(fromSource)
    print("Selected! Source:", fromSource)
    -- fromSource: "User" | "OneClick" | "AutoDeselect" | "Overflow" | nil
end)

-- Clicked OFF
icon.deselected:Connect(function(fromSource)
    print("Deselected!")
end)

-- Both — gives current state
icon.toggled:Connect(function(isSelected, fromSource)
    print("State:", isSelected)
end)

-- Hover
icon.viewingStarted:Connect(function() print("hovering") end)
icon.viewingEnded:Connect(function()   print("done")     end)

-- Notice badge added
icon.notified:Connect(function() print("notice!") end)
```

---

### 5. Toggle Logic

```lua
local enabled = false

local icon = Icon.new()
    :setLabel("Feature")
    :align("Right")

icon.toggled:Connect(function(isOn)
    enabled = isOn
    if isOn then
        -- enable
    else
        -- disable
    end
end)
```

---

### 6. Different Labels Per State

```lua
local icon = Icon.new()
    :setLabel("OFF",    "Deselected")
    :setLabel("ON",     "Selected")
    :setLabel("...",    "Viewing")     -- while hovering

-- Works with image, color, etc.
icon:setImage(111111, "Deselected")
icon:setImage(222222, "Selected")
icon:setTextColor(Color3.fromRGB(180,180,180), "Deselected")
icon:setTextColor(Color3.fromRGB(100,255,100), "Selected")
```

---

### 7. Bind a GUI Frame

Auto show/hide a frame when icon toggles:

```lua
local frame = game.Players.LocalPlayer.PlayerGui.MyGui.Frame

local icon = Icon.new()
    :setLabel("Menu")
    :align("Right")
    :bindToggleItem(frame)

-- Equivalent:
icon.selected:Connect(function()   frame.Visible = true  end)
icon.deselected:Connect(function() frame.Visible = false end)

-- Multiple frames:
icon:bindToggleItem(frameA)
icon:bindToggleItem(frameB)
icon:unbindToggleItem(frameA)
```

---

### 8. Keyboard Shortcut

```lua
icon:bindToggleKey(Enum.KeyCode.X)    -- press X to toggle
icon:unbindToggleKey(Enum.KeyCode.X)  -- remove
```

Also creates a caption hint automatically showing "X".

---

### 9. Caption Tooltip

Tooltip shown on hover:

```lua
icon:setCaption("Open Shop")
icon:setCaptionHint(Enum.KeyCode.B)  -- show "B" hint (no actual bind)
icon:setCaption(nil)                  -- remove
```

---

### 10. Notifications Badge

```lua
icon:notify()                  -- +1 badge
icon:notify(icon.deselected)   -- +1, auto-clear when deselected
icon:clearNotices()            -- remove all

print(icon.totalNotices)       -- current count
```

---

### 11. One-Click Button

Icon auto-deselects immediately after click:

```lua
local icon = Icon.new()
    :setLabel("Heal")
    :oneClick()

icon.deselected:Connect(function()
    -- runs every click
    print("Healed!")
end)
```

---

### 12. Lock & Debounce

```lua
icon:lock()    -- user can't toggle (code still can)
icon:unlock()  -- re-enable

-- Cooldown (use task.spawn — it yields)
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(3)  -- lock for 3s then unlock
    end)
end)
```

---

### 13. Theme Customization

```lua
-- Single change
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30)})

-- Multiple changes
icon:modifyTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget",       "BackgroundTransparency", 0},
    {"Widget",       "MinimumWidth",           80},
    {"Widget",       "MinimumHeight",          44},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
    {"IconLabel",    "TextSize",               15},
})

-- State-specific
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(0, 120, 255), "Selected"})
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30, 30, 30),  "Deselected"})

-- Children in dropdown/menu
icon:modifyChildTheme({
    {"Widget", "MinimumWidth",    200},
    {"Widget", "BackgroundColor3", Color3.fromRGB(30, 30, 35)},
})

-- ALL icons globally
Icon.modifyBaseTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(20, 20, 20)},
    {"Widget",      "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
})
```

---

### 14. Dropdown (Vertical Menu)

```lua
local c1 = Icon.new():setLabel("Option A")
local c2 = Icon.new():setLabel("Option B")
local c3 = Icon.new():setLabel("Option C")
local c4 = Icon.new():setLabel("Option D")

c1.selected:Connect(function() print("A!") end)

local drop = Icon.new()
    :setLabel("Menu")
    :modifyTheme({{"Dropdown", "MaxIcons", 3}})     -- scroll after 3
    :modifyChildTheme({{"Widget", "MinimumWidth", 160}})
    :setDropdown({c1, c2, c3, c4})

drop:setDropdown({})       -- remove
c1:joinDropdown(drop)      -- add manually
c1:leave()                 -- remove from parent
```

> ⚠️ Icons with a dropdown cannot be nested inside another dropdown.

---

### 15. Menu (Horizontal Menu)

```lua
local i1 = Icon.new():setLabel("Fly")
local i2 = Icon.new():setLabel("Speed")
local i3 = Icon.new():setLabel("Noclip")

local menu = Icon.new()
    :setLabel("Tools")
    :modifyTheme({{"Menu", "MaxIcons", 2}})
    :setMenu({i1, i2, i3})

menu:setMenu({})     -- remove
i1:joinMenu(menu)    -- add manually
i1:leave()
```

---

### 16. Fixed Menu

Always open, no close button:

```lua
Icon.new()
    :modifyTheme({{"Menu", "MaxIcons", 3}})
    :setFixedMenu({
        Icon.new():setLabel("Home"),
        Icon.new():setLabel("Shop"),
        Icon.new():setLabel("Inventory"),
        Icon.new():setLabel("Settings"),
    })
```

---

### 17. Dynamic Dropdown From Data

```lua
local features = {
    {label = "Fly",           fn = function(on) print("Fly:", on)    end},
    {label = "Speed Hack",    fn = function(on) print("Speed:", on)  end},
    {label = "Noclip",        fn = function(on) print("Clip:", on)   end},
    {label = "Infinite Jump", fn = function(on) print("Jump:", on)   end},
    {label = "Auto Farm",     fn = function(on) print("Farm:", on)   end},
}

local children = {}
for _, feat in ipairs(features) do
    local child = Icon.new()
        :setLabel("✗ " .. feat.label)
        :setWidth(170)
        :autoDeselect(false)

    child.toggled:Connect(function(isOn)
        child:setLabel((isOn and "✓ " or "✗ ") .. feat.label)
        feat.fn(isOn)
    end)

    table.insert(children, child)
end

Icon.new()
    :setLabel("Features")
    :align("Left")
    :modifyTheme({{"Dropdown", "MaxIcons", 5}})
    :modifyChildTheme({
        {"Widget", "MinimumWidth",           180},
        {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
        {"Widget", "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",      UDim.new(0, 6)},
    })
    :setDropdown(children)
```

---

### 18. RichText in Labels

Inject colored / styled text into a label:

```lua
local child = Icon.new()

task.defer(function()
    local label = child:getInstance("IconLabel")
    if not label then return end
    label.RichText = true
    label.Text = 'Dark Aura  <font color="#FF5050">5,600 KILLS</font>'
end)
```

Locked item (grayed out):

```lua
task.defer(function()
    local label = child:getInstance("IconLabel")
    if not label then return end
    label.RichText = true
    label.Text = '🔒 <font color="#888888">' .. itemName .. '</font>'
end)
```

---

### 19. Global Dark Theme

```lua
Icon.modifyBaseTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget",       "BackgroundTransparency", 0},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
})
```

---

### 20. Control Icons via Code

```lua
local icon = Icon.new():setName("myIcon"):setLabel("Test")

local found = Icon.getIcon("myIcon")   -- get by name

icon:select()                          -- force select
icon:deselect()                        -- force deselect

local all = Icon.getIcons()            -- {[uid] = icon}

Icon.setTopbarEnabled(false)           -- hide all
Icon.setTopbarEnabled(true)            -- show all

icon:destroy()                         -- cleanup
```

---

## API Reference

### Global Functions

| Function | Returns | Description |
|----------|---------|-------------|
| `Icon.new()` | `Icon` | Create new icon |
| `Icon.getIcon(nameOrUID)` | `Icon?` | Find by name or UID |
| `Icon.getIcons()` | `{[uid]:Icon}` | All active icons |
| `Icon.setTopbarEnabled(bool)` | — | Show/hide all ScreenGuis |
| `Icon.modifyBaseTheme(mods)` | — | Theme all icons globally |
| `Icon.setDisplayOrder(int)` | — | Base DisplayOrder for ScreenGuis |

---

### Methods

> ✅ Chainable &nbsp; 🔁 Toggleable (accepts `iconState`) &nbsp; ⏸ Yields

#### Appearance

| Method | ✅ | 🔁 | Description |
|--------|----|----|-------------|
| `:setImage(id, state?)` | ✅ | 🔁 | Image. Asset ID or `"rbxassetid://..."` |
| `:setLabel(text, state?)` | ✅ | 🔁 | Text label |
| `:setWidth(n, state?)` | ✅ | 🔁 | Min width (default `44`) |
| `:setImageScale(n, state?)` | ✅ | 🔁 | Image size ratio (default `0.5`) |
| `:setImageRatio(n, state?)` | ✅ | 🔁 | Aspect ratio (default `1`) |
| `:setCornerRadius(s,o, state?)` | ✅ | 🔁 | Corner rounding |
| `:setTextSize(n, state?)` | ✅ | 🔁 | Font size (default `16`) |
| `:setTextColor(c, state?)` | ✅ | 🔁 | Text color |
| `:setTextFont(f,w?,s?, state?)` | ✅ | 🔁 | Font. `Enum.Font`, name, or ID |
| `:setOrder(n, state?)` | ✅ | 🔁 | Display order |
| `:disableStateOverlay(bool)` | ✅ | — | Disable click shade |
| `:modifyTheme(mods)` | ✅ | — | Custom theme |
| `:modifyChildTheme(mods)` | ✅ | — | Theme for children |

#### Behavior

| Method | ✅ | Description |
|--------|----|-------------|
| `:align(str)` | ✅ | `"Left"` \| `"Center"` \| `"Right"` |
| `:setName(name)` | ✅ | Name for `getIcon()` |
| `:setEnabled(bool)` | ✅ | Show/hide |
| `:select()` | ✅ | Force select |
| `:deselect()` | ✅ | Force deselect |
| `:lock()` | ✅ | Block user input |
| `:unlock()` | ✅ | Allow user input |
| `:debounce(sec)` | ✅⏸ | Lock → wait → unlock |
| `:autoDeselect(bool)` | ✅ | Deselect when other icon clicked (default `true`) |
| `:oneClick(bool)` | ✅ | Auto-deselect after select |

#### Notifications

| Method | ✅ | Description |
|--------|----|-------------|
| `:notify(event?)` | ✅ | Add notice (+1) |
| `:clearNotices()` | ✅ | Remove all |

#### Toggle Items & Keys

| Method | ✅ | Description |
|--------|----|-------------|
| `:bindToggleItem(gui)` | ✅ | Frame auto shows/hides |
| `:unbindToggleItem(gui)` | ✅ | Remove binding |
| `:bindToggleKey(kc)` | ✅ | Keyboard shortcut |
| `:unbindToggleKey(kc)` | ✅ | Remove keybind |

#### Caption

| Method | ✅ | Description |
|--------|----|-------------|
| `:setCaption(text)` | ✅ | Hover tooltip |
| `:setCaptionHint(kc)` | ✅ | Key hint in caption, no real bind |

#### Dropdown & Menu

| Method | ✅ | Description |
|--------|----|-------------|
| `:setDropdown(icons)` | ✅ | Vertical. `{}` to remove |
| `:joinDropdown(parent)` | ✅ | Join parent dropdown |
| `:setMenu(icons)` | ✅ | Horizontal. `{}` to remove |
| `:setFixedMenu(icons)` | ✅ | Always-open, no close button |
| `:joinMenu(parent)` | ✅ | Join parent menu |
| `:leave()` | ✅ | Exit dropdown/menu |

#### Misc

| Method | ✅ | Description |
|--------|----|-------------|
| `:call(func)` | ✅ | `task.spawn(func(icon))`, stays chainable |
| `:addToJanitor(ud)` | ✅ | Auto-clean on destroy |
| `:bindEvent(name, cb)` | ✅ | Connect event by camelCase name |
| `:unbindEvent(name)` | ✅ | Disconnect |
| `:getInstance(name)` | — | Get widget descendant by name |
| `:destroy()` | ✅ | Destroy icon + connections |

---

### Events

```lua
icon.selected:Connect(function(fromSource) end)
-- fromSource: "User"|"OneClick"|"AutoDeselect"|"HideParentFeature"|"Overflow"|nil

icon.deselected:Connect(function(fromSource) end)

icon.toggled:Connect(function(isSelected, fromSource) end)

icon.viewingStarted:Connect(function() end)  -- hover start

icon.viewingEnded:Connect(function() end)    -- hover end

icon.notified:Connect(function() end)        -- new notice
```

---

### Properties (Read-only)

| Property | Type | Description |
|----------|------|-------------|
| `icon.name` | `string` | Widget name |
| `icon.isSelected` | `bool` | Current state |
| `icon.isEnabled` | `bool` | Visible? |
| `icon.totalNotices` | `int` | Active notice count |
| `icon.locked` | `bool` | Is locked? |

---

### Theme Targets

| Name | Targets |
|------|---------|
| `"Widget"` | Main container |
| `"IconCorners"` | Corner rounding (collective) |
| `"IconGradient"` | Gradient overlay |
| `"IconLabel"` | Text label |
| `"IconImage"` | Image element |
| `"IconSpot"` | Background spot |
| `"Dropdown"` | Dropdown container |
| `"Menu"` | Menu container |

**Widget properties:**

| Property | Type | Default |
|----------|------|---------|
| `BackgroundColor3` | `Color3` | Theme default |
| `BackgroundTransparency` | `number` | Theme default |
| `MinimumWidth` | `number` | `44` |
| `MinimumHeight` | `number` | `44` |

**Dropdown / Menu attributes:**

| Attribute | Description |
|-----------|-------------|
| `MaxIcons` | Items before scroll |
| `MaxWidth` | Max container width |

---

## Real-World Examples

### ESP Toggle

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local espIcon = Icon.new()
    :setLabel("ESP OFF", "Deselected")
    :setLabel("ESP ON",  "Selected")
    :setTextColor(Color3.fromRGB(180, 180, 180), "Deselected")
    :setTextColor(Color3.fromRGB(100, 255, 100), "Selected")
    :align("Right")
    :setCaption("Toggle ESP")
    :bindToggleKey(Enum.KeyCode.X)
    :modifyTheme({
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(25, 25, 30)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
    })

espIcon.toggled:Connect(function(isOn)
    -- toggleESP(isOn)
    print("ESP:", isOn)
end)
```

---

### Hide / Show Obsidian UI

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"
))()
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local Window = Library:CreateWindow({ Title = "Script", AutoShow = true })
Library.ShowToggleFrameInKeybinds = false

Icon.new()
    :setLabel("Hide", "Deselected")
    :setLabel("Show", "Selected")
    :align("Right")
    :modifyTheme({
        {"Widget",      "BackgroundColor3",       Color3.fromRGB(25, 25, 30)},
        {"Widget",      "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",           UDim.new(0, 8)},
    })
    :bindEvent("toggled", function()
        Window:Toggle()
    end)
```

---

### Accessories Shop Dropdown

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local icons = {}
for _, v in pairs(game:GetService("Players").LocalPlayer
    .PlayerGui.AwesomeGUI.Shop.AccessoryArray.Array:GetChildren()) do

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
            and '🔒 <font color="#888888">' .. v.Name .. '</font>'
            or v.Name
    end)

    child.selected:Connect(function()
        if isLocked then child:deselect() return end
        game:GetService("ReplicatedStorage")
            .AccessoryHandle:FireServer("Equip", v.Name, nil)
    end)

    table.insert(icons, child)
end

Icon.new()
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
```

---

### Full Script Hub

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

Icon.modifyBaseTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(18, 18, 22)},
    {"Widget",       "BackgroundTransparency", 0},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
})

local function makeToggle(label, callback)
    local c = Icon.new()
        :setLabel("✗ " .. label)
        :setWidth(180)
        :autoDeselect(false)
    c.toggled:Connect(function(isOn)
        c:setLabel((isOn and "✓ " or "✗ ") .. label)
        callback(isOn)
    end)
    return c
end

local function makeButton(label, callback)
    local c = Icon.new():setLabel(label):setWidth(180):oneClick()
    c.deselected:Connect(callback)
    return c
end

local childStyle = {
    {"Widget", "MinimumWidth",           190},
    {"Widget", "BackgroundColor3",       Color3.fromRGB(25, 25, 32)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",      UDim.new(0, 6)},
}

-- ⚔ Combat
Icon.new()
    :setLabel("⚔ Combat"):align("Left")
    :modifyTheme({{"Dropdown","MaxIcons",5}})
    :modifyChildTheme(childStyle)
    :setDropdown({
        makeToggle("Aimbot",     function(on) end),
        makeToggle("Silent Aim", function(on) end),
        makeToggle("ESP",        function(on) end),
        makeToggle("Chams",      function(on) end),
        makeToggle("No Recoil",  function(on) end),
        makeToggle("Rapid Fire", function(on) end),
    })

-- 🏃 Movement
Icon.new()
    :setLabel("🏃 Move"):align("Left")
    :modifyTheme({{"Dropdown","MaxIcons",5}})
    :modifyChildTheme(childStyle)
    :setDropdown({
        makeToggle("Fly",          function(on) end),
        makeToggle("Speed Hack",   function(on) end),
        makeToggle("Noclip",       function(on) end),
        makeToggle("Inf Jump",     function(on) end),
        makeToggle("Anti-Gravity", function(on) end),
    })

-- 🔧 Misc (one-click buttons)
Icon.new()
    :setLabel("🔧 Misc"):align("Left")
    :modifyTheme({{"Dropdown","MaxIcons",4}})
    :modifyChildTheme(childStyle)
    :setDropdown({
        makeButton("Teleport to Spawn", function() print("tp!") end),
        makeButton("Rejoin",            function() print("rj!") end),
        makeButton("Copy UID",          function() print("id!") end),
    })
```

---

## Known Bug Fixes

### Fix 1 — Janitor camelCase aliases
```
attempt to call missing method 'clean' of table
```
TopbarPlus calls `janitor:clean()` / `janitor:add()` / `janitor:destroy()` but Janitor only exposes PascalCase. Patched by adding aliases:
```lua
Janitor.__index.clean   = Janitor.__index.Cleanup
Janitor.__index.add     = Janitor.__index.Add
Janitor.__index.destroy = Janitor.__index.Destroy
```

### Fix 2 — `math.clamp` nil argument
```
invalid argument #2 to 'clamp' (number expected, got nil)
```
`widget:GetAttribute("MinimumWidth")` returns `nil` before the attribute is set. Patched:
```lua
local widgetMinimumWidth  = widget:GetAttribute("MinimumWidth")  or 0
local widgetMinimumHeight = widget:GetAttribute("MinimumHeight") or 36
```

---
---

# 🇻🇳 Tiếng Việt

## Mục Lục
- [Cài Đặt](#cài-đặt)
- [Khái Niệm Cơ Bản](#khái-niệm-cơ-bản)
- [Hướng Dẫn Từng Bước](#hướng-dẫn-từng-bước)
- [API Reference](#api-reference-1)
- [Ví Dụ Thực Tế](#ví-dụ-thực-tế)
- [Các Lỗi Đã Fix](#các-lỗi-đã-fix)

---

## Cài Đặt

```lua
-- Từ file local
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- Từ URL
local tp   = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR/REPO/main/TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

-- Kiểm tra an toàn
if not Icon then
    warn("[TopbarPlus] Load thất bại!")
    return
end
```

---

## Khái Niệm Cơ Bản

### Cách Hoạt Động

TopbarPlus tạo icon tùy chỉnh trên thanh topbar của Roblox. Mỗi icon có thể:
- Toggle selected / deselected khi click
- Hiển thị dropdown hoặc menu ngang
- Bind với frame GUI để tự show/hide
- Phản hồi phím tắt bàn phím

### Chaining — Nối Chuỗi

Hầu hết các method trả về chính icon, cho phép gọi liên tiếp:

```lua
-- Không chaining (dài)
local icon = Icon.new()
icon:setImage(12345678)
icon:setLabel("Shop")
icon:align("Right")

-- Có chaining (gọn)
local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Shop")
    :align("Right")
```

### Icon States — Trạng Thái

| Trạng thái | Giá trị | Khi áp dụng |
|------------|---------|-------------|
| Mặc định | `nil` | Luôn luôn |
| Deselected | `"Deselected"` | Khi chưa click |
| Selected | `"Selected"` | Khi đang click |
| Viewing | `"Viewing"` | Khi hover trước khi nhả |

> Không phân biệt hoa thường: `"deselected"` = `"Deselected"` = `"DESELECTED"`.

---

## Hướng Dẫn Từng Bước

### 1. Hello World

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

Icon.new():setLabel("Xin chào!")
```

---

### 2. Ảnh + Chữ

```lua
-- Cả hai
local icon = Icon.new()
    :setImage(6031068420)
    :setLabel("Shop")

-- Chỉ ảnh
Icon.new():setImage(6031068420)

-- Chỉ chữ
Icon.new():setLabel("Shop")
```

---

### 3. Căn Vị Trí

```lua
icon:align("Left")    -- mặc định, bên trái
icon:align("Center")  -- giữa màn hình
icon:align("Right")   -- bên phải (cạnh nút Roblox)
```

---

### 4. Events — Sự Kiện

```lua
local icon = Icon.new():setLabel("Test")

-- Click BẬT
icon.selected:Connect(function(fromSource)
    print("Đã chọn! Nguồn:", fromSource)
    -- fromSource: "User"|"OneClick"|"AutoDeselect"|"Overflow"|nil
end)

-- Click TẮT
icon.deselected:Connect(function(fromSource)
    print("Đã bỏ chọn!")
end)

-- Cả hai — có trạng thái hiện tại
icon.toggled:Connect(function(isSelected, fromSource)
    print("Trạng thái:", isSelected)
end)

-- Hover
icon.viewingStarted:Connect(function() print("đang hover") end)
icon.viewingEnded:Connect(function()   print("hết hover")  end)

-- Badge thông báo mới
icon.notified:Connect(function() print("có thông báo!") end)
```

---

### 5. Logic Bật/Tắt

```lua
local tinhNangBat = false

local icon = Icon.new()
    :setLabel("Tính Năng")
    :align("Right")

icon.toggled:Connect(function(isOn)
    tinhNangBat = isOn
    if isOn then
        -- bật tính năng
    else
        -- tắt tính năng
    end
end)
```

---

### 6. Chữ Khác Nhau Theo Trạng Thái

```lua
local icon = Icon.new()
    :setLabel("TẮT",  "Deselected")
    :setLabel("BẬT",  "Selected")
    :setLabel("...",  "Viewing")

-- Áp dụng cho ảnh và màu
icon:setImage(111111, "Deselected")
icon:setImage(222222, "Selected")
icon:setTextColor(Color3.fromRGB(180,180,180), "Deselected")
icon:setTextColor(Color3.fromRGB(100,255,100), "Selected")
```

---

### 7. Bind Frame GUI

```lua
local frame = game.Players.LocalPlayer.PlayerGui.MyGui.Frame

local icon = Icon.new()
    :setLabel("Menu")
    :align("Right")
    :bindToggleItem(frame)  -- tự show/hide theo trạng thái icon

-- Tương đương thủ công:
icon.selected:Connect(function()   frame.Visible = true  end)
icon.deselected:Connect(function() frame.Visible = false end)

-- Nhiều frame:
icon:bindToggleItem(frameA)
icon:bindToggleItem(frameB)
icon:unbindToggleItem(frameA)
```

---

### 8. Phím Tắt Bàn Phím

```lua
icon:bindToggleKey(Enum.KeyCode.X)    -- nhấn X để toggle
icon:unbindToggleKey(Enum.KeyCode.X)  -- gỡ
```

Tự động hiện gợi ý phím "X" trong caption.

---

### 9. Caption Tooltip

```lua
icon:setCaption("Mở Cửa Hàng")
icon:setCaptionHint(Enum.KeyCode.B)  -- gợi ý "B", không bind thật
icon:setCaption(nil)                  -- xóa
```

---

### 10. Badge Thông Báo

```lua
icon:notify()                  -- +1
icon:notify(icon.deselected)   -- +1, tự xóa khi bỏ chọn
icon:clearNotices()            -- xóa tất cả

print(icon.totalNotices)       -- số hiện tại
```

---

### 11. Nút Single-Click

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

### 12. Khóa & Debounce

```lua
icon:lock()    -- người dùng không toggle được
icon:unlock()  -- mở lại

-- Cooldown (dùng task.spawn vì yields)
icon.selected:Connect(function()
    task.spawn(function()
        icon:debounce(3)  -- khóa 3 giây
    end)
end)
```

---

### 13. Tùy Chỉnh Giao Diện

```lua
-- Một thay đổi
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30)})

-- Nhiều thay đổi
icon:modifyTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget",       "BackgroundTransparency", 0},
    {"Widget",       "MinimumWidth",           80},
    {"Widget",       "MinimumHeight",          44},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
})

-- Theo trạng thái
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(0,120,255), "Selected"})
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30),  "Deselected"})

-- Cho icon con (dropdown/menu)
icon:modifyChildTheme({
    {"Widget", "MinimumWidth",           200},
    {"Widget", "BackgroundColor3",       Color3.fromRGB(30,30,35)},
})

-- Toàn cục
Icon.modifyBaseTheme({
    {"Widget",      "BackgroundColor3",       Color3.fromRGB(20,20,20)},
    {"Widget",      "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",           UDim.new(0,8)},
})
```

---

### 14. Dropdown — Menu Dọc

```lua
local c1 = Icon.new():setLabel("Lựa Chọn A")
local c2 = Icon.new():setLabel("Lựa Chọn B")
local c3 = Icon.new():setLabel("Lựa Chọn C")

c1.selected:Connect(function() print("A!") end)

local drop = Icon.new()
    :setLabel("Menu")
    :modifyTheme({{"Dropdown", "MaxIcons", 3}})
    :modifyChildTheme({{"Widget", "MinimumWidth", 160}})
    :setDropdown({c1, c2, c3})

drop:setDropdown({})   -- xóa
c1:joinDropdown(drop)  -- thêm thủ công
c1:leave()             -- rời
```

---

### 15. Menu — Menu Ngang

```lua
local i1 = Icon.new():setLabel("Bay")
local i2 = Icon.new():setLabel("Tốc Độ")
local i3 = Icon.new():setLabel("Xuyên Tường")

local menu = Icon.new()
    :setLabel("Công Cụ")
    :modifyTheme({{"Menu", "MaxIcons", 2}})
    :setMenu({i1, i2, i3})
```

---

### 16. Fixed Menu — Menu Cố Định

```lua
Icon.new()
    :modifyTheme({{"Menu", "MaxIcons", 3}})
    :setFixedMenu({
        Icon.new():setLabel("Trang Chủ"),
        Icon.new():setLabel("Cửa Hàng"),
        Icon.new():setLabel("Kho Đồ"),
        Icon.new():setLabel("Cài Đặt"),
    })
```

---

### 17. Dropdown Động Từ Dữ Liệu

```lua
local tinhNang = {
    {ten = "Bay",           hanh = function(bat) print("Bay:", bat)    end},
    {ten = "Hack Tốc Độ",  hanh = function(bat) print("Speed:", bat)  end},
    {ten = "Xuyên Tường",  hanh = function(bat) print("Clip:", bat)   end},
    {ten = "Nhảy Vô Hạn", hanh = function(bat) print("Jump:", bat)   end},
}

local iconCon = {}
for _, tn in ipairs(tinhNang) do
    local child = Icon.new()
        :setLabel("✗ " .. tn.ten)
        :setWidth(180)
        :autoDeselect(false)

    child.toggled:Connect(function(isOn)
        child:setLabel((isOn and "✓ " or "✗ ") .. tn.ten)
        tn.hanh(isOn)
    end)

    table.insert(iconCon, child)
end

Icon.new()
    :setLabel("Tính Năng")
    :align("Left")
    :modifyTheme({{"Dropdown", "MaxIcons", 5}})
    :modifyChildTheme({
        {"Widget", "MinimumWidth",           190},
        {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
        {"Widget", "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",      UDim.new(0, 6)},
    })
    :setDropdown(iconCon)
```

---

### 18. RichText Trong Label

```lua
local child = Icon.new()

task.defer(function()
    local lbl = child:getInstance("IconLabel")
    if not lbl then return end
    lbl.RichText = true
    lbl.Text = 'Dark Aura  <font color="#FF5050">5,600 KILLS</font>'
end)
```

Item bị khóa:

```lua
lbl.Text = '🔒 <font color="#888888">' .. tenItem .. '</font>'
```

---

### 19. Giao Diện Toàn Cục

```lua
Icon.modifyBaseTheme({
    {"Widget",       "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget",       "BackgroundTransparency", 0},
    {"IconCorners",  "CornerRadius",           UDim.new(0, 8)},
    {"IconGradient", "Enabled",                false},
})
```

---

### 20. Điều Khiển Bằng Code

```lua
local icon = Icon.new():setName("iconCuaToi"):setLabel("Test")

local found = Icon.getIcon("iconCuaToi")

icon:select()
icon:deselect()

local tatCa = Icon.getIcons()

Icon.setTopbarEnabled(false)
Icon.setTopbarEnabled(true)

icon:destroy()
```

---

## API Reference

> Code và tên hàm hoàn toàn giống phần [API Reference tiếng Anh](#api-reference) — Lua không thay đổi.

---

## Ví Dụ Thực Tế

> Code hoàn toàn giống phần [Real-World Examples](#real-world-examples) — copy paste trực tiếp.

---

## Các Lỗi Đã Fix

### Fix 1 — Janitor camelCase aliases
```
attempt to call missing method 'clean' of table
```
TopbarPlus gọi `janitor:clean()` / `janitor:add()` / `janitor:destroy()` nhưng Janitor chỉ có PascalCase. Đã vá bằng cách thêm aliases:
```lua
Janitor.__index.clean   = Janitor.__index.Cleanup
Janitor.__index.add     = Janitor.__index.Add
Janitor.__index.destroy = Janitor.__index.Destroy
```

### Fix 2 — `math.clamp` nhận nil
```
invalid argument #2 to 'clamp' (number expected, got nil)
```
`widget:GetAttribute("MinimumWidth")` trả về `nil` khi chưa set. Đã vá:
```lua
local widgetMinimumWidth  = widget:GetAttribute("MinimumWidth")  or 0
local widgetMinimumHeight = widget:GetAttribute("MinimumHeight") or 36
```

---

<div align="center">
<br/>

Original TopbarPlus bởi [@ForeverHD](https://github.com/1ForeverHD) & HD Admin  
Bundle + fix được maintain riêng cho executor

</div>
