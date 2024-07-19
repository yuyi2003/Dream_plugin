Boomnum={
    msg={
        addfalse1="{nick}您已经加入游戏了，请等待开局\n位置:{place}";
        addfalse2="游戏已经开始，请等待游戏结束再加入游戏";
        addtrue="#{AT-{qq}}加入游戏成功，请等待游戏开始\n位置:{place}";
        check1="{player} 位置:{place} 状态:{state}\n";
    };
    player={qq=0;nick=0;place=0;next=0;state="存活";};
    func={}
}

function Boomnum.func.Bfile(group)
    local file="Numboom/"..group
    return file
end

function Boomnum.func.setup(file)
    local num=dream.api.getUserConf("Dice","Numboom",file) or 100
    return num
end

function Boomnum.func.playeradd(msg)
    local file=Boomnum.func.Bfile(msg.fromGroup)
    local mode=1
    if mode==1 then
        local state=dream.api.getUserConf("数字炸弹","boom",file)
        if state==1 then
            local tall=dream.api.getUserConf("数字炸弹人数","boom",file) or 0
            tall=tall+1

            local player=dream.api.getUserConf("玩家",msg.fromQQ,file)
            if dream.api.getUserConf("数字炸弹时间","boom",file)==nil then
                dream.api.setUserConf("数字炸弹时间",os.time(),"boom",file)
            end
            if dream.api.getUserConf("数字炸弹时间",msg.fromQQ,file)==dream.api.getUserConf("数字炸弹时间","boom",file) then
                return Boomnum.msg.addfalse1:gsub("{place}",player.place):gsub("{nick}",msg.fromGroupNick)
            else
                dream.api.setUserConf("数字炸弹时间",dream.api.getUserConf("数字炸弹时间","boom",file),msg.fromQQ,file)
                player=table.clone(Boomnum.player)
                player.qq=msg.fromQQ
                player.nick=msg.fromGroupNick
                player.place=tall
                player.next=dream.api.getUserConf("数字炸弹堆顶","boom",file) or 0
                dream.api.setUserConf("数字炸弹堆顶",msg.fromQQ,"boom",file)
                dream.api.setUserConf("玩家",player,msg.fromQQ,file)
                dream.api.setUserConf("数字炸弹人数",tall,"boom",file)
            end
            return Boomnum.msg.addtrue:gsub("{place}",player.place):gsub("{qq}",msg.fromQQ)
        end
        return Boomnum.msg.addfalse2
    end
    return "自由模式不用排队"
end
dream.keyword.set("Numboom","数字炸弹加入",Boomnum.func.playeradd)

function Boomnum.func.playercheck(msg)
    local file=Boomnum.func.Bfile(msg.fromGroup)
    local mode=1
    if mode==1 then
        local p=dream.api.getUserConf("数字炸弹堆顶","boom",file) or 0
        local message=""
        while p~=0 do
            p=tostring(p)
            print(1)
            local player=dream.api.getUserConf("玩家",p,file)
            local msg=Boomnum.msg.check1:gsub("{player}",player.nick):gsub("{place}",player.place):gsub("{state}",player.state)
            message=message..msg
            p=player.next
        end
        return message
    end
    return "自由模式不用排队"
end
dream.keyword.set("Numboom","数字炸弹查看玩家",Boomnum.func.playercheck)

function Boomnum.func.GameStart(msg)
    local file=Boomnum.func.Bfile(msg.fromGroup)
    local message={}
    message.time=dream.api.getUserConf("数字炸弹时间","boom",file)
    message.down=1
    message.up=100
    message.target=sdk.randomInt(message.down,message.up)
    message.p=tostring(dream.api.getUserConf("数字炸弹堆顶","boom",file))
    local player=dream.api.getUserConf("玩家",message.p,file)
    message.next=player.next
    dream.api.setUserConf("数字炸弹数据",message,"boom",file)
    return "游戏开始，请一号猜数字#{AT-"..message.p.."}请输入指令'数字炸弹猜测[数字]'"
end

function Boomnum.func.findplayer(p)
    local file=Boomnum.func.Bfile(msg.fromGroup)
    local player=dream.api.getUserConf("玩家",p,file)
    local NPlayer=dream.api.getUserConf("玩家",p.next,file)
        while NPlayer.state~="存活" do
            local next=NPlayer.next
            if next==0 then next=tostring(dream.api.getUserConf("数字炸弹堆顶","boom",file)) end
            NPlayer=dream.api.getUserConf("玩家",tostring(next),file)
        end
    return player,NPlayer
end

function Boomnum.func.playerboom(msg)
    local file=Boomnum.func.Bfile(msg.fromGroup)
    local up=Boomnum.func.setup(file)
    local mode=2
    if mode==1 then
        local state=0
        local message=dream.api.getUserConf("数字炸弹数据","boom",file)
        if msg.fromQQ==message.p then
            local player,NPlayer=Boomnum.func.findplayer(message.p)
            local num=dream.tonumber(msg.fromMsg:match("%d+"))
            if num<=message.down or num>=message.up then
                return "输入范围不合法，请重新输入"
            end
            if num<message.target then
                message.down=num 
            elseif num>message.target then
                message.up=num
            else
                state=1
            end
        else
            return "还没到你的回合，请耐心等待"
        end
    elseif mode==2 then
        
        local message=dream.api.getUserConf("数字炸弹数据","boom",file) or {down=1;up=up}
        if message.target==nil or message.target==0 then message.target=sdk.randomInt(2,up-1) end
        local num=dream.tonumber(msg.fromMsg:match("%d+"))
        if num<=message.down or num>=message.up or num==nil then
            return ("输入范围不合法，请重新输入。当前区间:{down}~{up}"):gsub("{down}",message.down):gsub("{up}",message.up)
        end
        if num<message.target then
            message.down=num 
            dream.api.setUserConf("数字炸弹数据",message,"boom",file)
            return ("小了，当前区间:{down}~{up}"):gsub("{down}",message.down):gsub("{up}",message.up)
        elseif num>message.target then
            message.up=num
            dream.api.setUserConf("数字炸弹数据",message,"boom",file)
            return ("大了，当前区间:{down}~{up}"):gsub("{down}",message.down):gsub("{up}",message.up)
        else
            message.target=0
            message.down=1
            message.up=up
            dream.api.setUserConf("数字炸弹数据",message,"boom",file)
            return ("{player}爆炸了"):gsub("{player}",msg.fromGroupNick)
        end
    end
end
dream.keyword.set("Numboom","数字炸弹猜测",Boomnum.func.playerboom)

function Boomnum.func.SetMaxDice(msg)
    if not dream.api.permission(msg.fromGroup,msg.fromQQ) or dream.deter.master(msg.fromQQ) then
        local file=Boomnum.func.Bfile(msg.fromGroup)
        local num=dream.tonumber(msg.fromMsg:match("%d+"))
        if num==nil then
            return "输入范围不合法"
        else
            dream.api.setUserConf("Dice",num,"Numboom",file)
            return "设置成功，当前起始点数:"..num
        end
    end
end
dream.command.set("Numboom","boomNumset",Boomnum.func.SetMaxDice)

return {
    id = "Numboom",
    version = "1.0.0",
    help = "--数字炸弹--",
    author = "雨岚之忆",
    mode = true
  }