local lv = {}--对lv进行操作的库
lv.add = function(playerid,lv,message)
    --print(playerid,lv)
    player[playerid]["ban"]["lv"] = player[playerid]["ban"]["lv"] + lv
    player[playerid]["ban"]["message"] = message
    print(message,player[playerid]["motion"])
    return
end
lv.reast = function(playerid)
    player[playerid]["ban"]["lv"] = 0
    return
end
local runtick = function()
    local tick = {}
    tick.checkfly = function(playerid)
        if config.fly.status then
            --print(player)
            --print(player[playerid]["speed"]["vertical"])
            if player[playerid]["air"]["isinair"] or config.fly.onlyinair then
                if player[playerid]["air"]["tick"] >= config.fly.airtick then
                    if player[playerid]["movesize"] > 0 then
                        --Player:changPlayerMoveType(playerid,2)
                        lv.add(playerid,1,"fly")
                    end
                    if player[playerid]["speed"]["vertical"] == 0 then
                        if player[playerid]["horizontal"] ~= 0 then
                            --Player:changPlayerMoveType(playerid,2)
                            lv.add(playerid,1,"fly1")
                        end
                    end
                end
            end
            --[[
            if player[playerid]["speed"]["vertical"] > 0 then
            print(player[playerid]["motion"])
            end]]
        end
        return
    end
    tick.checkairjump = function(playerid)
        if config.airjump.status then
            if player[playerid]["air"]["isinair"] or player[playerid]["air"]["isinair"] == config.airjump.onlyinair then
                if player[playerid]["air"]["tick"] >= config.airjump.airtick then
                    if (function () if player[playerid]["jump"]["height"] and player[playerid]["jump"]["height"] > 0 then return true else return false end end)()  then
                        if player[playerid]["speed"]["vertical"] > 0 then
                            if player[playerid]["hit"]["tick"] > config.airjump.hittick then
                                local x,y,z = getpos(player[playerid]["pos"][1])
                                local distance = getspeedvertical(y,player[playerid]["jump"]["start_pos"][2])
                                if distance - player[playerid]["jump"]["height"] >= config.airjump.height  then
                                    lv.add(playerid,1,"airjump")
                                end
                            end
                        end
                    end
                end
            end
        end
        return
    end
    tick.checkhighjump = function (playerid)
        if config.highjump.status then
            if player[playerid]["jump"]["height"] > config.highjump.height + math.random(0,10) * 0.01 then
                local x,y,z = getpos(player[playerid]["pos"][1])
                local code,length = World:getRayLength(x,y,z,x,y-player[playerid]["jump"]["height"]*100,z,player[playerid]["jump"]["height"]*100)
                Player:setPosition(playerid,x,y-length+1.5,z)
                lv.add(playerid,player[playerid]["jump"]["height"]*10,"highjump")
            end
        end
        return
    end
    tick.checkblockreach = function(playerid)
        if config.blockreach.status then
            if player[playerid]["blockdistance"] > config.blockreach.distance + math.random(0,10) * 0.1 then
                lv.add(playerid,player[playerid]["blockdistance"] - config.blockreach.distance,"blockreach")
                player[playerid]["blockdistance"] =0
            end
        end
        return
    end
    tick.checkactorreach = function(playerid)
        if config.actorreach.status then
            if player[playerid]["playerdistance"] > config.actorreach.distance + math.random(0,10) * 0.1 then
            lv.add(playerid,player[playerid]["playerdistance"] - config.actorreach.distance,"actorreach")
            player[playerid]["playerdistance"] = 0
            end
        end
    end
    tick.checkban = function(playerid)
        if player[playerid]["ban"]["lv"] >= config.banlv then
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