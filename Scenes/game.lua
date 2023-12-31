local composer = require("composer")
local physics = require("physics")
local widget = require("widget")
local scene = composer.newScene()

-- Turn on physics and set up gravity
physics.start()
physics.setGravity(0, 0)

--------------------------------------------------------------------------------
-- VARIABLES AND TABLES BLOCK BEGINS
--------------------------------------------------------------------------------

-- Create scene groups
local bgGroup
local bactGroup
local uiGroup
local textGroup

-- Set up UI color palette
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

-- Create variables
local gameLoopTimer
local budgetText
local zoomText
local money = 0
local zoom = 1000
local idCount = 0
-- local borders
local navJoystickInner
local currentNutrient = ""
local nutrientsQuantity = 20
local currentNutrientsQuantity = 0
local wallsWidth = 2000
local wallsHeight = 2000

-- List of all nutrients
local nutrientsList = {}

-- Initialize nutrients and their properties
local nutrient = {} -- nutrient's template
nutrient.id = 0
nutrient.name = ""
nutrient.size = 0 -- radius
nutrient.color = {0.8, 0, 0}

-- List of all bacterias
local bacteriaList = {}

-- Initialize fundamental bacteria properties
local globalBact = {} -- bacterium's template
globalBact.genus = genusList[math.random(table.maxn(genusList))]
globalBact.species = speciesList[math.random(table.maxn(speciesList))]
globalBact.sizeX = math.random(20, 60)
globalBact.sizeY = math.random(100, 240)
globalBact.color = {0, 0, 0.6}
globalBact.membraneSize = 6
globalBact.membraneColor = {0, 0.6, 0}

-- Sounds variables
local buttonSound

--------------------------------------------------------------------------------
-- VARIABLES AND TABLES BLOCK ENDS
--------------------------------------------------------------------------------
-- FUNCTIONS BLOCK BEGINS
--------------------------------------------------------------------------------

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
			bactGroup.xScale = bactGroup.xScale + 0.1
			bactGroup.yScale = bactGroup.yScale + 0.1
			-- bactGroup.x = bactGroup.x * 1.1
			-- bactGroup.y = bactGroup.y * bactGroup.yScale
		elseif(zoom >= 1000 and zoom < 2000) then
			zoom = zoom + 200
			zoomText.text = "Zoom: x" .. zoom
			bactGroup.xScale = bactGroup.xScale + 0.2
			bactGroup.yScale = bactGroup.yScale + 0.2
			-- bactGroup.x = bactGroup.x * 1.2
			-- bactGroup.y = bactGroup.y * bactGroup.yScale
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
			bactGroup.xScale = bactGroup.xScale - 0.1
			bactGroup.yScale = bactGroup.yScale - 0.1
			-- bactGroup.x = bactGroup.x * bactGroup.xScale
			-- bactGroup.y = bactGroup.y * bactGroup.yScale
		elseif(zoom > 1000 and zoom <= 2000) then
			zoom = zoom - 200
			zoomText.text = "Zoom: x" .. zoom
			bactGroup.xScale = bactGroup.xScale - 0.2
			bactGroup.yScale = bactGroup.yScale - 0.2
			-- bactGroup.x = bactGroup.x * bactGroup.xScale
			-- bactGroup.y = bactGroup.y * bactGroup.yScale
		end
	end
end

-- Nutrients creation function
local function createNewNutrient(name)
	
	-- Display the nutrient
	local newNutrient = display.newCircle(bactGroup, math.random(wallLeft.x + 20, wallRight.x - 20), math.random(wallTop.y + 20, wallBottom.y - 20), 20)
	table.insert(nutrientsList, newNutrient)
	
	-- Set up physical and graphical properties
	physics.addBody(newNutrient, "dynamic", {density = 2})
	newNutrient:setFillColor(unpack(nutrient.color))
	newNutrient.alpha = 0
	newNutrient:applyLinearImpulse(math.random(-4, 4), math.random(-4, 4), newNutrient.x, newNutrient.y)
	transition.to(newNutrient, {time = 4000, alpha = 1})
	
	-- Set label
	newNutrient.label = "nutrient"
	
	-- Set nutrient's food value
	newNutrient.foodValue = 50
	
	-- Set nutrient's name
	if(name ~= nil) then newNutrient.name = name
	else newNutrient.name = "unknown" end
	
end

-- Balance nutrients quantity function
local function balanceNutrientsQuantity()
	
	if(currentNutrientsQuantity < nutrientsQuantity) then
		
		currentNutrientsQuantity = currentNutrientsQuantity + 1
		timer.performWithDelay(10000, createNewNutrient)
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
local function createNewBacterium(coordinateX, coordinateY, childRotation, genNum)
	
	print("\nCreating a new bacterium!\n")
	
	-- Display the bacterium
	local newBact = display.newRoundedRect(bactGroup, coordinateX, coordinateY, globalBact.sizeX, globalBact.sizeY, 10)
	table.insert(bacteriaList, newBact)
	
	-- Set up physical and graphical properties
	physics.addBody(newBact, "dynamic", {density = 6, friction = 0.5, bounce = 0.3})
	newBact.path.radius = newBact.path.width * 0.5
	newBact:setFillColor(unpack(globalBact.color))
	newBact:setStrokeColor(unpack(globalBact.membraneColor))
	newBact.strokeWidth = globalBact.membraneSize
	newBact.alpha = 0
	transition.to(newBact, {time = 4000, alpha = 1})
	newBact.angle = childRotation
	newBact.rotation = newBact.angle
	
	-- Set id and label
	newBact.id = idCount
	idCount = idCount + 1
	newBact.label = "bacterium"
	print("Bacterium's ID: " .. newBact.id)
	
	-- Initialize genus and species
	newBact.genus = globalBact.genus
	newBact.species = globalBact.species
	print("Bacterium's name: " .. newBact.genus .. " " .. newBact.species)
	
	-- Count generation
	newBact.generation = genNum + 1
	newBact.isReproducing = false
	newBact.wasBorn = math.round(system.getTimer())
	newBact.reproductionTime = math.random(60000, 120000)
	print("Bacterium's generation: " .. newBact.generation)
	
	-- Food parameters: radius of view, satiety, the last time of satiety reduction, hunger speed
	newBact.foodRadius = 400
	newBact.satiety = 100
	newBact.reductionTime = math.round(system.getTimer())
	newBact.hungerSpeed = 500
	
end

-- The function checking if a bacterium is close to a wall
local function isCloseToWall(bact)
	
	if(bact.x - bactGroup.x < 30) then return true
	elseif(bact.y - bactGroup.y < 30) then return true
	elseif(bactGroup.x + bactGroup.contentWidth - bact.x < 30) then return true
	elseif(bactGroup.y + bactGroup.contentHeight - bact.y < 30) then return true
	else return false end
	
end

-- Avoid walls function
local function avoidWalls(bact, wall)
	
	if(wall == wallTop) then
		
		transition.to(bact, {time = 200, rotation = 180})
		bact:setLinearVelocity(0, 30)
		
	elseif(wall == wallLeft) then
		
		transition.to(bact, {time = 200, rotation = 90})
		bact:setLinearVelocity(30, 0)
		
	elseif(wall == wallRight) then
		
		transition.to(bact, {time = 200, rotation = 270})
		bact:setLinearVelocity(-30, 0)
		
	elseif(wall == wallBottom) then
		
		transition.to(bact, {time = 200, rotation = 0})
		bact:setLinearVelocity(0, -30)
		
	end
end

-- Idle moving bacteria function
local function idleMove(bacterium)
	
	-- transition.to(bacterium, {delta = true, delay = 1000, time = 500, x = 0, y = 0})
	-- timer.performWithDelay(1000, bacterium:setLinearVelocity(0, 0))
	bacterium:rotate(0)

	local angle = math.random(-30, 30)
	transition.to(bacterium, {delta = true, delay = 200, time = 500, rotation = angle})
	bacterium.angle = math.abs(math.round(bacterium.rotation + 360) % 360)
	
	if(bacterium.angle >= 0 and bacterium.angle < 90) then
		bacterium:setLinearVelocity(bacterium.contentWidth - bacterium.width, -bacterium.contentHeight)
	elseif(bacterium.angle >= 90 and bacterium.angle < 180) then
		bacterium:setLinearVelocity(bacterium.contentWidth - bacterium.width, bacterium.height - bacterium.contentHeight)
	elseif(bacterium.angle >= 180 and bacterium.angle < 270) then
		bacterium:setLinearVelocity(-(bacterium.contentWidth - bacterium.width), bacterium.height - bacterium.contentHeight)
	elseif(bacterium.angle >= 270 and bacterium.angle < 360) then
		bacterium:setLinearVelocity(-(bacterium.contentWidth - bacterium.width), -bacterium.contentHeight)
	end
	
	-- if(isCloseToWall(bacterium)) then avoidWalls(bacterium) end
	
end

-- A bacterium's decision making function
local function shouldIMove(bact)
	
	local chance = math.random(1, 30)
	if(chance == 1) then idleMove(bact) end
	
end

-- Dying bacterium function
local function death(deadBacterium)
	
	display.remove(deadBacterium)
	for i = 1, #bacteriaList, 1 do
		
		if(bacteriaList[i] == deadBacterium) then
			table.remove(bacteriaList, i)
			break
		end
	end	
end

-- Bacteria duplication function
local function duplicateBacterium(parentBact)
	
	parentBact:setLinearVelocity(0, 0) -- Stop the parent bacterium
	parentBact:rotate(0) -- Stop rotation
	-- Stretch the bacterium in length
	transition.to(parentBact, {time = 4000, delta = true, height = 300})
	
	-- Count new coordinates and rotation
	-- 1-st child
	local child_1_X = parentBact.x - parentBact.contentWidth * 0.5
	local child_1_Y = parentBact.y - parentBact.contentHeight * 0.5
	local child_1_Rotation = parentBact.rotation
	-- 2-nd child
	local child_2_X = parentBact.x + parentBact.contentWidth * 0.5
	local child_2_Y = parentBact.y + parentBact.contentHeight * 0.5
	local child_2_Rotation = parentBact.rotation
	
	transition.to(parentBact, {delay = 4000, time = 4000, alpha = 0, onComplete = death(parentBact)})
	
	createNewBacterium(child_1_X, child_1_Y, child_1_Rotation, parentBact.generation)
	createNewBacterium(child_2_X, child_2_Y, child_2_Rotation, parentBact.generation)
	
end

-- Bacterium eats a nutrient function
local function bacteriumEats(bact, nutr)
	
	display.remove(nutr)
	for i = 1, #nutrientsList, 1 do
		if(nutrientsList[i] == nutr) then
			table.remove(nutrientsList, i)
			break
		end
	end
	bact.satiety = bact.satiety + nutr.foodValue
	currentNutrientsQuantity = currentNutrientsQuantity - 1
	
end

-- Decrease satiety function
local function decreaseSatiety(bact)
		
		if(system.getTimer() - bact.reductionTime >= bact.hungerSpeed) then
			
			bact.satiety = bact.satiety - 1
			bact.reductionTime = math.round(system.getTimer())
			
		end
end

-- The function checking if a bacterium is ready to reproduce
local function isReadyToReproduce(bact)
	
	if(system.getTimer() - bact.wasBorn >= bact.reproductionTime and bact.isReproducing == false) then
		
		bact.isReproducing = true
		duplicateBacterium(bact)
		
	end	
end

-- Create walls function
local function createWalls(lengthHorizontal, lengthVertical)
	
	-- Top wall
	wallTop = display.newRect(bactGroup, wallsWidth * 0.5, 0, lengthHorizontal, 10)
	wallTop:setFillColor(0, 0, 0)
	physics.addBody(wallTop, "static", {friction = 0.5, bounce = 0.3})
	wallTop.label = "wall_top"
	
	-- Left wall
	wallLeft = display.newRect(bactGroup, 0, wallsHeight * 0.5, 10, lengthVertical)
	wallLeft:setFillColor(0, 0, 0)
	physics.addBody(wallLeft, "static", {friction = 0.5, bounce = 0.3})
	wallLeft.label = "wall_left"
	
	-- Right wall
	wallRight = display.newRect(bactGroup, wallsWidth, wallsHeight * 0.5, 10, lengthVertical)
	wallRight:setFillColor(0, 0, 0)
	physics.addBody(wallRight, "static", {friction = 0.5, bounce = 0.3})
	wallRight.label = "wall_right"
	
	-- Bottom wall
	wallBottom = display.newRect(bactGroup, wallsWidth * 0.5, wallsHeight, lengthHorizontal, 10)
	wallBottom:setFillColor(0, 0, 0)
	physics.addBody(wallBottom, "static", {friction = 0.5, bounce = 0.3})
	wallBottom.label = "wall_bottom"
	
end

-- Camera movement function
local function moveCamera()
	
	bactGroup.x = bactGroup.x - (navJoystickInner.x - 240) * 0.2
	bactGroup.y = bactGroup.y - (navJoystickInner.y - display.contentHeight + 240) * 0.2
	
	if(bactGroup.y > wallsHeight * 0.5 - 400) then -- top border
		bactGroup.y = wallsHeight * 0.5 - 400
	end
	if(bactGroup.x > wallsWidth * 0.5) then -- left border
		bactGroup.x = wallsWidth * 0.5
	end
	if(bactGroup.x < wallsWidth * 0.5 - wallTop.contentWidth) then -- right border
		bactGroup.x = wallsWidth * 0.5 - wallTop.contentWidth
	end
	if(bactGroup.y < wallsHeight * 0.5 - wallLeft.contentHeight - 400) then -- bottom border
		bactGroup.y = wallsHeight * 0.5 - wallLeft.contentHeight - 400
	end
	
end

-- Navigational joystick function
local function onNavJoystick(event)
	
	if(event.phase == "moved") then
		
		navJoystickInner.x = event.x
		navJoystickInner.y = event.y
		
	elseif(event.phase == "ended" or event.phase == "cancelled") then
		
		navJoystickInner.x = 240
		navJoystickInner.y = display.contentHeight - 240
		
	end
	
	if(math.sqrt((navJoystickInner.x - 240)^2 + (navJoystickInner.y - display.contentHeight + 240)^2) > 100) then
		
		navJoystickInner.x = 240
		navJoystickInner.y = display.contentHeight - 240
		
	end
end

-- Global collision function
local function onGlobalCollision(event)
	
	local obj_1 = event.object1
	local obj_2 = event.object2
	
	-- Bacterium eats a nutrient
	if(obj_1.label == "bacterium" and obj_2.label == "nutrient" and obj_1.satiety < 50) then
		
		bacteriumEats(obj_1, obj_2)
	
	elseif(obj_1.label == "nutrient" and obj_2.label == "bacterium" and obj_2.satiety < 50) then
		
		bacteriumEats(obj_2, obj_1)
	
	-- Handle wall collisions
	elseif(string.starts(obj_1.label, "wall") and obj_2.label == "bacterium") then
		
		avoidWalls(obj_2, obj_1)
		-- obj_2:rotate(90)
		-- transition.to(obj_2, {delta = true, time = 200, rotation = math.random(-1, 1) * 90})
		-- idleMove(obj_2)
		
	elseif(obj_1.label == "bacterium" and string.starts(obj_2.label, "wall")) then
		
		avoidWalls(obj_1, obj_2)
		-- obj_1:rotate(90)
		-- transition.to(obj_1, {delta = true, time = 200, rotation = math.random(-1, 1) * 90})
		-- idleMove(obj_1)
		
	end
end

-- Game loop function
local function gameLoop()
	
	for i = 1, #bacteriaList, 1 do -- Run through all bacteria
		
		if(bacteriaList[i]) then
			
			-- Decrease satiety
			decreaseSatiety(bacteriaList[i])
			
			-- Check if a bacterium is ready for reproduction
			isReadyToReproduce(bacteriaList[i])
			
			-- if a bacteria is hungry, search for food, if it's nearby or move wherever
			if(bacteriaList[i].satiety > 0 and bacteriaList[i].satiety < 50 and bacteriaList[i].isReproducing == false) then
			
				local foodDist = bacteriaList[i].foodRadius + 1 -- Distance to a nutrient
				local directionX = 0
				local directionY = 0
				
				for k = 1, #nutrientsList, 1 do -- Run through all nutrients
					
					difX = nutrientsList[k].x - bacteriaList[i].x
					difY = nutrientsList[k].y - bacteriaList[i].y
					local currentFoodDist = math.round(math.sqrt(difX^2 + difY^2))
					
					if(currentFoodDist <= foodDist) then
						
						foodDist = currentFoodDist -- Distance to the closest nutrient
						directionX = difX
						directionY = difY
						
					end
				end
				
				if(foodDist > bacteriaList[i].foodRadius) then
				
					shouldIMove(bacteriaList[i])
					
				else
				
					bacteriaList[i]:setLinearVelocity(directionX, directionY)
					
				end
				
			elseif(bacteriaList[i].satiety <= 0) then -- if a bacterium is completely hungry, it dies
				
				death(bacteriaList[i])
			
			-- if a bacterium is not hungry and is not reproducing, move wherever
			elseif(bacteriaList[i].isReproducing == false) then
				
				shouldIMove(bacteriaList[i])
				
			end
		end
	end
	
	-- Balance the number of nutrients
	balanceNutrientsQuantity()
	
end

--------------------------------------------------
-- FUNCTIONS BLOCK ENDS
--------------------------------------------------

-- SCENE:CREATE
function scene:create(event)
	
	-- Create scene display groups
	local sceneGroup = self.view
	bgGroup = display.newGroup()
	bactGroup = display.newGroup()
	uiGroup = display.newGroup()
	textGroup = display.newGroup()
	-- Insert all display groups into scene group
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(bactGroup)
	sceneGroup:insert(uiGroup)
	sceneGroup:insert(textGroup)
	
	-- Create map background
	local map = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	map:setFillColor(unpack(uiColorLight))
	
	-- Create walls
	createWalls(wallsWidth, wallsHeight)
	
	-- Create the first bacterium
	createNewBacterium(display.contentCenterX, display.contentCenterY, 0, 0)
	
	--------------------------------------------------
	-- INTERFACE BLOCK BEGINS
	--------------------------------------------------
	
	-- Create microscope background
	local microscopeBg = display.newImageRect(uiGroup, "Images/Backgrounds/MicroscopeBg.png", 1920, 1080)
	microscopeBg.x = display.contentCenterX
	microscopeBg.y = display.contentCenterY
	
	-- Create top panel
	local topPanel = display.newRect(uiGroup, display.contentCenterX, 5, display.contentWidth - 10, 120)
	topPanel.anchorX = 0.5
	topPanel.anchorY = 0
	topPanel:setFillColor(unpack(uiColorGreenMedium))
	topPanel:setStrokeColor(unpack(uiColorGreenLight))
	topPanel.strokeWidth = 10
	
	-- Display text on the panel
	
	-- Budget string
	budgetText = display.newText(textGroup, "Budget: $" .. money, 40, 65, native.systemFont, 60)
	budgetText.anchorX = 0
	budgetText.anchorY = 0.5
	budgetText:setFillColor(unpack(uiColorLight))
	
	-- Zoom string
	zoomText = display.newText(textGroup, "Zoom: x" .. zoom, display.contentCenterX, 65, native.systemFont, 60)
	zoomText:setFillColor(unpack(uiColorLight))
	
	-- Create buttons
	
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
	navJoystickInner = display.newCircle(uiGroup, 240, display.contentHeight - 240, 80)
	navJoystickInner:setFillColor(unpack(uiColorGreenMedium))
	navJoystickInner:setStrokeColor(unpack(uiColorGreenLight))
	navJoystickInner.strokeWidth = 8
	
	--------------------------------------------------
	-- INTERFACE BLOCK ENDS
	--------------------------------------------------
	
	-- Initialize sounds
	buttonSound = audio.loadSound("Sounds/Button_sound1.wav")
	
end

-- SCENE:SHOW
function scene:show(event)
	
	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
		physics.start()
		Runtime:addEventListener("key", onBackButton)
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener("enterFrame", moveCamera)
		Runtime:addEventListener("collision", onGlobalCollision)
		navJoystickInner:addEventListener("touch", onNavJoystick)
		-- gameLoopTimer = timer.performWithDelay(math.random(3000, 6000), gameLoop, 0)
		
	end
end

-- SCENE:HIDE
function scene:hide(event)

	local sceneGroup = self.view
	local phase = event.phase
	if(event.phase == "will") then
		
	elseif(event.phase == "did") then
		
		physics.pause()
		Runtime:removeEventListener("key", onBackButton)
		Runtime:removeEventListener("enterFrame", gameLoop)
		Runtime:removeEventListener("enterFrame", moveCamera)
		Runtime:removeEventListener("collision", onGlobalCollision)
		-- timer.pause(gameLoopTimer)
		
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