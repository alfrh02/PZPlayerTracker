--**************************************************
--**                PLAYER TRACKER                **
--**               by Alfred/alfrh02 :-)          **
--**                Happy Hunting                 **
--**************************************************

local function calculateDistance(x1,y1,x2,y2)
    local i = (x2 - x1) * (x2 - x1);
    local y = (y2 - y1) * (y2 - y1);
    local distance = i + y;
    distance = math.sqrt(distance);
    return round(distance)
end

local function calculateRotation(x1,y1,x2,y2)
    local delta_x = x2 - x1
    local delta_y = y2 - y1
    local radians = math.atan2(delta_y, delta_x)
    return(math.deg(radians))
end

local function round(i)
    return (math.floor(i))
end

local function degreeTrack(playerX,playerY,targetX,targetY)
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

local function trackPlayer()
	local player = getSpecificPlayer(0)
    local x = player:getX()
    local y = player:getY()
    
    local target = getSpecificPlayer(1)
    local targetX = 10700 --target:getX()
    local targetY = 9400 --target:getX()
    --print(compassTrack(round(x),round(y),targetX,targetY))
    --print(calculateDistance(round(x),round(y),targetX,targetY))
    print(round(calculateRotation(round(x),round(y),targetX,targetY)))
    print(degreeTrack(round(x),round(y),targetX,targetY))

    return degreeTrack(round(x),round(y),targetX,targetY)
end

Events.OnPlayerMove.Add(trackPlayer)
