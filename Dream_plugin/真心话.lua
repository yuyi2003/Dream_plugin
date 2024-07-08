Truth={
    player={name=0,qq=0,num=0,next=0};
    msg={
        addfalse="{name}已经骰过点了 骰点结果:{num}";
        addtrue="{name}骰点成功 骰点结果:{num}";
        check="玩家:{name} 骰点结果:{num}\n";
    };
    func={};
}

function Truth.func.Tfile(group)--文件路径
    local file="Truth/"..group
    return file
end
--Truth.func.
function Truth.func.atmsg(moudle)--@某人
    local message="#{AT-"..moudle.qq.."}"
    return message
end

function Truth.func.addin(msg)--加入
    local file=Truth.func.Tfile(msg.fromGroup)
    local player=dream.api.getUserConf("玩家",msg.fromQQ,file)
    if dream.api.getUserConf("时间","Truth",file)==nil then
        dream.api.setUserConf("时间",os.time(),"Truth",file)
    end
    if dream.api.getUserConf("时间",msg.fromQQ,file)==dream.api.getUserConf("时间","Truth",file) then
        return Truth.msg.addfalse:gsub("{name}",player.name):gsub("{num}",player.num)
    else
        local player=table.clone(Truth.player)
        player.qq=msg.fromQQ
        player.name=msg.fromGroupNick
        player.num=sdk.randomInt(1,100)
        player.next=(dream.api.getUserConf("顶指针","Truth",file) or 0)
        dream.api.setUserConf("玩家",player,msg.fromQQ,file)
        dream.api.setUserConf("时间",dream.api.getUserConf("时间","Truth",file),msg.fromQQ,file)
        dream.api.setUserConf("顶指针",msg.fromQQ,"Truth",file)
        return Truth.msg.addtrue:gsub("{name}",player.name):gsub("{num}",player.num)
    end
end
dream.keyword.set("Truth","真心话加入",Truth.func.addin)

function Truth.func.checkout(msg)--查看
    local file=Truth.func.Tfile(msg.fromGroup)
    local p=dream.api.getUserConf("顶指针","Truth",file)
    local message=""
    while p~=0 do
        p=tostring(p)
        local player=dream.api.getUserConf("玩家",p,file)
        local check=Truth.msg.check:gsub("{name}",player.name):gsub("{num}",player.num)
        message=message..check
        p=player.next
    end
    return message
end
dream.keyword.set("Truth","真心话查看",Truth.func.checkout)

function Truth.func.checknum(file)--比较最大最小
    local p=dream.api.getUserConf("顶指针","Truth",file)
    local min=nil
    local max=nil
    while p~=0 do
        p=tostring(p)
        local player=dream.api.getUserConf("玩家",p,file)
        if min==nil then min=player end
        if max==nil then max=player end
        if min.num>player.num then  min=player end
        if max.num<player.num then  max=player end
        p=player.next
    end
    return min,max
end

function Truth.func.restartT(msg)--重置
    local file=Truth.func.Tfile(msg.fromGroup)
    local message="重置成功\n"
    if dream.api.getUserConf("顶指针","Truth",file)~=0 then
        message=message..Truth.func.checkout(msg)
        local min,max=Truth.func.checknum(file)
        local message1="#{MULT} "..Truth.func.atmsg(max).." 问 "..Truth.func.atmsg(min)
        message=message..message1
        dream.api.setUserConf("时间",os.time(),"Truth",file)
        dream.api.setUserConf("顶指针",0,"Truth",file)
    end
    return message
end
dream.keyword.set("Truth","真心话重置",Truth.func.restartT)

return {
    id = "Truth",
    version = "2.0.0",
    help = "--真心话--\n真心话加入\n真心话查看\n真心话重置--查看结果",
    author = "雨岚之忆",
    mode = true
  }