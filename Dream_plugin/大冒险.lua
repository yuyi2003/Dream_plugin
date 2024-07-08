Dare={
    player={name=0,qq=0,num=0,next=0};
    msg={
        addfalse="{name}已经骰过点了 骰点结果:{num}";
        addtrue="{name}骰点成功 骰点结果:{num}";
        check="玩家:{name} 骰点结果:{num}\n";
    };
    func={};
    para={
        Dare={
            {name="1.喵女仆";
            nature="【静态】【口癖后缀】【1小时】";
            intro="称呼他人为[xx大人]，句尾加[喵~] ；cd结束之后要艾特某位群友说[最喜欢主人了]，表达自己意犹未尽之意(? )";};
            {name="2.弱受是这样的";
            nature="【静态】【群ID】【1天】";
            intro="群ID改成[渴望被怜爱的弱受xxx，请尽情xx我吧! ] (或头衔 [群rpqxx] )";};
            {name="3.击剑";
            nature="【动态】【{moudle}次】";
            moudle={{1,2,3,4,5},"1-5"};
            intro="可选择一个人进行撅斗(输.r看点数)，败者必须想方设法喊足对方{moudle}次老公（如老公，我稀罕你、撅撅老公等）";};
            {name="4.表白";
            nature="【动态】【30字以上】";
            intro="自选给群里某个人表白";};
            {name="5.行为艺术家";
            nature="【动态】";
            intro="描述自己赛博或线下见到群友后，可能对其做的事【如阴暗地爬行后抱住了大腿、击股之交等】";};
            {name="6.幸运6";
            nature="【特殊】";
            intro="幸运6消除一切debuff!";};
            {name="7.涩图";
            nature="【动态】";
            intro="发相册里认为最涩气最好看的老婆照片";};
            {name="8.本姑娘就是罗刹";
            nature="【静态】【群人设】【12点结束】";
            intro="指定一个人给自己下达角色扮演的命令(如群友或者二次元角色) ";};
            {name="9.你好，结婚！";
            nature="【动态】【QQ空间】";
            intro="QQ空间发[这是我老婆( 附群友图片) ]，并艾特至少三位群友，可以设置仅群友可见";};
            {name="10.精神状态极佳";
            nature="【动态】";
            intro="当场发癫";};
            {name="11.他/她是谁？";
            nature="【动态】";
            intro="请描述一位群友， 并在描述完后让大家猜他/她的身份";};
            {name="12.花火的礼物";
            nature="【特殊】";
            intro="重骰一次, 然后将所有debuff转移给下一位点数最小的玩家(包括本轮)";};
            {name="13.一生一世";
            nature="【静态】【12点结束】";
            intro="与下一位点数13/14的群cd+情头（有原配可重骰,原配不介意的除外）";};
            {name="14.一生一世";
            nature="【静态】【12点结束】";
            intro="与下一位点数13/14的群cd+情头（有原配可重骰，原配不介意的除外）";};
            {name="15.帮帮可莉吧~";
            nature="【动态】【1次/{moudle}小时】【12点结束】";
            moudle={{0.5,1,1.5},"0.5，1或者1.5"};
            intro="自选一位欧尼酱/姐姐大人/主人，定时撒娇";};
            {name="16.正中xp！";
            nature="【动态】";
            intro="描述下你的xp并艾特你认为最符合你xp的群友";};
            {name="17.我真好看";
            nature="【动态】";
            intro="说出自己身上觉得最涩气的部位并说为什么";};
            {name="18.名刀";
            nature="【特殊】";
            intro="免死金牌x1 (可以使之后的一次惩罚无效)";};
            {name="19.攻受异形";
            nature="【动态】";
            intro="根据点数艾特某位群友发癫来表达自己的❤️爱意(?) (根据本轮骰点,单数则你是攻,偶数则你是受)";};
            {name="20.菲谢尔也要谈恋爱";
            nature="【动态】【30字以上】";
            intro="咏唱一句中二台词";};
            {name="21.你画我猜";
            nature="【动态】";
            intro="画图后指定一人猜，猜不出来的变喵女仆";};
            {name="22.还是情场糕手！";
            nature="【动态】【对{moudle}人】";
            moudle={{1,2,3},"1-3"};
            intro="选择{moudle}个群友并试图对其说情话令其心动";};
            {name="23.雌小鬼是要被撅的！";
            nature="【动态】【{moudle}次】";
            moudle={{1,2,3,4,5},"1-5"};
            intro="雌小鬼语气发言(可对话群友)";};
            {name="24.纯0狂喜！";
            nature="【特殊】";
            intro="可自选一个群友，与其交换所有debuff";};
            {name="25.大风机关";
            nature="【动态】";
            intro="讲一一个冷笑话";};
            {name="26.不要~";
            nature="【动态】【30字以上】";
            intro="描述自己被撅时的姿势和声音";};
            {name="27.这就是我啦！";
            nature="【动态】";
            intro="描述某位群友的初印象和现印象";};
            {name="28.童言无忌";
            nature="【动态】";
            intro="说出自己最社死的一次经历";};
            {name="29.大爱仙尊！";
            moudle={{10,20,30,40,50,60},"1-60"};
            nature="【静态】【口癖后缀】【{moudle}分钟】";
            intro="说话加[❤️] ";};
            {name="30.拿来吧你！";
            nature="【特殊】";
            intro="可自选获得任意一条buff";};
            {name="31.无言";
            moudle={{10,20,30},"1-30"};
            nature="【静态】【口癖】【{moudle}分钟】";
            intro="用标点符号代表接下来在这一段时间的每一句话";};
            {name="32.傲娇已经退环境惹！";
            nature="【静态】【口癖前缀】【1小时】";
            intro="我才不是xxx格式发言";};
            {name="33.我是谁？";
            nature="【静态】【群ID】";
            intro="选择一人给自己指定外号（需改群ID）";};
            {name="34.叠词词，恶心心~";
            nature="【静态】【.rd30分钟】";
            intro="用ABB格式简短发言";};
            {name="35.可爱捏";
            moudle={{10,20,30,40,50,60},"1-60"};
            nature="【静态】【口癖后缀】【{moudle}分钟】";
            intro="句尾+语气词~ (如啊~/嘶~/嗯~/呜~) ";};
            {name="36.潘多拉魔盒";
            nature="【特殊】";
            intro="可令所有参与本轮的玩家指定获得一条静态buff（包括自己）";};
            {name="37.好不好嘛~";
            moudle={{1,2,3,4,5},"1-5"};
            nature="【动态】【{moudle}次】";
            intro="向本回合接受惩罚的其他人撒娇";};
            {name="38.哒咩！";
            nature="【动态】";
            intro="扮演女仆发表涩涩言论(被撅状态ing )\n(如主人~那里不——啊~ )";};
            {name="39.再来一次";
            nature="【特殊】";
            intro="再执行一次最近的惩罚";};
            {name="40.求你了，来测吧！";
            nature="【动态】【20字】";
            intro="想象自己被撅的情景";};
            {name="41.我的上帝啊！";
            moudle={{1,2,3,4,5},"1-5"};
            nature="【动态】【{moudle}句】";
            intro="用翻译腔说话";};
            {name="42.多大仇啊？";
            nature="【特殊】";
            intro="可与某位群友一起自选执行一条debuff";};
            {name="43.我劝你善良，别太重口";
            nature="【动态】";
            intro="说出自己看过印象最深的本子";};
            {name="44.禁忌姿势";
            nature="【动态】";
            intro="说出自己最喜欢的🧀（体位）";};
            {name="45.yyds！";
            nature="【动态】";
            intro="从六大体型中选出一种描述并发癫（萝莉/正太/少女/少年/成女/成男/南梁）\n（如萝莉有三好，身娇体柔易推倒，还有牢饭吃）";};
            {name="46.纯0是这样的";
            nature="【动态】【QQ空间】";
            intro="QQ空间发说说“全体目光向我看齐，我是个纯0！”（并艾特至少三位群友，可设置仅群友可见）";};
            {name="47.社会性死亡";
            nature="【动态】【QQ空间】";
            intro="QQ空间发最近一次的大冒险语录（没有就搬运其他人最近的）（并艾特至少三位群友，可设置仅群友可见）";};
            {name="48.拿去玩吧";
            nature="【特殊】";
            intro="可自选一条debuff，赠予下回合点数最低的人";};
            {name="49.美梦之神的庇佑";
            nature="【动态】";
            intro="描述自己最激动的春梦/yy（潇楚南，未柳稻关，湘香里，海听烽符）";};
            {name="50.他/她一直很瑟琴的";
            nature="【动态】";
            intro="选择一位群友，并说出自己想象中的他/她形象如何（类似自设，可性转），请着重描写涩气（如发型如何好，腿如何好等）";};
        };
    static={1,2,8,13,12,29,31,32,33,34,35};
    dynamic={3,4,5,7,9,10,11,15,16,17,19,20,21,22,23,25,26,27,28,37,38,40,41,43,44,45,46,47,49,50};
    specicl={6,12,18,24,30,36,39,42,48};
    };
}

function Dare.func.Tfile(group)--文件路径
    local file="Dare/"..group
    return file
end
--Dare.func.
function Dare.func.atmsg(moudle)--@某人
    local message="#{AT-"..moudle.qq.."}"
    return message
end

function Dare.func.addin(msg)--加入
    local file=Dare.func.Tfile(msg.fromGroup)
    local player=dream.api.getUserConf("玩家",msg.fromQQ,file)
    if dream.api.getUserConf("时间","Dare",file)==nil then
        dream.api.setUserConf("时间",os.time(),"Dare",file)
    end
    if dream.api.getUserConf("时间",msg.fromQQ,file)==dream.api.getUserConf("时间","Dare",file) then
        return Dare.msg.addfalse:gsub("{name}",player.name):gsub("{num}",player.num)
    else
        local player=table.clone(Dare.player)
        player.qq=msg.fromQQ
        player.name=msg.fromGroupNick
        player.num=sdk.randomInt(1,100)
        player.next=(dream.api.getUserConf("顶指针","Dare",file) or 0)
        dream.api.setUserConf("玩家",player,msg.fromQQ,file)
        dream.api.setUserConf("时间",dream.api.getUserConf("时间","Dare",file),msg.fromQQ,file)
        dream.api.setUserConf("顶指针",msg.fromQQ,"Dare",file)
        return Dare.msg.addtrue:gsub("{name}",player.name):gsub("{num}",player.num)
    end
end
dream.keyword.set("Dare","大冒险加入",Dare.func.addin)

function Dare.func.checkout(msg)--查看
    local file=Dare.func.Tfile(msg.fromGroup)
    local p=dream.api.getUserConf("顶指针","Dare",file)
    local message=""
    while p~=0 do
        p=tostring(p)
        local player=dream.api.getUserConf("玩家",p,file)
        local check=Dare.msg.check:gsub("{name}",player.name):gsub("{num}",player.num)
        message=message..check
        p=player.next
    end
    return message
end
dream.keyword.set("Dare","大冒险查看",Dare.func.checkout)

function Dare.func.Daremsg(nature,intro)--大冒险语句1
    local Dare=table.clone(Dare.para.Dare[sdk.randomInt(1,#Dare.para.Dare)])
    local moudle
    if Dare.moudle~=nil then
        moudle=Dare.moudle[1][sdk.randomInt(1,#Dare.moudle)]
        Dare.nature=Dare.nature:gsub("{moudle}",moudle)
        Dare.intro=Dare.intro:gsub("{moudle}",moudle)
    end
    local message=Dare.name
    if nature==1 then
        message=message.."\n"..Dare.nature
    end
    if intro==1 then
        message=message.."\n"..Dare.intro
    end
    return message
end

function Dare.func.Daremessage(mod,nature,intro)--大冒险语句指定模式
    local num
    if mod==1 then
        num=sdk.randomInt(1,#Dare.Dare.static)
    elseif mod==2 then
        num=sdk.randomInt(1,#Dare.Dare.dynamic)
    elseif mod==3 then
        num=sdk.randomInt(1,#Dare.Dare.special)
    end
    local Dare=table.clone(Dare.para.Dare[num])
    local moudle
    if Dare.moudle~=nil then
        moudle=Dare.moudle[1][sdk.randomInt(1,#Dare.moudle)]
        Dare.nature=Dare.nature:gsub("{moudle}",moudle)
        Dare.intro=Dare.intro:gsub("{moudle}",moudle)
    end
    local message=Dare.name
    if nature==1 then
        message=message.."\n"..Dare.nature
    end
    if intro==1 then
        message=message.."\n"..Dare.intro
    end
    return message
end

function Dare.func.Daremsg1(moudle)--大冒险语句2
    local msg=Dare.func.Daremsg(1,1)
    local message="#{MULT} "..Dare.func.atmsg(moudle).." 数值："..moudle.num.."\n"..msg
    return message
end

function Dare.func.checknum(file)--比较最大最小
    local p=dream.api.getUserConf("顶指针","Dare",file)
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

function Dare.func.restartD(msg)--大冒险重置
    local file=Dare.func.Tfile(msg.fromGroup)
    local message="重置成功\n"
    if dream.api.getUserConf("顶指针","Dare",file)~=0 then
        message=message..Dare.func.checkout(msg)
        local min,max=Dare.func.checknum(file)
        local message1=Dare.func.Daremsg1(min)..Dare.func.Daremsg1(max)
        message=message..message1
        dream.api.setUserConf("时间",os.time(),"Dare",file)
        dream.api.setUserConf("顶指针",0,"Dare",file)
    end
    return message
end
dream.keyword.set("Dare","大冒险重置",Dare.func.restartD)

function Dare.func.DareRandom(msg)
    local dare=Dare.func.Daremsg(1,1)
    return msg.fromNick.."抽到了:\n"..dare
 end
 dream.keyword.set("Dare","随机大冒险",Dare.func.DareRandom)
 
 function Dare.func.Darecheck(num)
     local dare=table.clone(Dare.para.Dare[num])
     local moudle
     if dare.moudle~=nil then
         moudle=dare.moudle[2]
         dare.nature=dare.nature:gsub("{moudle}",moudle)
         dare.intro=dare.intro:gsub("{moudle}",moudle)
     end
     local msg=dare.name.."\n"..dare.nature.."\n"..dare.intro
     return msg
 end
 
 function Dare.func.Darecheck1(msg)
     local num=dream.tonumber(msg.fromMsg:match("%d+"))
     if num==nil or num<1 or num>#Dare.para.Dare then
         return "输入数值参数不合法，请重新输入"
     else
         return Dare.func.Darecheck(num)
     end
     
 end
 dream.keyword.set("Dare","查看大冒险",Dare.func.Darecheck1)
 
 function Dare.func.listDare(msg)
    local message="#{SPLIT}"
    for i=1,#Dare.para.Dare do
        message=message..Dare.func.Darecheck(i).."#{SPLIT}"
    end
    return message
end
dream.keyword.set("Dare","大冒险列表",Dare.func.listDare)

return {
    id = "Dare",
    version = "2.0.0",
    help = "--大冒险--\n大冒险加入\n大冒险查看\n大冒险重置--查看结果\n随机大冒险\n查看大冒险 [数值]--查询对应大冒险惩罚\n大冒险列表--返回所有大冒险惩罚",
    author = "雨岚之忆",
    
    mode = true
  }