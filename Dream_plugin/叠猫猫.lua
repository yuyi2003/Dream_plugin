YesdreamNekopara={
    func={};
    msg={
        add="{name}\n位置:{tall}\n身高:{height}cm 体重:{weight}kg\n耳朵:{ear} 尾巴:{tail}\n体型:{type} CUP:{cup}\n衣服:{cloth}";
        addfalse="你已经加入猫堆啦";
        down="轰，猫堆倒了。本次记录：{tall}";
        check1="当前猫堆高度:{tall}\n";
        check2="{name}  位置:{place}\n    体型:{type}  CUP:{cup}\n";
        check3="{name}  位置:{place}\n身高:{height}cm 体重:{weight}kg\n耳朵:{ear} 尾巴:{tail}\n体型:{type} CUP:{cup}\n衣服:{cloth}";
        check3false="你还未加入猫堆";
        pushnil="还没有猫堆可以推";
        pushin="你在猫堆上左右晃动，猫堆倒了。\n高度:{tall}";
        pushout="你撞到了猫堆上，猫堆倒了。\n高度:{tall}";
        pushfalse="经过你的努力，猫堆纹丝未动";
        setneko="成功设置猫堆高度限制,当前限制：{num}",
        restart="重置猫堆成功。\n高度:{tall}",
        pushself="你离开了猫堆，这里没有猫堆可以推了"
    };
    neko={who=0;height=0;weight=0;cup=0;age=0;type=0;ear=0;tail=0;eye=0;cloth=0;place=0;down=0;bearing=0;bear=0;};
    zhaoneko={who="赵赵喵2.0";height="165";weight=46.5825;cup="A";age=16;type="少女";ear="天蓝色头饰";tail="天蓝色插件";eye="蓝色";cloth="jk水手服";place=0;down=0;bearing=0;bear=0;};
    qyjneko={who="青余久";height="177";weight=63.658;cup="E";age=19;type="成女";ear="黑色";tail="黑色挂件";eye="黑色";cloth="男士西装";place=0;down=0;bearing=0;bear=0;};
    cupsize={0.3,0.4,0.5,0.7,1};
    cup={"A","B","C","D","E"};
    heightsize={120,140,160};
    type={"萝莉","少女","成女"};
    color={"黑褐","薄梅","焦羽","雾白桐","墨羽染","云唐桂","血色玫瑰","正黑","缟沉茶","月夜墨森","青木亚麻灰","薄藤","蜂蜜茶","鹃紫","莓果","姬胡桃","樱花粉","薰衣草紫","冬石竹","樱珊瑚","雾霾蓝","银灰","纯白","蔚蓝","金栗","金"};
    eye={"彤","胭脂","绯红","橙","杏红","橙","鹅黄","缃","茶","栗","棕","琥珀","柳绿","豆绿","竹青","碧","玉","翡翠","艾青","靛","蔚蓝","藏青","黛蓝","绛紫","黛紫","群青","绀蓝","丁香","苍","水","象牙白","缟","荼白","霜","灰","玄","乌黑","墨"};
    cloth={"紧身毛衣","礼服","水手服","连衣裙","侦探服","女仆装","探险服","女式西装","黑色大衣","女式皮夹克","吊带裙","休闲服","巫女服","制式盔甲","比基尼盔甲","赤裸","露背毛衣","护士装","修女服","魔法师袍","学校泳装","泳装","Lolita","汉服","民族式服装","内衣","初心冒险者装备"};
}

function YesdreamNekopara.func.nekofile(group)
    local file="NekoNkeoNkeo/"..group
    return file
end

function getgroupnum(group)
    local num=dream.api.getUserConf("群人数",group,"Yesdreamgroup")
    if num==nil or (os.time()>(dream.api.getUserConf("时间",group,"Yesdreamgroup") or 0)) then
        local time=os.time()+604800
        local tab=dream.api.getMembersList(group)
        num=#tab
        dream.api.setUserConf("群人数",num,group,"Yesdreamgroup")
        dream.api.setUserConf("时间",time,group,"Yesdreamgroup")
    end
    return num
end

function YesdreamNekopara.func.Randomear()
    local i=sdk.randomInt(1,#YesdreamNekopara.color)
    local ii=sdk.randomInt(1,100)
    local string=""
    if ii==100 then
        string="头饰"
    end
    return YesdreamNekopara.color[i].."色"..string
end

function YesdreamNekopara.func.Randomtail()
    local i=sdk.randomInt(1,#YesdreamNekopara.color)
    local ii=sdk.randomInt(1,100)
    local string=""
    if ii<=20 then
        string="挂件"
    elseif ii==100 then
        string="插件"
    end
    return YesdreamNekopara.color[i].."色"..string
end

function YesdreamNekopara.func.RandomStature(group,nick)
    local num=#dream.api.getGroupsList(group)
    print(num)
    local neko=table.clone(YesdreamNekopara.neko)
    local i=sdk.randomInt(1,3)
    local bmi=sdk.randomInt(170,230)/10
    local cup=sdk.randomInt(1,5)
    local h=sdk.randomInt(1,20)
    local height
    local weight
        neko.who=nick
        height=YesdreamNekopara.heightsize[i]+h
        weight=height/100*height/100*bmi+YesdreamNekopara.cupsize[cup]
        neko.height=height
        neko.weight=weight
        neko.cup=YesdreamNekopara.cup[cup]
        neko.type=YesdreamNekopara.type[i]
        neko.ear=YesdreamNekopara.func.Randomear()
        neko.tail=YesdreamNekopara.func.Randomtail()
        neko.cloth=YesdreamNekopara.cloth[sdk.randomInt(1,#YesdreamNekopara.cloth)]
        neko.bearing=weight*(math.log(math.log(num))+math.log(num*num*num))
        neko.age=sdk.randomInt(10,19)
        return neko
end

function YesdreamNekopara.func.RandomNeko(group,qq,nick)
    if qq=="1619180854" then
        return YesdreamNekopara.zhaoneko
    elseif qq=="3248496551" then
        return YesdreamNekopara.qyjneko
    else
        return YesdreamNekopara.func.RandomStature(group,nick)
    end
end

function YesdreamNekopara.func.CheckNeko(file)
    local weight=0
    local p=dream.api.getUserConf("猫堆顶","neko",file) or 0
    while p~=0 do
        print(weight)
        p=tostring(p)
        local neko=dream.api.getUserConf("猫堆",p,file)
        neko.bear=weight
        if neko.bear>neko.bearing then
            return 0
        end
        weight=weight+neko.weight
        dream.api.setUserConf("猫堆",neko,p,file)
        p=neko.down
    end
    if (dream.api.getUserConf("猫堆高度","neko",file) or 0)>=(dream.api.getUserConf("猫堆高度限制","neko",file) or 200) then
        return 0
    end
    return 1
end

function YesdreamNekopara.func.DownNeko(file)
    local tall1=dream.api.getUserConf("猫堆高度","neko",file) or 0
    dream.api.setUserConf("猫堆高度",0,"neko",file)
    dream.api.setUserConf("猫堆顶",0,"neko",file)
    dream.api.setUserConf("猫堆时间",os.time(),"neko",file)
    return tall1
end

function YesdreamNekopara.func.AddNeko (msg)
    local file=YesdreamNekopara.func.nekofile(msg.fromGroup)
    local tall= dream.api.getUserConf("猫堆高度","neko",file) or 0
    if dream.api.getUserConf("猫堆时间","neko",file)==nil then
        dream.api.setUserConf("猫堆时间",os.time(),"neko",file)
    end
    if dream.api.getUserConf("猫堆时间",msg.fromQQ,file)==dream.api.getUserConf("猫堆时间","neko",file) then
        return YesdreamNekopara.msg.addfalse
    else
        local neko=YesdreamNekopara.func.RandomNeko(msg.fromGroup,msg.fromQQ,msg.fromNick)
        neko.down=dream.api.getUserConf("猫堆顶","neko",file) or 0
        dream.api.setUserConf("猫堆时间",dream.api.getUserConf("猫堆时间","neko",file),msg.fromQQ,file)
        dream.api.setUserConf("猫堆顶",msg.fromQQ,"neko",file)
        neko.place=tall
        tall=tall+1
        dream.api.setUserConf("猫堆",neko,msg.fromQQ,file)
        dream.api.setUserConf("猫堆高度",tall,"neko",file)
        local state=YesdreamNekopara.func.CheckNeko(file)
        if state==0 then
            local tall1=YesdreamNekopara.func.DownNeko(file)
            return YesdreamNekopara.msg.down:gsub("{tall}",tall1)
        end
        return YesdreamNekopara.msg.add:gsub("{name}",msg.fromNick):gsub("{tall}",tall):gsub("{height}",neko.height):gsub("{weight}",neko.weight):gsub("{type}",neko.type):gsub("{cup}",neko.cup):gsub("{ear}",neko.ear):gsub("{tail}",neko.tail):gsub("{cloth}",neko.cloth)
    end
end
dream.keyword.set("NekoNkeoNkeo","叠猫猫加入",YesdreamNekopara.func.AddNeko)

function YesdreamNekopara.func.Check1Neko(msg)
    local file=YesdreamNekopara.func.nekofile(msg.fromGroup)
    local tall= dream.api.getUserConf("猫堆高度","neko",file) or 0
    local p=dream.api.getUserConf("猫堆顶","neko",file)
    local message=YesdreamNekopara.msg.check1:gsub("{tall}",tall)
    while p~=0 do
        p=tostring(p)
        local neko=dream.api.getUserConf("猫堆",p,file)
        local check2=YesdreamNekopara.msg.check2:gsub("{name}",neko.who):gsub("{place}",neko.place+1):gsub("{type}",neko.type):gsub("{cup}",neko.cup)
        message=message..check2
        p=neko.down
    end
    return message
end
dream.keyword.set("NekoNkeoNkeo","叠猫猫查看猫堆",YesdreamNekopara.func.Check1Neko)

function YesdreamNekopara.func.CheckSelf(msg)
    local file=YesdreamNekopara.func.nekofile(msg.fromGroup)
    if (dream.api.getUserConf("猫堆时间",msg.fromQQ,file) or 0)==dream.api.getUserConf("猫堆时间","neko",file) then
        local neko=dream.api.getUserConf("猫堆",msg.fromQQ,file)
        return YesdreamNekopara.msg.check3:gsub("{name}",neko.who):gsub("{place}",neko.place+1):gsub("{height}",neko.height):gsub("{weight}",neko.weight):gsub("{type}",neko.type):gsub("{cup}",neko.cup):gsub("{ear}",neko.ear):gsub("{tail}",neko.tail):gsub("{cloth}",neko.cloth)
    else
        return YesdreamNekopara.msg.check3false
    end
end
dream.keyword.set("NekoNkeoNkeo","叠猫猫查看自己",YesdreamNekopara.func.CheckSelf)

function YesdreamNekopara.func.PushNeko(msg)
    local file=YesdreamNekopara.func.nekofile(msg.fromGroup)
    local tall= dream.api.getUserConf("猫堆高度","neko",file) or 0
    local self
    if (dream.api.getUserConf("猫堆时间",msg.fromQQ,file) or 0)==dream.api.getUserConf("猫堆时间","neko",file) then
        self=1
    else
        self=0
    end
    if tall==0 then
        return YesdreamNekopara.msg.pushnil
    elseif tall==1 and self==1 then
        local tall=YesdreamNekopara.func.DownNeko(file)
        return YesdreamNekopara.msg.pushself
    elseif tall==1 and self==0 then
        return YesdreamNekopara.msg.pushfalse
    else
        local target=(tall^(2))/math.log(tall)
        local num=sdk.randomInt(1,100)
        if num<target then
            local tall=YesdreamNekopara.func.DownNeko(file)
            if self==1 then
                return YesdreamNekopara.msg.pushin:gsub("{tall}",tall)
            else
                return YesdreamNekopara.msg.pushout:gsub("{tall}",tall)
            end
        else
            return YesdreamNekopara.msg.pushfalse
        end
    end
end
dream.keyword.set("NekoNkeoNkeo","叠猫猫推倒猫堆",YesdreamNekopara.func.PushNeko)


function YesdreamNekopara.func.SetTop(msg)
    if not dream.api.permission(msg.fromGroup,msg.fromQQ) then
    local file=YesdreamNekopara.func.nekofile(msg.fromGroup)
    local num=dream.tonumber(msg.fromMsg:match("%d+"))
    if num==nil then
        return "数据错误，请重新输入"
    end
    dream.api.setUserConf("猫堆高度限制",num,"neko",file)
    return YesdreamNekopara.msg.setneko:gsub("{num}",num)
    end
end
dream.command.set("NekoNkeoNkeo","nekoset",YesdreamNekopara.func.SetTop)

function YesdreamNekopara.func.ResetNeko(msg)
    if not dream.api.permission(msg.fromGroup,msg.fromQQ) or dream.deter.master(msg.fromQQ) then
        local file=YesdreamNekopara.func.nekofile(msg.fromGroup)
        local tall=YesdreamNekopara.func.DownNeko(file)
        return YesdreamNekopara.msg.restart:gsub("{tall}",tall)
    else
        return ""
    end
end
dream.command.set("NekoNkeoNkeo","nekoreset",YesdreamNekopara.func.ResetNeko)

return {
    id = "NekoNkeoNkeo",
    version = "1.4.6",
    help = "--叠猫猫(NekoNkeoNkeo)--\n叠猫猫加入\n叠猫猫推倒猫堆\n叠猫猫查看猫堆\n叠猫猫查看自己\n.nekoset [数字]--设置叠猫猫上限高度(限管理以上)\n.nekoreset--强制重置猫堆高度(限管理以上)\n(指令中并不包含中括号，替换掉的时候请连同中括号一起替换)",
    author = "雨岚之忆",
    mode = true
  }