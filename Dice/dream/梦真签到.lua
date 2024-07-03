Checkin={--签到
        setting={
            add_min=1;--基础最小数值
            add_max=50;--基础最大数值
            min_weight=1;--最小数值增加，与连续天数加权权重
            max_weight=2;--最大数值增加，与连续天数加权权重
            --[[
                最小数值=基础数值+小权重*连续签到天数
                最大数值=基础数值+大权重*连续签到天数
            ]]
        };
        message={
            success={
                "{user}签到成功，获得{addcoin}枚金币";
            };
            failure={
                "{user}今天已经签过到了哦";
            }
            --[[
            可接受参数:
                {user}--触发人姓名
                {addcoin}--增加金币数目
            ]]--     
        }
    };
i=sdk.randomInt(1,100)

function checkin(msg)
    if msg.fromMsg~="签到" then
        return ""
      end
    if (dream.api.getUserConf("签到天",msg.fromQQ,"checkin") or 0)~=dream.api.today() then
        if os.date("%j") - (dream.api.getUserConf("签到日",msg.fromQQ,"checkin") or 0)<=1  then
            print(os.date("%j") - (dream.api.getUserConf("签到日",msg.fromQQ,"checkin") or 0))
            dream.api.setUserConf("连续签到天",(dream.api.getUserConf("连续签到天",msg.fromQQ,"checkin") or 0)+1,msg.fromQQ,"checkin")
            else
                dream.api.setUserConf("连续签到天",1,msg.fromQQ,"checkin")
        end
        dream.api.setUserConf("签到天",dream.api.today(),msg.fromQQ,"checkin")
        dream.api.setUserConf("签到日",os.date("%j"),msg.fromQQ,"checkin")
        local j=dream.api.getUserConf("连续签到天",msg.fromQQ,"checkin")
        local coin=sdk.randomInt(Checkin.setting.add_min+Checkin.setting.min_weight*j,Checkin.setting.add_max+Checkin.setting.max_weight*j)
        dream.api.setUserConf("金币",(dream.api.getUserConf("金币",msg.fromQQ,"yesdream_bag") or 0)+coin,msg.fromQQ,"yesdream_bag")
        return Checkin.message.success[i%#Checkin.message.success+1]:gsub("{user}",msg.fromNick):gsub("{addcoin}",coin)
    else
        return Checkin.message.failure[i%#Checkin.message.failure+1]:gsub("{user}",msg.fromNick)
    end
end

dream.keyword.set("checkin","签到",checkin)



return {
    id = "checkin",
    version = "1.0.0",
    help = "",
    author = "雨岚之忆",
    
    mode = true
  } 