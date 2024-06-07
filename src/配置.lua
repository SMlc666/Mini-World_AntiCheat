config = {
    banlv = 5,--封禁的临界值
    blockreach = {--长臂猿检测
        status = true,--是否开启长臂猿检测
        distance = 5.1,--玩家极限挖掘距离
    },--物块长臂猿检测
    actorreach = {
        status = true,--是否开启实体长臂猿检测
        distance = 3.6,--玩家极限攻击距离
    },--实体长臂猿检测
    fly = {
        status =true,--是否开启飞行检测
        onlyinair = true,--只在空中时进行检测
        inairtick = 40,--允许的空中持续时间
    },--飞行检测
    highjump = {
        status = true,--是否开启长跳检测
        height = 0.3,--玩家极限跳跃高度
    },--跳高检测
    airjump = {
        status = true,--是否开启空中跳跃检测
        hittick = 40,--允许的受击间隔
        height = 0.1--允许的两次跳跃之间的距离
    },--空中跳跃检测
}