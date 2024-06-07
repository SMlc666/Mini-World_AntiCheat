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
getpos = function (pos)
    return pos[1],pos[2],pos[3]
end