Love_DLC={--好感度自定义回复DLC
        reply1={
            name="reply1";
            keyword={"test1";"test2"};
            date=nil;
            time_barrier={21600,39600,46800,68400,79200};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {--时间1
                    "测试11";--好感1
                    "测试12";--好感2
                };
                {--时间2
                    "测试21";
                    "测试22";
                };
                {"测试3"};
                {"测试4"};
                {"测试5"};
                {"测试6"};
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
        local love=(dream.api.getUserConf("好感度",msg.fromQQ,"yesdream_favorability") or 0)*0.1
        return message:gusb("{love}",love):gsub("{nick}",msg.fromNick):gsub("{dice}",msg.fromDiceName)
    end
end

function reply1(msg)
    local message=reply_message(msg,Love_DLC.reply1)
    return message
end

for i=1,#Love_DLC.reply1.keyword do
    dream.keyword.set("love",Love_DLC.reply1.keyword[i],reply1)
end