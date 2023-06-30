-- simulation.lua
local composer = require("composer")
local widget = require("widget")
local physics = require("physics")
local scene = composer.newScene()

function scene:create(event)
	physics.start()
	physics.setGravity(0, 0)
	local sceneGroup = self.view
	local BgGroup = display.newGroup()
	local MainGroup = display.newGroup()
	local UIGroup = display.newGroup()
	sceneGroup:insert(BgGroup)
	sceneGroup:insert(MainGroup)
	sceneGroup:insert(UIGroup)
	
	-- Sounds
	local buttonLaunchOnPressSound = audio.loadSound("Sounds/ButtonLaunchOnPress.wav")
	local buttonLaunchOnReleaseSound = audio.loadSound("Sounds/ButtonLaunchOnRelease.wav")
	
	local function randomizer(a, b)
		math.randomseed(system.getTimer())
		return math.random(a, b)
	end
	
	local firstDNA = {}
	firstDNA.life_cycle = 300000
	firstDNA.sizeX = randomizer(20, 100)
	firstDNA.sizeY = randomizer(20, 100)
	firstDNA.red = 1
	firstDNA.green = 1
	firstDNA.blue = 1
	firstDNA.childrenTime = randomizer(30000, 200000)
	
	-- Text section
	local numberOfCreaturesText = display.newText(UIGroup, "Number of creatures: ", 1510, 60, "Fira.otf", 36)
	numberOfCreaturesText.anchorX = 0
	numberOfCreaturesText.anchorY = 0
	numberOfCreaturesText.x = 1085
	numberOfCreaturesText.y = 0
	local DNASizeXText = display.newText(UIGroup, "SizeX: ", 1510, 150, "Fira.otf", 36)
	DNASizeXText.anchorX = 0
	DNASizeXText.anchorY = 0
	DNASizeXText.x = 1085
	DNASizeXText.y = 50
	local DNASizeYText = display.newText(UIGroup, "SizeY: ", 1510, 200, "Fira.otf", 36)
	DNASizeYText.anchorX = 0
	DNASizeYText.anchorY = 0
	DNASizeYText.x = 1085
	DNASizeYText.y = 100
	local DNARedText = display.newText(UIGroup, "Red: ", 1510, 250, "Fira.otf", 36)
	DNARedText.anchorX = 0
	DNARedText.anchorY = 0
	DNARedText.x = 1085
	DNARedText.y = 150
	local DNAGreenText = display.newText(UIGroup, "Green: ", 1510, 300, "Fira.otf", 36)
	DNAGreenText.anchorX = 0
	DNAGreenText.anchorY = 0
	DNAGreenText.x = 1085
	DNAGreenText.y = 200
	local DNABlueText = display.newText(UIGroup, "Blue: ", 1510, 350, "Fira.otf", 36)
	DNABlueText.anchorX = 0
	DNABlueText.anchorY = 0
	DNABlueText.x = 1085
	DNABlueText.y = 250
	
	local simulationBg = display.newImageRect(BgGroup, "Images/Backgrounds/SimulationBackground.png", 1080, 1080, 1080, 1080)
	simulationBg.anchorX = 0
	simulationBg.anchorY = 0
	local simulationBg2 = display.newImageRect(BgGroup, "Images/Backgrounds/SimulationBg2.png", 855, 1080, 855, 1080)
	simulationBg2.anchorX = 0
	simulationBg2.anchorY = 0
	simulationBg2.x = 1070
	simulationBg2.y = 0
	local borderTop = display.newRect(UIGroup, 540, 5, 1080, 10)
	physics.addBody(borderTop, "static", { width = 1080, height = 10, bounce = 0.1 } )
	local borderBottom = display.newRect(UIGroup, 540, 1075, 1080, 10)
	physics.addBody(borderBottom, "static", { width = 1080, height = 10, bounce = 0.1 } )
	local borderLeft = display.newRect(UIGroup, 5, 540, 10, 1080)
	physics.addBody(borderLeft, "static", { width = 10, height = 1080, bounce = 0.1 } )
	local borderRight = display.newRect(UIGroup, 1075, 540, 10, 1080)
	physics.addBody(borderRight, "static", { width = 10, height = 1080, bounce = 0.1 } )
	
	local numberOfCreatures = 0
	local creaturesTable = {}
	
	function updateText()
	numberOfCreaturesText.text = "Number of creatures: " .. numberOfCreatures
	DNASizeXText.text = "SizeX: " .. creaturesTable[numberOfCreatures].sizeX
	DNASizeYText.text = "SizeY: " .. creaturesTable[numberOfCreatures].sizeY
	DNARedText.text = "Red: " .. creaturesTable[numberOfCreatures].red
	DNAGreenText.text = "Green: " .. creaturesTable[numberOfCreatures].green
	DNABlueText.text = "Blue: " .. creaturesTable[numberOfCreatures].blue
	end
	function newDNA(odna )
		
		local wDNA = {}
		wDNA.life_cycle = odna.life_cycle + errorDNAChance()
		math.randomseed(system.getTimer() )
		wDNA.sizeX = odna.sizeX + errorDNAChance()* randomizer(1, 10)
		math.randomseed(system.getTimer() )
		wDNA.sizeY = odna.sizeY + errorDNAChance()* randomizer(1, 10)
		math.randomseed(system.getTimer() )
		wDNA.red = (odna.red + errorDNAChance())%2
		math.randomseed(system.getTimer() )
		wDNA.green = (odna.green + errorDNAChance())%2
		math.randomseed(system.getTimer() )
		wDNA.blue = (odna.blue + errorDNAChance())%2
		math.randomseed(system.getTimer() )
		wDNA.childrenTime = odna.childrenTime + errorDNAChance()*1000
		math.randomseed(system.getTimer() )
		
		return newCreature(wDNA)
	end
	function newCreature(nDNA)
		
		local creature = display.newRect(MainGroup, math.random(100, 980), math.random(100, 980), nDNA.sizeX, nDNA.sizeY)
		table.insert(creaturesTable, creature)
		creature.timeOfBorn = system.getTimer()
		numberOfCreatures = #creaturesTable
		physics.addBody(creature, "dynamic", { width = nDNA.sizeX, height = nDNA.sizeY, bounce = 0.1 } )
		creature.name = "creature"
		creature.dna = nDNA
		creature.life_cycle = nDNA.life_cycle
		creature.sizeX = nDNA.sizeX
		creature.sizeY = nDNA.sizeY
		creature.red = nDNA.red
		creature.green = nDNA.green
		creature.blue = nDNA.blue
		creature.childrenTime = nDNA.childrenTime
		
		creature:setFillColor(creature.red, creature.green, creature.blue)
		--creature:setLinearVelocity(0, 0)
	end
	function errorDNAChance()
		return math.ceil(randomizer(-1000, 1000)/1000)
	end
	function move(a)
		if a == 0 then
		
		else
			for i=1, numberOfCreatures do
				creaturesTable[i]:setLinearVelocity(math.random(-100, 100), math.random(-100, 100))
			end
		end
	end
	function checkChildrenTime()
		for i=1, #creaturesTable do
			if  system.getTimer()- creaturesTable[i].timeOfBorn > creaturesTable[i].childrenTime then
				creaturesTable[i].timeOfBorn = creaturesTable[i].timeOfBorn + math.random(20000, 120000)
				newDNA(creaturesTable[i])
			end
		end
	end
	
	-- Buttons
	
	local function buttonPauseListener(event)
		if event.phase == "began" then
			audio.play(buttonLaunchOnPressSound)
		elseif event.phase == "ended" then
			audio.play(buttonLaunchOnReleaseSound)
			physics.pause()
			timer.pause(loopTimer)
			--buttonPause:setEnabled(false)
			--buttonResume:setEnabled(true)
		end
	end
	local function buttonRestartListener(event)
		if event.phase == "began" then
			audio.play(buttonLaunchOnPressSound)
		elseif event.phase == "ended" then
			audio.play(buttonLaunchOnReleaseSound)
			physics.stop()
			timer.pause(loopTimer)
			composer.removeScene("simulation")
			composer.gotoScene("simulation")
		end
	end
	local function buttonBackListener(event)
		if event.phase == "began" then
			audio.play(buttonLaunchOnPressSound)
		elseif event.phase == "ended" then
			audio.play(buttonLaunchOnReleaseSound)
			physics.stop()
			timer.pause(loopTimer)
			composer.removeScene("simulation")
			composer.gotoScene("start")
		end
	end
	local function buttonResumeListener(event)
		if event.phase == "began" then
			audio.play(buttonLaunchOnPressSound)
		elseif event.phase == "ended" then
			audio.play(buttonLaunchOnReleaseSound)
			physics.start()
			timer.resume(loopTimer)
			--buttonResume:setEnabled(false)
			--buttonPaus:setEnabled(true)
		end
	end
	
	local buttonPause = widget.newButton(
	{
		left = 1085,
		top = 620,
		width = 400,
		heigth = 200,
		onEvent = buttonPauseListener,
		defaultFile = "Images/Buttons/ButtonSimulationPauseDefault.png",
		overFile = "Images/Buttons/ButtonSimulationPauseOver.png"
	}
	)
	local buttonResume = widget.newButton(
	{
		left = 1510,
		top = 620,
		width = 400,
		heigth = 200,
		onEvent = buttonResumeListener,
		defaultFile = "Images/Buttons/ButtonSimulationResumeDefault.png",
		overFile = "Images/Buttons/ButtonSimulationResumeOver.png"
	}
	)
	local buttonRestart = widget.newButton(
	{
		left = 1510,
		top = 840,
		width = 400,
		heigth = 200,
		onEvent = buttonRestartListener,
		defaultFile = "Images/Buttons/ButtonSimulationRestartDefault.png",
		overFile = "Images/Buttons/ButtonSimulationRestartOver.png"
	}
	)
	local buttonBack = widget.newButton(
	{
		left = 1085,
		top = 840,
		width = 400,
		heigth = 200,
		onEvent = buttonBackListener,
		defaultFile = "Images/Buttons/ButtonSimulationBackDefault.png",
		overFile = "Images/Buttons/ButtonSimulationBackOver.png"
	}
	)
	
	UIGroup:insert(buttonResume)
	UIGroup:insert(buttonPause)
	UIGroup:insert(buttonRestart)
	UIGroup:insert(buttonBack)
	
	
	
	newDNA(firstDNA)

	function loop()
		math.randomseed(system.getTimer() )
		
		checkChildrenTime()
		move()
		
		updateText()
	end

	loopTimer = timer.performWithDelay(200, loop, 0)
	
	
end

function scene:show(event)
	
end
function scene:hide(event)
	
end
function scene:destroy(event)
	
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene