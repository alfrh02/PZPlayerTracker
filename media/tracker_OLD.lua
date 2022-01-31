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
-- @param _key - The key which was pressed by the Player.
-----
local function checkKey(key)
	if (key == 26 or key == 1) then
		flag = not flag; -- reverse flag
	end
	-- up and down to change tracker
	if (key == 200 and flag) then
		tracker = tracker+1;
		if (tracker > 1) then
			tracker = 0;
		end
	end
	if (key == 208 and flag) then
		tracker = tracker-1
		if (tracker < 0) then
			tracker = 0;
		end
	end
	-- left and right to change hunter
	--[[
	if (key == 205) then
		hunterNumber = hunterNumber+1
	end
	if (key == 203) then
		hunterNumber = hunterNumber-1
		if (hunterNumber<0) then
			hunterNumber = 0;
		end
	end
	]]--
end
---
-- Round up if decimal is higher than 0.5 and down if it is smaller.
-- @param num
--
local function round(num)
	if num == "NULL" then
		return "NULL";
	end
	local number = num;
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
local function degreeTrack(targetX,targetY,PlayerX,PlayerY)
    Pointer = "NULL"
    local rotation = calculateRotation(targetX,targetY,PlayerX,PlayerY)

    --POSITIVE DEGREES
    if rotation > -22.5 and rotation < 22.5 then
        Pointer = "WEST (top left)"
    end
    if rotation > 22.5 and rotation < 67.5 then
        Pointer = "NORTH_WEST (up)"
    end
    if rotation > 67.5 and rotation < 112.5 then
        Pointer = "NORTH (top right)"
    end
    if rotation > 112.5 and rotation < 157.5 then
        Pointer = "NORTH-EAST (right)"
    end
    if rotation > 157.5 and rotation <= 180 then
        Pointer = "EAST (bottom right)"
    end

    --NEGATIVE DEGREES
    if rotation < -22.5 and rotation > -67.5 then
        Pointer = "SOUTH-WEST (left)"
    end
    if rotation < -67.5 and rotation > -112.5 then
        Pointer = "SOUTH (bottom left)"
    end
    if rotation < -112.5 and rotation > -157.5 then
        Pointer = "SOUTH-EAST (down)"
    end
    if rotation < -157.5 and rotation > -180 then
        Pointer = "EAST (bottom right)"
    end
    return Pointer;
end

local gameStarted = false;
local function OnGameStart()
	gameStarted = true; 
end

local function getTargetInfo()
	Player = getSpecificPlayer(0);
	Target = getSpecificPlayer(0);

	local players = getOnlinePlayers();
	if players and gameStarted then
		if players:get(tracker) then
			Target = players:get(tracker)
		else
			Target = getSpecificPlayer(0);
		end
		if Player:getUsername() ~= players:get(0):getUsername() then
			flag = false
		end
	end

	PlayerX = Player:getX();
	PlayerY = Player:getY();

	if Target then
		TargetX = Target:getX();
		TargetY = Target:getY();
		TargetUsername = Target:getUsername();
		Direction = degreeTrack(TargetX,TargetY,PlayerX,PlayerY);
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
	if Player and flag then
		--[[
		local room = Player:getCurrentSquare():getRoom();
		local roomTxt;
		if room then
			local roomName = Player:getCurrentSquare():getRoom():getName();
			roomTxt = roomName;
		else
			roomTxt = "outside";
		end
		]]
		local strings = {
			"You are here:",
			"X: " .. round(PlayerX),
			"Y: " .. round(PlayerY),
			"",
			"",
			--"Current Room: ",
			--roomTxt,
		};

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end
	end
	if Player and flag and Target then
		--[[
		local room = Target:getCurrentSquare():getRoom(); --
		local roomTxt;
		if room then
			local roomName = Target:getCurrentSquare():getRoom():getName();
			roomTxt = roomName;
		else
			roomTxt = "outside";
		end
		]]--
		local strings = {
			"Your target is here:",
			"X: " .. round(TargetX),
			"Y: " .. round(TargetY),
			"",
			"",
			--"Current Room: ",
			--roomTxt,
		}

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, "Your target is " .. Direction .. ".", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)
	end
	if Player and flag and not Target then
		local strings = {
			"Your target is here:",
			"X: --",
			"Y: --",
			"",
			"",
			--"Current Room: ",
			--"--",
		}

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			PlayerX = Player:getX();
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, "Your target is NULL.", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)
	end
end

--[[
function Debugfunc()
	local players = getOnlinePlayers();
	local player1 = players:get(1)
	print(player1:getX());
end
]]--

Events.OnKeyPressed.Add(checkKey);
Events.OnTickEvenPaused.Add(getTargetInfo);
Events.OnPostUIDraw.Add(showUI);
--Events.EveryOneMinute.Add(Debugfunc);
Events.EveryOneMinute.Add(OnGameStart)

local function degreeTrack(targetX,targetY,PlayerX,PlayerY)
    local pointer = "NULL"

	local radians = math.atan2(playerX - targetX, playerY - targetY)
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