-- LENNON HUB V2 - FULL SCRIPT
-- UI Completa + Speed + Jump + Insta Floor + Desync Visual

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LennonHubV2"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 220, 0, 340)
main.Position = UDim2.new(0.5, -110, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", main)
frameStroke.Color = Color3.fromRGB(0,0,0)
frameStroke.Thickness = 1.5
frameStroke.Transparency = 0.15

-- Title
local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "LENNON HUB V2"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Divider
local divider = Instance.new("Frame")
divider.Parent = main
divider.Size = UDim2.new(1, -16, 0, 1)
divider.Position = UDim2.new(0, 8, 0, 32)
divider.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
divider.BorderSizePixel = 0

-- ===== VARIÁVEIS =====
local originalSpeed
local originalJumpPower
local originalJumpHeight

local floorPart
local floorTween
local followConn

local desyncConn
local desyncTime = 0

-- ===== FUNÇÃO TOGGLE =====
local function createToggle(text, size, pos, mode)
	local toggled = false

	local btn = Instance.new("TextButton")
	btn.Parent = main
	btn.Size = size
	btn.Position = pos
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.TextColor3 = Color3.fromRGB(220,220,220)
	btn.BackgroundColor3 = Color3.fromRGB(42,42,42)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(0,0,0)
	stroke.Thickness = 1.3
	stroke.Transparency = 0.1

	btn.MouseButton1Click:Connect(function()
		toggled = not toggled

		-- Visual
		if toggled then
			btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
			btn.TextColor3 = Color3.fromRGB(255,255,255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(42,42,42)
			btn.TextColor3 = Color3.fromRGB(220,220,220)
		end

		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		-- SPEED
		if mode == "speed" and hum then
			if toggled then
				originalSpeed = hum.WalkSpeed
				hum.WalkSpeed = 24
			else
				if originalSpeed then hum.WalkSpeed = originalSpeed end
			end
		end

		-- JUMP+
		if mode == "jump" and hum then
			if toggled then
				originalJumpPower = hum.JumpPower
				originalJumpHeight = hum.JumpHeight
				hum.UseJumpPower = true
				hum.JumpPower = 55
			else
				if originalJumpPower then hum.JumpPower = originalJumpPower end
				if originalJumpHeight then hum.JumpHeight = originalJumpHeight end
			end
		end

		-- INSTA FLOOR
		if mode == "floor" and hrp then
			if toggled then
				floorPart = Instance.new("Part")
				floorPart.Size = Vector3.new(20,1,20)
				floorPart.Anchored = true
				floorPart.CanCollide = true
				floorPart.Material = Enum.Material.Neon
				floorPart.Transparency = 0.4
				floorPart.Color = Color3.fromRGB(0,255,0)
				floorPart.CFrame = hrp.CFrame * CFrame.new(0,-4,0)
				floorPart.Parent = workspace

				followConn = RunService.Heartbeat:Connect(function()
					if floorPart and hrp then
						floorPart.CFrame = CFrame.new(hrp.Position.X, floorPart.Position.Y, hrp.Position.Z)
					end
				end)

				floorTween = TweenService:Create(
					floorPart,
					TweenInfo.new(4, Enum.EasingStyle.Linear),
					{CFrame = floorPart.CFrame * CFrame.new(0,30,0)}
				)
				floorTween:Play()
			else
				if followConn then followConn:Disconnect() end
				if floorTween then floorTween:Cancel() end
				if floorPart then floorPart:Destroy() end
				floorPart = nil
			end
		end

		-- DESYNC VISUAL
		if mode == "desync" and hrp then
			if toggled then
				desyncConn = RunService.RenderStepped:Connect(function(dt)
					desyncTime += dt * 20
					local ox = math.sin(desyncTime) * 0.35
					local oz = math.cos(desyncTime) * 0.35
					local ry = math.sin(desyncTime) * 1.5
					hrp.CFrame = hrp.CFrame * CFrame.new(ox,0,oz) * CFrame.Angles(0,math.rad(ry),0)
				end)
			else
				if desyncConn then desyncConn:Disconnect() end
			end
		end
	end)

	return btn
end

-- ===== BOTÕES =====
createToggle("DEVOURER", UDim2.new(0,105,0,34), UDim2.new(0,8,0,40))
createToggle("NEED AURAS", UDim2.new(0,105,0,34), UDim2.new(0,117,0,40))

createToggle("DESYNC V3", UDim2.new(0,105,0,34), UDim2.new(0,8,0,82), "desync")
createToggle("SPEED", UDim2.new(0,105,0,34), UDim2.new(0,117,0,82), "speed")

createToggle("JUMP+", UDim2.new(0,105,0,34), UDim2.new(0,8,0,124), "jump")
createToggle("INSTA FLOOR", UDim2.new(0,105,0,34), UDim2.new(0,117,0,124), "floor")

createToggle("FLY V2", UDim2.new(0,214,0,42), UDim2.new(0,8,0,170))
