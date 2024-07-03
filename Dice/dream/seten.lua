--[[
  * 更新人物卡的同时自动改群名称
  * author：筑梦师V2.0
  * 请随意修改/转载
]]

seten = {}

function seten.on(msg)
  if ((not dream.api.permission(msg.fromGroup,msg.fromQQ)) or dream.deter.master(msg)) == false then
    return ""
  end
  if dream.plugin.getConfig("seten","setenList") then
    local setenList = dream.plugin.getConfig("seten","setenList")
    setenList[msg.fromGroup] = "on"
  else
    setenList = {
      [msg.fromGroup] = "on"
    }
  end
  dream.plugin.setConfig("seten","setenList",setenList)
  return "已开启群\\["..msg.fromGroup.."\\]的自动群名片更新√"
end
dream.command.set("seten","seten on",seten.on)

function seten.off(msg)
  if ((not dream.api.permission(msg.fromGroup,msg.fromQQ)) or dream.deter.master(msg)) == false then
    return ""
  end
  if dream.plugin.getConfig("seten","setenList") then
    local setenList = dream.plugin.getConfig("seten","setenList")
    setenList[msg.fromGroup] = "off"
  else
    setenList = {
      [msg.fromGroup] = "off"
    }
  end
  dream.plugin.setConfig("seten","setenList",setenList)
  return "已关闭群\\["..msg.fromGroup.."\\]的自动群名片更新√"
end
dream.command.set("seten","seten off",seten.off)

function seten.st(msg)
  if msg.fromParams:gsub(" ","") == "show" then
    return "stshow"
  elseif msg.fromParams == "" then
    dream.api.sendMessage("人物卡数据写入失败，缺少必要参数，如技能名，技能数值",msg)
    return "属性修改指令修改完毕"
  end
  local skill = ""
  local num
  for i=1,#msg.fromParams do
    if msg.fromParams:sub(i,i):find("([0-9]+)") then
      num = msg.fromParams:sub(i,-1)
      break
    else
      skill = skill..msg.fromParams:sub(i,i)
    end
  end
  if skill == "" then
    dream.api.sendMessage("人物卡数据写入失败，缺少必要参数，如技能名，技能数值",msg)
    return "属性修改指令修改完毕"
  elseif not num then
    dream.api.sendMessage("人物卡数据写入失败，缺少必要参数，如技能名，技能数值",msg)
    return "属性修改指令修改完毕"
  end
  local playerName = sdk.readPlayerName(msg.fromQQ,msg.fromGroup)
  local playerCard = sdk.readPlayerCard(msg.fromQQ,playerName)
  playerCard[skill] = num
  sdk.writePlayerCard(msg.fromQQ,playerName,playerCard)
  local data = {
    player = playerName,
    nick = msg.fromDiceName,
    user = msg.fromNick,
    id = msg.fromQQ,
    group = msg.fromGroup,
    changed = skill.."="..num
  }
  local SET_PAYER_INFO = dream.escape(data,sdk.readSystemConfig("SENTENCE_SET_PAYER_INFO"))
  if dream.plugin.getConfig("seten","setenList") then
    local setenList = dream.plugin.getConfig("seten","setenList")
    if setenList[msg.fromGroup] == "on" then
      dream.api.sendMessage(SET_PAYER_INFO,msg)
      log("尝试群名片自动更新中…")
      log("少女祈祷中…")
      return "sn"
    end
  end
  dream.api.sendMessage(SET_PAYER_INFO,msg)
  return "属性修改指令修改完毕"
end
dream.replace.set("seten","st",seten.st)

function seten.help(msg)
  return [[自动群名片更新帮助文档
.seten on //开启自动群名片更新
.seten off //关闭自动群名片更新]]
end
dream.command.set("seten","seten help",seten.help)

return {
  id = "seten",
  version = 0.1,
  help = "群名片自动更新",
  author = "筑梦师V2.0",
  
  mode = false
}