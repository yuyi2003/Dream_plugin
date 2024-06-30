TruthorDare={
    player={name=0,qq=0,num=0,next=0};
    msg={
        addfalse="{name}已经骰过点了 骰点结果:{num}";
        addtrue="{name}骰点成功 骰点结果:{num}";
        check="玩家:{name} 骰点结果:{num}\n";
    };
    Dare={
        "1.猫女仆（称呼群友加主人或大人（哪个都行），句尾加喵，持续1小时。结束后要@某位倒霉蛋说：最喜欢主人了）";
        "2.弱受（群名改为[渴望被怜爱的弱受（名字），请尽情（自由发挥）我吧！]（一天）";
        "3.决斗（选择一人进行决斗(.r比谁大)，败者需要真情实感的喊足胜者五次老公）";
        "4.表白（@一个倒霉蛋进行表白，不少于30字）";
        "5.才艺（以文字形式表演才艺，越尬越好。";
        "6.幸运（消除身上的所有惩罚）";
        "7.涩图（发相册里最涩的一张涩图）";
        "8.角色扮演（选择一个倒霉蛋让其选择自己扮演的角色，可以是任何人。（至12点（凌晨十二点也算）";
        "9.QQ空间表白（在QQ空间发：这是我老婆（附某个倒霉群友的图片）并至少三位群友可见）";
        "10.发癫（字面意思";
        "11.描述群友（描述一位倒霉蛋群友，让大家猜ta的身份）";
        "12.大转移术（重投一次，连带着重投与之前的惩罚一起给下一轮点数最低的人）";
        "13.试做情侣（与下一个投到13或14的倒霉蛋换情侣头像跟群名，（至12点（凌晨12点也算）（如cp可重投）";
        "14.试做情侣（与下一个投到13或14的倒霉蛋换情侣头像跟群名，（至12点（凌晨12点也算）（如cp介意可重投）";
        "15.皇室之间の恋情（选择一个人扮演热恋中的公主与王子，双方需称呼对方为王子或公主。谁是公主谁是王子自行商量）";
        "16.描述xp（描述你的xp并@一个最符合你xp的倒霉蛋群友）";
        "17.说出你认为你身上最涩气的部位（字面意思，需说明理由）";
        "18.名刀（获得一个免死金牌，可抵挡一次任意次数的惩罚，包括惩罚12的转移（注：会被惩罚12转移）";
        "19.发癫2（根据本回合点数@某位倒霉蛋群友表达自己的爱意，点数单数为攻，双数为受）";
        "20.中二病发作（吟唱一句中二台词，至少三十字。";
        "21.你画我猜（画一幅画并@一个倒霉蛋群友猜，四次机会内没猜出来倒霉蛋接受惩罚1，反之画的人接受惩罚1）";
        "22.情话（@一个倒霉蛋说情话试图让其心动）";
        "23.雌小鬼（对话群友说满五句雌小鬼发言）";
        "24.用翻译腔说话（一小时）";
        "25.冷笑话（学习赛诺讲一个冷笑话）";
        "26.脑补（脑补自己被爆炒的场景并描述，至少三十字）";
        "27.印象（描述自己对某个倒霉蛋群友的初印象与现印象）";
        "28.社死经历（说出自己一次最社死的经历，写明感受）";
        "29.说话加❤️或♡";
        "30.自选获得任意一条buff";
        "31.沉默是金（用标点符号或者表情包表示接下来的每一句话）";
        "32.死傲娇（发言使用傲娇语气）（一小时）";
        "33.带外号（找一个倒霉蛋起外号，将群名改为外号，并在发言时带上自己的外号）";
        "34.叠词词（发言言使用叠词词）（一小时）";
        "35.语气词（句尾加语气词啊～、嘶～、呜～、嗯～等）（一小时）";
        "36.AOE（令本轮所有.r的倒霉蛋获得口癖（如惩罚1、32到35）或改群名称（如惩罚2））";
        "37.撒娇（对点数最大或最小的人撒娇，最大向最小撒娇，最小向最大撒娇）";
        "38.涩涩女仆限定款（扮演女仆发表涩涩言论）";
        "39.否定（否定别人的每一句话）";
        "40.花猫和铲屎官（选择一人决斗(.r比谁大)，胜者是花猫，败者是铲屎官，花猫可不定时发送：“喵！我饿了，我饿了！”此时铲屎官需@花猫发送：“投喂”）"
    }
}
function addin(msg)
    local file="TruthorDare"..msg.fromGroup
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
    local file="TruthorDare"..msg.fromGroup
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
    local file="TruthorDare"..msg.fromGroup
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
    local msg=TruthorDare.Dare[sdk.randomInt(1,40)]
    local message="#{MULT} "..atmsg(moudle).." 数值："..moudle.num.."\n"..msg
    return message
end

function restartD(msg)
    local file="TruthorDare"..msg.fromGroup
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

return {
    id = "TruthorDare",
    version = "1.0.0",
    help = "--真心话大冒险--\n真心话加入/大冒险加入\n真心话查看/大冒险查看\n真心话重置/大冒险重置--查看结果",
    author = "雨岚之忆",
    
    mode = true
  }