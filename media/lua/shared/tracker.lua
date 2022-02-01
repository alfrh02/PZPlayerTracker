--**************************************************
--**                PLAYER TRACKER                **
--**              by Alfred/alfrh02 :-)           **
--**                happy hunting                 **
--**************************************************
--**  Thanks to RoboMat & Turbotutone - I ripped  **
--**       the base of this code from their       **
--**           "Coordinate Viewer" mod.           **
--**************************************************

local FONT_SMALL = UIFont.Small;
local T_MANAGER = getTextManager();

local SCREEN_X = 20
local SCREEN_Y = getPlayerScreenHeight(0)/2.25;


local flag = true;
local floor = math.floor;

local tracker = 0;

local onlineConnected = false;

-- ------------------------------------------------
-- Functions
-- ---------------------------------------------
---
-- Checks if the [ key is pressed to activate / deactivate the
-- debug menu.
-- @param _key - The key which was pressed by the player.
-----
local function checkKey(key)
	if key == 26 then --[
		flag = not flag; -- reverse flag
	end
	if key == 200 then -- up arrow
		tracker = tracker+1;
		if onlineConnected and tracker > players:size()then
			tracker = players:size()
		end
	end
	if key == 208 then -- down arrow
		tracker = tracker-1
		if tracker < 0 then
			tracker = 0;
		end
	end
	if key == 199 or key == 210 then -- home key
		onlineConnected = true;
		tracker = 1;
	end
end
---
-- Round up if decimal is higher than 0.5 and down if it is smaller.
-- @param num
--
local function round(num)
	local number = num;
	return number <= 0 and floor(number) or floor(number + 0.5);
end

---
-- return what direction the target is at
--
local function degreeTrack(targetX,targetY,playerX,playerY)
    local pointer = "NULL"

	local radians = math.atan2(playerY - targetY, playerX - targetX)
	local rotation = math.deg(radians)

    			--POSITIVE DEGREES--
    if rotation > -22.5 and rotation < 22.5 then
        pointer = "WEST (top left)"
    end
    if rotation > 22.5 and rotation < 67.5 then
        pointer = "NORTH_WEST (up)"
    end
    if rotation > 67.5 and rotation < 112.5 then
        pointer = "NORTH (top right)"
    end
    if rotation > 112.5 and rotation < 157.5 then
        pointer = "NORTH-EAST (right)"
    end
    if rotation > 157.5 and rotation <= 180 then
        pointer = "EAST (bottom right)"
    end

    			--NEGATIVE DEGREES--
    if rotation < -22.5 and rotation > -67.5 then
        pointer = "SOUTH-WEST (left)"
    end
    if rotation < -67.5 and rotation > -112.5 then
        pointer = "SOUTH (bottom left)"
    end
    if rotation < -112.5 and rotation > -157.5 then
        pointer = "SOUTH-EAST (down)"
    end
    if rotation < -157.5 and rotation > -180 then
        pointer = "EAST (bottom right)"
    end

    return pointer;
end

local function getTargetInfo()
	player = getSpecificPlayer(0);
	players = getOnlinePlayers();

	if onlineConnected then
		if players:size() == 0 then
			onlineConnected = false;
		end
		Target = players:get(tracker);
	else
		Target = getSpecificPlayer(0);
	end

	playerX = player:getX();
	playerY = player:getY();

	if Target then
		TargetX = Target:getX();
		TargetY = Target:getY();
		TargetUsername = Target:getUsername();
		Direction = degreeTrack(TargetX,TargetY,playerX,playerY);
	else
		TargetX = "NULL";
		TargetY = "NULL";
		TargetUsername = "player " .. tracker+1;
	end
end

---
-- Creates a small overlay UI that shows debug info if the
-- [ key is pressed.
local function showUI()
	if player and flag then
		-- local room = player:getCurrentSquare():getRoom();
		-- local roomTxt;
		-- if room then
		-- 	local roomName = player:getCurrentSquare():getRoom():getName();
		-- 	roomTxt = roomName;
		-- else
		-- 	roomTxt = "outside";
		-- end

		local strings = {
			"You are here:",
			"X: " .. round(playerX),
			"Y: " .. round(playerY),
			"",
			"",
			-- "Current Room: ",
			-- roomTxt,
		};

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end
	end
	if player and flag and Target then
		-- local room = Target:getCurrentSquare():getRoom();
		-- local roomTxt;
		-- if room then
		-- 	local roomName = Target:getCurrentSquare():getRoom():getName();
		-- 	roomTxt = roomName;
		-- else
		-- 	roomTxt = "outside";
		-- end

		local strings = {
			"Your target is here:",
			"X: " .. round(TargetX),
			"Y: " .. round(TargetY),
			"",
			"",
			-- "Current Room: ",
			-- roomTxt,
		}

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+50, "Your target is " .. Direction .. ".", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+70, "You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)
		
		-- centre text below the player. uses MeasureStringX() which returns length of text. length of text is then used to take away from the player's screen's width.
		-- screenwidth / 2 - screenwidth * textlength / 2
		local stringX = T_MANAGER:MeasureStringX(FONT_SMALL, getText("Your target is " .. Direction .. ".")) / 1920

		T_MANAGER:DrawString(FONT_SMALL, 
		getPlayerScreenWidth(0)/2 - getPlayerScreenWidth(0)*stringX / 2, 
		getPlayerScreenHeight(0) /1.65, 
		"Your target is " .. Direction .. ".", 1, 1, 1, 1);

		stringX = T_MANAGER:MeasureStringX(FONT_SMALL, getText("You are tracking " .. TargetUsername .. ".")) / 1920

		T_MANAGER:DrawString(FONT_SMALL, 
		getPlayerScreenWidth(0)/2 - getPlayerScreenWidth(0)*stringX / 2, 
		getPlayerScreenHeight(0) /1.60, 
		"You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)

	end
	if player and flag and not Target then
		-- local strings = {
		-- 	"Your target is here:",
		-- 	"X: --",
		-- 	"Y: --",
		-- 	"",
		-- 	"",
		-- 	"Current Room: ",
		-- 	"--",
		-- }

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, "Your target is NULL.", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)
	end
end

function OnCharacterDeath() 
	onlineConnected = false;
end

--[[
function Debugfunc()
	local variable = getOnlinePlayers();
	local player1 = variable:get(1)
	print(player1:getX());
end
]]--

Events.OnKeyPressed.Add(checkKey);
Events.OnTickEvenPaused.Add(getTargetInfo);
Events.OnPostUIDraw.Add(showUI);
Events.OnCharacterDeath.Add(OnCharacterDeath);
--Events.EveryOneMinute.Add(Debugfunc);
--Events.OnServerStarted.Add(OnServerStarted);