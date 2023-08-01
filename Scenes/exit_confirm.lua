local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

-- Set up UI color palette
local uiColorDark = {0.13, 0.13, 0.13}
local uiColorLight = {0.94, 0.94, 0.94}
local uiColorGreenDark = {0.01, 0.15, 0.07}
local uiColorGreenMedium = {0.02, 0.46, 0.22}
local uiColorGreenLight = {0.15, 0.97, 0.52}

-- Sounds variables
local buttonSound

--------------------------------
-- FUNCTIONS BLOCK BEGINS
--------------------------------

-- No button function
local function onNoButton(event)
	
	if(event.phase == "began") then
		
		audio.play(buttonSound)
		
	end
	
	if(event.phase == "ended") then
		
		composer.hideOverlay("slideUp", 500)
		
	end
end

-- Yes button function
local function onYesButton(event)
	
	if(event.phase == "began") then
		
		audio.play(buttonSound)
		
	end
	
	if(event.phase == "ended") then
		
		native.requestExit()
		
	end
end

--------------------------------
-- FUNCTIONS BLOCK ENDS
--------------------------------

-- SCENE:CREATE
function scene:create(event)
	
	-- Create display groups
	local sceneGroup = self.view	
	local uiGroup = display.newGroup()
	local textGroup = display.newGroup()
	-- Insert all display groups into scene group
	sceneGroup:insert(uiGroup)
	sceneGroup:insert(textGroup)
	
	----------------------------------------------------------------------------
	-- INTERFACE BLOCK BEGINS
	----------------------------------------------------------------------------
	
	-- Create background
	local background = display.newRoundedRect(uiGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.6, display.contentHeight * 0.6, 120)
	background:setFillColor(unpack(uiColorGreenDark))
	background:setStrokeColor(unpack(uiColorGreenLight))
	background.strokeWidth = 12
	
	-- Display the question
	local questionText = display.newText(textGroup, "Are you sure you want to exit from the app?", display.contentCenterX, display.contentCenterY - 200, native.systemFont, 50)
	
	-- No button
	local buttonNo = widget.newButton({
		onEvent = onNoButton,
		shape = "roundedRect",
		width = 300,
		height = 120,
		cornerRadius = 60,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 10,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 60
	})
	
	uiGroup:insert(buttonNo)
	buttonNo.x = display.contentCenterX - 300
	buttonNo.y = display.contentCenterY + 200
	buttonNo:setLabel("No")
	
	-- Yes button
	local buttonYes = widget.newButton({
		onEvent = onYesButton,
		shape = "roundedRect",
		width = 300,
		height = 120,
		cornerRadius = 60,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 10,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 60
	})
	
	uiGroup:insert(buttonYes)
	buttonYes.x = display.contentCenterX + 300
	buttonYes.y = display.contentCenterY + 200
	buttonYes:setLabel("Yes")
	
	----------------------------------------------------------------------------
	-- INTERFACE BLOCK ENDS
	----------------------------------------------------------------------------
	
	-- Initialize sounds
	buttonSound = audio.loadSound("Sounds/Button_sound1.wav")
	
end

-- SCENE:SHOW
function scene:show(event)

	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
		-- Runtime:removeEventListener("key", onBackButton)
		
	end
end

-- SCENE:HIDE
function scene:hide(event)

	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
		-- Runtime:removeEventListener("key", onBackButton)
		
	end
end

-- SCENE:DESTROY
function scene:destroy(event)
	
	local sceneGroup = self.view
	audio.dispose(buttonSound)
	
end

-- Add scene event listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene