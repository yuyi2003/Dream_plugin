--[[增改教程:

    观前提醒:此教程并非从零或者月夜系，不会的懒得解答

    先将模板table进行复制并修改，在最新版中，模板table移动到配置文件
    再将模板函数复制到最下面，并将[替换]修改成table的名字

    ps:回复和触发词均为table，可并行多加回复
]]--

--[[    模板table
    [名字]={
        name="[名字]";--填名字，需要和引用对齐
        num={
            tiger_time=nil;--触发时间/填入nil则为每日触发
            roll_target=nil;--比这个数值小即可加好感/填nil即为匹配好感度
            --随机边界
            roll_max=100;
            roll_min=1;
            --增减数值
            num_max=20;
            num_min=1;

            freq=4;--次数/每天
            timelink=3;--间隔/每次
        };
        sen={
            keyword={"";};--触发词
            success={"";};--成功回复
            fail={"";};--失败回复
            timeless={"";};--时间不足回复
            freqout={"";};--次数过多回复
        };
    };
]]--

--[[    sen可接受参数:
    {nick}--触发人姓名
    {dice}--骰娘名字
    {cold}--每日最高触发次数(限sen.freqout)
    {timeless}--冷却时间(限sen.timeless)
    {num}--增加或者减少好感数量(限success和fail)
]]--

--[[    模板函数
function [名字](msg)
    local modle=Love.[名字]
    local sen=love_add(msg,modle)
    return sen;
end

for v=1,#Love.[名字].sen.keyword do
    dream.keyword.set("love",Love.[名字].sen.keyword[v],[名字])
    end
]]--
Love={--好感度
        --[[
            关于好感度函数:
                barrier代表分界函数，左开右闭。
                message_barrier代表不同好感所触发的回复，从低到高
                比如示例，间隔为100，800，2000.即为：语句1 100 语句2 800 语句3 2000 语句4
                message代表统一底部回复，一般用于展示好感度
        ]]
        haogan={
            barrier={100,800,2000};
            message_barrier={
                {"和我做朋友？（轻笑）好啊";};
                {"一起吗？布洛妮娅做了新的游戏";};
                {"你说，芽衣她们现在在干嘛呢？";};
                {"谢谢你，以后的故事，我们一起吧";};
            };
            message={"\n(花火的好感度？:{haogan})"};
        };
        --table复制到大概这个位置即可--
        add2={
            name="add2";--填名字，需要和引用对齐
            num={
                tiger_time=nil;--触发时间/填入nil则为每日触发
                roll_target=101;--比这个数值小即可加好感/填nil即为匹配好感度
                --随机边界
                roll_max=100;
                roll_min=1;
                --增减数值
                num_max=30;
                num_min=5;
                freq=1;--次数/每天
                timelink=1;--间隔/每次
            };
            sen={
                keyword={"喂食吐司披萨";};--触发词
                success={"以前，芝士可是很难买到的\n某些数值悄悄上升了--{num}";};--成功回复
                fail={"";};--失败回复
                timeless={"谢谢，不过我已经吃饱了";};--时间不足回复
                freqout={"谢谢，不过我已经吃饱了";};--次数过多回复
            };
        };
        add3={
            name="add3";--填名字，需要和引用对齐
            num={
                tiger_time=nil;--触发时间/填入nil则为每日触发
                roll_target=101;--比这个数值小即可加好感/填nil即为匹配好感度
                --随机边界
                roll_max=100;
                roll_min=1;
                --增减数值
                num_max=40;
                num_min=10;
                freq=1;--次数/每天
                timelink=1;--间隔/每次
            };
            sen={
                keyword={"喂食甜椒咖喱";};--触发词
                success={"是啊，甜椒咖喱怎么会有辣味呢？\n某些数值悄悄上升了--{num}";};--成功回复
                fail={"";};--失败回复
                timeless={"谢谢，不过我已经吃饱了";};--时间不足回复
                freqout={"谢谢，不过我已经吃饱了";};--次数过多回复
            };
        };
        add4={
            name="add4";--填名字，需要和引用对齐
            num={
                tiger_time=nil;--触发时间/填入nil则为每日触发
                roll_target=101;--比这个数值小即可加好感/填nil即为匹配好感度
                --随机边界
                roll_max=100;
                roll_min=1;
                --增减数值
                num_max=20;
                num_min=1;
                freq=1;--次数/每天
                timelink=1;--间隔/每次
            };
            sen={
                keyword={"喂食炸鸡块";};--触发词
                success={"在圣芙蕾雅那段时间，我最喜欢吃芽衣做的炸鸡块了\n某些数值悄悄上升了--{num}";};--成功回复
                fail={"";};--失败回复
                timeless={"谢谢，不过我已经吃饱了";};--时间不足回复
                freqout={"谢谢，不过我已经吃饱了";};--次数过多回复
            };
        };
        --table复制到大概这个位置即可--
        add1={
            name="add1";--填名字，需要和引用对齐
            num={
                tiger_time=nil;--触发时间/填入nil则为每日触发
                roll_target=101;--比这个数值小即可加好感/填nil即为匹配好感度
                --随机边界
                roll_max=100;
                roll_min=1;
                --增减数值
                num_max=20;
                num_min=1;
                freq=3;--次数/每天
                timelink=4;--间隔/每次
            };
            sen={
                keyword={"喂食琪亚娜";};--触发词
                success={"谢谢，感觉你的手艺和芽衣平分秋色呢\n某些数值悄悄上升了--{num}";};--成功回复
                fail={"有趣的小玩意,既然是你...那我就不客气的拿走了~\n某些数值悄悄上升了--{num}";};--失败回复
                timeless={"谢谢，不过我已经吃饱了";};--时间不足回复
                freqout={"谢谢，不过我已经吃饱了";};--次数过多回复
            };
            --[[  
                可接受参数:
                    {nick}--触发人姓名
                    {Dice}--骰娘名字
                    {cold}--每日最高触发次数(限sen.freqout)
                    {timeless}--冷却时间(限sen.timeless)
                    {num}--增加或者减少好感数量(限success和fail)
            ]]--
        };
    };
local i=sdk.randomInt(1,100)--如果回复能超过100记得改这里

local function date()
    local time=os.date("%m").."-"..os.date("%d")
    return time
end

local function barrier(haogan,barrier)
    for j=1,#barrier do
        if haogan<barrier[j] then
            return j
        end
    end
    return #barrier+1
end

function love_read(msg)
    local haogan=(dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)
    local message_select=Love.haogan.message_barrier[barrier(haogan,Love.haogan.barrier)]
    local message=message_select[i%#message_select+1]..Love.haogan.message[i%#Love.haogan.message+1]
    haogan=haogan*0.1
    return message:gsub("{haogan}",haogan)
  end
  dream.keyword.set("love","好感度",love_read)

function qianyi(msg)
    local file = io.open(dream.setting.path.."/data/user.json","r")
    if not file then
        return ""
    end
    local data = file:read("*a")
    file:close()
    data = json.decode(data)
    local tab = {}
    local tab_ = {}
    for i=1,#data do
        if dream.api.getUserConf("好感度",data[i].id) then
            dream.api.setUserConf("好感度",data[i]["好感度"],data[i].id,"yesdream_favorability")
            print("数据迁移成功")
        end
    end
    return("数据迁移完毕")
end
dream.keyword.set("love","迁移数据",qianyi)

function love_add(msg,modle)
    if (modle.num.tiger_time or date())==date() then
        if dream.api.getUserConf("好感度_"..modle.name.."_冷却_天",msg.fromQQ,"yesdream_favorability")==dream.api.today() then
            if (dream.api.getUserConf("好感度_"..modle.name.."_冷却_次数",msg.fromQQ,"yesdream_favorability") or 0)>=modle.num.freq then
                return modle.sen.freqout[(i%(#modle.sen.freqout))+1]:gsub("{nick}",msg.fromNick):gsub("{cold}",modle.num.freq):gsub("{dice}",msg.fromDicename)
            else
                if (dream.api.getUserConf("好感度_"..modle.name.."_冷却_时间",msg.fromQQ,"yesdream_favorability") or 0)>=(os.date("%H")*60+os.date("%M")) then
                   return modle.sen.timeless[(i%(#modle.sen.timeless))+1]:gsub("{nick}",msg.fromNick):gsub("{timeless}",(dream.api.getUserConf("好感度_"..modle.name.."_冷却_时间",msg.fromQQ,"yesdream_favorability")-(os.date("%H")*60+os.date("%M")))):gsub("{dice}",msg.fromDicename)
                end
            end
        else
            dream.api.setUserConf("好感度_"..modle.name.."_冷却_次数",0,msg.fromQQ,"yesdream_favorability")
        end
        dream.api.setUserConf("好感度_"..modle.name.."_冷却_天",dream.api.today(),msg.fromQQ,"yesdream_favorability")
        dream.api.setUserConf("好感度_"..modle.name.."_冷却_次数",(dream.api.getUserConf("好感度_"..modle.name.."_冷却_次数",msg.fromQQ,"yesdream_favorability") or 0)+1,msg.fromQQ,"yesdream_favorability")
        dream.api.setUserConf("好感度_"..modle.name.."_冷却_时间",os.date("%H")*60+os.date("%M")+modle.num.timelink*60,msg.fromQQ,"yesdream_favorability")
        local roll=sdk.randomInt(modle.num.roll_min,modle.num.roll_max)
        local love=sdk.randomInt(modle.num.num_min,modle.num.num_max)
        local love_num=(dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)>100 and 100 or (dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)
        if roll<(modle.num.roll_target or (love_num/10)+1)  then
            dream.api.setUserConf("好感度",(dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)+love,msg.fromQQ,"yesdream_favorability")
            return modle.sen.success[(i%(#modle.sen.success))+1]:gsub("{nick}",msg.fromNick):gsub("{dice}",msg.fromDicename):gsub("{num}",love*0.1)
        else
            dream.api.setUserConf("好感度",(dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)-love,msg.fromQQ,"yesdream_favorability")
            return modle.sen.fail[(i%(#modle.sen.fail))+1]:gsub("{nick}",msg.fromNick):gsub("{dice}",msg.fromDicename):gsub("{num}",love*0.1)
        end
    end
end

function add1(msg)
    local modle=Love.add1
    local sen=love_add(msg,modle)
    return sen
end
for v=1,#Love.add1.sen.keyword do
dream.keyword.set("love",Love.add1.sen.keyword[v],add1)
end

function add2(msg)
    local modle=Love.add2
    local sen=love_add(msg,modle)
    return sen
end
for v=1,#Love.add2.sen.keyword do
dream.keyword.set("love",Love.add2.sen.keyword[v],add2)
end

function add3(msg)
    local modle=Love.add3
    local sen=love_add(msg,modle)
    return sen
end
for v=1,#Love.add3.sen.keyword do
dream.keyword.set("love",Love.add3.sen.keyword[v],add3)
end

function add4(msg)
    local modle=Love.add4
    local sen=love_add(msg,modle)
    return sen
end
for v=1,#Love.add4.sen.keyword do
dream.keyword.set("love",Love.add4.sen.keyword[v],add4)
end


--在此添加模板函数--

return {
    id = "love",
    version = "1.5.0",
    help = "--梦真好感度--",
    author = "雨岚之忆",
    
    mode = true
  }
