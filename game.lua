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

local money = 0
local zoom = 1000

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
	
	-- Creating map background
	local map = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	map:setFillColor(unpack(uiColorLight))
	
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
	local budgetText = display.newText(textGroup, "Budget: $" .. money, 40, 65, native.systemFont, 60)
	budgetText.anchorX = 0
	budgetText.anchorY = 0.5
	budgetText:setFillColor(unpack(uiColorLight))
	
	-- Zoom string
	local zoomText = display.newText(textGroup, "Zoom: x" .. zoom, display.contentCenterX, 65, native.systemFont, 60)
	zoomText:setFillColor(unpack(uiColorLight))
	
	-- Creating buttons
	
	-- Zoom stepper
	local stepperOptions = {
		
		width = 100,
		height = 200,
		numFrames = 5,
		sheetContentWidth = 500,
		sheetContentHeight = 200
	}
	
	local stepperSheet = graphics.newImageSheet("Images/Buttons/StepperSheet.png", stepperOptions)
	
	local newStepper = widget.newStepper({
		x = 150,
		y = 300,
        sheet = stepperSheet,
        defaultFrame = 1,
        noMinusFrame = 3,
        noPlusFrame = 4,
        minusActiveFrame = 2,
        plusActiveFrame = 5,
        -- onPress = onStepperPress
    })
	newStepper:rotate(0)
	
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