local composer = require("composer")
local widget = require("widget")
local physics = require("physics")
local scene = composer.newScene()

-- Turning on physics and setting up gravity
physics.start()
physics.setGravity(0, 0)

--------------------------------------------------
-- VARIABLES AND TABLES BLOCK BEGINS
--------------------------------------------------

-- Creating scene groups
local bgGroup
local bactGroup
local uiGroup
local textGroup

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
local gameLoopTimer
local budgetText
local zoomText
local money = 0
local zoom = 1000
local idCount = 0

-- List of all nutrients
local nutrientsList = {}

-- Initializing nutrients and their properties
local nutrient = {} -- nutrient's template
nutrient.id = 0
nutrient.name = ""
nutrient.size = 0 -- radius
nutrient.color = {0.8, 0, 0}

-- List of all bacterias
local bacteriaList = {}

-- Initializing bacteria and their properties
local bact = {} -- bacterium's template
bact.id = 0
bact.genus = ""
bact.species = ""
bact.generation = 1
bact.sizeX = 40
bact.sizeY = 200
bact.color = {0, 0, 0.6}
bact.membraneSize = 6
bact.membraneColor = {0, 0.6, 0}

-- Sounds variables
local buttonSound

--------------------------------------------------
-- VARIABLES AND TABLES BLOCK ENDS
--------------------------------------------------
-- FUNCTIONS BLOCK BEGINS
--------------------------------------------------

-- Back button function
local function onBackButton(event)
	
	if(event.keyName == "back") then
		composer.gotoScene("Scenes.menu")
		return true
	end
end

-- Menu button function
local function onMenuButton(event)
	
	if(event.phase == "began") then
		audio.play(buttonSound)
	end
	
	if(event.phase == "ended") then
		composer.gotoScene("Scenes.menu")
	end
end

-- Plus button function
local function onPlusButton(event)
	
	if(event.phase == "began") then
		audio.play(buttonSound)
	end
	
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
	
	if(event.phase == "began") then
		audio.play(buttonSound)
	end
	
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

-- Nutrients creation function
local function createNewNutrient(name)
	
	-- Displaying the nutrient
	local newNutrient = display.newCircle(bactGroup, math.random(20, display.contentWidth - 20), math.random(20, display.contentHeight - 20), 20)
	table.insert(nutrientsList, newNutrient)
	
	-- Setting physical and graphical properties
	physics.addBody(newNutrient, "dynamic", {density = 2})
	newNutrient:setFillColor(unpack(nutrient.color))
	newNutrient:applyLinearImpulse(math.random(-4, 4), math.random(-4, 4), newNutrient.x, newNutrient.y)
	
	-- Setting nutrient's name
	if(name ~= nil) then
		
		newNutrient.name = name
		
	else
		
		newNutrient.name = "unknown"
		
	end
end

-- Random nutrient name function
local function newNutrientName()
	
	local letters = {"A", "B", "C", "D", "E", "F"}
	local name = letters[math.random(1, 6)]
	
	name = name .. math.random(0, 9)
	name = name .. math.random(0, 9)
	
	return name	
end

-- Bacterium creation function
local function createNewBacterium()
	
	print("\nCreating a new bacterium!\n")
	
	-- Displaying the bacterium
	local newBact = display.newRoundedRect(bactGroup, display.contentCenterX, display.contentCenterY, math.random(20, 60), math.random(100, 240), 10)
	table.insert(bacteriaList, newBact)
	
	-- Setting physical and graphical properties
	physics.addBody(newBact, "dynamic", {density = 6, friction = 0.5, bounce = 0.3})
	newBact.path.radius = newBact.path.width * 0.5
	newBact:setFillColor(unpack(bact.color))
	newBact:setStrokeColor(unpack(bact.membraneColor))
	newBact.strokeWidth = bact.membraneSize
	
	-- Setting id
	newBact.id = idCount
	idCount = idCount + 1
	print("Bacterium's ID: " .. newBact.id)
	
	-- Initializing genus and species
	newBact.genus = genusList[math.random(table.maxn(genusList))]
	newBact.species = speciesList[math.random(table.maxn(speciesList))]
	print("Bacterium's name: " .. newBact.genus .. " " .. newBact.species)
	
	-- Counting generation
	newBact.generation = bact.generation
	bact.generation = bact.generation + 1
	print("Bacterium's generation: " .. newBact.generation)
	
	newBact.angle = 0
	
end

-- Idle moving bacteria function
local function idleMove(bacterium)
	
	timer.performWithDelay(1000, bacterium:setLinearVelocity(0, 0))
	bacterium:rotate(0)

	print("\nbacterium.angle was = " .. bacterium.angle)
	local angle = math.random(-180, 180)
	transition.to(bacterium, {time = 500, onComplete = bacterium:rotate(angle)})
	-- transition.to(bacterium, {time = 500, rotation = angle})
	bacterium.angle = math.abs(math.round(bacterium.rotation) % 360)
	-- 
	-- bacterium.angle = (bacterium.angle + angle) % 360
	print("bacterium.angle is = " .. bacterium.angle)
	
	if(bacterium.angle >= 0 and bacterium.angle < 90) then
		bacterium:setLinearVelocity(bacterium.contentWidth - bacterium.width, -bacterium.contentHeight)
	elseif(bacterium.angle >= 90 and bacterium.angle < 180) then
		bacterium:setLinearVelocity(bacterium.contentWidth - bacterium.width, bacterium.height - bacterium.contentHeight)
	elseif(bacterium.angle >= 180 and bacterium.angle < 270) then
		bacterium:setLinearVelocity(-(bacterium.contentWidth - bacterium.width), bacterium.height - bacterium.contentHeight)
	elseif(bacterium.angle >= 270 and bacterium.angle < 360) then
		bacterium:setLinearVelocity(-(bacterium.contentWidth - bacterium.width), -bacterium.contentHeight)
	end
	
end

-- Game loop function
local function gameLoop()
	
	for i = 1, #bacteriaList, 1 do
	
		local thisBact = bacteriaList[i]
		idleMove(thisBact)
		
	end
	
end

--------------------------------------------------
-- FUNCTIONS BLOCK ENDS
--------------------------------------------------

-- SCENE:CREATE
function scene:create(event)
	
	-- Creating scene display groups
	local sceneGroup = self.view
	bgGroup = display.newGroup()
	bactGroup = display.newGroup()
	uiGroup = display.newGroup()
	textGroup = display.newGroup()
	
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(bactGroup)
	sceneGroup:insert(uiGroup)
	sceneGroup:insert(textGroup)
	
	-- Creating map background
	local map = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	map:setFillColor(unpack(uiColorLight))
	
	-- Creating physical borders
	local borders = display.newLine(bactGroup, 0, 0, display.contentWidth, 0, display.contentWidth, display.contentHeight, 0, display.contentHeight, 0, 0)
	physics.addBody(borders, "static", {friction = 0.5, bounce = 0.3})
	
	local currentNutrient = newNutrientName()
	
	for i = 1, 20, 1 do
		
		createNewNutrient(currentNutrient)
		
	end
	
	createNewBacterium()
	
	--------------------------------------------------
	-- INTERFACE BLOCK BEGINS
	--------------------------------------------------
	
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
		fontSize = 160,
		font = "Tahoma",
		labelYOffset = -11
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
		fontSize = 160,
		font = "Tahoma",
		labelYOffset = -11
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
	
	--------------------------------------------------
	-- INTERFACE BLOCK ENDS
	--------------------------------------------------
	
	-- Initializing sounds
	buttonSound = audio.loadSound("Sounds/Button_sound1.wav")
	
end

-- SCENE:SHOW
function scene:show(event)
	
	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
		Runtime:addEventListener("key", onBackButton)
		gameLoopTimer = timer.performWithDelay(math.random(3000, 6000), gameLoop, 0)
		
	end
end

-- SCENE:HIDE
function scene:hide(event)

	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
		Runtime:removeEventListener("key", onBackButton)
		timer.pause(gameLoopTimer)
		
	end
end

-- SCENE:DESTROY
function scene:destroy(event)
	
	local sceneGroup = self.view
	audio.dispose(buttonSound)
	
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene