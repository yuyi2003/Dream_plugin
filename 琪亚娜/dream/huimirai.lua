if dream.MiraiApiHttp == true then
    dream.plugin.setConfig("MiraiApiHttp","http",8080)
    dream.plugin.setConfig("MiraiApiHttp","server",5700)
    dream.plugin.setConfig("MiraiApiHttp","verifyKey","1234567890") -- 这个改"1234567890"时候别删"，删了报错不归我管
  else
    return {
    id = "MiraiApiHttp",
    version = 1.0,
    help = "对接mirai-api-http插件",
    author = "筑梦师V2.0",
    
    mode = false -- 不用MiraiApiHttp会禁用此插件
    }
end

function recall(msg)
    local messageId = dream.tostring(msg.fromMsg:match("ids=(.+),")):match("([0-9]+)")
    local Msg = msg.fromMsg:match("content=<not yet initialized>%](.+)$")
    if Msg == nil then
        return ""
    end
    Msg = Msg:gsub(dream.api.getDiceQQ(),""):gsub(" ","")
    if Msg == "#撤回" then
        local i,j = mirai.recall(messageId,msg)
        if i then
            return "撤回成功"
        else
            return "撤回失败："..j
        end
    end
end
  dream.keyword.set("MiraiApiHttp","[mirai:quote:",recall,true)

function sleep(msg)
    if dream.api.permission(msg.fromGroup,dream.api.getDiceQQ()) == true then
        return "当前"..msg.fromDiceName.."没有管理权限呢～"
    end
    local qq,str = msg.fromMsg:match("^#safe (.+) (.+)$")
    local n,m =string.match(str,"^(.+)d(.+)$")
    local b = string.match(str,"^[0-9]+")
    local time =1
    local roll = 1
    local second = 1
    if (n == nil or m == nil)then
        if (tostring(str)==b) then
            time=tonumber(str)
        end
    else
        roll = ZhaoDiceSDK.roll(str,100)
        time = roll.number
    end
        second=time*60
        mirai.mute(msg.fromGroup,qq,second)
    return "设置成功"
end
dream.keyword.set("MiraiApiHttp","#safe",sleep)

function Title(msg)
    if dream.api.permission(msg.fromGroup,dream.api.getDiceQQ(),"OWNER") == false then
      return "当前"..msg.fromDiceName.."没有群主权限呢～"
    end
    local id,title = msg.fromMsg:match("^#title(.+)give(.+)$")
    if id == nil then
      return ""
    elseif title == nil then
      return ""
    elseif id == "我" then
      id = msg.fromQQ
    elseif not id:match("([0-9]+)") then
      return ""
    end
    id = id:match("([0-9]+)")
    local list = dream.api.getGroupsList(msg.fromGroup)
    local bool
    for i=1,#list.list do
      if list.list[i].uin == tonumber(id) then
        bool = true
        break
      else
        bool = false
      end
    end
    if not bool then
      return "群员"..id.."不存在×"
    end
    local b,r = mirai.SetTitle(msg.fromGroup,id,title)
    if b then
      return "设置成功"
    else
      return "设置失败："..r
    end
  end
  dream.keyword.set("MiraiApiHttp","#title",Title,true)

  function toAdmin(msg)
    local qq = msg.fromMsg:match("^#adson(.+)$")
    qq = qq:gsub(" ","")
    local bool,r = mirai.memberAdmin(msg.fromGroup,qq,true)
    if not bool then
      return "设置管理员失败："..r
    else
      return "设置成功"
    end
  end
  dream.keyword.set("MiraiApiHttp","#adson",toAdmin,true)
  
  function removeAdmin(msg)
    local qq = msg.fromMsg:match("^#adsoff(.+)$")
    qq = qq:gsub(" ","")
    local bool,r = mirai.memberAdmin(msg.fromGroup,qq,false)
    if not bool then
      return "剥夺管理员失败："..r
    else
      return "剥夺成功"
    end
  end
  dream.keyword.set("MiraiApiHttp","#adsoff",removeAdmin,true)
  


return {
    id = "MiraiApiHttp",
    version = 1.0,
    help = "对接mirai-api-http插件",
    author = "筑梦师V2.0",
    
    mode = true
  }