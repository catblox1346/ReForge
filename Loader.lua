-- The Forge Script Beta 1.0.0


-- Key System
local KEY_URL = "https://ads.luarmor.net/get_key?for=BoatBuilderHub_Key_System-FxZfyDCbapNR"

local folderName, fileName = "ReForgeConfigs", "Settings.config"
local filePath = folderName .. "/" .. fileName

if not isfolder(folderName) then
	makefolder(folderName)
end

do
	local savedKey
	if isfile(filePath) then
		local ok, content = pcall(readfile, filePath)
		if ok and content and content ~= "" then
			savedKey = content:gsub("%s+", "")
		end
	end
	if savedKey then
		local ok = pcall(function()
			script_key = savedKey
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0bef79fe69ee3fe8607ff9f07f2d8def.lua"))()
		end)
		if ok then return end
	end
end

local reguiSrc = game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua")
local ReGui = loadstring(reguiSrc)()

local win = ReGui:Window({ Title = "Key System", NoClose = true, NoResize = true, Size = UDim2.new(0, 350, 0, 250) }):Center()
_G.KeyWindow = win

local keyText = ""
local busy = false

win:Label({ Text = "🔒 Script Locked", TextScaled = false, TextSize = 20, Size = UDim2.new(1, 0, 0, 30) })
win:Separator()
win:Label({ Text = "Please enter your key to access the script:", TextWrapped = true })

win:InputText({
	Label = "Key",
	Placeholder = "Enter key here...",
	Callback = function(_, text)
		keyText = text
	end,
})

local statusLbl = win:Label({ Text = "", TextColor3 = Color3.fromRGB(255, 30, 30) })
local function setStatus(t, ok)
	statusLbl.Text = t
	statusLbl.TextColor3 = ok and Color3.fromRGB(30, 255, 30) or Color3.fromRGB(255, 30, 30)
end

win:Button({
	Text = "Copy Key Link",
	Size = UDim2.new(1, 0, 0, 20),
	BackgroundColor3 = Color3.fromRGB(255, 165, 30),
	Callback = function()
		setclipboard(KEY_URL)
		setStatus("Key link copied to clipboard!", true)
	end,
})

local row = win:Row({ Expanded = true })
local submitBtn

submitBtn = row:Button({
	Text = "Submit",
	BackgroundColor3 = Color3.fromRGB(30, 255, 30),
	Callback = function()
		if busy or keyText == "" then return end
		busy = true
		submitBtn.Text = "CHECKING..."
		statusLbl.Text = ""
		task.spawn(function()
			local cleaned = keyText:gsub("%s+", "")
			local ok = pcall(function()
				script_key = cleaned
				loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0bef79fe69ee3fe8607ff9f07f2d8def.lua"))()
			end)
			if ok then
				pcall(writefile, filePath, cleaned)
			else
				setStatus("Invalid key or error", false)
			end
			submitBtn.Text = "Submit"
			busy = false
		end)
	end,
})

row:Button({
	Text = "Need Help?",
	BackgroundColor3 = Color3.fromRGB(30, 255, 255),
	Callback = function()
		local p = win:PopupModal({ Title = "Need Help?", AutoSize = "Y", Visible = true })
		p:Label({ Text = "How to get your key:", TextScaled = false, TextSize = 16 })
		p:Separator()
		p:Label({ Text = "1. Click 'Copy Key Link'.\n2. Open it and complete the steps.\n3. Paste the key here and press 'Submit'.", TextWrapped = true })
		p:Separator()
		p:Label({ Text = "For bugs/further help open a ticket in the discord", TextWrapped = true })
		p:Separator()
		local r = p:Row({ Expanded = true })
		r:Button({
			Text = "Copy Discord Link",
			BackgroundColor3 = Color3.fromRGB(255, 30, 30),
			Callback = function()
				setclipboard("https://discord.gg/mAmR6kz3QH")
				setStatus("Discord link copied to clipboard!", true)
			end,
		})
		p:Separator()
		p:Button({
			Text = "Close",
			Callback = function()
				p:ClosePopup()
			end,
		})
	end,
})
