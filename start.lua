-- start.lua
local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

function scene:create(event)
	print("start.lua create")
	local sceneGroup = self.view
	local BgGroup = display.newGroup()
	local MainGroup = display.newGroup()
	local UIGroup = display.newGroup()
	sceneGroup:insert(BgGroup)
	sceneGroup:insert(MainGroup)
	sceneGroup:insert(UIGroup)
	
	-- Loading sounds
	local checkboxSoundEnabled = audio.loadSound("Sounds/checkboxSound.wav")
	local checkboxSoundDisabled = audio.loadSound("Sounds/checkboxSound2.wav")
	local buttonLaunchOnPressSound = audio.loadSound("Sounds/ButtonLaunchOnPress.wav")
	local buttonLaunchOnReleaseSound = audio.loadSound("Sounds/ButtonLaunchOnRelease.wav")
	
	-- Basis background
	local basis = display.newImageRect(BgGroup,"Images/Backgrounds/StartBackground.png", 1920, 1080)
	basis.x = display.contentCenterX
	basis.y = display.contentCenterY
	
	-- Version pointer
	local version = display.newText(UIGroup, "Life Simulation Engine v.0.4.1", 1570, 30, "Fira.otf", 32) 
	
	-- Monitor
	local function monitorListener(event)
	end
	
	local monitor = widget.newScrollView(
		{
		top = 60,
		left = 1260,
		width = 600,
		height = 400,
		scrollWidth = 600,
		scrollHeight = 400,
		hideBackground = false,
		isLocked = false,
		listener = monitorListener
		}
	)
	
	local textOptions = 
	{
		text = "Console log:",
		parent = monitor,
		x = -300,
		y = 200,
		font = "Fira.otf",
		fontSize = 36,
	}
	local textM = display.newText(textOptions)
	textM.anchorX = 0
	textM.anchorY = 1
	textM:setFillColor(0, 0, 0)
	local t1 = display.newText(monitor, "Loading Console...", 0, 0, "Fira.otf", 36)
	t1:setFillColor(0, 0, 0)
	transition.fadeOut( textM, { time=0 } )
	transition.fadeOut( t1, { time=2000 , delay = 4000} )
	transition.fadeIn( textM, { time=2000 , delay = 6000})
	
	local function textIntoMonitor(text)
		textM.text = textM.text .. "\n" .. text
		--local view = monitor:getView()
		--view.height = view.height + 50
		--monitor:setScrollHeight(view.height)
		--monitor:scrollTo("bottom", {time = 0})
	end
	
	-- Checkboxes
	local function checkboxReproductionListener(event)
		local switch = event.target
		if switch.isOn == true then
			audio.play(checkboxSoundEnabled)
			textIntoMonitor("Reproduction is enabled")
		elseif switch.isOn == false then
			audio.play(checkboxSoundDisabled)
			textIntoMonitor("Reproduction is disabled")
		end
	end
	
	local checkboxReproductionOptions = {
		width = 300,
		height = 100,
		numFrames = 2,
		sheetContentWidth = 300,
		sheetContentHeight = 200
	}

	local checkboxReproductionSheet = graphics.newImageSheet( "Images/Checkboxes/CheckboxReproductionSheet.png", checkboxReproductionOptions )
	local checkboxReproduction = widget.newSwitch(
    {
		sheet = checkboxReproductionSheet,
		left = 60,
		top = 60,
		width = 300,
		height = 100,
		style = "checkbox",
		id = "checkboxReproduction",
		onPress = checkboxReproductionListener,
		frameOff = 1,
		frameOn = 2,
		initialSwitchState = false
    }
	)
	
	
	--Button Info
	local function buttonInfoListener(event)
		if event.phase == "began" then
			textIntoMonitor("Info opened")
			audio.play(buttonLaunchOnPressSound)
		elseif event.phase == "ended" then
			audio.play(buttonLaunchOnReleaseSound)
			local options =
			{
				isModal = true,
				effect = "fade",
				time = 400,
			}
			composer.showOverlay("info", options)
		end
	end
	
	local buttonInfo = widget.newButton(
	{
		top = 920,
		left = 60,
		width = 200,
		height = 100,
		defaultFile = "Images/Buttons/ButtonInfoDefault.png",
		overFile = "Images/Buttons/ButtonInfoOver.png",
		onEvent = buttonInfoListener
	
	}
	)
	
	-- Button Launch
	local function buttonLaunchListener(event)
		if event.phase == "began" then
			textIntoMonitor("Simulation is launching...")
			audio.play(buttonLaunchOnPressSound)
		elseif event.phase == "ended" then
			audio.play(buttonLaunchOnReleaseSound)
			composer.gotoScene("simulation")
		end
	end
	local buttonLaunch = widget.newButton(
	{
		left = 1460,
		top = 820,
		width = 400,
		height = 200,
		defaultFile = "Images/Buttons/ButtonLaunchDefault.png",
		overFile = "Images/Buttons/ButtonLaunchOver.png",
		onEvent = buttonLaunchListener
	}	
	)
	
	UIGroup:insert(checkboxReproduction)
	UIGroup:insert(monitor)
	UIGroup:insert(buttonInfo)
	UIGroup:insert(buttonLaunch)
	
	
end
function scene:show(event)
	if event.phase == "will" then print("start.lua show will")
	elseif event.phase == "did" then	print("start.lua show did")
	end
	
end
function scene:hide(event)
	if event.phase == "will" then print("start.lua hide will")
	elseif event.phase == "did" then	print("start.lua hide did")
	end	
end
function scene:destroy(event)
	print("start.lua destroy")
	
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene