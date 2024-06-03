player = {}
getdistance = function(target,target1)--计算距离函数
    local x,y,z = target[1],target[2],target[3]
    local x1,y1,z1 = target1[1],target1[2],target1[3]
    local distance = math.sqrt((x-x1)^2+(y-y1)^2+(z-z1)^2)
    return distance
end
getspeedhorizontal = function(target,target1)--计算水平距离及速度的函数
    local x = target[1]
    local x1 = target1[1]
    local z = target[2]
    local z1 = target[2]
    return math.sqrt((x-x1)^2+(z-z1)^2)
end
getspeedvertical = function(y,y1)
    return y-y1
end
getpos = function(pos)
    return pos[1],pos[2],pos[3] 
end
playerenter = function(event)
    local playerid = event.eventobjid
    player[playerid] = {
        lv = 0,--作弊等级
        movesize = 0,--移动方块的数量
        isinair = false,--是否在空中
        motion = 0, --玩家行动状态
        blockdistance = 0,--玩家与挖掘方块的距离
        playerdistance = 0,--玩家与攻击对象的距离
        pos ={},--玩家坐标
        speed = {--速度
            vertical = 0,--垂直速度
            horizontal = 0--水平速度
        },
        jump = {
            height = 0, -- 玩家跳跃高度
            start_pos = {},--开始时的坐标
        }, -- 玩家某次跳跃高度
    }
    for i=1,10 do
        player[playerid]["pos"][i] = {}
    end
    return print(playerid.." enter game")
end
local playerleave = function(event)
    local playerid = eventobjid
    player[playerid] = nil
    return print(playerid.." leave game")
end
local playermotionstage = function(event)
    local playerid = event.eventobjid
    local playermotion = event.playermotion
    if playermotion == 0 then
        player[playerid]["movesize"] = 0
    elseif playermotion == 32 then
        player[playerid]["jump"]["height"] = 0
        player[playerid]["jump"]["start_pos"] = {}
    end
    player[playerid]["motion"] = playermotion
    return 
end
local playermove = function(event)
    local playerid = event.eventobjid
    player[playerid]["movesize"] = player[playerid]["movesize"] + 1
end
local playerclickblock = function(event)
    local playerid = event.eventobjid
    local blockpos = {
        event.x,
        event.y,
        event.z
    }
    local distance = getdistance(player[playerid]["pos"][1],blockpos)
    player[playerid]["blockdistance"] = distance
    return
end
local playerclickactor = function(event)
    local playerid = event.eventobjid
    local targetid = event.toobjid
    local code,targetx,targety,targetz = Actor:getPosition(targetid)
    local blockpos = {
        targetx,
        targety,
        targetz
    }
    local distance = getdistance(player[playerid]["pos"][1],blockpos)
    player[playerid]["playerdistance"] = distance
    return
end
local runtick = function()
    local tick = {}
    tick.playerinair = function(playerid)
        local isinair = Actor:isInAir(playerid)
        player[playerid]["isinair"] = isinair == 0
        return
    end
    tick.playerpos = function(playerid)
        local code,x,y,z = Actor:getPosition(playerid)
        --print(x,y,z)
        for i = 2,10 do
            player[playerid]["pos"][i] = player[playerid]["pos"][i-1]
        end
        player[playerid]["pos"][1] = {
            x,
            y,
            z,
        }
        return
    end
    tick.speed = function(playerid)
        local x,y,z = getpos(player[playerid]["pos"][1])
        local x1,y1,z1 = getpos(player[playerid]["pos"][10])
        if not x or not x1 then
           return 
        end
        local vertical = getspeedvertical(y,y1)
        --print(vertical)
        local horizontal = getspeedhorizontal({x,z},{x1,z1})
        player[playerid]["speed"]["vertical"] = vertical
        player[playerid]["speed"]["horizontal"] = horizontal
        return
    end
    tick.playerjump = function(playerid)
        if player[playerid]["motion"] == 4 then
            if not player[playerid]["jump"]["start_pos"][1] then
                local code,x,y,z = Actor:getPosition(playerid)
                player[playerid]["jump"]["start_pos"] = {x,y,z}
            elseif player[playerid]["speed"]["vertical"] < 0 and player[playerid]["jump"]["height"] == 0 then
                local code,x,y,z = Actor:getPosition(playerid)
                local x1,y1,z1 = getpos(player[playerid]["jump"]["start_pos"])
                local height = getspeedvertical(y,y1)
                player[playerid]["jump"]["height"] = height
            end
        end
        return
    end
    for playerid,value in pairs(player) do
        for index,func in pairs(tick) do
            func(playerid)
        end
    end
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=],playerenter)
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=],playerleave)
ScriptSupportEvent:registerEvent([=[Player.MotionStateChange]=],playermotionstage)
ScriptSupportEvent:registerEvent([=[Player.AttackHit]=],playerclickactor)
ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=],playerclickblock)
ScriptSupportEvent:registerEvent([=[Player.MoveOneBlockSize]=],playermove)
ScriptSupportEvent:registerEvent("Game.RunTime",runtick)