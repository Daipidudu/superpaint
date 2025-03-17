-- Settings --

local color = Color3.fromRGB(255,0,0)

-- Values --

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local provincesFolder = Instance.new("Model")
provincesFolder.Parent = workspace
local highlight = Instance.new("Highlight")
highlight.FillColor = color
highlight.FillTransparency = 0.8
highlight.Parent = workspace
highlight.Adornee = provincesFolder

local UI = Instance.new("ScreenGui",player.PlayerGui)
local UIHolder = Instance.new("Frame",UI)
UIHolder.AnchorPoint = Vector2.new(0.5,0.5)
UIHolder.BackgroundTransparency = 1
UIHolder.Position = UDim2.new(0.5,0,0.5,0)
UIHolder.Size = UDim2.new(0,0,0,0)
local aspectratio = Instance.new("UIAspectRatioConstraint",UIHolder)
local mainFrame = Instance.new("Frame",UIHolder)
mainFrame.BackgroundColor3 = Color3.fromRGB(33,33,42)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.Size = UDim2.new(0.5,0,0.276,0)
mainFrame.Rotation = 359
local topBar = Instance.new("Frame",mainFrame)
topBar.BorderColor3 = Color3.fromRGB(0,0,0)
topBar.BackgroundColor3 = Color3.fromRGB(49,49,64)
topBar.Size = UDim2.new(1,0,0.14,0)
local pss = Instance.new("TextLabel",topBar)
pss.Text = "0 noobs painting/second"
pss.AnchorPoint = Vector2.new(0,0.5)
pss.Size = UDim2.new(0.974,0,0.5,0)
pss.Position = UDim2.new(0,0,0.5,0)
pss.TextColor3 = Color3.fromRGB(255,255,255)
pss.BackgroundTransparency = 1
pss.TextScaled = true
pss.TextXAlignment = Enum.TextXAlignment.Right
local scrollFrame = Instance.new("ScrollingFrame",mainFrame)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0,0,0.14,0)
scrollFrame.Size = UDim2.new(1,0,0.86,0)
scrollFrame.ScrollBarThickness = 0
local panelTitle = Instance.new("TextLabel",topBar)
panelTitle.AnchorPoint = Vector2.new(0,0.5)
panelTitle.BackgroundTransparency = 1
panelTitle.Position = UDim2.new(0.02,0,0.5,0)
panelTitle.Size = UDim2.new(1,0,0.5,0)
panelTitle.Text = '<b>Daips Epic Paint Panel</b><font size="6">🤑</font>'
panelTitle.RichText = true
panelTitle.TextScaled = true
panelTitle.TextColor3 = Color3.fromRGB(255,255,255)
panelTitle.TextXAlignment = Enum.TextXAlignment.Left
local listlayout = Instance.new("UIListLayout",scrollFrame)
listlayout.Padding = UDim.new(0,10)
local uipadding = Instance.new("UIPadding",scrollFrame)
uipadding.PaddingTop = UDim.new(0,10)
uipadding.PaddingLeft = UDim.new(0,10)
uipadding.PaddingRight = UDim.new(0,10)
uipadding.PaddingBottom = UDim.new(0,10)
local doneButton = Instance.new("TextButton",UI)
doneButton.Visible = false
doneButton.AnchorPoint = Vector2.new(0.5,0)
doneButton.BackgroundColor3 = Color3.fromRGB(0,247,159)
doneButton.Position = UDim2.new(0.5,0,0,0)
doneButton.Size = UDim2.new(0.3,0,0.1,0)
doneButton.TextColor3 = Color3.fromRGB(255,255,255)
doneButton.TextScaled = true
doneButton.Text = "Done"
doneButton.AutoButtonColor = false
doneButton.BorderSizePixel = 0
local whiteFrame = Instance.new("Frame",mainFrame)
whiteFrame.Size = UDim2.new(1,0,1,0)
whiteFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4612386227"
sound.Parent = workspace
local changecolor = Instance.new("Sound")
changecolor.SoundId = "rbxassetid://4612383790"
changecolor.Parent = workspace
local sound2 = Instance.new("Sound")
sound2.SoundId = "rbxassetid://7486747911"
sound2.Parent = workspace
sound2.PlaybackSpeed = 2
local provinceSound = Instance.new("Sound")
provinceSound.SoundId = "rbxassetid://5694665239"
provinceSound.Parent = workspace

local provinces = {}

local provincespersecond = 0
local pps = 0

local selectColorMode = false
local removeProvincesMode = false
local selectProvincesMode = false
local safeMode = false
local newpaint = false
local painting = true
local keepTerColor = false

local provinceCodeGenerator = 0

local dragging
local dragInput
local dragStart
local startPos

-- Functions --

local function paintProvinceLoop(province, coro, highlighty)
	local savedColor = color
	local db = true
	local event = runService.Stepped:Connect(function()
		if db and painting then
			if newpaint == false or safeMode then
				db = false
			end
			if pps <= 1000 then
				if player.Character:FindFirstChild("PaintBucket") then
					if province.Color ~= color and keepTerColor == false or keepTerColor == true and province.Color ~= savedColor then
						local args = {
							[1] = "PaintPart",
							[2] = {
								["Part"] = province,
								["Color"] = color
							},
							[3] = "Peace"
						}
						if keepTerColor then
							args = {
								[1] = "PaintPart",
								[2] = {
									["Part"] = province,
									["Color"] = savedColor
								},
								[3] = "Peace"
							}
						end
						provincespersecond = provincespersecond + 1
						game:GetService("Players").LocalPlayer.Character.PaintBucket.Remotes.ServerControls:InvokeServer(unpack(args))
					end
				end
				if safeMode then
					wait(1)
				elseif newpaint then
					wait(3)
				end
			end
			db = true
		end
	end)
	local provinceInfo = {
		["Province"] = province,
		["Coroutine"] = coro,
		["Event"] = event,
		["Highlight"] = highlighty
	}
	table.insert(provinces, provinceInfo)
	provinceCodeGenerator += 1
end

local function createNewOption(optionType, text, customText, enabled)
	local optionFrame = Instance.new("Frame",scrollFrame)
	optionFrame.BorderColor3 = Color3.fromRGB(0,0,0)
	optionFrame.BackgroundColor3 = Color3.fromRGB(49, 49, 64)
	optionFrame.Size = UDim2.new(1,0,0.075,0)
	optionFrame.Parent = scrollFrame
	local textlabel = Instance.new("TextLabel",optionFrame)
	textlabel.BackgroundTransparency = 1
	textlabel.Position = UDim2.new(0.02,0,0.2,0)
	textlabel.Size = UDim2.new(1,0,0.6,0)
	textlabel.TextScaled = true
	textlabel.Text = text
	textlabel.Font = Enum.Font.SourceSansBold
	textlabel.TextColor3 = Color3.fromRGB(255,255,255)
	textlabel.TextXAlignment = Enum.TextXAlignment.Left
	if optionType == "switch" then
		local switchFrame = Instance.new("Frame",optionFrame)
		switchFrame.BackgroundColor3 = Color3.fromRGB(241, 33, 103)
		switchFrame.Position = UDim2.new(0.865,0,0.125,0)
		switchFrame.Size = UDim2.new(0.125,0,0.75,0)
		switchFrame.BorderSizePixel = 0
		local switch = Instance.new("ImageButton",switchFrame)
		switch.AutoButtonColor = false
		switch.BorderSizePixel = 0
		switch.Size = UDim2.new(1,0,1,0)
		switch.BackgroundColor3 = Color3.fromRGB(255,255,255)
		local aspectRatio = Instance.new("UIAspectRatioConstraint",switch)
		if enabled then
			tweenService:Create(switch.Parent,TweenInfo.new(0.1),{BackgroundColor3 = Color3.fromRGB(53, 227, 153)}):Play()
			tweenService:Create(switch,TweenInfo.new(0.1),{Position = UDim2.new(1,0,0,0)}):Play()
			tweenService:Create(switch,TweenInfo.new(0.1),{AnchorPoint = Vector2.new(1,0)}):Play()
		end
		return switch
	elseif optionType == "color" then
		local colorButton = Instance.new("ImageButton",optionFrame)
		colorButton.Position = UDim2.new(0.928,0,0.125,0)
		colorButton.AutoButtonColor = false
		colorButton.Size = UDim2.new(0.062,0,0.75,0)
		return colorButton
	elseif optionType == "custom" then
		local button = Instance.new("ImageButton",optionFrame)
		button.BackgroundColor3 = Color3.fromRGB(100,100,100)
		button.Position = UDim2.new(0.865,0,0.125,0)
		button.Size = UDim2.new(0.125,0,0.75,0)
		button.AutoButtonColor = false
		local textlabel = Instance.new("TextLabel",button)
		textlabel.BackgroundTransparency = 1
		textlabel.Position = UDim2.new(0.5,0,0.5,0)
		textlabel.AnchorPoint = Vector2.new(0.5,0.5)
		textlabel.Size = UDim2.new(0.8,0,0.8,0)
		textlabel.Text = customText
		textlabel.TextScaled = true
		textlabel.Font = Enum.Font.SourceSansBold
		textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		return button
	end
end

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Script --

wait(1)

sound:Play()

if userInputService
