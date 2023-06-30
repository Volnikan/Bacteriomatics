-- video.lua
local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view
	local mainGroup = display.newGroup()
	sceneGroup:insert(mainGroup)
	local video = native.newVideo(mainGroup, display.contentCenterX, display.contentCenterY, 1920, 1080 )
	video:load( "Videos/video.mov" )
	-- Play video
	video:play()
 
	-- Stop the video and remove
	--video:pause()
	--video:removeSelf()
	--video = nil

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