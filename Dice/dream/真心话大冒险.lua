TruthorDare={
    player={name=0,qq=0,num=0,next=0};
    msg={
        addfalse="{name}已经骰过点了 骰点结果:{num}";
        addtrue="{name}骰点成功 骰点结果:{num}";
        check="玩家:{name} 骰点结果:{num}\n";
    };
    Dare={
        "1.猫女仆 称呼他人为[xx大人]，句尾加[喵~] (1小时)，cd结束之后要艾特某位群友说[最喜欢主人了]，表达自己意犹未尽之意(? )";
        "2.群ID改成[渴望被怜爱的弱受xxx，请尽情xx我吧! ] (或头衔 [群rpqxx] ) (1天)";
        "3.可选择一一个人进行撅斗(输.r看点数)，败者必须想方设法喊足对方五次老公(限次数:5次，但要真情实感)";
        "4.给群里某个人表白(30字 )";
        "5.表演自己的才艺，越尴尬越好";
        "6.幸运6消除一切debuff!";
        "7.发相册里认为最涩气最好看的老婆照片";
        "8.指定-一个人给自己下达角色扮演的命令(如群友或者二次元角色) (下一个12点结束 )";
        "9.QQ空间发[这是我老婆( 附群友图片) ]，并艾特至少三位群友，可以设置仅群友可见";
        "10.当场发癫";
        "11.请描述一-位群友， 并在描述完后让大家猜他/她的身份";
        "12.可重骰一次, 然后将所有debuff转移给下一位点数最小的玩家( 包括本轮)";
        "13.与下一-位点数13/14的群cd+情头，寓意1314 [有原配可重骰,原配不介意的除外](下一个12点结束)";
        "14.与下一位点数13/14的群cd+情头，寓意1314 [有原配可重骰，原配不介意的除外](下一个12点结束)";
        "15.选择一个人一-起角色扮演热恋中的公主和王子，两人需互相称呼对方为公主和王子(点数高者自选决定) (第二天12点结束 )";
        "16.描述下你的xp并艾特你认为最符合你xp的群友";
        "17.说出自己身_上觉得最涩气的部位并说为什么";
        "18.免死金牌x1 (相当于名刀，可用于下次接受惩罚)";
        "19.根据点数艾特某位群友发癫来表达自己的❤️爱意(?) (骰点单数则你是攻,偶数则你是受)";
        "20.咏唱一句中二台词(30字以上)";
        "21.画幅图然后指定一人猜(你画我猜)，猜不出来的变喵女仆";
        "22.选择一位群友并试图说一句情话令其心动";
        "23.说满五句雌小鬼语气发言(可对话群友)";
        "24.用翻译腔打字(根据.rd5来决定句数)";
        "25.讲一一个冷笑话";
        "26.脑补自己被撅的姿势和情景(30字以上)";
        "27.描述某位群友的初印象和现印象";
        "28.说出自己最社死的一-次经历";
        "29.说话加[❤️] (1小时)";
        "30.可自选获得任意一条buff";
        "31.用标点符号代表接下来在这一段时间的每一句话";
        "32.口癖:才不是xxx格式发言( 傲娇语气就行)(一小时)";
        "33.选择一人给自己指定外号（需改群名）";
        "34.口癖:叠词词~ (一小时)";
        "35.口癖:句尾+语气词~ (如啊~/嘶~/嗯~/呜~) (一小时 )";
        "36:可令本轮参与投掷的玩家指定获得一条静态buff(指口癖，头衔，喵女1卜等只需要操作头像ID口癖的)";
        "37:对点数最大/最小的人撒娇( 你最大则最小撒娇向你撒娇，你最小则最大向你撒娇)";
        "38:扮演女仆发表涩涩言论(被撅状态ing )(如:主....哪里不...啊~ )";
        "39:口癖:否定别人的每一句话 (10分钟内)";
        "40:想象自己被撅的情景（20字以上）"
    }
}
function ToDfile(group)
    local file="TruthorDare/"..group
    return file
end

function addin(msg)
    local file=ToDfile(msg.fromGroup)
    local player=dream.api.getUserConf("玩家",msg.fromQQ,file)
    if dream.api.getUserConf("时间","TruthorDare",file)==nil then
        dream.api.setUserConf("时间",os.time(),"TruthorDare",file)
    end
    if dream.api.getUserConf("时间",msg.fromQQ,file)==dream.api.getUserConf("时间","TruthorDare",file) then
        return TruthorDare.msg.addfalse:gsub("{name}",player.name):gsub("{num}",player.num)
    else
        local player=TruthorDare.player
        player.qq=msg.fromQQ
        player.name=msg.fromGroupNick
        player.num=sdk.randomInt(1,100)
        player.next=(dream.api.getUserConf("顶指针","TruthorDare",file) or 0)
        dream.api.setUserConf("玩家",player,msg.fromQQ,file)
        dream.api.setUserConf("时间",dream.api.getUserConf("时间","TruthorDare",file),msg.fromQQ,file)
        dream.api.setUserConf("顶指针",msg.fromQQ,"TruthorDare",file)
        return TruthorDare.msg.addtrue:gsub("{name}",player.name):gsub("{num}",player.num)
    end
end
dream.keyword.set("TruthorDare","真心话加入",addin)
dream.keyword.set("TruthorDare","大冒险加入",addin)

function checkout(msg)
    local file=ToDfile(msg.fromGroup)
    local p=dream.api.getUserConf("顶指针","TruthorDare",file)
    local message=""
    while p~=0 do
        p=tostring(p)
        local player=dream.api.getUserConf("玩家",p,file)
        local check=TruthorDare.msg.check:gsub("{name}",player.name):gsub("{num}",player.num)
        message=message..check
        p=player.next
    end
    return message
end
dream.keyword.set("TruthorDare","真心话查看",checkout)
dream.keyword.set("TruthorDare","大冒险查看",checkout)

function checknum(file)
    local p=dream.api.getUserConf("顶指针","TruthorDare",file)
    local empty={}
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

function TruAt(moudle)
    local msg=atmsg(moudle[1])
    for i=2,#moudle do
     msg=msg..atmsg(moudle[i])
    end
    return msg
end

function restartT(msg)
    local file=ToDfile(msg.fromGroup)
    local message="重置成功\n"
    message=message..checkout(msg)
    local min,max=checknum(file)
    local message1="#{MULT} "..atmsg(max).." 问 "..atmsg(min)
    message=message..message1
    dream.api.setUserConf("时间",os.time(),"TruthorDare",file)
    dream.api.setUserConf("顶指针",0,"TruthorDare",file)
    return message
end
dream.keyword.set("TruthorDare","真心话重置",restartT)

function atmsg(moudle)
    local message="#{AT-"..moudle.qq.."}"
    return message
end

function Daremsg(moudle)
    local msg=TruthorDare.Dare[sdk.randomInt(1,#TruthorDare.Dare)]
    local message="#{MULT} "..atmsg(moudle).." 数值："..moudle.num.."\n"..msg
    return message
end

function restartD(msg)
    local file=ToDfile(msg.fromGroup)
    local message="重置成功\n"
    message=message..checkout(msg)
    local min,max=checknum(file)
    local message1=Daremsg(min)..Daremsg(max)
    message=message..message1
    dream.api.setUserConf("时间",os.time(),"TruthorDare",file)
    dream.api.setUserConf("顶指针",0,"TruthorDare",file)
    return message
end
dream.keyword.set("TruthorDare","大冒险重置",restartD)

function DareRandom(msg)
   local msg=TruthorDare.Dare[sdk.randomInt(1,#TruthorDare.Dare)]
   return msg.fromNick.."抽到了:\n"..msg
end
return {
    id = "TruthorDare",
    version = "1.0.1",
    help = "--真心话大冒险--\n真心话加入/大冒险加入\n真心话查看/大冒险查看\n真心话重置/大冒险重置--查看结果",
    author = "雨岚之忆",
    
    mode = true
  }