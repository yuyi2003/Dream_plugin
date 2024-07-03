Bottle_post={--漂流瓶
        throw_message={
            "成功向海里添加一个漂流瓶"
        };
        pickup_message={
            "你成功捡起一个漂流瓶\n漂流瓶ID:{bottle_ID}\n漂流瓶内容:\n{bottle_message}"
        };
        empty_message={
            "不要丢空瓶子"
        }
    };
i=sdk.randomInt(1,100)
function throw_bottle(msg)
    local num=(dream.api.getUserConf("漂流瓶数量","bottle_post","bottle_post") or 0)+1
    local fromMsg=msg.fromMsg:match("^丢漂流瓶(.+)$")
    if fromMsg==nil then
        return Bottle_post.empty_message
    end
    dream.api.setUserConf("漂流瓶内容",fromMsg,num,"bottle_post")
    dream.api.setUserConf("漂流瓶发送者",msg.fromQQ,num,"bottle_post")
    dream.api.setUserConf("漂流瓶来自群",msg.fromGroup,num,"bottle_post")
    dream.api.setUserConf("漂流瓶数量",num,"bottle_post","bottle_post")
    return Bottle_post.throw_message[(i%#Bottle_post.throw_message)+1]
end

dream.keyword.set("bottle_post","丢漂流瓶",throw_bottle)

function pickup_bottle(msg)
    if (dream.api.getUserConf("漂流瓶数量","bottle_post","bottle_post") or 0)~=0 then
    local num=ZhaoDiceSDK.randomInt(1,dream.api.getUserConf("漂流瓶数量","bottle_post","bottle_post"))
    local Msg=dream.api.getUserConf("漂流瓶内容",num,"bottle_post")
    return Bottle_post.pickup_message[(i%#Bottle_post.pickup_message)+1]:gsub("{bottle_ID}",num):gsub("{bottle_message}",Msg)
    else
        return "error"    
    end
end

dream.keyword.set("bottle_post","捡漂流瓶",pickup_bottle)


return {
    id = "bottle_post",
    version = "1.0.0",
    help = "",
    author = "雨岚之忆",
    
    mode = true
  } 