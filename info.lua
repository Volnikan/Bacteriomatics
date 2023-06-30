-- info.lua
local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()



function scene:create(event)
	print("info.lua create")
	local sceneGroup = self.view
	local BgGroup = display.newGroup()
	local UIGroup = display.newGroup()
	sceneGroup:insert(BgGroup)
	sceneGroup:insert(UIGroup)
	local picture = display.newRect(BgGroup, 960, 540, 1920, 1080)
	picture:setFillColor(1, 1, 1)
	local mask = graphics.newMask("Images/Backgrounds/infoMask.png")
	picture:setMask(mask)
	
	local text = [=====[
	Nikvol Software Corporation ©
	
	This program is designed to perform tasks related to 
	simulation processes of life beings.
	]=====]
	local textText = display.newText(BgGroup, text, 0, 0, native.systemFont, 64)
	textText.anchorX = 0
	textText.anchorY = 0
	textText.x = 200
	textText.y = 200
	textText:setFillColor(0, 0, 0)
	UIGroup:insert(textText)

	
	
	-- ButtonBack
	function buttonBackListener(event)
		if event.phase == "ended" then
			composer.hideOverlay("slideDown", 500)
		end
	end
	
	local buttonBack = widget.newButton(
	{
		left = 1400,
		top = 760,
		width = 400,
		height = 200,
		id = "buttonBack",
		onEvent = buttonBackListener,
		defaultFile = "Images/Buttons/ButtonSimulationBackDefault.png",
		overFile = "Images/Buttons/ButtonSimulationBackOver.png"
	}
	)

	UIGroup:insert(buttonBack)
end
function scene:show( event )
	if event.phase == "will" then
		print("info.lua show will")
	elseif event.phase == "did" then
		print("info.lua show did")
	end
end
function scene:hide(event)
	if event.phase == "will" then
		print("info.lua hide will")
	elseif event.phase == "did" then
		print("info.lua hide did")
	end
end
function scene:destroy(event)
		print("info.lua destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene