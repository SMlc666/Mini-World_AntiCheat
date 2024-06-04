local lv = {}--对lv进行操作的库
lv.add = function(playerid,lv)
    --print(playerid,lv)
    player[playerid]["lv"] = player[playerid]["lv"] + lv
    return
end
lv.reast = function(playerid)
    player[playerid]["lv"] = 0
    return
end
local runtick = function()
    local tick = {}
    tick.checkfly = function(playerid)
        --print(player)
        --print(player[playerid]["speed"]["vertical"])
        if player[playerid]["movesize"] > 0 then
            if player[playerid]["isinair"] then
                Player:changPlayerMoveType(playerid,2)
                lv.add(playerid,1)
            end
        end
        if player[playerid]["speed"]["vertical"] == 0 then
            if player[playerid]["isinair"] and player[playerid]["horizontal"] ~= 0 then
                Player:changPlayerMoveType(playerid,2)
                lv.add(playerid,1)
            end
        end
        --[[
        if player[playerid]["speed"]["vertical"] > 0 then
           print(player[playerid]["motion"])
        end
        return]]
    end
    tick.checkairjump = function(playerid)
        if player[playerid]["isinair"] then
            if player[playerid]["height"] > 0 then
                if player[playerid]["speed"]["vertical"] > 0 then
                    if player[playerid]["hit"]["tick"] > config.airjump.hittick then
                        lv.add(playerid,1)
                    end
                end
            end
        end
        return
    end
    tick.checklongjump = function (playerid)
        if player[playerid]["jump"]["height"] > config.longjump.height + math.random(0,10) * 0.01 then
            local x,y,z = table.unpack(player[playerid]["pos"][1])
            local code,length = World:getRayLength(x,y,z,x,y-player[playerid]["jump"]["height"]*100,z,player[playerid]["jump"]["height"]*100)
            Player:setPosition(playerid,x,y-length+1.5,z)
            lv.add(playerid,player[playerid]["jump"]["height"]*10)
        end
        return
    end
    tick.checkblockreach = function(playerid)
        if player[playerid]["blockdistance"] > config.reach.block + math.random(0,10) * 0.1 then
            lv.add(playerid,player[playerid]["blockdistance"] - 5)
            player[playerid]["blockdistance"] =0
        end
        return
    end
    tick.checkactorreach = function(playerid)
        if player[playerid]["playerdistance"] > config.reach.actor + math.random(0,10) * 0.1 then
           lv.add(playerid,player[playerid]["playerdistance"] - 3.6)
           player[playerid]["playerdistance"] = 0
        end
    end
    tick.checkban = function(playerid)
        if player[playerid]["lv"] >= config.banlv then
            print(playerid.."are banned")
            lv.reast(playerid)
        end
        return
    end
    for playerid,value in pairs(player) do
        for index,func in pairs(tick) do
           func(playerid) 
        end
    end
end
ScriptSupportEvent:registerEvent("Game.RunTime",runtick)