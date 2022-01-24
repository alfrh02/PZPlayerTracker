--**************************************************
--**                PLAYER TRACKER                **
--**              by Alfred/alfrh02 :-)           **
--**                happy hunting.                **
--**************************************************
--**  Thanks to RoboMat & Turbotutone - I ripped  **
--**       the base of this code from their       **
--**           "Coordinate Viewer" mod.           **
--**************************************************

print("Loaded Player Tracker by alfrh02/alfred.")

local FONT_SMALL = UIFont.Small;
local T_MANAGER = getTextManager();

local SCREEN_X = 20;
local SCREEN_Y = 1080/2;

local flag = true;
local flag2 = true;
local floor = math.floor;

local tracker = 0;

---
-- toggles flag depending on if the "[" or "ESC" keys are pressed.
-- also checks for the up and down arrows to cycle through players.
--
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

local function round(num)
	if num == "NULL" then
		return "NULL";
	end
	local number = num;
	return number <= 0 and floor(number) or floor(number + 0.5);
end

---
-- calculates what angle the target is at (in degrees)
--
local function calculateRotation(x1,y1,x2,y2)
    local delta_x = x2 - x1
    local delta_y = y2 - y1
    local radians = math.atan2(delta_y, delta_x)
    return(math.deg(radians))
end

---
-- returns what direction the angles from calculateRotation() are
-- important to note that angle 0 (or forwards) is actually top-right, and not "up".
--
local function degreeTrack(targetX,targetY,PlayerX,PlayerY)
    Pointer = "NULL"
    local rotation = calculateRotation(targetX,targetY,PlayerX,PlayerY)

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

---
-- W.I.P.
--
Target = getSpecificPlayer(0);
local function OnServerStarted()
	local variable = getOnlinePlayers();
	Target = variable:get(tracker);
	if Target[1] and flag2 then
		Hunter = Target[0]:getUsername(); --player 1 is assigned as "Hunter"
		Hunted = Target[1]:getUsername(); --player 2 is assigned as "Hunted"
		flag2 = false;
		print("Hunter + Prey assigned to " .. Hunter .. " and " .. Hunted);
	end
end
---
-- defines certain variables based on the presence of another player. If offline, Target is equal to the player themself and will always return true.
--
local function getTargetInfo()
	Player = getSpecificPlayer(0);

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
-- Creates the text overlay to display coordinates+. Dependent on flag returning true, which is toggled by the "[" or "ESC" keys as defined in checkKey() above.
-- 
local function showUI()
	local huntee 
	if Hunted == getSpecificPlayer(0):getUsername() then
		huntee = true;
	else
		huntee = false;
	end

	if not huntee then
		if Player and flag then
			local room = Player:getCurrentSquare():getRoom();
			local roomTxt;
			if room then
				local roomName = Player:getCurrentSquare():getRoom():getName();
				roomTxt = roomName;
			else
				roomTxt = "outside";
			end

			local strings = {
				"You are here:",
				"X: " .. round(PlayerX),
				"Y: " .. round(PlayerY),
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
		if Player and flag and Target then
			local room = Target:getCurrentSquare():getRoom();
			local roomTxt;
			if room then
				local roomName = Target:getCurrentSquare():getRoom():getName();
				roomTxt = roomName;
			else
				roomTxt = "outside";
			end

			local strings = {
				"Your target is here:",
				"X: " .. round(TargetX),
				"Y: " .. round(TargetY),
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
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)
		end
		if Player and flag and not Target then
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
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X,SCREEN_Y+130, "You are tracking " .. TargetUsername .. ".", 1, 1, 1, 1)
		end
	end
end

--[[
-- debug function
function Debugfunc()
	local variable = getOnlinePlayers();
	local player1 = variable:get(1)
	print(player1:getX());
end
]]--

Events.OnKeyPressed.Add(checkKey);
Events.OnTickEvenPaused.Add(getTargetInfo);
Events.OnPostUIDraw.Add(showUI);
--Events.EveryOneMinute.Add(Debugfunc);
Events.OnServerStarted.Add(OnServerStarted);