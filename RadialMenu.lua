-- RadialMenu - Executor Port
-- Ported from EgoMoose/Rbx-Gui-Library
-- Compatible with Delta, Synapse X, Solara, etc.

local UIS = game:GetService("UserInputService")
local RUNSERVICE = game:GetService("RunService")

local function getSafeGui()
	if gethui then return gethui() end
	local ok, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok then return cg end
	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- CONSTANTS
local TAU = math.pi * 2
local GAP = 2
local FOV = 70
local VIEW_DIST = 50
local PART_PER_UNIT = 6
local CENTER = CFrame.new(0, 0, -VIEW_DIST)
local EXTERIOR_RADIUS = VIEW_DIST * math.tan(math.rad(FOV / 2))
local G_OFFSET = GAP / (2 * EXTERIOR_RADIUS)
local EX_OFFSET = -TAU / 4 + G_OFFSET

-- Simple Maid
local function newMaid()
	local maid = { _tasks = {} }
	function maid:Mark(task)
		table.insert(self._tasks, task)
		return task
	end
	function maid:Sweep()
		for _, task in ipairs(self._tasks) do
			if typeof(task) == "RBXScriptConnection" then
				task:Disconnect()
			elseif typeof(task) == "Instance" then
				task:Destroy()
			elseif type(task) == "function" then
				task()
			end
		end
		self._tasks = {}
	end
	return maid
end

-- Triangle (2 WedgeParts per triangle)
local WEDGE_TEMPLATE = Instance.new("WedgePart")
WEDGE_TEMPLATE.Material = Enum.Material.SmoothPlastic
WEDGE_TEMPLATE.Anchored = true
WEDGE_TEMPLATE.CanCollide = false
WEDGE_TEMPLATE.Color = Color3.new(1, 1, 1)

local function Triangle(parent, a, b, c)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	if abd > acd and abd > bcd then
		c, a = a, c
	elseif acd > bcd and acd > abd then
		a, b = b, a
	end
	ab, ac, bc = b - a, c - a, c - b
	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit
	local height = math.abs(ab:Dot(up))
	local width1 = math.abs(ab:Dot(back))
	local width2 = math.abs(ac:Dot(back))
	local w1 = WEDGE_TEMPLATE:Clone()
	w1.Size = Vector3.new(0, height, width1)
	w1.CFrame = CFrame.fromMatrix((a + b) / 2, right, up, back)
	w1.Parent = parent
	local w2 = WEDGE_TEMPLATE:Clone()
	w2.Size = Vector3.new(0, height, width2)
	w2.CFrame = CFrame.fromMatrix((a + c) / 2, -right, up, -back)
	w2.Parent = parent
	return w1, w2
end

-- CreateSection
local function createSection(subN, interior_radius, exterior_radius, ppu)
	local subModel = Instance.new("Model")
	local exCircum = (TAU * exterior_radius) / subN - GAP
	local inCircum = (TAU * interior_radius) / subN - GAP
	local exTheta = exCircum / exterior_radius
	local inTheta = inCircum / interior_radius
	local diffTheta = exTheta - inTheta
	local exPoints, inPoints = {}, {}
	local nParts = math.ceil(exCircum / ppu)
	for i = 0, nParts do
		exPoints[i + 1] = CENTER * CFrame.fromEulerAnglesXYZ(0, 0, (i / nParts) * exTheta) * Vector3.new(exterior_radius, 0, 0)
		inPoints[i + 1] = CENTER * CFrame.fromEulerAnglesXYZ(0, 0, diffTheta / 2 + (i / nParts) * inTheta) * Vector3.new(interior_radius, 0, 0)
	end
	for i = 1, nParts do
		local a = exPoints[i]
		local b = inPoints[i]
		local c = exPoints[i + 1]
		local d = inPoints[i + 1]
		Triangle(subModel, a, b, c)
		Triangle(subModel, b, c, d)
	end
	return subModel
end

-- ViewportFrame + Camera templates
local VPF_TEMPLATE = Instance.new("ViewportFrame")
VPF_TEMPLATE.Ambient = Color3.new(1, 1, 1)
VPF_TEMPLATE.LightColor = Color3.new(1, 1, 1)
VPF_TEMPLATE.LightDirection = Vector3.new(0, 0, -1)
VPF_TEMPLATE.BackgroundTransparency = 1
VPF_TEMPLATE.Size = UDim2.new(1, 0, 1, 0)

local CAM_TEMPLATE = Instance.new("Camera")
CAM_TEMPLATE.CameraType = Enum.CameraType.Scriptable
CAM_TEMPLATE.CFrame = CFrame.new()
CAM_TEMPLATE.FieldOfView = FOV

local function pivotAround(model, pivotCF, newCF)
	local inv = pivotCF:Inverse()
	for _, part in next, model:GetDescendants() do
		if part:IsA("BasePart") then
			part.CFrame = newCF * (inv * part.CFrame)
		end
	end
end

-- CreateRadial Frame
local function createRadial(subN, tPercent, rotation)
	rotation = rotation or 0
	local dialEx = (1 - tPercent) * EXTERIOR_RADIUS - 1
	local dialIn = dialEx - 2
	local section = createSection(subN, (1 - tPercent) * EXTERIOR_RADIUS, EXTERIOR_RADIUS, PART_PER_UNIT)
	local innerSection = createSection(subN, dialIn, dialEx, PART_PER_UNIT / 2)
	local frame = Instance.new("Frame")
	local radialFrame = Instance.new("Frame")
	local attachFrame = Instance.new("Frame")
	radialFrame.BackgroundTransparency = 1
	attachFrame.BackgroundTransparency = 1
	radialFrame.Size = UDim2.new(1, 0, 1, 0)
	attachFrame.Size = UDim2.new(1, 0, 1, 0)
	radialFrame.Name = "Radial"
	attachFrame.Name = "Attach"
	radialFrame.Parent = frame
	attachFrame.Parent = frame
	local thickness = tPercent * EXTERIOR_RADIUS
	local interior_radius = EXTERIOR_RADIUS - thickness
	local inv_tPercent = 1 - tPercent / 2
	local exCircum = (TAU * EXTERIOR_RADIUS) / subN
	local exTheta = exCircum / EXTERIOR_RADIUS
	local inCircum = (TAU * interior_radius) / subN - GAP
	local inTheta = inCircum / interior_radius
	local edge = Vector2.new(math.cos(inTheta), math.sin(inTheta)) * interior_radius - Vector2.new(interior_radius, 0)
	local edgeLen = math.min(edge.Magnitude / (EXTERIOR_RADIUS * 2), 0.18)
	for i = 0, subN - 1 do
		local vpf = VPF_TEMPLATE:Clone()
		local cam = CAM_TEMPLATE:Clone()
		vpf.CurrentCamera = cam
		vpf.Name = i + 1
		local theta = (i / subN) * TAU + rotation
		local sub = section:Clone()
		pivotAround(sub, CENTER, CENTER * CFrame.fromEulerAnglesXYZ(0, 0, theta + EX_OFFSET))
		sub.Parent = vpf
		local t = theta - EX_OFFSET + exTheta / 2 + G_OFFSET
		local c = -math.cos(t) / 2 * inv_tPercent
		local s = math.sin(t) / 2 * inv_tPercent
		local attach = Instance.new("Frame")
		attach.Name = i + 1
		attach.BackgroundTransparency = 1
		attach.BackgroundColor3 = Color3.new()
		attach.BorderSizePixel = 0
		attach.AnchorPoint = Vector2.new(0.5, 0.5)
		attach.Position = UDim2.new(0.5 + c, 0, 0.5 + s, 0)
		attach.Size = UDim2.new(edgeLen, 0, edgeLen, 0)
		attach.Parent = attachFrame
		cam.Parent = vpf
		vpf.Parent = radialFrame
	end
	section:Destroy()
	local vpf = VPF_TEMPLATE:Clone()
	local cam = CAM_TEMPLATE:Clone()
	vpf.CurrentCamera = cam
	vpf.Name = "RadialDial"
	local g = GAP / (2 * dialEx)
	local off = -TAU / 4 + g
	pivotAround(innerSection, CENTER, CENTER * CFrame.fromEulerAnglesXYZ(0, 0, rotation + off))
	innerSection.Parent = vpf
	vpf.Parent = frame
	frame.BackgroundTransparency = 1
	frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	frame.Size = UDim2.new(1, 0, 1, 0)
	return frame
end

-- Input groups
local GAMEPAD_CLICK = { [Enum.KeyCode.ButtonA] = true }
local MOUSE_GROUP = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseMovement] = true,
	[Enum.UserInputType.Touch] = true,
}
local GAMEPAD_GROUP = {}
for i = 1, 8 do
	GAMEPAD_GROUP[Enum.UserInputType["Gamepad" .. i]] = true
end

local function shortestDist(start, stop)
	local modDiff = (stop - start) % TAU
	local sDist = math.pi - math.abs(math.abs(modDiff) - math.pi)
	if ((modDiff + TAU) % TAU < math.pi) then
		return sDist
	else
		return -sDist
	end
end

-- RadialMenu Class
local RadialMenu = {}
RadialMenu.__index = RadialMenu
RadialMenu.__type = "RadialMenu"

function RadialMenu.new(subN, tPercent, rotation)
	local self = setmetatable({}, RadialMenu)
	self._Maid = newMaid()
	self._ClickedBind = Instance.new("BindableEvent")
	self._HoverBind = Instance.new("BindableEvent")
	self._LastHoverIndex = nil
	self.Frame = createRadial(subN, tPercent or 0.5, rotation or 0)
	self.Rotation = rotation or 0
	self.SubN = subN
	self.Enabled = true
	self.DeadZoneIn = 0.5
	self.DeadZoneOut = math.huge
	self.Clicked = self._ClickedBind.Event
	self.Hover = self._HoverBind.Event
	self:_init()
	self:SetDialProps({ ImageColor3 = Color3.new(0, 0, 0) })
	self:SetRadialProps({
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.7,
	})
	return self
end

function RadialMenu:_init()
	local subN = self.SubN
	local dial = self.Frame.RadialDial
	local inputType = Enum.UserInputType.MouseMovement
	self._Maid:Mark(self._ClickedBind)
	self._Maid:Mark(self._HoverBind)
	self._Maid:Mark(UIS.LastInputTypeChanged:Connect(function(iType)
		if MOUSE_GROUP[iType] or GAMEPAD_GROUP[iType] then
			inputType = iType
		end
	end))
	local lTheta = 0
	self._Maid:Mark(UIS.InputBegan:Connect(function(input, gpe)
		if gpe or not self.Enabled then return end
		if GAMEPAD_GROUP[input.UserInputType] then
			if not GAMEPAD_CLICK[input.KeyCode] then return end
			self._ClickedBind:Fire(self:PickIndex(lTheta))
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local theta = self:GetTheta(Enum.UserInputType.MouseMovement)
			if theta then
				self._ClickedBind:Fire(self:PickIndex(theta))
			end
		end
	end))
	self._Maid:Mark(UIS.TouchEnded:Connect(function(touch, gpe)
		if gpe or not self.Enabled then return end
		if not self:IsVisible() then return end
		if lTheta ~= 0 then
			self._ClickedBind:Fire(self:PickIndex(lTheta))
		end
	end))
	self._Maid:Mark(RUNSERVICE.RenderStepped:Connect(function(dt)
		if not self.Enabled then return end
		local theta = self:GetTheta(inputType)
		if theta and self:IsVisible() then
			lTheta = theta
			local frameRot = math.rad(self.Frame.Rotation)
			local toDeg = math.deg(theta - self.Rotation + frameRot + EX_OFFSET + 2 * TAU) % 360
			local closest = toDeg / (360 / self.SubN) + 0.5
			dial.Rotation = math.deg(self:GetRotation(closest))
			local index = self:PickIndex(theta)
			if index ~= self._LastHoverIndex then
				self._HoverBind:Fire(self._LastHoverIndex, index)
				self._LastHoverIndex = index
			end
		end
	end))
end

function RadialMenu:SetRadialProps(props)
	for _, child in next, self.Frame.Radial:GetChildren() do
		for prop, value in next, props do
			child[prop] = value
		end
	end
end

function RadialMenu:SetDialProps(props)
	local dial = self.Frame.RadialDial
	for prop, value in next, props do
		dial[prop] = value
	end
end

local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled

function RadialMenu:GetTheta(userInputType)
	local delta = nil
	if MOUSE_GROUP[userInputType] then
		local frame = self.Frame
		local radius = frame.AbsoluteSize.y / 2
		local center = frame.AbsolutePosition + frame.AbsoluteSize / 2
		local offset = IS_MOBILE and Vector2.new(0, 0) or Vector2.new(0, -36)
		local mousePos = UIS:GetMouseLocation() + offset
		delta = (mousePos - center) / radius
	elseif GAMEPAD_GROUP[userInputType] then
		local states = UIS:GetGamepadState(userInputType)
		local stateMap = {}
		for _, state in next, states do
			stateMap[state.KeyCode] = state
		end
		local stick = stateMap[Enum.KeyCode.Thumbstick2]
		if stick then
			delta = stick.Position * Vector3.new(1, -1, 1)
		end
	end
	if delta then
		local m = delta.Magnitude
		if m >= self.DeadZoneIn and m <= self.DeadZoneOut then
			return math.atan2(delta.Y, -delta.X)
		end
	end
end

function RadialMenu:PickIndex(theta)
	local frameRot = math.rad(self.Frame.Rotation)
	local toDeg = math.deg(theta - self.Rotation + frameRot + EX_OFFSET + 2 * TAU) % 360
	local closest = math.floor(toDeg / (360 / self.SubN))
	return closest + 1
end

function RadialMenu:GetRotation(index)
	return -TAU * ((index - 1) / self.SubN)
end

function RadialMenu:GetRadial(index)
	return self.Frame.Radial[tostring(index)]
end

function RadialMenu:GetAttachment(index)
	return self.Frame.Attach[tostring(index)]
end

function RadialMenu:IsVisible()
	local frame = self.Frame
	while frame and frame:IsA("GuiObject") and frame.Visible do
		frame = frame.Parent
		if frame and frame:IsA("ScreenGui") and frame.Enabled then
			return true
		end
	end
	return false
end

function RadialMenu:Destroy()
	self._Maid:Sweep()
	if self.Frame then self.Frame:Destroy() end
	self.Clicked = nil
	self.Hover = nil
	self.Frame = nil
end
