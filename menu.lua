local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

-- Setting UI color palette
local uiColorDark = {0.13, 0.13, 0.13}
local uiColorLight = {0.94, 0.94, 0.94}
local uiColorGreenDark = {0.01, 0.15, 0.07}
local uiColorGreenMedium = {0.02, 0.46, 0.22}
local uiColorGreenLight = {0.15, 0.97, 0.52}

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
	
	-- Creating buttons
	local buttonExit = widget.newButton({
		label = "exit_button",
		onEvent = onExitButton,
		shape = "roundedRect",
		width = 300,
		height = 80,
		cornerRadius = 20,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenMedium},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 8,
		labelColor = {default = uiColorLight},
		fontSize = 36
		
	})
	
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