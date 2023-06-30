-- settings.lua
local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view
	local BgGroup = display.newGroup()
	local MainGroup = display.newGroup()
	local UIGroup = display.newGroup()
	sceneGroup:insert(BgGroup)
	sceneGroup:insert(MainGroup)
	sceneGroup:insert(UIGroup)
	
	local picture = display.newImageRect(BgGroup,"LoadingPic.png", 1920, 1080)
	picture.x = display.contentCenterX
	picture.y = display.contentCenterY
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