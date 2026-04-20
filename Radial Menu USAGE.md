# RadialMenu v3

Executor-compatible radial menu — port of EgoMoose/Rbx-Gui-Library.  
Works on **Delta, Synapse X, Solara** và các executor tương tự.

---

## Quick Start

```lua
local menu = RadialMenu.fromConfig({
    items = {
        { label = "Heal",   color = Color3.fromRGB(60, 220, 120), onSelect = function() end },
        { label = "Attack", color = Color3.fromRGB(255, 70,  70),  onSelect = function() end },
        { label = "Shield", color = Color3.fromRGB(70, 130, 255), onSelect = function() end },
    },
})
```

PC: **RightClick** để mở.  
Mobile: Tap nút **❋** góc dưới phải.

---

## `fromConfig` — Full Options

```lua
RadialMenu.fromConfig({
    items             = { ... },      -- required, min 2
    size              = 310,          -- pixel diameter
    thickness         = 0.42,         -- ring width 0–1
    rotation          = 0,            -- radians offset
    openKey           = nil,          -- Enum.KeyCode keybind
    followCursor      = true,         -- spawn at cursor
    closeOnSelect     = true,         -- close after pick
    openOnRightClick  = true,         -- PC right-click (khi không có openKey)
    showMobileButton  = true,         -- hiện/ẩn nút ❋ mobile
    parent            = nil,          -- custom ScreenGui
    centerButton      = { ... },      -- nút tròn giữa
})
```

### `items[]`

| Field | Type | Description |
|---|---|---|
| `label` | `string` | Text trong slice |
| `color` | `Color3` | Màu nền slice |
| `icon` | `string` | `rbxassetid://...` |
| `onSelect` | `function(index)` | Callback khi chọn |

### `centerButton`

Nút tròn nằm chính giữa menu. Mặc định click = đóng menu.

| Field | Type | Default | Description |
|---|---|---|---|
| `label` | `string` | `nil` | Text hiển thị |
| `icon` | `string` | `nil` | Image asset |
| `color` | `Color3` | `RGB(18,18,26)` | Màu nền |
| `hoverColor` | `Color3` | `RGB(28,28,40)` | Màu khi hover |
| `strokeColor` | `Color3` | `RGB(0,210,255)` | Màu viền glow |
| `labelColor` | `Color3` | white | Màu text |
| `iconColor` | `Color3` | white | Màu icon |
| `size` | `number` | `0.24` | Tỉ lệ so với kích thước menu (0–1) |
| `onClick` | `function` | `menu:Close()` | Callback khi press |

### `showMobileButton`

```lua
showMobileButton = true   -- hiện nút ❋ góc dưới phải (default)
showMobileButton = false  -- ẩn nút, tự quản lý Open/Close
```

---

## Methods

| Method | Description |
|---|---|
| `menu:Open()` | Mở ở center màn hình |
| `menu:Open(x, y)` | Mở tại toạ độ màn hình |
| `menu:Close()` | Đóng có animation |
| `menu:Close(callback)` | Đóng rồi gọi callback |
| `menu:Destroy()` | Dọn sạch toàn bộ |

### Low-level

| Method | Returns | Description |
|---|---|---|
| `menu:GetRadial(i)` | `ViewportFrame` | Slice thứ i |
| `menu:GetAttachment(i)` | `Frame` | Frame label/icon slice i |
| `menu:SetRadialProps(props)` | — | Set prop cho tất cả slices |
| `menu:SetDialProps(props)` | — | Set prop cho dial indicator |
| `menu:PickIndex(theta)` | `number` | Index gần nhất với góc theta |
| `menu:GetTheta(inputType)` | `number?` | Góc input hiện tại (nil = deadzone) |

---

## Events

```lua
menu.Clicked:Connect(function(index)
    print("Đã chọn slice:", index)
end)

menu.Hover:Connect(function(oldIndex, newIndex)
    print("Di chuyển từ", oldIndex, "→", newIndex)
end)
```

---

## Examples

### Minimal (3 items)

```lua
local menu = RadialMenu.fromConfig({
    items = {
        { label = "A", onSelect = function() print("A") end },
        { label = "B", onSelect = function() print("B") end },
        { label = "C", onSelect = function() print("C") end },
    },
})
```

---

### Center Button + Icons

```lua
local menu = RadialMenu.fromConfig({
    size      = 320,
    thickness = 0.40,
    centerButton = {
        icon        = "rbxassetid://7733960981",
        size        = 0.26,
        strokeColor = Color3.fromRGB(255, 80, 80),
        onClick     = function()
            print("center pressed")
            menu:Close()
        end,
    },
    items = {
        {
            label    = "Heal",
            icon     = "rbxassetid://123456",
            color    = Color3.fromRGB(60, 220, 120),
            onSelect = function() end,
        },
        {
            label    = "Attack",
            icon     = "rbxassetid://654321",
            color    = Color3.fromRGB(255, 70, 70),
            onSelect = function() end,
        },
    },
})
```

---

### Keyboard Keybind (không dùng RightClick)

```lua
local menu = RadialMenu.fromConfig({
    openKey      = Enum.KeyCode.Q,
    followCursor = true,
    items        = { ... },
})
```

---

### Manual Control (tự quản lý Open/Close)

```lua
local menu = RadialMenu.fromConfig({
    openKey          = nil,
    openOnRightClick = false,
    showMobileButton = false,
    closeOnSelect    = false,
    items            = { ... },
})

someButton.Activated:Connect(function()
    menu:Open(200, 400)
end)

menu.Clicked:Connect(function(index)
    print("Chọn:", index)
    menu:Close()
end)
```

---

### Mobile — Ẩn nút mặc định, tự làm nút riêng

```lua
local menu = RadialMenu.fromConfig({
    showMobileButton = false,
    items            = { ... },
})

local myBtn = Instance.new("TextButton")
myBtn.Text = "Open"
myBtn.Parent = playerGui
myBtn.Activated:Connect(function()
    if menu._IsOpen then menu:Close() else menu:Open() end
end)
```

---

### Low-level (không dùng `fromConfig`)

```lua
local sg = Instance.new("ScreenGui")
sg.Parent = game:GetService("CoreGui")

local menu = RadialMenu.new(4, 0.45, 0)
local container = menu:Mount(sg, 300)

menu._ItemColors[1] = Color3.fromRGB(255, 80, 80)
menu:GetRadial(1).ImageColor3 = Color3.fromRGB(255, 80, 80)
menu:GetRadial(1).ImageTransparency = 0.2

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1,0,1,0)
lbl.Text = "Attack"
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.new(1,1,1)
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.Parent = menu:GetAttachment(1)

menu.Clicked:Connect(function(i)
    print("Clicked:", i)
end)

menu:Open()
```

---

## Radial Bar

Vòng ngoài menu là **64 segment** trang trí, hiệu ứng gradient cyan → blue → violet.  
Sweep-in clockwise khi `Open()`, fade-out khi `Close()` — không có progress/cooldown.

---

## Properties

| Property | Default | Description |
|---|---|---|
| `menu.Enabled` | `true` | Bật/tắt input |
| `menu.DeadZoneIn` | `0.5` | Vùng chết bên trong (0–1) |
| `menu.DeadZoneOut` | `math.huge` | Vùng chết bên ngoài |
| `menu.SubN` | — | Số slice |
| `menu.Rotation` | — | Rotation offset (radians) |
| `menu.Frame` | — | Root Frame của ring |
| `menu._Container` | — | Holder Frame (có UIScale) |
| `menu._IsOpen` | — | Trạng thái hiện tại |
| `menu._CenterBtn` | — | Reference đến center button |
| `menu._MobileBtn` | — | Reference đến mobile button |

---

## Compatibility

| Executor | Status |
|---|---|
| Delta | ✅ |
| Synapse X | ✅ |
| Solara | ✅ |
| Wave | ✅ |

- `gethui()` → fallback `CoreGui` → `PlayerGui`
- Không dùng `require()` hay `script` references
- Touch + Mouse + Gamepad support
