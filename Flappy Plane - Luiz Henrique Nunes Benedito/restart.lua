local composer = require( "composer" )
local scene = composer.newScene()

local dados = require( "dados" )
local score = require( "score" )


function restartGame(event)
     if event.phase == "ended" then
		saveScore()
		composer.gotoScene("start")
     end
end

function showStart()
	startTransition = transition.to(restart,{time=200, alpha=1})
	scoreTextTransition = transition.to(scoreText,{time=600, alpha=1})
	scoreTextTransition = transition.to(bestText,{time=600, alpha=1})
end

function showScore()
	scoreTransition = transition.to(scoreBg,{time=600, y=display.contentCenterY,onComplete=showStart})
end

function showGameOver()
	fadeTransition = transition.to(gameOver,{time=600, alpha=1,onComplete=showScore})
end

function loadScore()
    
	local prevScore = score.load()
	if prevScore ~= nil then
		if prevScore <= dados.score then
			score.set(dados.score)
		else 
			score.set(prevScore)
		end
	else 
		score.set(dados.score)

	end
end

function saveScore()
	score.save()
end



function scene:create( event )

   local grupoCenario = self.view

   background = display.newImageRect("bg.png",900,1425)
	background.anchorX = 0.5
	background.anchorY = 0.5
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	grupoCenario:insert(background)
	
	gameOver = display.newImageRect("gameOver.png",500,100)
	gameOver.anchorX = 0.5
	gameOver.anchorY = 0.5
	gameOver.x = display.contentCenterX 
	gameOver.y = display.contentCenterY - 400
	gameOver.alpha = 0
	grupoCenario:insert(gameOver)
	
	scoreBg = display.newImageRect("menuBg.png",480,393)
	scoreBg.anchorX = 0.5
	scoreBg.anchorY = 0.5
    scoreBg.x = display.contentCenterX
    scoreBg.y = display.contentHeight + 500
    grupoCenario:insert(scoreBg)
	
	restart = display.newImageRect("start_btn.png",300,65)
	restart.anchorX = 0.5
	restart.anchorY = 1
	restart.x = display.contentCenterX
	restart.y = display.contentCenterY + 400
	restart.alpha = 0
	grupoCenario:insert(restart)
	
	scoreText = display.newText(dados.score,display.contentCenterX + 110,
	display.contentCenterY - 60, native.systemFont, 50)
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0 
	grupoCenario:insert(scoreText)
	
	bestText = score.init({
	fontSize = 50,
	font = "Helvetica",
	x = display.contentCenterX + 70,
	y = display.contentCenterY + 85,
	maxDigits = 7,
	leadingZeros = false,
	filename = "scorefile.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText:setFillColor(0,0,0)
	grupoCenario:insert(bestText)
end


function scene:show( event )

   local grupoCenario = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
	  composer.removeScene("game")
	restart:addEventListener("touch", restartGame)
	showGameOver()
	--saveScore()
	loadScore()
   end
end


function scene:hide( event )

   local grupoCenario = self.view
   local phase = event.phase

   if ( phase == "will" ) then
	  
		restart:removeEventListener("touch", restartGame)
		transition.cancel(fadeTransition)
		transition.cancel(scoreTransition)
		transition.cancel(scoreTextTransition)
		transition.cancel(startTransition)
	  
   elseif ( phase == "did" ) then

   end
end


function scene:destroy( event )

   local grupoCenario = self.view

end

---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene













