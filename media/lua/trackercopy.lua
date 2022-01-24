--**************************************************
--**                player TRACKER                **
--**              by Alfred/alfrh02 :-)           **
--**                happy hunting.                **
--**************************************************
--**  Thanks to RoboMat & Turbotutone - I ripped  **
--**       the base of this code from their       **
--**           "Coordinate Viewer" mod.           **
--**************************************************
print("Loaded player Tracker by alfrh02/alfred.")

local FONT_SMALL = UIFont.Small;
local T_MANAGER = getTextManager();

local SCREEN_X = 20;
local SCREEN_Y = 1080/2;

local flag = true;
local floor = math.floor;

local tracker = 0;
local player = getSpecificplayer(0);
local playerUsername = player:getUsername();

local target = getSpecificplayer(0);

local targetX = "NULL";
local targetY = "NULL";

local playerX = "NULL";
local playerY = "NULL";

local function round(num)
	if num == "NULL" then
		return "NULL";
	end
	local number = num;
	return number <= 0 and floor(number) or floor(number + 0.5);
end

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

local function calculateRotation(x1,y1,x2,y2)
    local delta_x = x2 - x1
    local delta_y = y2 - y1
    local radians = math.atan2(delta_y, delta_x)
    return(math.deg(radians))
end

local function degreeTrack(targetX,targetY,playerX,playerY)
    Pointer = "NULL"
    local rotation = calculateRotation(targetX,targetY,playerX,playerY)

    --POSITIVE DEGREES (right)
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

    --NEGATIVE DEGREES (left)
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

local function gettargetInfo()
	playerX = player:getX();
	playerY = player:getY();

    if isServer() then
        local variable = getOnlinePlayers();
	    target = variable:get(tracker);
    end

	if target then
		targetX = target:getX();
        targetY = target:getY();
		targetUsername = target:getUsername();
		Direction = degreeTrack(targetX,targetY,playerX,playerY);
	else
		targetX = "NULL";
		targetY = "NULL";
		targetUsername = "player " .. tracker+1;
	end
end

local function showUI()
	if player and flag then
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

	if player and flag and target then
		local room = target:getCurrentSquare():getRoom();
		local roomTxt;
		if room then
			local roomName = target:getCurrentSquare():getRoom():getName();
			roomTxt = roomName;
		else
			roomTxt = "outside";
		end

		local strings = {
			"Your target is here:",
			"X: " .. round(targetX),
			"Y: " .. round(targetY),
			"",
			"",
			"Current Room: ",
			roomTxt,
		}

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, "Your target is " .. Direction .. ".", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. targetUsername .. ".", 1, 1, 1, 1)
	end

	if player and flag and not target then
		local strings = {
			"Your target is here:",
			"X: --",
			"Y: --",
			"",
			"",
			"Current Room: ",
			"--",
		}

		local txt;
		for i = 1, #strings do
			txt = strings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), txt, 1, 1, 1, 1);
		end

		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X, SCREEN_Y+100, "Your target is NULL.", 1, 1, 1, 1);
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. targetUsername .. ".", 1, 1, 1, 1)
	end
end

Events.OnKeyPressed.Add(checkKey);
Events.OnTickEvenPaused.Add(gettargetInfo);
--Events.EveryOneMinute.Add(Debugfunc);
Events.OnPostUIDraw.Add(showUI);