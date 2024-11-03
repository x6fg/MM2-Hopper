---todxyz
local UIS = game:GetService("UserInputService")

local library = {}

function library:init(setclip)
	local main = {}	

	local Main = Instance.new("ScreenGui")
	local Container = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local MainCorner = Instance.new("UICorner")
	local SubTitle = Instance.new("TextLabel")
	local List = Instance.new("ScrollingFrame")
	local ListPadding = Instance.new("UIPadding")
	local ListLayout = Instance.new("UIListLayout")
	local ToolTip = Instance.new("TextLabel")
	local Status = Instance.new("TextLabel")
	local ServerHop = Instance.new("TextButton")
	
	Main.Name = "Main"
	Main.Parent = game.CoreGui
	Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Container.Name = "Container"
	Container.Parent = Main
	Container.AnchorPoint = Vector2.new(0.5, 0.5)
	Container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Container.BorderSizePixel = 0
	Container.Position = UDim2.new(0.5, 0, 0.5, 0)
	Container.Size = UDim2.new(0, 400, 0, 270)
	
	local frame = Container
	local dragToggle = nil
	local dragStart = nil
	local startPos = nil
	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		frame.Position = position
	end

	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)

	Title.Name = "Title"
	Title.Parent = Container
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(0, 6, 0, 0)
	Title.Size = UDim2.new(0, 136, 0, 25)
	Title.Font = Enum.Font.GothamMedium
	Title.Text = "Murder Mystery 2"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 18.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	MainCorner.CornerRadius = UDim.new(0, 4)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = Container

	SubTitle.Name = "SubTitle"
	SubTitle.Parent = Container
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SubTitle.BackgroundTransparency = 1.000
	SubTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SubTitle.BorderSizePixel = 0
	SubTitle.Position = UDim2.new(0, 152, 0, 1)
	SubTitle.Size = UDim2.new(0, 142, 0, 25)
	SubTitle.Font = Enum.Font.Gotham
	SubTitle.Text = "beaming util v4"
	SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubTitle.TextSize = 14.000
	SubTitle.TextWrapped = true
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left

	List.Name = "List"
	List.Parent = Container
	List.Active = true
	List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	List.BackgroundTransparency = 0.950
	List.BorderColor3 = Color3.fromRGB(0, 0, 0)
	List.BorderSizePixel = 0
	List.Position = UDim2.new(0, 0, 0.0962962955, 0)
	List.Size = UDim2.new(0, 400, 0, 226)
	List.CanvasSize = UDim2.new(0, 0, 1, 40)
	List.ScrollBarThickness = 0
	
	ListPadding.Name = "ListPadding"
	ListPadding.Parent = List
	ListPadding.PaddingTop = UDim.new(0, 6)

	ListLayout.Name = "ListLayout"
	ListLayout.Parent = List
	ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Padding = UDim.new(0, 4)

	ToolTip.Name = "ToolTip"
	ToolTip.Parent = Container
	ToolTip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToolTip.BackgroundTransparency = 1.000
	ToolTip.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToolTip.BorderSizePixel = 0
	ToolTip.Position = UDim2.new(0, 5, 0, 252)
	ToolTip.Size = UDim2.new(0, 218, 0, 18)
	ToolTip.Font = Enum.Font.Gotham
	ToolTip.Text = "<b>Tip:</b> press a name to copy it"
	ToolTip.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToolTip.TextSize = 12.000
	ToolTip.TextWrapped = true
	ToolTip.TextXAlignment = Enum.TextXAlignment.Left
	ToolTip.RichText = true
	
	Status.Name = "Status"
	Status.Parent = Container
	Status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Status.BackgroundTransparency = 1.000
	Status.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Status.BorderSizePixel = 0
	Status.Position = UDim2.new(0, 158, 0, 252)
	Status.Size = UDim2.new(0, 218, 0, 18)
	Status.Font = Enum.Font.Gotham
	Status.Text = "<b> Status: </b> initializing.."
	Status.TextColor3 = Color3.fromRGB(255, 255, 255)
	Status.TextSize = 12.000
	Status.TextWrapped = true
	Status.TextXAlignment = Enum.TextXAlignment.Left
	Status.RichText = true
	
	ServerHop.Name = "ServerHop"
	ServerHop.Parent = Main
	ServerHop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ServerHop.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ServerHop.BorderSizePixel = 0
	ServerHop.Position = UDim2.new(0.429965168, 0, 0.0339195989, 0)
	ServerHop.Size = UDim2.new(0, 200, 0, 27)
	ServerHop.Font = Enum.Font.SourceSans
	ServerHop.Text = "Server Hop"
	ServerHop.TextColor3 = Color3.fromRGB(0, 0, 0)
	ServerHop.TextSize = 14.000
	
	local newFunction = setclip

	function main:UpdateStatus(status)
		Status.Text = '<b>Status: </b> ' .. status
	end

	function main:AddPlayer(playerName)
		local x = {}
		local playerToAdd = game.Players:FindFirstChild(playerName)
		if playerToAdd then
			local DisplayName = playerToAdd.DisplayName
			local Name = playerToAdd.Name
	
			local NewText = Name .. " (" .. DisplayName .. ")"
			local PlayerExample = Instance.new("TextButton")
			local ExampleCorner = Instance.new("UICorner")
			
			PlayerExample.Name, PlayerExample.Text = NewText, NewText
			PlayerExample.Parent = List
			PlayerExample.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
			PlayerExample.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PlayerExample.BorderSizePixel = 0
			PlayerExample.Size = UDim2.new(1, -6, 0, 25)
			PlayerExample.AutoButtonColor = false
			PlayerExample.Font = Enum.Font.Gotham
			PlayerExample.TextColor3 = Color3.fromRGB(0, 0, 0)
			PlayerExample.TextSize = 14.000

			function x:SetCallback(na)
				PlayerExample.MouseButton1Click:Connect(na)
			end
			
			ExampleCorner.CornerRadius = UDim.new(0, 4)
			ExampleCorner.Name = "ExampleCorner"
			ExampleCorner.Parent = PlayerExample
		end
		return x

	end
	

	function main:ServerHopCallBack(x)
		ServerHop.MouseButton1Click:Connect(x)
	end
	
	return main
end

return library
