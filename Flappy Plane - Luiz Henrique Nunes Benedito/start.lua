local composer = require( "composer" )
local scene = composer.newScene()




local physics = require "physics"
physics.start()
local dados = require( "dados" )


function startGame(event)
     if event.phase == "ended" then
		composer.gotoScene("game")
     end
end

function chaoMovimento(self,event)
	
	if self.x < (-900 + (self.speed*2)) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
	
end
-- Movimentação do titulo 
function tituloTransicaoBaixo()
	baixoTransicao = transition.to(grupoTitulo,{time=400, y=grupoTitulo.y+20,onComplete=tituloTransicaoCima})
	
end

function tituloTransicaoCima()
	cimaTransicao = transition.to(grupoTitulo,{time=400, y=grupoTitulo.y-20, onComplete=tituloTransicaoBaixo})
	
end

function tituloAnimacao()
	tituloTransicaoBaixo()
end

---------------------------------------------------------------------------------

-- criar cenario
function scene:create( event )

   local grupoCenario = self.view

   
    background = display.newImageRect("bg.png",900,1425)
	background.anchorX = 0.5
	background.anchorY = 1
	background.x = display.contentCenterX
	background.y = display.contentHeight
	grupoCenario:insert(background)
	
	titulo = display.newImageRect("titulo.png",500,100)
	titulo.anchorX = 0.5
	titulo.anchorY = 0.5
	titulo.x = display.contentCenterX - 80
	titulo.y = display.contentCenterY 
	grupoCenario:insert(titulo)
	
	chao = display.newImageRect('chao.png',900,162)
	chao.anchorX = 0
	chao.anchorY = 1
	chao.x = 0
	chao.y = display.viewableContentHeight
	physics.addBody(chao, "static", {density=.1, bounce=0.1, friction=.2})
	chao.speed = 4
	grupoCenario:insert(chao)

	chao2 = display.newImageRect('chao.png',900,162)
	chao2.anchorX = 0
	chao2.anchorY = 1
	chao2.x = chao2.width
	chao2.y = display.viewableContentHeight
	physics.addBody(chao2, "static", {density=.1, bounce=0.1, friction=.2})
	chao2.speed = 4
	grupoCenario:insert(chao2)
	
	start = display.newImageRect("start_btn.png",300,65)
	start.anchorX = 0.5
	start.anchorY = 1
	start.x = display.contentCenterX
	start.y = display.contentHeight - 400
	grupoCenario:insert(start)
	
	p_options = 
	{
		-- Parametros Sprite Aviao
		width = 88,
		height = 73,
		numFrames = 3,
		-- Tamanho do arquivo
		sheetContentWidth = 264,
		sheetContentHeight = 73,
	}

	planeSheet = graphics.newImageSheet( "plane.png", p_options )
	plane = display.newSprite( planeSheet, { name="plane", start=1, count=3, time=500 } )
	plane.anchorX = 0.5
	plane.anchorY = 0.5
	plane.x = display.contentCenterX + 240
	plane.y = display.contentCenterY 
	plane:play()
	grupoCenario:insert(plane)
	
	grupoTitulo = display.newGroup()
	grupoTitulo.anchorChildren = true
	grupoTitulo.anchorX = 0.5
	grupoTitulo.anchorY = 0.5
	grupoTitulo.x = display.contentCenterX
	grupoTitulo.y = display.contentCenterY - 250
	grupoTitulo:insert(titulo)
	grupoTitulo:insert(plane)
	grupoCenario:insert(grupoTitulo)
	tituloAnimacao()
   
   
end

function scene:show( event )

   local grupoCenario = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
		composer.removeScene("restart")
		start:addEventListener("touch", startGame)
		chao.enterFrame = chaoMovimento
		Runtime:addEventListener("enterFrame", chao)
		chao2.enterFrame = chaoMovimento
		Runtime:addEventListener("enterFrame", chao2)
   end
end


function scene:hide( event )

   local grupoCenario = self.view
   local phase = event.phase

   if ( phase == "will" ) then
	    start:removeEventListener("touch", startGame)
		Runtime:removeEventListener("enterFrame", chao)
		Runtime:removeEventListener("enterFrame", chao2)
		transition.cancel(baixoTransicao)
		transition.cancel(cimaTransicao)
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










