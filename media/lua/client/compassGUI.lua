-- =============================================================================
-- COORDINATE VIEWER
-- by RoboMat & Turbotutone
-- 
-- Created: 07.08.13 - 21:31
--
-- Not my most elegant code, but it works :D
-- =============================================================================

local FONT_SMALL = UIFont.Small;
local T_MANAGER = getTextManager();

local SCREEN_X = 20;
local SCREEN_Y = 1080/2;

local flag = true;
local floor = math.floor;

-- ------------------------------------------------
-- Functions
-- ------------------------------------------------
---
-- Checks if the [ key is pressed to activate / deactivate the
-- debug menu.
-- @param _key - The key which was pressed by the player.
--
local function checkKey(_key)
	local key = _key;
	if key == 26 then
		flag = not flag; -- reverse flag
	end
end

---
-- Round up if decimal is higher than 0.5 and down if it is smaller.
-- @param _num
--
local function round(_num)
	local number = _num;
	return number <= 0 and floor(number) or floor(number + 0.5);
end

local function calculateRotation(x1,y1,x2,y2)
    local delta_x = x2 - x1
    local delta_y = y2 - y1
    local radians = math.atan2(delta_y, delta_x)
    return(math.deg(radians))
end

---
-- return what direction the target is at
--
local function degreeTrack(playerX,playerY,targetX,targetY)
    Pointer = "NULL"
    local rotation = calculateRotation(playerX,playerY,targetX,targetY)

    --POSITIVE DEGREES
    if rotation > -22.5 and rotation < 22.5 then
        Pointer = "WEST"
    end
    if rotation > 22.5 and rotation < 67.5 then
        Pointer = "NORTH_WEST"
    end
    if rotation > 67.5 and rotation < 112.5 then
        Pointer = "NORTH"
    end
    if rotation > 112.5 and rotation < 157.5 then
        Pointer = "NORTH-EAST"
    end
    if rotation > 157.5 and rotation <= 180 then
        Pointer = "EAST"
    end

    --NEGATIVE DEGREES
    if rotation < -22.5 and rotation > -67.5 then
        Pointer = "SOUTH-WEST"
    end
    if rotation < -67.5 and rotation > -112.5 then
        Pointer = "SOUTH"
    end
    if rotation < -112.5 and rotation > -157.5 then
        Pointer = "SOUTH-EAST"
    end
    if rotation < -157.5 and rotation > -180 then
        Pointer = "EAST"
    end
    return Pointer;
end

---
-- Creates a small overlay UI that shows debug info if the
-- [ key is pressed.
local function showUI()
	local player = getSpecificPlayer(0);
	local target = getSpecificPlayer(1)

	if player and flag then
		-- Absolute Coordinates.
		local absX = player:getX();
		local absY = player:getY();

		local targetX = target:getX()
		local targetY = target:getX()
	
		-- Detect room.
		local room = player:getCurrentSquare():getRoom();
		local roomTxt;
		if room then
			local roomName = player:getCurrentSquare():getRoom():getName();
			roomTxt = roomName;
		else
			roomTxt = "outside";
		end

		local strings = {
			"You are here:",
			"X: " .. round(absX),
			"Y: " .. round(absY),
			"",
			"",
			"Current Room: ",
			"" .. roomTxt,
		};

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		
		local targetRoomName = target:getCurrentSquare():getRoom();
		local targetRoomTxt;
		if targetRoomName then
			local targetRoomName = target:getCurrentSquare():getRoom():getName();
			targetRoomTxt = targetRoomName;
		else
			targetRoomTxt = "outside";
		end
		

		local targetstrings = {
			"Your target is here:",
			"X: " .. round(targetX),
			"Y: " .. round(targetY),
			"",
			"",
			"Current Room: ",
			"" .. targetRoomTxt,
		};

		local targettxt;
		for i = 1, #targetstrings do
			targettxt = targetstrings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), targettxt, 1, 1, 1, 1);
		end
		local direction = "Your target is " .. degreeTrack(absX,absY,targetX,targetY)
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, direction, 1, 1, 1, 1);
	end
end

Events.OnKeyPressed.Add(checkKey);
Events.OnPostUIDraw.Add(showUI);
