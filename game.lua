local composer = require("composer")
local widget = require("widget")
local physics = require("physics")
local scene = composer.newScene()

-- Setting UI color palette
local uiColorDark = {0.13, 0.13, 0.13}
local uiColorLight = {0.94, 0.94, 0.94}
local uiColorGreenDark = {0.01, 0.15, 0.07}
local uiColorGreenMedium = {0.02, 0.46, 0.22}
local uiColorGreenLight = {0.15, 0.97, 0.52}

-- The list of possible genuses
local genusList = {
	"Laferma",
	"Destratus",
	"Lumfocea",
	"Kaladea"	
}

-- The list of possible species
local speciesList = {
	"Simfonicus",
	"Tarseris",
	"Lasista",
	"Pulma",
	"Samonia",
	"Xerodus"
}

-- Creating variables
local budgetText
local zoomText
local money = 0
local zoom = 1000

-- Menu button function
local function onMenuButton(event)
	
	if(event.phase == "ended") then
		composer.gotoScene("menu")
	end
end

-- Plus button function
local function onPlusButton(event)

	if(event.phase == "ended") then
		if(zoom >= 200 and zoom < 1000) then
			zoom = zoom + 100
			zoomText.text = "Zoom: x" .. zoom
		elseif(zoom >= 1000 and zoom < 2000) then
			zoom = zoom + 200
			zoomText.text = "Zoom: x" .. zoom
		end
	end
end

-- Minus button function
local function onMinusButton(event)

	if(event.phase == "ended") then
		if(zoom > 200 and zoom <= 1000) then
			zoom = zoom - 100
			zoomText.text = "Zoom: x" .. zoom
		elseif(zoom > 1000 and zoom <= 2000) then
			zoom = zoom - 200
			zoomText.text = "Zoom: x" .. zoom
		end
	end
end

-- Bacteria creation function
local function createNewBacteria()
	
end

-- SCENE:CREATE
function scene:create(event)
	
	-- Creating scene display groups
	local sceneGroup = self.view
	local bgGroup = display.newGroup()
	local bactGroup = display.newGroup()
	local uiGroup = display.newGroup()
	local textGroup = display.newGroup()
	
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(bactGroup)
	sceneGroup:insert(uiGroup)
	sceneGroup:insert(textGroup)
	
	-- Creating map background
	local map = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	map:setFillColor(unpack(uiColorLight))
	
	--------------------------------
	-- INTERFACE BLOCK BEGINS
	--------------------------------
	
	-- Creating microscope background
	local microscopeBg = display.newImageRect(uiGroup, "Images/Backgrounds/MicroscopeBg.png", 1920, 1080)
	microscopeBg.x = display.contentCenterX
	microscopeBg.y = display.contentCenterY
	
	-- Creating top panel
	local topPanel = display.newRect(uiGroup, display.contentCenterX, 5, display.contentWidth - 10, 120)
	topPanel.anchorX = 0.5
	topPanel.anchorY = 0
	topPanel:setFillColor(unpack(uiColorGreenMedium))
	topPanel:setStrokeColor(unpack(uiColorGreenLight))
	topPanel.strokeWidth = 10
	
	-- Displaying text on the panel
	
	-- Budget string
	budgetText = display.newText(textGroup, "Budget: $" .. money, 40, 65, native.systemFont, 60)
	budgetText.anchorX = 0
	budgetText.anchorY = 0.5
	budgetText:setFillColor(unpack(uiColorLight))
	
	-- Zoom string
	zoomText = display.newText(textGroup, "Zoom: x" .. zoom, display.contentCenterX, 65, native.systemFont, 60)
	zoomText:setFillColor(unpack(uiColorLight))
	
	-- Creating buttons
	
	-- Menu button sheet options
	local menuSheetOptions = {
		width = 120,
		height = 120,
		numFrames = 2,
		border = 1,
		sheetContentWidth = 122,
		sheetContentHeight = 244
	}
	
	-- Menu button image sheet
	local menuButtonSheet = graphics.newImageSheet("Images/Buttons/MenuButtonSheet.png", menuSheetOptions)
	
	-- Menu button
	local menuButton = widget.newButton({
		sheet = menuButtonSheet,
		defaultFrame = 1,
		overFrame = 2,
		onEvent = onMenuButton,
	})
	
	uiGroup:insert(menuButton)
	menuButton.anchorX = 1
	menuButton.anchorY = 0
	menuButton.x = display.contentWidth - 10
	menuButton.y = 5
	
	-- Zoom plus button
	local plusButton = widget.newButton({
		label = "plus_button",
		onEvent = onPlusButton,
		shape = "roundedRect",
		width = 160,
		height = 160,
		cornerRadius = 40,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 12,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 160
	})
	
	uiGroup:insert(plusButton)
	plusButton.x = 240
	plusButton.y = 280
	plusButton:setLabel("+")
	
	
	-- Zoom minus button
	local minusButton = widget.newButton({
		label = "minus_button",
		onEvent = onMinusButton,
		shape = "roundedRect",
		width = 160,
		height = 160,
		cornerRadius = 40,
		fillColor = {default = uiColorGreenMedium, over = uiColorGreenLight},
		strokeColor = {default = uiColorGreenLight, over = uiColorGreenMedium},
		strokeWidth = 12,
		labelColor = {default = uiColorLight, over = uiColorDark},
		fontSize = 160
	})
	
	uiGroup:insert(minusButton)
	minusButton.x = 240
	minusButton.y = 500
	minusButton:setLabel("–")
	
	
	-- Navigational joystick
	
	-- Outer part
	local navJoystickOuter = display.newCircle(uiGroup, 240, display.contentHeight - 240, 160)
	navJoystickOuter:setFillColor(unpack(uiColorGreenDark))
	navJoystickOuter:setStrokeColor(unpack(uiColorGreenLight))
	navJoystickOuter.strokeWidth = 16
	
	-- Inner part
	local navJoystickInner = display.newCircle(uiGroup, 240, display.contentHeight - 240, 80)
	navJoystickInner:setFillColor(unpack(uiColorGreenMedium))
	navJoystickInner:setStrokeColor(unpack(uiColorGreenLight))
	navJoystickInner.strokeWidth = 8
	
	--------------------------------
	-- INTERFACE BLOCK ENDS
	--------------------------------
	
	-- Turning on physics and setting up gravity
	physics.start()
	physics.setGravity(0, 0)
	
	-- List of all bacterias
	local bacteriasList = {}
	
	-- Initializing bacterias and their properties
	local bact = {} -- bacteria's template
	bact.id = 0
	bact.genus = ""
	bact.species = ""
	bact.sizeX = 40
	bact.sizeY = 200
	bact.color = {0, 0, 0}
	
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

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene