local composer = require("composer")
local widget = require("widget")
local json = require("json")
local scene = composer.newScene()

-- Setting UI color palette
local uiColorDark = {0.13, 0.13, 0.13}
local uiColorLight = {0.94, 0.94, 0.94}
local uiColorGreenDark = {0.01, 0.15, 0.07}
local uiColorGreenMedium = {0.02, 0.46, 0.22}
local uiColorGreenLight = {0.15, 0.97, 0.52}

-- Creating variables
local musicVolume = 50
local soundVolume = 50
local musicVolumeText
local soundVolumeText
local settingsParametersPath = system.pathForFile("Settings.json", system.DocumentsDirectory)

-- Sounds variables
local buttonSound

-- Settings table
local settingsTable = {
	["language"] = "",
	["music"] = musicVolume,
	["sound"] = soundVolume
}

-- Slider imagesheet options
local sliderOptions = {
	frames = {
		{x = 4, y = 76, width = 32, height = 32},
		{x = 44, y = 76, width = 32, height = 32},
		{x = 76, y = 4, width = 32, height = 32},
		{x = 76, y = 36, width = 32, height = 32},
		{x = 4, y = 4, width = 64, height = 64}
	},
	sheetContentWidth = 112,
	sheetContentHeight = 112
}

-- Reading settings function
local function readSettings()
	
	local settingsFile = io.open(settingsParametersPath, "r")
	
	if settingsFile then
		local contents = settingsFile:read("*a")
		settingsTable = json.decode(contents)
		musicVolume = settingsTable.music
		soundVolume = settingsTable.sound
	end
	
	io.close(settingsFile)
	settingsFile = nil
	
end

-- Writitng settings function
local function writeSettings()
	
	settingsTable.music = musicVolume
	settingsTable.sound = soundVolume
	
	local settingsFile = io.open(settingsParametersPath, "w")
	settingsFile:write(json.encode(settingsTable))
	io.close(settingsFile)
	settingsFile = nil
	
end

-- Music volume slider function
local function onMusicSliderMove(event)

	musicVolume = event.value
	musicVolumeText.text = "Music volume: " .. musicVolume
	
	if(event.phase == "ended") then
		writeSettings()
	end
end

-- Sound volume slider function
local function onSoundSliderMove(event)

	soundVolume = event.value
	soundVolumeText.text = "Sound volume: " .. soundVolume
	
	if(event.phase == "ended") then
		writeSettings()
	end
end

-- Back button function
local function onBackButton(event)
	
	if(event.phase == "began") then
		audio.play(buttonSound)
	end
	
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
	
	readSettings()
	
	-- Language settings
	local languageText = display.newText(textGroup, "Language: ", 120, 120, native.systemFontBold, 60)
	languageText.anchorX = 0
	languageText.anchorY = 0.5
	languageText:setFillColor(unpack(uiColorLight))
	
	-- Music volume settings
	musicVolumeText = display.newText(textGroup, "Music volume: " .. musicVolume, 120, 320, native.systemFontBold, 60)
	musicVolumeText.anchorX = 0
	musicVolumeText.anchorY = 0.5
	languageText:setFillColor(unpack(uiColorLight))
	
	-- Music volume slider
	local sliderSheet = graphics.newImageSheet("Images/Sliders/SliderImageSheet.png", sliderOptions)
	
	local musicSlider = widget.newSlider(
		{
			sheet = sliderSheet,
			leftFrame = 1,
			middleFrame = 2,
			rightFrame = 3,
			fillFrame = 4,
			frameWidth = 48,
			frameHeight = 48,
			handleFrame = 5,
			handleWidth = 96,
			handleHeight = 96,
			x = display.contentWidth - 600,
			y = 320,
			orientation = "horizontal",
			width = 800,
			value = musicVolume,
			listener = onMusicSliderMove
		}
	)
	
	uiGroup:insert(musicSlider)
	musicSlider.anchorX = 1
	musicSlider.anchorY = 0.5
	
	-- Sound volume settings
	soundVolumeText = display.newText(textGroup, "Sound volume: " .. soundVolume, 120, 520, native.systemFontBold, 60)
	soundVolumeText.anchorX = 0
	soundVolumeText.anchorY = 0.5
	soundVolumeText:setFillColor(unpack(uiColorLight))
	
	local soundSlider = widget.newSlider(
		{
			sheet = sliderSheet,
			leftFrame = 1,
			middleFrame = 2,
			rightFrame = 3,
			fillFrame = 4,
			frameWidth = 48,
			frameHeight = 48,
			handleFrame = 5,
			handleWidth = 96,
			handleHeight = 96,
			x = display.contentWidth - 600,
			y = 520,
			orientation = "horizontal",
			width = 800,
			value = soundVolume,
			listener = onSoundSliderMove
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
	
	-- Initializing sounds
	buttonSound = audio.loadSound("Sounds/Button_sound1.wav")
	
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
	audio.dispose(buttonSound)
	
end

-- Adding scene event listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene