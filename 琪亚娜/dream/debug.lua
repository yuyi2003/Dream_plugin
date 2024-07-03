--[[
  * Dream官方插件
  * 在聊天界面执行lua语句
]]

de = {}

function de.main(i)
  local str = i.fromParams
  if str ~= "" then
    local start = os.clock()
    msg = table.clone(i)
    local fun = rawload(str)
    local res,info = pcall(fun)
    if not res then
      return "error："..info
    end
    local type_data = type(info)
    collectgarbage("collect")
    i = tostring(tostring(info))
    local endl = os.clock()
    return "loadTime："..endl-start.."s\n返回类型："..type_data.."\n返回："..i
  end
end
dream.keyword.set("debug",">",de.main,true)

function de.dolua(i)
  local str = i.fromParams
  if str ~= "" then
    local start = os.clock()
    msg = table.clone(i)
    local fun = rawload(str)
    local res,info = pcall(fun)
    if not res then
      return "error："..info
    end
    local type_data = type(info)
    collectgarbage("collect")
    i = tostring(tostring(info))
    local endl = os.clock()
    return "loadTime："..endl-start.."s\n返回类型："..type_data.."\n返回："..i
  end
end
dream.command.set("debug","do",de.dolua,true)

return {
  id = "debug",
  version = "2.0",
  help = [[在聊天界面执行lua代码]],
  author = "筑梦师V2.0",
  mode = true
}