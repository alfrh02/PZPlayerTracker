--**************************************************
--**                PLAYER TRACKER                **
--**              by Alfred/alfrh02 :-)           **
--**                happy hunting.                **
--**************************************************
--**  Thanks to RoboMat & Turbotutone - I ripped  **
--**       the base of this code from their       **
--**           "Coordinate Viewer" mod.           **
--**************************************************

local FONT_SMALL = UIFont.Small;
local T_MANAGER = getTextManager();

local SCREEN_X = 20;
local SCREEN_Y = 1080/2;

local flag = true;
local floor = math.floor;

local tracker = 0;

-- ------------------------------------------------
-- Functions
-- ---------------------------------------------
---
-- Checks if the [ key is pressed to activate / deactivate the
-- debug menu.
-- @param _key - The key which was pressed by the player.
-----
local function checkKey(key)
	if (key == 26 or key == 1) then
		flag = not flag; -- reverse flag
	end
	if (key == 200) then
		tracker = tracker+1;
	end
	if (key == 208) then
		tracker = tracker-1
		if (tracker < 0) then
			tracker = 0;
		end
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
local function degreeTrack(targetX,targetY,playerX,playerY)
    Pointer = "NULL"
    local rotation = calculateRotation(targetX,targetY,playerX,playerY)

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
local function getTargetInfo()
	Target = getSpecificPlayer(tracker);

	TargetX = Target:getX()
	TargetY = Target:getY()
end

local function showUI()
	local player = getSpecificPlayer(0);

	if player and flag then
        --SendCommandToServer("/godmod alfred");
		local playerX = player:getX();
		local playerY = player:getY();
	
		----------------------------------------[[player]]----------------------------------------
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
			"X: " .. round(playerX),
			"Y: " .. round(playerY),
			"",
			"",
			"Current Room: ",
			roomTxt,
		};

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end
	end
	if player and Target and flag then

		local playerX = player:getX();
		local playerY = player:getY();

		----------------------------------------[[target]]----------------------------------------
		local targetRoomName = Target:getCurrentSquare():getRoom();
		local targetRoomTxt;
		if targetRoomName then
			local targetRoomName = Target:getCurrentSquare():getRoom():getName();
			targetRoomTxt = targetRoomName;
		else
			targetRoomTxt = "outside";
		end
		

		local strings = {
			"Your target is here:",
			"X: " .. round(TargetX),
			"Y: " .. round(TargetY),
			"",
			"",
			"Current Room: ",
			targetRoomTxt,
		};

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		local direction = "Your target is " .. degreeTrack(TargetX,TargetY,playerX,playerY) .. "."
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, direction, 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. Target:getUsername(), 1, 1, 1, 1)
	end
	if player and not Target and flag then
		local targetX = 0
		local targetY = 0

		----------------------------------------[[null]]----------------------------------------		
		local strings = {
			"Your target is here:",
			"X: " .. round(targetX),
			"Y: " .. round(targetY),
			"",
			"",
			"Current Room: ",
			"NULL" ,
		};

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end
		
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, "Your target is NULL", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking NULL", 1, 1, 1, 1)
	end
end

Events.OnKeyPressed.Add(checkKey);
Events.OnPlayerMove.Add(getTargetInfo);
Events.OnPostUIDraw.Add(showUI);
Events.OnMainMenuEnter.Remove(showUI);