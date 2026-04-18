# TopbarPlus Executor Bundle — Documentation

<div align="center">

![TopbarPlus](https://img.shields.io/badge/TopbarPlus-Executor%20Bundle-blue?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1-purple?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Roblox-Executor-red?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**[English](#english) · [Tiếng Việt](#tiếng-việt)**

> Wrapper bundle của [TopbarPlus v3](https://github.com/1ForeverHD/TopbarPlus) dành cho Roblox executor.  
> Executor-ready bundle wrapper of [TopbarPlus v3](https://github.com/1ForeverHD/TopbarPlus).

</div>

---

# English

## Table of Contents
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
  - [Global Functions](#global-functions)
  - [Constructor](#constructor)
  - [Methods](#methods)
  - [Events](#events)
  - [Properties](#properties)
- [Full Examples](#full-examples)
- [Known Fixes](#known-fixes)

---

## Installation

### From file (executor)
```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()
```

### From URL
```lua
local tp   = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR/REPO/main/TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()
```

### Debug check
```lua
if not Icon then
    warn("[TopbarPlus] Failed to load!")
    return
end
```

---

## Quick Start

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Menu")
    :align("Right")

icon.selected:Connect(function()
    print("opened!")
end)

icon.deselected:Connect(function()
    print("closed!")
end)
```

---

## API Reference

### Global Functions

| Function | Description |
|----------|-------------|
| `Icon.new()` | Create a new icon |
| `Icon.getIcon(nameOrUID)` | Get icon by name or UID |
| `Icon.getIcons()` | Get all icons as `{ [uid] = icon }` |
| `Icon.setTopbarEnabled(bool)` | Show/hide all TopbarPlus ScreenGuis |
| `Icon.modifyBaseTheme(mods)` | Modify appearance of **all** icons |
| `Icon.setDisplayOrder(int)` | Set base DisplayOrder of ScreenGuis |

---

### Constructor

#### `Icon.new()`
Creates an empty `32x32` icon on the topbar.
```lua
local icon = Icon.new()
```

---

### Methods

All methods are **chainable** unless stated otherwise.

#### Appearance

| Method | Description |
|--------|-------------|
| `:setImage(imageId, iconState?)` | Set icon image. Accepts asset ID, `"rbxassetid://..."` or full URL |
| `:setLabel(text, iconState?)` | Set text label |
| `:setWidth(min, iconState?)` | Set minimum width (default: `44`) |
| `:setImageScale(n, iconState?)` | Image size relative to icon (default: `0.5`) |
| `:setImageRatio(n, iconState?)` | Aspect ratio of image (default: `1`) |
| `:setCornerRadius(scale, offset, iconState?)` | Corner rounding |
| `:setTextSize(n, iconState?)` | Label font size (default: `16`) |
| `:setTextColor(Color3, iconState?)` | Label text color |
| `:setTextFont(font, weight?, style?, iconState?)` | Label font. Accepts `Enum.Font`, font name, or asset ID |
| `:setOrder(n, iconState?)` | Display order in topbar |
| `:disableStateOverlay(bool)` | Disable click shade effect |

> **`iconState`** can be `"Deselected"`, `"Selected"`, or `nil` (both states).

---

#### Behavior

| Method | Description |
|--------|-------------|
| `:align(alignment)` | `"Left"` \| `"Center"` \| `"Right"` |
| `:setName(name)` | Name for `Icon.getIcon(name)` lookup |
| `:setEnabled(bool)` | Show/hide icon |
| `:select()` | Force select via code |
| `:deselect()` | Force deselect via code |
| `:lock()` | Disable user input toggle (code can still toggle) |
| `:unlock()` | Re-enable user input |
| `:debounce(seconds)` | Lock → wait → unlock. **Yields**, use in `task.spawn` |
| `:autoDeselect(bool)` | If `true` (default), deselects when another icon is selected |
| `:oneClick(bool)` | Auto-deselect after being selected (single-click button) |

---

#### Notifications

| Method | Description |
|--------|-------------|
| `:notify(clearEvent?)` | Add notice badge (+1). Optional: auto-clear on event |
| `:clearNotices()` | Remove all notices |

---

#### Toggle Items & Keys

| Method | Description |
|--------|-------------|
| `:bindToggleItem(guiObject)` | GuiObject shows/hides when icon toggles |
| `:unbindToggleItem(guiObject)` | Remove binding |
| `:bindToggleKey(Enum.KeyCode)` | Keyboard shortcut to toggle |
| `:unbindToggleKey(Enum.KeyCode)` | Remove keybind |

---

#### Caption

| Method | Description |
|--------|-------------|
| `:setCaption(text)` | Tooltip shown on hover. Pass `nil` to remove |
| `:setCaptionHint(Enum.KeyCode)` | Show keybind hint in caption without binding it |

---

#### Dropdown (Vertical Menu)

| Method | Description |
|--------|-------------|
| `:setDropdown(arrayOfIcons)` | Create vertical dropdown. Pass `{}` to remove |
| `:joinDropdown(parentIcon)` | Join another icon's dropdown |

---

#### Menu (Horizontal Menu)

| Method | Description |
|--------|-------------|
| `:setMenu(arrayOfIcons)` | Create horizontal menu. Pass `{}` to remove |
| `:setFixedMenu(arrayOfIcons)` | Always-open menu with hidden close button |
| `:joinMenu(parentIcon)` | Join another icon's menu |

---

#### Misc

| Method | Description |
|--------|-------------|
| `:leave()` | Remove icon from parent dropdown/menu |
| `:call(func)` | Run `func(icon)` via `task.spawn` while staying chainable |
| `:addToJanitor(userdata)` | Clean up on icon destroy |
| `:bindEvent(eventName, callback)` | Connect to event by name (camelCase) |
| `:unbindEvent(eventName)` | Disconnect event binding |
| `:getInstance(name)` | Get first descendant in widget by name |
| `:destroy()` | Destroy icon and all connections |

---

#### Theme / modifyTheme

```lua
-- Single modification
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30)})

-- Multiple modifications
icon:modifyTheme({
    {"Widget", "BackgroundColor3",    Color3.fromRGB(30, 30, 30)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",   UDim.new(0, 8)},
    {"IconGradient", "Enabled",       false},
    {"Widget", "MinimumWidth",        100},
    {"Widget", "MinimumHeight",       44},
})

-- Apply to ALL child icons (dropdown/menu children)
icon:modifyChildTheme({
    {"Widget", "MinimumWidth", 200},
})

-- Apply to ALL icons globally
Icon.modifyBaseTheme({
    {"Widget", "BackgroundColor3", Color3.fromRGB(20, 20, 20)},
})
```

**Common theme targets:**

| Name | What it affects |
|------|----------------|
| `"Widget"` | Main icon container frame |
| `"IconCorners"` | Corner radius of icon |
| `"IconGradient"` | Gradient overlay |
| `"IconLabel"` | Text label |
| `"IconImage"` | Image element |
| `"Dropdown"` | Dropdown container |
| `"Menu"` | Menu container |

**Common `Dropdown`/`Menu` attributes:**

| Attribute | Description |
|-----------|-------------|
| `"MaxIcons"` | Max icons before scroll |
| `"MaxWidth"` | Max width |

---

### Events

```lua
icon.selected:Connect(function(fromSource)
    -- fromSource: "User" | "OneClick" | "AutoDeselect" | "HideParentFeature" | "Overflow" | nil
end)

icon.deselected:Connect(function(fromSource) end)

icon.toggled:Connect(function(isSelected, fromSource) end)

icon.viewingStarted:Connect(function() end)   -- hover start

icon.viewingEnded:Connect(function() end)     -- hover end

icon.notified:Connect(function() end)         -- new notice
```

---

### Properties

> All read-only.

| Property | Type | Description |
|----------|------|-------------|
| `icon.name` | `string` | Widget name (default: `"Widget"`) |
| `icon.isSelected` | `bool` | Current selected state |
| `icon.isEnabled` | `bool` | Whether icon is visible |
| `icon.totalNotices` | `int` | Number of active notices |
| `icon.locked` | `bool` | Whether icon is locked |

---

## Full Examples

### Basic Toggle
```lua
local icon = Icon.new()
    :setLabel("ESP")
    :setLabel("OFF", "Deselected")
    :setLabel("ON",  "Selected")
    :align("Right")
    :setCaption("Toggle ESP  [X]")
    :bindToggleKey(Enum.KeyCode.X)

icon.toggled:Connect(function(isOn)
    -- your logic here
    print("ESP:", isOn)
end)
```

---

### Bind GUI Frame
```lua
local myFrame = -- your ScreenGui frame

local icon = Icon.new()
    :setLabel("Hide", "Deselected")
    :setLabel("Show", "Selected")
    :align("Right")
    :bindToggleItem(myFrame)
```

---

### Dropdown from Data
```lua
local items = {
    {name = "Fly",       fn = function(on) print("Fly", on)   end},
    {name = "Speed",     fn = function(on) print("Speed", on) end},
    {name = "Noclip",    fn = function(on) print("Clip", on)  end},
    {name = "Inf Jump",  fn = function(on) print("Jump", on)  end},
}

local children = {}
for _, item in ipairs(items) do
    local child = Icon.new()
        :setLabel(item.name)
        :setWidth(140)
        :autoDeselect(false)
    child.toggled:Connect(function(isOn)
        item.fn(isOn)
        child:setLabel((isOn and "✓ " or "✗ ") .. item.name)
    end)
    table.insert(children, child)
end

Icon.new()
    :setLabel("Features")
    :align("Left")
    :modifyTheme({{"Dropdown", "MaxIcons", 5}})
    :modifyChildTheme({{"Widget", "MinimumWidth", 160}})
    :setDropdown(children)
```

---

### Dark Theme
```lua
Icon.modifyBaseTheme({
    {"Widget", "BackgroundColor3",      Color3.fromRGB(20, 20, 25)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",     UDim.new(0, 8)},
    {"IconGradient", "Enabled",         false},
})
```

---

### Accessories Dropdown (Real Example)
```lua
local accessoryIcons = {}
for _, v in pairs(game:GetService("Players").LocalPlayer
    .PlayerGui.AwesomeGUI.Shop.AccessoryArray.Array:GetChildren()) do

    local isLocked = v:FindFirstChild("Locked") and v.Locked.Visible

    local child = Icon.new()
        :setImage(v.Accessory.Image)
        :setWidth(220)
        :modifyTheme({
            {"Widget", "BackgroundColor3",      Color3.fromRGB(30, 30, 35)},
            {"Widget", "BackgroundTransparency", 0},
            {"IconCorners", "CornerRadius",     UDim.new(0, 6)},
        })

    task.defer(function()
        local label = child:getInstance("IconLabel")
        if label then
            label.RichText = true
            label.Text = isLocked
                and '🔒 <font color="#888888">' .. v.Name .. '</font>'
                or v.Name
        end
    end)

    child.selected:Connect(function()
        if isLocked then child:deselect() return end
        game:GetService("ReplicatedStorage").AccessoryHandle:FireServer("Equip", v.Name, nil)
    end)

    table.insert(accessoryIcons, child)
end

Icon.new()
    :setLabel("Accessories")
    :align("Right")
    :modifyTheme({
        {"Widget", "BackgroundColor3",      Color3.fromRGB(25, 25, 30)},
        {"Widget", "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",     UDim.new(0, 8)},
        {"Dropdown", "MaxIcons",            6},
    })
    :modifyChildTheme({
        {"Widget", "MinimumWidth",          220},
        {"Widget", "BackgroundColor3",      Color3.fromRGB(30, 30, 35)},
        {"Widget", "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",     UDim.new(0, 6)},
    })
    :setDropdown(accessoryIcons)
```

---

### With Obsidian UI Library
```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"
))()

local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local Window = Library:CreateWindow({
    Title    = "My Script",
    AutoShow = true,
})

Library.ShowToggleFrameInKeybinds = false  -- hide default toggle button

local toggleUI = Icon.new()
    :setLabel("Hide", "Deselected")
    :setLabel("Show", "Selected")
    :align("Right")

toggleUI.toggled:Connect(function()
    Window:Toggle()
end)
```

---

## Known Fixes

This bundle includes 2 patches over the original TopbarPlus source:

### Fix 1 — Janitor camelCase aliases
**Error:** `attempt to call missing method 'clean' of table`  
**Cause:** TopbarPlus calls `janitor:clean()` / `janitor:add()` / `janitor:destroy()` but Janitor only exposes PascalCase (`Clean`, `Add`, `Destroy`).  
**Fix:** Added camelCase aliases in `Packages/Janitor`.

### Fix 2 — `math.clamp` nil argument
**Error:** `invalid argument #2 to 'clamp' (number expected, got nil)`  
**Cause:** `widget:GetAttribute("MinimumWidth")` returns `nil` when attribute not yet set.  
**Fix:** Added `or 0` / `or 36` fallbacks in `Elements/Widget`.

---

---

# Tiếng Việt

## Mục Lục
- [Cài Đặt](#cài-đặt)
- [Bắt Đầu Nhanh](#bắt-đầu-nhanh)
- [API Reference](#api-reference-1)
  - [Hàm Toàn Cục](#hàm-toàn-cục)
  - [Constructor](#constructor-1)
  - [Phương Thức](#phương-thức)
  - [Events](#events-1)
  - [Properties](#properties-1)
- [Ví Dụ Đầy Đủ](#ví-dụ-đầy-đủ)
- [Các Lỗi Đã Fix](#các-lỗi-đã-fix)

---

## Cài Đặt

### Từ file (executor)
```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()
```

### Từ URL
```lua
local tp   = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR/REPO/main/TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()
```

### Kiểm tra lỗi
```lua
if not Icon then
    warn("[TopbarPlus] Load thất bại!")
    return
end
```

---

## Bắt Đầu Nhanh

```lua
local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local icon = Icon.new()
    :setImage(12345678)
    :setLabel("Menu")
    :align("Right")

icon.selected:Connect(function()
    print("đã mở!")
end)

icon.deselected:Connect(function()
    print("đã đóng!")
end)
```

---

## API Reference

### Hàm Toàn Cục

| Hàm | Mô tả |
|-----|-------|
| `Icon.new()` | Tạo icon mới |
| `Icon.getIcon(nameOrUID)` | Lấy icon theo tên hoặc UID |
| `Icon.getIcons()` | Lấy tất cả icons dạng `{ [uid] = icon }` |
| `Icon.setTopbarEnabled(bool)` | Hiện/ẩn toàn bộ TopbarPlus ScreenGui |
| `Icon.modifyBaseTheme(mods)` | Thay đổi appearance của **tất cả** icon |
| `Icon.setDisplayOrder(int)` | Đặt DisplayOrder cho ScreenGui |

---

### Constructor

#### `Icon.new()`
Tạo icon trống `32x32` trên topbar.
```lua
local icon = Icon.new()
```

---

### Phương Thức

Tất cả phương thức đều **chainable** (có thể nối chuỗi) trừ khi ghi chú khác.

#### Giao Diện

| Phương thức | Mô tả |
|-------------|-------|
| `:setImage(imageId, iconState?)` | Đặt ảnh icon. Nhận asset ID, `"rbxassetid://..."` hoặc URL |
| `:setLabel(text, iconState?)` | Đặt text hiển thị |
| `:setWidth(min, iconState?)` | Chiều rộng tối thiểu (mặc định: `44`) |
| `:setImageScale(n, iconState?)` | Kích thước ảnh so với icon (mặc định: `0.5`) |
| `:setImageRatio(n, iconState?)` | Tỉ lệ khung hình ảnh (mặc định: `1`) |
| `:setCornerRadius(scale, offset, iconState?)` | Bo góc icon |
| `:setTextSize(n, iconState?)` | Kích thước font chữ (mặc định: `16`) |
| `:setTextColor(Color3, iconState?)` | Màu chữ |
| `:setTextFont(font, weight?, style?, iconState?)` | Font chữ. Nhận `Enum.Font`, tên font, hoặc asset ID |
| `:setOrder(n, iconState?)` | Thứ tự hiển thị trên topbar |
| `:disableStateOverlay(bool)` | Tắt hiệu ứng shade khi nhấn |

> **`iconState`** có thể là `"Deselected"`, `"Selected"`, hoặc `nil` (cả hai trạng thái).

---

#### Hành Vi

| Phương thức | Mô tả |
|-------------|-------|
| `:align(alignment)` | `"Left"` \| `"Center"` \| `"Right"` |
| `:setName(name)` | Đặt tên để dùng với `Icon.getIcon(name)` |
| `:setEnabled(bool)` | Hiện/ẩn icon |
| `:select()` | Chọn icon bằng code |
| `:deselect()` | Bỏ chọn icon bằng code |
| `:lock()` | Chặn người dùng toggle (code vẫn toggle được) |
| `:unlock()` | Mở lại cho người dùng toggle |
| `:debounce(seconds)` | Khóa → chờ → mở. **Yields**, dùng trong `task.spawn` |
| `:autoDeselect(bool)` | Nếu `true` (mặc định), tự bỏ chọn khi icon khác được chọn |
| `:oneClick(bool)` | Tự bỏ chọn sau khi được chọn (nút single-click) |

---

#### Thông Báo

| Phương thức | Mô tả |
|-------------|-------|
| `:notify(clearEvent?)` | Thêm badge thông báo (+1). Tùy chọn: tự xóa khi có event |
| `:clearNotices()` | Xóa tất cả thông báo |

---

#### Toggle Items & Phím Tắt

| Phương thức | Mô tả |
|-------------|-------|
| `:bindToggleItem(guiObject)` | GuiObject tự show/hide theo trạng thái icon |
| `:unbindToggleItem(guiObject)` | Gỡ binding |
| `:bindToggleKey(Enum.KeyCode)` | Phím tắt để toggle icon |
| `:unbindToggleKey(Enum.KeyCode)` | Gỡ phím tắt |

---

#### Caption (Tooltip)

| Phương thức | Mô tả |
|-------------|-------|
| `:setCaption(text)` | Tooltip hiện khi hover. Truyền `nil` để xóa |
| `:setCaptionHint(Enum.KeyCode)` | Hiện gợi ý phím trong caption mà không bind |

---

#### Dropdown (Menu Dọc)

| Phương thức | Mô tả |
|-------------|-------|
| `:setDropdown(arrayOfIcons)` | Tạo dropdown dọc. Truyền `{}` để xóa |
| `:joinDropdown(parentIcon)` | Vào dropdown của icon khác |

---

#### Menu (Menu Ngang)

| Phương thức | Mô tả |
|-------------|-------|
| `:setMenu(arrayOfIcons)` | Tạo menu ngang. Truyền `{}` để xóa |
| `:setFixedMenu(arrayOfIcons)` | Menu luôn mở, không có nút đóng |
| `:joinMenu(parentIcon)` | Vào menu của icon khác |

---

#### Khác

| Phương thức | Mô tả |
|-------------|-------|
| `:leave()` | Rời khỏi dropdown/menu cha |
| `:call(func)` | Chạy `func(icon)` qua `task.spawn`, vẫn chainable |
| `:addToJanitor(userdata)` | Dọn dẹp khi icon bị destroy |
| `:bindEvent(eventName, callback)` | Kết nối event theo tên (camelCase) |
| `:unbindEvent(eventName)` | Ngắt kết nối event |
| `:getInstance(name)` | Lấy descendant đầu tiên trong widget theo tên |
| `:destroy()` | Xóa icon và tất cả connections |

---

#### Theme / modifyTheme

```lua
-- Một thay đổi
icon:modifyTheme({"Widget", "BackgroundColor3", Color3.fromRGB(30,30,30)})

-- Nhiều thay đổi
icon:modifyTheme({
    {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 30)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",      UDim.new(0, 8)},
    {"IconGradient", "Enabled",          false},
    {"Widget", "MinimumWidth",           100},
    {"Widget", "MinimumHeight",          44},
})

-- Áp dụng cho TẤT CẢ icon con (trong dropdown/menu)
icon:modifyChildTheme({
    {"Widget", "MinimumWidth", 200},
})

-- Áp dụng cho TẤT CẢ icon toàn cục
Icon.modifyBaseTheme({
    {"Widget", "BackgroundColor3", Color3.fromRGB(20, 20, 20)},
})
```

**Các target theme thường dùng:**

| Tên | Ảnh hưởng đến |
|-----|---------------|
| `"Widget"` | Frame container chính của icon |
| `"IconCorners"` | Bo góc icon |
| `"IconGradient"` | Lớp gradient |
| `"IconLabel"` | Text label |
| `"IconImage"` | Phần tử ảnh |
| `"Dropdown"` | Container dropdown |
| `"Menu"` | Container menu |

**Thuộc tính `Dropdown`/`Menu` thường dùng:**

| Thuộc tính | Mô tả |
|------------|-------|
| `"MaxIcons"` | Số icon tối đa trước khi scroll |
| `"MaxWidth"` | Chiều rộng tối đa |

---

### Events

```lua
icon.selected:Connect(function(fromSource)
    -- fromSource: "User" | "OneClick" | "AutoDeselect" | "HideParentFeature" | "Overflow" | nil
end)

icon.deselected:Connect(function(fromSource) end)

icon.toggled:Connect(function(isSelected, fromSource) end)

icon.viewingStarted:Connect(function() end)  -- hover bắt đầu

icon.viewingEnded:Connect(function() end)    -- hover kết thúc

icon.notified:Connect(function() end)        -- có notice mới
```

---

### Properties

> Tất cả read-only.

| Property | Kiểu | Mô tả |
|----------|------|-------|
| `icon.name` | `string` | Tên widget (mặc định: `"Widget"`) |
| `icon.isSelected` | `bool` | Trạng thái được chọn hiện tại |
| `icon.isEnabled` | `bool` | Icon có đang hiển thị không |
| `icon.totalNotices` | `int` | Số notice đang hiện |
| `icon.locked` | `bool` | Icon có đang bị khóa không |

---

## Ví Dụ Đầy Đủ

### Toggle Cơ Bản
```lua
local icon = Icon.new()
    :setLabel("ESP")
    :setLabel("TẮT", "Deselected")
    :setLabel("BẬT", "Selected")
    :align("Right")
    :setCaption("Bật/Tắt ESP  [X]")
    :bindToggleKey(Enum.KeyCode.X)

icon.toggled:Connect(function(isOn)
    print("ESP:", isOn)
end)
```

---

### Bind Frame GUI
```lua
local myFrame = -- frame của bạn

local icon = Icon.new()
    :setLabel("Ẩn", "Deselected")
    :setLabel("Hiện", "Selected")
    :align("Right")
    :bindToggleItem(myFrame)  -- tự show/hide, không cần event
```

---

### Dropdown Từ Dữ Liệu
```lua
local features = {
    {name = "Bay",       fn = function(on) print("Bay:", on)     end},
    {name = "Tốc Độ",   fn = function(on) print("Speed:", on)   end},
    {name = "Xuyên Tường", fn = function(on) print("Clip:", on) end},
    {name = "Nhảy Vô Hạn", fn = function(on) print("Jump:", on) end},
}

local children = {}
for _, feat in ipairs(features) do
    local child = Icon.new()
        :setLabel(feat.name)
        :setWidth(150)
        :autoDeselect(false)
    child.toggled:Connect(function(isOn)
        feat.fn(isOn)
        child:setLabel((isOn and "✓ " or "✗ ") .. feat.name)
    end)
    table.insert(children, child)
end

Icon.new()
    :setLabel("Tính Năng")
    :align("Left")
    :modifyTheme({{"Dropdown", "MaxIcons", 5}})
    :modifyChildTheme({{"Widget", "MinimumWidth", 170}})
    :setDropdown(children)
```

---

### Dark Theme Toàn Cục
```lua
Icon.modifyBaseTheme({
    {"Widget", "BackgroundColor3",       Color3.fromRGB(20, 20, 25)},
    {"Widget", "BackgroundTransparency", 0},
    {"IconCorners", "CornerRadius",      UDim.new(0, 8)},
    {"IconGradient", "Enabled",          false},
})
```

---

### Dropdown Accessories (Ví Dụ Thực Tế)
```lua
local accessoryIcons = {}
for _, v in pairs(game:GetService("Players").LocalPlayer
    .PlayerGui.AwesomeGUI.Shop.AccessoryArray.Array:GetChildren()) do

    local isLocked = v:FindFirstChild("Locked") and v.Locked.Visible

    local child = Icon.new()
        :setImage(v.Accessory.Image)
        :setWidth(220)
        :modifyTheme({
            {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
            {"Widget", "BackgroundTransparency", 0},
            {"IconCorners", "CornerRadius",      UDim.new(0, 6)},
        })

    task.defer(function()
        local label = child:getInstance("IconLabel")
        if label then
            label.RichText = true
            label.Text = isLocked
                and '🔒 <font color="#888888">' .. v.Name .. '</font>'
                or v.Name
        end
    end)

    child.selected:Connect(function()
        if isLocked then child:deselect() return end
        game:GetService("ReplicatedStorage").AccessoryHandle:FireServer("Equip", v.Name, nil)
    end)

    table.insert(accessoryIcons, child)
end

Icon.new()
    :setLabel("Accessories")
    :align("Right")
    :modifyTheme({
        {"Widget", "BackgroundColor3",       Color3.fromRGB(25, 25, 30)},
        {"Widget", "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",      UDim.new(0, 8)},
        {"Dropdown", "MaxIcons",             6},
    })
    :modifyChildTheme({
        {"Widget", "MinimumWidth",           220},
        {"Widget", "BackgroundColor3",       Color3.fromRGB(30, 30, 35)},
        {"Widget", "BackgroundTransparency", 0},
        {"IconCorners", "CornerRadius",      UDim.new(0, 6)},
    })
    :setDropdown(accessoryIcons)
```

---

### Kết Hợp Với Obsidian UI
```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"
))()

local tp   = loadstring(readfile("TopbarPlus_bundled_fixed.lua"))()
local Icon = tp.get()

local Window = Library:CreateWindow({
    Title    = "Script của tôi",
    AutoShow = true,
})

Library.ShowToggleFrameInKeybinds = false  -- ẩn nút toggle mặc định

local toggleUI = Icon.new()
    :setLabel("Ẩn", "Deselected")
    :setLabel("Hiện", "Selected")
    :align("Right")

toggleUI.toggled:Connect(function()
    Window:Toggle()
end)
```

---

## Các Lỗi Đã Fix

Bundle này đã vá 2 lỗi so với source TopbarPlus gốc:

### Fix 1 — Janitor camelCase aliases
**Lỗi:** `attempt to call missing method 'clean' of table`  
**Nguyên nhân:** TopbarPlus gọi `janitor:clean()` / `janitor:add()` / `janitor:destroy()` nhưng Janitor chỉ expose PascalCase (`Clean`, `Add`, `Destroy`).  
**Sửa:** Thêm camelCase aliases trong `Packages/Janitor`.

### Fix 2 — `math.clamp` nhận nil
**Lỗi:** `invalid argument #2 to 'clamp' (number expected, got nil)`  
**Nguyên nhân:** `widget:GetAttribute("MinimumWidth")` trả về `nil` khi attribute chưa được set.  
**Sửa:** Thêm fallback `or 0` / `or 36` trong `Elements/Widget`.

---

<div align="center">

Made with ❤️ for the Roblox executor community  
Original TopbarPlus by [@ForeverHD](https://github.com/1ForeverHD)

</div>
