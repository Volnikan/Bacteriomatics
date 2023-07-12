local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

-- Setting UI color palette
local uiColorDark = {0.13, 0.13, 0.13}
local uiColorLight = {0.94, 0.94, 0.94}
local uiColorGreenDark = {0.01, 0.15, 0.07}
local uiColorGreenMedium = {0.02, 0.46, 0.22}
local uiColorGreenLight = {0.15, 0.97, 0.52}

-- Back button function
local function onBackButton(event)
	if(event.phase == "ended") then
		composer.gotoScene("menu")
	end
end

-- SCENE:CREATE
function scene:create(event)
	
	-- Creating and adjusting groups
	local sceneGroup = self.view
	local bgGroup = display.newGroup()
	local uiGroup = display.newGroup()
	local textGroup = display.newGroup()
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(uiGroup)
	sceneGroup:insert(textGroup)
	
	-- Creating background
	local background = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	background:setFillColor(unpack(uiColorDark))
	
	-- Displaying settings
	
	-- Language settings
	local languageText = display.newText(textGroup, "Language: ", 120, 120, native.systemFontBold, 60)
	languageText.anchorX = 0
	languageText.anchorY = 0.5
	languageText:setFillColor(unpack(uiColorLight))
	
	-- Music volume settings
	local musicVolumeText = display.newText(textGroup, "Music Volume: ", 120, 320, native.systemFontBold, 60)
	musicVolumeText.anchorX = 0
	musicVolumeText.anchorY = 0.5
	languageText:setFillColor(unpack(uiColorLight))
	
	local musicSlider = widget.newSlider(
		{
			x = display.contentWidth - 600,
			y = 320,
			width = 800,
			value = 50
		}
	)
	
	uiGroup:insert(musicSlider)
	musicSlider.anchorX = 1
	musicSlider.anchorY = 0.5
	
	-- Sound volume settings
	local soundMusicText = display.newText(textGroup, "Sound Volume: ", 120, 520, native.systemFontBold, 60)
	soundMusicText.anchorX = 0
	soundMusicText.anchorY = 0.5
	languageText:setFillColor(unpack(uiColorLight))
	
	local soundSlider = widget.newSlider(
		{
			x = display.contentWidth - 600,
			y = 520,
			width = 800,
			value = 50
		}
	)
	
	uiGroup:insert(soundSlider)
	soundSlider.anchorX = 1
	soundSlider.anchorY = 0.5
	
	
	
	
	-- Creating buttons
	
	-- Back button
	local buttonBack = widget.newButton({
		label = "back_button",
		onEvent = onBackButton,
		shape = "roundedRect",
		width = 300,
		height = 120,
		cornerRadius = 60,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 16,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 60
	})
	
	uiGroup:insert(buttonBack)
	buttonBack.anchorX = 0
	buttonBack.anchorY = 0.5
	buttonBack.x = 120
	buttonBack.y = display.contentHeight - 120
	buttonBack:setLabel("Back")
	
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