Love_DLC={--好感度自定义回复DLC
        reply1={
            name="reply1";
            keyword={"和格蕾修一起玩"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={5000};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "今天，是快乐的颜色，谢谢你。如果有时间，在一起玩吧。";
                    "你看着面前的少女，夜空中，她的眼睛闪闪发光，恍若星眸。\n她抬头仰望夜空，夜空繁星闪烁。\n“星星们居住的地方，会是什么颜色呢？”\n“我想，那一定是最美丽的颜色，和你一样。”\n你如此说道。\n繁星与你，皆为奇迹。"
                }
            }
        };
        reply2={
            name="reply2";
            keyword={"摸摸格蕾修"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={800};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "(害羞的躲开。)";
                    "唔--"
                }
            }
            --[[
            可接受参数:
                {nick}--触发人姓名
                {dice}--骰娘名字
                {love}--现有好感度
        ]]-- 
        }
    };

local function date()
    local time=os.date("%m").."-"..os.date("%d")
    return time
end

local function time()
    local time=os.date("%H")*3600+os.date("%M")*60+os.date("%S")
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

function reply_message (msg,module)
    if (module.date or date())==date() then
        local haogan=barrier((dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0),module.haogan_barrier)
        local time=barrier(time(),module.time_barrier)
        print(haogan)
        print(time)
        local message=module.message[time][haogan]
        print(message)
        print(msg.fromNick)
        print(msg.fromDiceName)
        local love=(dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)*0.1
        print(love)
        return message:gsub("{nick}",msg.fromNick):gsub("{dice}",msg.fromDiceName)
    end
end

function reply1(msg)
    local message=reply_message(msg,Love_DLC.reply1)
    return message
end

function reply2(msg)
    local message=reply_message(msg,Love_DLC.reply2)
    return message
end

for i=1,#Love_DLC.reply1.keyword do
    dream.keyword.set("love",Love_DLC.reply1.keyword[i],reply1)
end

for i=1,#Love_DLC.reply2.keyword do
    dream.keyword.set("love",Love_DLC.reply2.keyword[i],reply2)
end