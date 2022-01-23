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

---
-- Creates a small overlay UI that shows debug info if the
-- [ key is pressed.
local function showUI()
	local player = getSpecificPlayer(0);
	-- local target = getSpecificPlayer(1)

	if player and flag then
		-- Absolute Coordinates.
		local absX = player:getX();
		local absY = player:getY();

		local targetX = 100 --target:getX()
		local targetY = 100 --target:getX()
	
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

		--[[
		local targetRoomName = target:getCurrentSquare():getRoom();
		local targetRoomTxt;
		if targetRoomName then
			local targetRoomName = target:getCurrentSquare():getRoom():getName();
			targetRoomTxt = targetRoomName;
		else
			targetRoomTxt = "outside";
		end
		]]

		local targetstrings = {
			"Your target is here:",
			"X: " .. round(targetX),
			"Y: " .. round(targetY),
			"",
			"",
			"Current Room: ",
			"" .. roomTxt--targetRoomTxt,
		};

		local targettxt;
		for i = 1, #targetstrings do
			targettxt = targetstrings[i];
			T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), targettxt, 1, 1, 1, 1);
		end
		T_MANAGER:DrawString(FONT_SMALL, SCREEN_X+100, SCREEN_Y + (i * 10), targettxt, 1, 1, 1, 1);
	end
end

Events.OnKeyPressed.Add(checkKey);
Events.OnPostUIDraw.Add(showUI);

Events.OnGameBoot.Add(initInfo);
