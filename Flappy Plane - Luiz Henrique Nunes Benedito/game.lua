

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require "physics"
physics.start()
physics.setGravity( 0, 100 )

local dados = require( "dados" )


local jogoComecou = false


function colisao( event )
	if ( event.phase == "began" ) then

		local options =
{
    
    time = 1800,
    params = {}
}
		composer.gotoScene( "restart", options)


	end
end

function chaoMovimento(self,event)
	
	if self.x < (-900 + (self.speed*2)) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
	
end


function voarCima(event)
	
   if event.phase == "began" then
       
		if jogoComecou == false then
			 plane.bodyType = "dynamic"
			 instrucoes.alpha = 0
			 tb.alpha = 1
			 addMontTimer = timer.performWithDelay(3000, addMont, -1)
			 moveMontTimer = timer.performWithDelay(5, MoveMont, -1)
			 jogoComecou = true
			 plane:applyForce(0, -300, plane.x, plane.y)
		else 
       
	    plane:applyForce(0, -800, plane.x, plane.y)
		
      end
	end
end



function MoveMont()
		for a = elements.numChildren,1,-1  do
			if(elements[a].x < display.contentCenterX - 170) then
				if elements[a].scoreAdded == false then
					dados.score = dados.score + 1
					tb.text = dados.score
					elements[a].scoreAdded = true
				end
			end
			if(elements[a].x > -100) then
				elements[a].x = elements[a].x - 12
			else 
				elements:remove(elements[a])
			end	
		end
end


-- Adicionando montanhas
function addMont()
	
	height = math.random(display.contentCenterY - 200, display.contentCenterY + 200)

	montCima = display.newImageRect('montCima.png',220,714)
	montCima.anchorX = 0.5
	montCima.anchorY = 1
	montCima.x = display.contentWidth 
	montCima.y = height - 150
	montCima.scoreAdded = false
	physics.addBody(montCima, "static", {density=1, bounce=0.1, friction=.2})
	elements:insert(montCima)
	
	montBaixo = display.newImageRect('montBaixo.png',220,714)
	montBaixo.anchorX = 0.5
	montBaixo.anchorY = 0
	montBaixo.x = display.contentWidth + 550
	montBaixo.y = height + 160
	montBaixo.scoreAdded = false
	physics.addBody(montBaixo, "static", {density=1, bounce=0.1, friction=.2})
	elements:insert(montBaixo)

end	

local function verificarMemoria()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end


function scene:create( event )

   local grupoCenario = self.view
   
   jogoComecou = false
   dados.score = 0
   
   local background = display.newImage("bg.png")
	grupoCenario:insert(background)


    bg = display.newImageRect('bg.png',900,1425)
	bg.anchorX = 0
	bg.anchorY = 1
	bg.x = 0
	bg.y = display.contentHeight
	bg.speed = 4
	grupoCenario:insert(bg)
    
   elements = display.newGroup()
	elements.anchorChildren = true
	elements.anchorX = 0
	elements.anchorY = 1
	elements.x = 0
	elements.y = 0
	grupoCenario:insert(elements)



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
	
	p_options = 
	{
		-- Parametros plane
		width = 88,
		height = 73,
		numFrames = 3,
		-- Tamanho da sprite
		sheetContentWidth = 264,
		sheetContentHeight = 73,
	}

	planeSheet = graphics.newImageSheet( "plane.png", p_options )
	plane = display.newSprite( planeSheet, { name="plane", start=1, count=3, time=500 } )
	plane.anchorX = 0.5
	plane.anchorY = 0.5
	plane.x = display.contentCenterX - 150
	plane.y = display.contentCenterY
	physics.addBody(plane, "static", {density=.1, bounce=0.1, friction=1})
	plane:applyForce(0, -300, plane.x, plane.y)
	plane:play()
	grupoCenario:insert(plane)


		e_options = 
	{
		-- parametros explosao
		width = 58,
		height = 51,
		numFrames = 12,
		-- resolução sprite
		sheetContentWidth = 696,
		sheetContentHeight = 51,
	}

function explodiu (event)
	plane:removeSelf( )
	explosaoSheet = graphics.newImageSheet( "explosao.png", e_options )
	explosao = display.newSprite( explosaoSheet, { name="explosao", start=1, count=12, time=1900, loopCount = 1} )
	explosao.anchorX = 0.5
	explosao.anchorY = 0.5
	explosao.x = plane.x
	explosao.y = plane.y
	explosao:play()

end

	
	tb = display.newText(dados.score,display.contentCenterX,
	150, "arial", 58)
	tb:setFillColor(0,0,0)
	tb.alpha = 0
	grupoCenario:insert(tb)
	
	instrucoes = display.newImageRect("instrucoes.png",400,328)
	instrucoes.anchorX = 0.5
	instrucoes.anchorY = 0.5
	instrucoes.x = display.contentCenterX
	instrucoes.y = display.contentCenterY
	grupoCenario:insert(instrucoes)
	
end



function scene:show( event )

   local grupoCenario = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   elseif ( phase == "did" ) then

	composer.removeScene("start")
	Runtime:addEventListener("touch", voarCima)

	chao.enterFrame = chaoMovimento
	Runtime:addEventListener("enterFrame", chao)

	chao2.enterFrame = chaoMovimento
	Runtime:addEventListener("enterFrame", chao2)
    
    Runtime:addEventListener("collision", explodiu)
    Runtime:addEventListener("collision", colisao)
   
    memTimer = timer.performWithDelay( 1000, verificarMemoria, 0 )
	  
   end
end


function scene:hide( event )

   local grupoCenario = self.view
   local phase = event.phase

   if ( phase == "will" ) then

	 Runtime:removeEventListener("touch", voarCima)
	Runtime:removeEventListener("enterFrame", chao)
	Runtime:removeEventListener("enterFrame", chao2)
	Runtime:removeEventListener("collision", explodiu)
	Runtime:removeEventListener("collision", colisao)
	timer.cancel(addMontTimer)
	timer.cancel(moveMontTimer)
	timer.cancel(memTimer)
	  
	  
   elseif ( phase == "did" ) then
  
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local grupoCenario = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene













