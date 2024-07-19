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
        };
        reply2={
            name="reply2";
            keyword={"举高高天依","天依举高高"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={5,100};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {--时间1
                    "不！你不举！",
                    "你是在玩火哦~",
                    "飞咯~"
                }
            }
        };
        reply3={
            name="reply3";
            keyword={"抱住天依","抱天依"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={100,200};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {--时间1
                 "爬爬爬，热死了",
                 "你是在玩火哦~",
                 "抱抱~"
                };
            }
        };
        reply4={
            name="reply4";
            keyword={"亲亲天依";"亲天依"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={100};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "阿绫阿和快来救我，这里有个叫{nick}的变态啊啊啊啊啊啊啊啊啊啊！",
                    "{nick}（づ￣3￣）づ╭～"
                };
            }
        };
        reply5={
            name="reply5";
            keyword={"揉揉天依";"揉天依"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={1,100,200};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "把你的脏手拿开！",
                    "|别揉了别揉了，再揉就要变形了",
                    "蹭蹭",
                    "＞﹏＜"
                };
            }
        };
        reply6={
            name="reply6";
            keyword={"天依贴贴","贴贴天依"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={1,100};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "死变态，给我爬！",
                    "hentai，谁想和你贴贴啊",
                    "贴贴~"

                };
            }
        };
        reply7={
            name="reply7";
            keyword={"摸天依"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={1,100,200};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "滚！",
                    "不可以摸那里啦",
                    "唔，别摸了，长不高的",
                    "摸，摸就摸"
                };
            }
        };
        reply8={
            name="reply8";
            keyword={"牵天依"};
            date=nil;
            time_barrier={};--一天内的秒数(小时*3600+分钟*60+秒)(不填为不区分)
            haogan_barrier={1};--未除十的好感(不填为不区分)
            message={--第一层大括号内区分时间,内部不同的语句区分好感度
                {
                    "谁要牵你的脏手",
                    "啊......好的（脸红）"
                };
            }
        }
        --[[
            可接受参数:
                {nick}--触发人姓名
                {dice}--骰娘名字
                {love}--现有好感度
        ]]-- 
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
        return message
    end
end

function reply1(msg)
    local message=reply_message(msg,Love_DLC.reply1)
    return message
end

for i=1,#Love_DLC.reply1.keyword do
    dream.keyword.set("love",Love_DLC.reply1.keyword[i],reply1)
end

function reply2(msg)
    local message=reply_message(msg,Love_DLC.reply2)
    return message
end

for i=1,#Love_DLC.reply2.keyword do
    dream.keyword.set("love",Love_DLC.reply2.keyword[i],reply2)
end

function reply3(msg)
    local message=reply_message(msg,Love_DLC.reply3)
    return message
end

for i=1,#Love_DLC.reply3.keyword do
    dream.keyword.set("love",Love_DLC.reply3.keyword[i],reply3)
end

function reply4(msg)
    local message=reply_message(msg,Love_DLC.reply4)
    return message
end

for i=1,#Love_DLC.reply4.keyword do
    dream.keyword.set("love",Love_DLC.reply4.keyword[i],reply4)
end

function reply5(msg)
    local message=reply_message(msg,Love_DLC.reply5)
    return message
end

for i=1,#Love_DLC.reply5.keyword do
    dream.keyword.set("love",Love_DLC.reply5.keyword[i],reply5)
end
function reply6(msg)
    local message=reply_message(msg,Love_DLC.reply6)
    return message
end

for i=1,#Love_DLC.reply6.keyword do
    dream.keyword.set("love",Love_DLC.reply6.keyword[i],reply6)
end

function reply6(msg)
    local message=reply_message(msg,Love_DLC.reply6)
    return message
end

for i=1,#Love_DLC.reply6.keyword do
    dream.keyword.set("love",Love_DLC.reply6.keyword[i],reply6)
end

function reply6(msg)
    local message=reply_message(msg,Love_DLC.reply6)
    return message
end

for i=1,#Love_DLC.reply6.keyword do
    dream.keyword.set("love",Love_DLC.reply6.keyword[i],reply6)
end
