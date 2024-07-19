YesdreamJolt={
    special_mix={name=0;text=0;type={shape=0,size=0,ice=0};contain={};relish={sweetness=0;intensity=0;viscosity=0};flavor=" ";blender=0;};
    shape={"古典杯";"高脚杯"};
    flavor={
        {"梦幻"," ","松弛"};
        {" "," "," "};
        {"破碎"," ","怀旧"}
    };
    relish={
        sweetness={"超苦","微苦"," ","微甜","超甜"};
        intensity={"超柔和","柔和"," ","强烈","超强烈"};
        viscosity={"超清爽","清爽"," ","浓厚","超浓厚"};
    };
    material={
        {name="提纯浮羊奶";sweetness=2;intensity=0;viscosity=2};
        {name="星空香槟";sweetness=1;intensity=0;viscosity=0};
        {name="椒椒博士";sweetness=1;intensity=0;viscosity=-1};
        {name="冰点苏乐达";sweetness=1;intensity=0;viscosity=-2};
        {name="安神气泡饮";sweetness=-1;intensity=0;viscosity=-1};
        {name="醒神苏打水";sweetness=-1;intensity=0;viscosity=-2};
        {name="怪味浓汁";sweetness=-2;intensity=0;viscosity=1};
        {name="激梦果酱";sweetness=0;intensity=2;viscosity=1};
        {name="极致糖浆";sweetness=0;intensity=1;viscosity=2};
        {name="苏花清露";sweetness=0;intensity=1;viscosity=-1};
        {name="夕红果沙司";sweetness=0;intensity=-1;viscosity=1};
        {name="魔血能量";sweetness=0;intensity=-1;viscosity=0};
        {name="传统老豆汁儿";sweetness=0;intensity=-2;viscosity=2}

    };
    sen={
        fail={
            "你已经开始特调";
            "杯子尺寸不合法";
            "杯子种类不合法";
            "冰块数量不合法";
            "材料不存在";
        };
        flow_fail={
            "你还未开始特调";
            "你还未选择杯子";
            "你还未加入冰块";
            "你还未加入材料/杯子未满/已搅拌";
            "你还未取名";
            "你还未添加介绍";
        }
    };
    func={};
}

function YesdreamJolt.func.startmix(msg)
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==0 then
        dream.api.setUserConf("特调启动","1",msg.fromQQ,"Dreamjolt")
        local special=table.clone(YesdreamJolt.special_mix)
        dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
        dream.api.setUserConf("特调启动",1,msg.fromQQ,"Dreamjolt")
        return ("{player}，惊梦特调，启动！"):gsub("{player}",msg.fromNick)
    else
    return YesdreamJolt.sen.fail[1]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调启动",YesdreamJolt.func.startmix)

function YesdreamJolt.func.selectcup(msg)
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==1 then
        local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
        local string=msg.fromMsg:match("^惊梦特调选择杯子(.+)$")
        if string==nil then
            return "输入不合法"
        end
        local place=string.find(string,"杯")
        local size=string.sub(string,1,place+2)
        local type=string.sub(string,place+3)
        if size=="小杯" then
            special.type.size=3
        elseif size=="大杯" then
            special.type.size=4
        elseif size=="超大杯" then
            special.type.size=5
        else
            return YesdreamJolt.sen.fail[2]
        end
        for i=1,#YesdreamJolt.shape do
            if type==YesdreamJolt.shape[i] then
                special.type.shape=YesdreamJolt.shape[i]
            end
        end
        if special.type.shape==0 then
            return  YesdreamJolt.sen.fail[3]
        end
        dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
        dream.api.setUserConf("特调启动",2,msg.fromQQ,"Dreamjolt")
        return ("已经选择杯子  {size}{shape}"):gsub("{size}",size):gsub("{shape}",type)
    else
        local num=(dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)+1
        return YesdreamJolt.sen.flow_fail[num]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调选择杯子",YesdreamJolt.func.selectcup)

function YesdreamJolt.func.addice(msg)
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==2 then
        local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
        local string=msg.fromMsg:match("^惊梦特调加入冰块(.+)$")
        if string==nil then
            return "输入不合法"
        end
        if string=="不加冰" then
            special.type.ice=0
        elseif string=="少量冰" then
            special.type.ice=1
        elseif string=="大量冰" then
            special.type.ice=2
        else
            return YesdreamJolt.sen.fail[4]
        end
        dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
        dream.api.setUserConf("特调启动",3,msg.fromQQ,"Dreamjolt")
        return ("已经选择冰块  {size}"):gsub("{size}",string)
    else
        local num=(dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)+1
        return YesdreamJolt.sen.flow_fail[num]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调加入冰块",YesdreamJolt.func.addice)


function YesdreamJolt.func.mixadd(msg)
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==3 then
        local add=0
        local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
        local string=msg.fromMsg:match("^惊梦特调加入原料(.+)$")
        local flavor
        if string==nil then
            return "输入不合法"
        end
        for i=1,#YesdreamJolt.material do
            if string==YesdreamJolt.material[i].name then
                add=YesdreamJolt.material[i]
            end
        end
        if add==0 then
            return YesdreamJolt.sen.fail[5]
        end
        special.contain[#special.contain+1]=add
        special.relish.sweetness=special.relish.sweetness+add.sweetness
        special.relish.intensity=special.relish.intensity+add.intensity
        special.relish.viscosity=special.relish.viscosity+add.viscosity
        if special.relish.sweetness>2 then special.relish.sweetness=2 end
        if special.relish.intensity>2 then special.relish.intensity=2 end
        if special.relish.viscosity>2 then special.relish.viscosity=2 end
        if special.relish.sweetness<-2 then special.relish.sweetness=-2 end
        if special.relish.intensity<-2 then special.relish.intensity=-2 end
        if special.relish.viscosity<-2 then special.relish.viscosity=-2 end
        dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
        if #special.contain==special.type.size then
        dream.api.setUserConf("特调启动",4,msg.fromQQ,"Dreamjolt")
        end
        return ("加入原料 {add} 成功\n当前风味 {flavor}\n 甜度:{sweetness}\n 烈度:{intensity}\n 浓稠度:{viscosity}"):gsub("{add}",add.name):gsub("{flavor}",special.flavor):gsub("{sweetness}",special.relish.sweetness):gsub("{intensity}",special.relish.intensity):gsub("{viscosity}",special.relish.viscosity)
    else
        local num=(dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)+1
        return YesdreamJolt.sen.flow_fail[num]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调加入原料",YesdreamJolt.func.mixadd)

function YesdreamJolt.func.blender(msg)
    local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==3 and special.blender==0 then
        special.blender=1
        if (special.relish.intensity<=1 and special.relish.sweetness<=1) and (special.relish.intensity>=-1 and special.relish.sweetness>=-1) then
        special.flavor=YesdreamJolt.flavor[special.relish.intensity+2][special.relish.sweetness+2]
        end
        dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
        return ("搅拌成功\n当前风味 {flavor}\n 甜度:{sweetness}\n 烈度:{intensity}\n 浓稠度:{viscosity}"):gsub("{flavor}",special.flavor):gsub("{sweetness}",special.relish.sweetness):gsub("{intensity}",special.relish.intensity):gsub("{viscosity}",special.relish.viscosity)
    else
        local num=(dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)+1
        return YesdreamJolt.sen.flow_fail[num]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调搅拌",YesdreamJolt.func.blender)

function YesdreamJolt.func.setname(msg)
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==4 then
    local string=msg.fromMsg:match("^惊梦特调名字(.+)$")
    string= string or "开拓者特调"
    local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
    special.name=string
    dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
    dream.api.setUserConf("特调启动",5,msg.fromQQ,"Dreamjolt")
    return ("{name}\n当前风味 {flavor}\n 甜度:{sweetness}\n 烈度:{intensity}\n 浓稠度:{viscosity}"):gsub("{name}",special.name):gsub("{flavor}",special.flavor):gsub("{sweetness}",special.relish.sweetness):gsub("{intensity}",special.relish.intensity):gsub("{viscosity}",special.relish.viscosity)
    else
        local num=(dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)+1
        return YesdreamJolt.sen.flow_fail[num]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调名字",YesdreamJolt.func.setname)

function YesdreamJolt.func.setinfo(msg)
    if (dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)==5 then
    local string=msg.fromMsg:match("^惊梦特调介绍(.+)$")
    string= string or "毫无疑问，这是只属于你的特调\n「调自己的饮品，其余让顾客去评判吧。--『调饮师手册』第二条」"
    local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
    local relish=YesdreamJolt.relish.sweetness[special.relish.sweetness+3].." "..YesdreamJolt.relish.intensity[special.relish.intensity+3].." "..YesdreamJolt.relish.viscosity[special.relish.viscosity+3]
    local text=special.name.."\n标签："..special.flavor..relish.."\n"..string
    special.text=text
    dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
    dream.api.setUserConf("特调启动",6,msg.fromQQ,"Dreamjolt")
    return text
    else
        local num=(dream.api.getUserConf("特调启动",msg.fromQQ,"Dreamjolt") or 0)+1
        return YesdreamJolt.sen.flow_fail[num]
    end
end
dream.keyword.set("Dreamjolt","惊梦特调介绍",YesdreamJolt.func.setinfo)

function YesdreamJolt.func.checkjolt(msg)
    local special=dream.api.getUserConf("特调",msg.fromQQ,"Dreamjolt")
    return special.text
end
dream.keyword.set("Dreamjolt","惊梦特调查看",YesdreamJolt.func.checkjolt)

function YesdreamJolt.func.restart(msg)
    special=nil
    dream.api.setUserConf("特调",special,msg.fromQQ,"Dreamjolt")
    dream.api.setUserConf("特调启动",0,msg.fromQQ,"Dreamjolt")
    return "重置成功"
end
dream.keyword.set("Dreamjolt","惊梦特调重置",YesdreamJolt.func.restart)

return {
    id = "Dreamjolt",
    version = "1.1.0",
    help = "--惊梦特调--",
    author = "雨岚之忆",
    
    mode = true
  }