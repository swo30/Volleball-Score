-----------------------------------------------------------------------------------------
--
-- score.lua
--
-----------------------------------------------------------------------------------------

require "math"

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"

--create display
display.setStatusBar(display.HiddenStatusBar)

orientation = {
	default = "landscape",
	supported = { "portrait", "landscapeLeft", "landscapeRight"}
}


--declare variables
score1		= 0
score2		= 0
hardCap		= 0
set1		= 0
set2		= 0
last_score	= {0,0,0,0,0}
font 		= "Britannic Bold"
invis 		= 0 -- set to 1 for visible hitboxes

image 	= display.newImageRect("backgrounds/bg.jpg", display.contentWidth+100, display.contentHeight) 
image.x = display.contentCenterX
image.y = display.contentCenterY


function menu()
	team1NamePrint		= display.newText("Team1 name:",display.contentWidth/5  	 ,display.contentHeight/5,font,20)
	team2NamePrint		= display.newText("Team2 name:",display.contentWidth*4/5 	 ,display.contentHeight/5,font,20)
	hardCapPrint 		= display.newText("Hard Cap"  ,display.contentWidth*4/5 - 35,display.contentHeight*7/10,font,20)
	hardCapNoCapPrint 	= display.newText("(0 for no cap):",hardCapPrint.x + 80,hardCapPrint.y+2,font,10)

	team1NameTextBox 	= native.newTextBox( display.contentWidth/5  , display.contentHeight/5   + 30, 175, 20 )
	team2NameTextBox 	= native.newTextBox( display.contentWidth*4/5, display.contentHeight/5   + 30, 175, 20 )
	hardCapTextBox		= native.newTextBox( display.contentWidth*4/5, display.contentHeight*4/5     , 175, 20 )

	hardCapTextBox.text	= "0"
	
	team1NameTextBox:addEventListener( "userInput", team1Listener )
	team2NameTextBox:addEventListener( "userInput", team2Listener )
	hardCapTextBox 	:addEventListener( "userInput", capListener )
	
	team1NameTextBox.isEditable	= true
	team2NameTextBox.isEditable	= true
	hardCapTextBox.isEditable	= true

	OkButton = display.newImageRect("ok button.gif",120,35)
	OkButton.x = display.contentWidth/5
	OkButton.y = display.contentHeight*4/5

	-- Create the touch event handler function 
	OkButton   :addEventListener("touch", OkButtonHandler)

end

function team1Listener( event )
	if ( event.phase == "editing" ) then
		print(tostring(event.text))
		team1Name = tostring(event.text)
		if team1Name == nil then
			team1Name = "Team1"
		end
	end
end

function team2Listener( event )
	if ( event.phase == "editing" ) then
		print(tostring(event.text))
		team2Name = tostring(event.text)
		if team2Name == nil then
			team2Name = "Team2"
		end
	end
end

function capListener( event )
	if ( event.phase == "editing" ) then
		hardCap = tonumber(event.text) --converts a string to nil
		if hardCap == nil then hardCap = 0 end
	end --end if edditing
end


function removeMenu()
	--remove menu objects
	team1NamePrint		:removeSelf()
	team2NamePrint		:removeSelf()
	hardCapPrint 		:removeSelf()
	hardCapNoCapPrint 	:removeSelf()
	team1NameTextBox	:removeSelf()
	team2NameTextBox	:removeSelf()
	hardCapTextBox		:removeSelf()
	OkButton			:removeSelf()

	--remove listeners
	team1NameTextBox:removeEventListener("userInput", team1Listener	)
	team2NameTextBox:removeEventListener("userInput", team2Listener	)
	hardCapTextBox 	:removeEventListener("userInput", capListener  	)
	OkButton		:removeEventListener("tap"		, removeMenu	)


	if team1Name == nil then team1Name = "Team1" end
	if team2Name == nil then team2Name = "Team2" end
	score1 = 0
	score2 = 0
	last_score[1] = 0
	last_score[2] = 0
	last_score[3] = 0
	last_score[4] = 0
	scoreView()
end


function removeScoreView()
	--remove removeMenu objects
	team1NameDisplay	:removeSelf()
	team2NameDisplay	:removeSelf()
	sets_print1			:removeSelf()
	sets_print2			:removeSelf()
	set1_text			:removeSelf()
	set2_text			:removeSelf()
	counterTeam1		:removeSelf()
	counterTeam2		:removeSelf()
	counterHitBox1		:removeSelf()
	counterHitBox2		:removeSelf()

	UndoButton :removeSelf()
	MenuButton :removeSelf()
	ResetButton:removeSelf()


	if (set1+set2 >= 1) then
		set1_score1			:removeSelf()
		set1_score2			:removeSelf()
		set1_colon 			:removeSelf()
	end
	if (set1+set2 >= 2) then
		set2_score1			:removeSelf()
		set2_score2			:removeSelf()
		set2_colon 			:removeSelf()
	end
	if (set1+set2 >= 3) then
		set3_score1			:removeSelf()
		set3_score2			:removeSelf()
		set3_colon 			:removeSelf()
	end
	--remove listeners
	counterHitBox1:removeEventListener("tap", countUp1)
	counterHitBox2:removeEventListener("tap", countUp2)
	
	--reset stats
	score1 = 0
	score2 = 0
	set1 = 0
	set2 = 0
	menu()
end


function scoreView()
	if team1Name == 'deez' and team2Name == 'nuts' then
		image 	= display.newImageRect("backgrounds/deeznuts.jpg", display.contentWidth+100, display.contentHeight) 
		image.x = display.contentCenterX
		image.y = display.contentCenterY
	end

	--create team names
	team1NameDisplay = display.newText(team1Name, 0, 0, font, 20)
	team1NameDisplay:setFillColor(1, 1, 1)
	team1NameDisplay.x = display.contentWidth /4
	team1NameDisplay.y = display.contentHeight - 50

	team2NameDisplay = display.newText(team2Name, 0, 0, font, 20)
	team2NameDisplay:setFillColor(1, 1, 1)
	team2NameDisplay.x = display.contentWidth * 3/4
	team2NameDisplay.y = display.contentHeight - 50



	sets_print1	=	display.newText("Sets" ,display.contentWidth/2     ,team1NameDisplay.y - 30 	,font,30)
	sets_print2	=	display.newText(":"    ,display.contentWidth/2     ,team1NameDisplay.y 		,font,20)
	set1_text 	= 	display.newText(set1   ,display.contentWidth/2 - 20,team1NameDisplay.y 		,font,20)
	set2_text 	= 	display.newText(set2   ,display.contentWidth/2 + 20,team1NameDisplay.y 		,font,20)

	--create numerical values
	counterTeam1 = display.newText(score1, display.contentWidth    /4, display.contentHeight /2, font, 80)
	counterTeam2 = display.newText(score2, display.contentWidth * 3/4, display.contentHeight /2, font, 80)

	--Hitbox					  --(x coor, y coor, width, height)
	counterHitBox1 = display.newRect(display.contentWidth    /4-20,display.contentHeight/2 ,display.contentWidth/2,display.contentHeight/2)
	counterHitBox2 = display.newRect(display.contentWidth*(3/4)+20,display.contentHeight/2 ,display.contentWidth/2,display.contentHeight/2)

	UndoButton   = display.newImageRect("undo button.gif",120,35)
	UndoButton.x = display.contentWidth /10
	UndoButton.y = display.contentHeight/10

	ResetButton   = display.newImageRect("reset button.gif",120,35)
	ResetButton.x = display.contentWidth*9/10
	ResetButton.y = display.contentHeight /10

	MenuButton   = display.newImageRect("menu button.gif",120,35)
	MenuButton.x = display.contentWidth*1/2
	MenuButton.y = display.contentHeight/10
							 --(R,G,B,alpha)
	counterHitBox1:setFillColor(1,0,0,invis)
	counterHitBox2:setFillColor(0,1,0,invis)

	counterHitBox1.isHitTestable = true  --When invis, you need to set hitable = true
	counterHitBox2.isHitTestable = true  --When invis, you need to set hitable = true

	counterHitBox1:addEventListener("tap", countUp1)
	counterHitBox2:addEventListener("tap", countUp2)

	UndoButton :addEventListener("touch", UndoButtonHandler)
	MenuButton :addEventListener("touch", MenuButtonHandler)
	ResetButton:addEventListener("touch", ResetButtonHandler)


end

function countUp1(event)
	print('countup1')

	last_score[0] = nil
	last_score[1] = score1
	last_score[2] = score2
	last_score[3] = set1
	last_score[4] = set2
	
	score1 = score1 + 1
	scoreCap() --update() in scoreCap
end

function countUp2(event)
	print('countup2')

	last_score[0] = nil
	last_score[1] = score1
	last_score[2] = score2
	last_score[3] = set1
	last_score[4] = set2

	score2 = score2 + 1
	scoreCap() --update() in scoreCap
end


function undo(event)
	if ((score1 == 0) and score2 == 0) and (set1+set2 == 1) then
		set1_score1:removeSelf()
		set1_score2:removeSelf()
		set1_colon :removeSelf()
	end	
	if ((score1 == 0) and (score2 == 0)) and (set1+set2 == 2) then
		set2_score1:removeSelf()
		set2_score2:removeSelf()
		set2_colon :removeSelf()
	end
	if ((score1 == 0) and (score2 == 0)) and (set1+set2 == 3) then
		set3_score1:removeSelf()
		set3_score2:removeSelf()
		set3_colon :removeSelf()
	end
	score1 	= last_score[1]
	score2 	= last_score[2]
	set1 	= last_score[3]
	set2 	= last_score[4]

	update()
end


function printSetScore()
	print("score1"..last_score[1])
	print("score2"..last_score[2])
	if (math.abs(set1+set2) == 1) then
		set1_score1 = display.newText(score1,display.contentWidth/2 - 20,team1NameDisplay.y/2,font,20)
		set1_score2 = display.newText(score2,display.contentWidth/2 + 20,team1NameDisplay.y/2,font,20)
		set1_colon  = display.newText(":"   ,display.contentWidth/2     ,team1NameDisplay.y/2,font,20)
	end

	if (math.abs(set1+set2) == 2) then
		set2_score1 = display.newText(score1,display.contentWidth/2 - 20,team1NameDisplay.y/2 + 20,font,20)
		set2_score2 = display.newText(score2,display.contentWidth/2 + 20,team1NameDisplay.y/2 + 20,font,20)
		set2_colon  = display.newText(":"   ,display.contentWidth/2     ,team1NameDisplay.y/2 + 20,font,20)
	end
	
	if (math.abs(set1+set2) == 3) then
		set3_score1 = display.newText(score1,display.contentWidth/2 - 20,team1NameDisplay.y/2 + 40,font,20)
		set3_score2 = display.newText(score2,display.contentWidth/2 + 20,team1NameDisplay.y/2 + 40,font,20)
		set3_colon  = display.newText(":"   ,display.contentWidth/2     ,team1NameDisplay.y/2 + 40,font,20)
	end
end


function update()
	counterTeam1:removeSelf()
	counterTeam2:removeSelf()
	counterTeam1 = display.newText(score1, display.contentWidth    /4, display.contentHeight /2, font, 80)
	counterTeam2 = display.newText(score2, display.contentWidth * 3/4, display.contentHeight /2, font, 80)

	set1_text:removeSelf()
	set2_text:removeSelf()
	set1_text 	= 	display.newText(set1   ,display.contentWidth/2 - 20,team1NameDisplay.y,font,20)
	set2_text 	= 	display.newText(set2   ,display.contentWidth/2 + 20,team1NameDisplay.y,font,20)
end

function reset()
	print('reset')
	score1 = 0
	score2 = 0
	update()
end


function scoreCap()
	print(hardCap)
	if hardCap == 0 then --no hardCap
		--team1NameDisplay won
		if (score1 >= 25) and (score1-score2 >= 2) then
			set1 = set1 + 1
			printSetScore()
			score1 = 0
			score2 = 0
		end 
		--team2NameDisplay won
		if (score2 >= 25) and (score2-score1 >= 2) then
			set2 = set2 + 1
			printSetScore()
			score1 = 0
			score2 = 0
		end

	else --hardCap

		if ((score1 == hardCap) or (score2 == hardCap)) then
			set1 = set1 + math.floor(score1/hardCap)
			set2 = set2 + math.floor(score2/hardCap)
			printSetScore()
			score1 = 0
			score2 = 0
		end

	end --hardCap
	update() -- gets always called
end



--All the button handlers

function OkButtonHandler( event )
	
	if (event.phase == "began") then  
		--press down and hold
		OkButton:removeSelf()
		OkButton:removeEventListener("touch", OkButtonHandler)
		OkButton = nil

		OkButton = display.newImageRect("ok button down.gif",120,35)
		OkButton:addEventListener("touch", OkButtonHandler)

		OkButton.xScale = 0.95 -- scale the button on touch release 
		OkButton.yScale = 0.95
		OkButton.x = display.contentWidth/5
		OkButton.y = display.contentHeight*4/5

	elseif (event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then
		OkButton:removeSelf()
		OkButton:removeEventListener("touch", OkButtonHandler)
		
		OkButton = display.newImageRect("ok button.gif",120,35)
		OkButton:addEventListener("touch", OkButtonHandler)
		OkButton.xScale = 1 
		OkButton.yScale = 1
		OkButton.x = display.contentWidth/5
		OkButton.y = display.contentHeight*4/5
 		removeMenu()
	end
end 


function UndoButtonHandler( event )
	
	if (event.phase == "began") then  
		--press down and hold
		UndoButton:removeSelf()
		UndoButton:removeEventListener("touch", UndoButtonHandler)
		UndoButton = nil

		UndoButton = display.newImageRect("undo button down.gif",120,35)
		UndoButton:addEventListener("touch", UndoButtonHandler)

		UndoButton.xScale = 0.95 -- scale the button on touch release 
		UndoButton.yScale = 0.95
		UndoButton.x = display.contentWidth /10
		UndoButton.y = display.contentHeight/10

	elseif (event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then
		UndoButton:removeSelf()
		UndoButton:removeEventListener("touch", UndoButtonHandler)
		
		UndoButton = display.newImageRect("undo button.gif",120,35)
		UndoButton:addEventListener("touch", UndoButtonHandler)
		UndoButton.xScale = 1 
		UndoButton.yScale = 1
		UndoButton.x = display.contentWidth /10
		UndoButton.y = display.contentHeight/10
 		undo()
	end
end 


function MenuButtonHandler( event )
	
	if (event.phase == "began") then  
		--press down and hold
		MenuButton:removeSelf()
		MenuButton:removeEventListener("touch", MenuButtonHandler)
		MenuButton = nil

		MenuButton = display.newImageRect("menu button down.gif",120,35)
		MenuButton:addEventListener("touch", MenuButtonHandler)

		MenuButton.xScale = 0.95 -- scale the button on touch release 
		MenuButton.yScale = 0.95
		MenuButton.x = display.contentWidth/2
		MenuButton.y = display.contentHeight/10

	elseif (event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then
		MenuButton:removeSelf()
		MenuButton:removeEventListener("touch", MenuButtonHandler)
		
		MenuButton = display.newImageRect("menu button.gif",120,35)
		MenuButton:addEventListener("touch", MenuButtonHandler)
		MenuButton.xScale = 1 
		MenuButton.yScale = 1
		MenuButton.x = display.contentWidth/2
		MenuButton.y = display.contentHeight/10
 		removeScoreView()
	end
end 


function ResetButtonHandler( event )
	
	if (event.phase == "began") then  
		--press down and hold
		ResetButton:removeSelf()
		ResetButton:removeEventListener("touch", ResetButtonHandler)
		ResetButton = nil

		ResetButton = display.newImageRect("reset button down.gif",120,35)
		ResetButton:addEventListener("touch", ResetButtonHandler)

		ResetButton.xScale = 0.95 -- scale the button on touch release 
		ResetButton.yScale = 0.95
		ResetButton.x = display.contentWidth*9/10
		ResetButton.y = display.contentHeight/10

	elseif (event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then
		ResetButton:removeSelf()
		ResetButton:removeEventListener("touch", ResetButtonHandler)
		
		ResetButton = display.newImageRect("reset button.gif",120,35)
		ResetButton:addEventListener("touch", ResetButtonHandler)
		ResetButton.xScale = 1 
		ResetButton.yScale = 1
		ResetButton.x = display.contentWidth*9/10
		ResetButton.y = display.contentHeight/10
 		reset()
	end
end 


menu()



