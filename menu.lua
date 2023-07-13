local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

-- Setting UI color palette
local uiColorDark = {0.13, 0.13, 0.13}
local uiColorLight = {0.94, 0.94, 0.94}
local uiColorGreenDark = {0.01, 0.15, 0.07}
local uiColorGreenMedium = {0.02, 0.46, 0.22}
local uiColorGreenLight = {0.15, 0.97, 0.52}

-- Play button function
local function onPlayButton(event)
	if(event.phase == "ended") then
		composer.gotoScene("simulation")
	end
end

-- Settings button function
local function onSettingsButton(event)
	if(event.phase == "ended") then
		composer.gotoScene("settings")
	end
end

-- Exit button function
local function onExitButton(event)
	if(event.phase == "ended") then
		native.requestExit()
	end
end

-- SCENE:CREATE
function scene:create(event)

	local sceneGroup = self.view
	local uiGroup = display.newGroup()
	local textGroup = display.newGroup()
	sceneGroup:insert(uiGroup)
	sceneGroup:insert(textGroup)
	
	-- Creating background
	local background = display.newRect(uiGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	background:setFillColor(unpack(uiColorDark))
	
	-- Displaying the game title
	local titleText = display.newText(textGroup, "Bacteriomatics", display.contentCenterX, display.contentHeight - 900, native.systemFontBold, 120)
	titleText:setFillColor(unpack(uiColorLight))
	
	-- Displaying the game version
	local versionText = display.newText(textGroup, "Version: v" .. system.getInfo("appVersionString"), display.contentWidth - 160, display.contentHeight - 20, native.systemFontBold, 30)
	versionText:setFillColor(unpack(uiColorLight), 0.5)
	
	-- Creating buttons
	
	-- Play button
	local buttonPlay = widget.newButton({
		label = "play_button",
		onEvent = onPlayButton,
		shape = "roundedRect",
		width = 500,
		height = 120,
		cornerRadius = 60,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 16,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 60
	})
	
	uiGroup:insert(buttonPlay)
	buttonPlay.x = display.contentCenterX
	buttonPlay.y = display.contentHeight - 600
	buttonPlay:setLabel("Play")
	
	-- Settings button
	local buttonSettings = widget.newButton({
		label = "settings_button",
		onEvent = onSettingsButton,
		shape = "roundedRect",
		width = 500,
		height = 120,
		cornerRadius = 60,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 16,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 60
	})
	
	uiGroup:insert(buttonSettings)
	buttonSettings.x = display.contentCenterX
	buttonSettings.y = display.contentHeight - 400
	buttonSettings:setLabel("Settings")
	
	-- Exit button
	local buttonExit = widget.newButton({
		label = "exit_button",
		onEvent = onExitButton,
		shape = "roundedRect",
		width = 500,
		height = 120,
		cornerRadius = 60,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 16,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 60
	})
	
	uiGroup:insert(buttonExit)
	buttonExit.x = display.contentCenterX
	buttonExit.y = display.contentHeight - 200
	buttonExit:setLabel("Exit")
	
end

-- SCENE:SHOW
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
	end
end

-- SCENE:HIDE
function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
	end
end

-- SCENE:DESTROY
function scene:destroy(event)
	local sceneGroup = self.view

end

-- Adding scene event listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene