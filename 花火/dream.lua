local startTime = os.clock() -- 在32位操作系统有溢出风险
local endTime
dream.api = {}
dream.nick = ZhaoDiceSDK.readSystemConfig("DICE_NAME") -- 你的骰娘名称
dream._VERSION = "ver4.2.1(131)"
dream.version = "Dream by 筑梦师V2.0&乐某人 "..dream._VERSION.."[2024-06-09 18:34:02] for AstralDice"

-- dream基本库 --
function dream.log(str,event)
  local event = event or "PluginLoader"
  local i
  if type(str) ~= "string" or type(str) ~= "number" then
    i = tostring(str)
  else
    i = str
  end
  print("["..event.."]"..str)
end

function dream.tonumber(str)
  if type(str) == "number" then
    return str
  elseif type(str) == "string" then
    if dream.math.isNumber(str) then
      local num = str + 1
      return num - 1
    end
    return nil
  else
    return nil
  end
end

tonumber = dream.tonumber

function dream.tostring(msg)
  local msg = msg
  if type(msg) == "nil" then
    return "nil"
  elseif type(msg) == "string" then
    return msg
  elseif type(msg) == "number" then
    return ""..msg
  elseif type(msg) == "boolean" then
    if msg then
      return "true"
    else
      return "false"
    end
  elseif type(msg) == "table" then
    if getmetatable(msg) then
      local metatable = getmetatable(msg)
      if metatable.__tostring then
        return metatable.__tostring(msg)
      else
        return dream.TableToString(msg)
      end
    else
      return dream.TableToString(msg)
    end
  elseif dream.search(msg) then
    local i = dream.search(msg)
    local tab = {}
    i = i:gsub(".",function(x)
      tab[#tab+1] = x:byte()
    end)
    i = 0
    for x=1,#tab do
      i = i + tonumber(tab[x])
    end
    i = dream.math.num2toHex(i,16)
    return type(msg)..":0x"..i:lower()
  else -- local value
    return "local:"..type(msg)
  end
end
tostring = dream.tostring

function dream.toboolean(str)
  if str == "true" then
    return true
  elseif str == "false" then
    return false
  else
    return nil
  end
end

function dream.require(dir)
  local file = io.open(dir,"r") or nil
  if file == nil then
    return false
  end
  local f = file:read("*a")
  file:close()
  local a,b = pcall(load("dofile(\""..dir.."\")"))
  if a then
    return load(f)() -- 以最后脚本的return结果为准
  else
    dream.error("调用库"..string.match(dir,".+/(.+)").."文件失败！错误信息:\n"..b)
    dream.sendMaster("调用库"..string.match(dir,".+/(.+)").."文件失败！错误信息:\n"..b)
    error()
  end
end

function rawload(luaStr)
  local file = io.open(dream.setting.path.."/lua.lua","w")
  file:write(luaStr)
  file:close()
  local a,b = loadfile(dream.setting.path.."/lua.lua")
  dream.execute("rm "..dream.setting.path.."/lua.lua")
  if a then
    return a
  else
    local line = b:match(dream.setting.path.."/lua.lua:(.+):")
    error("line:"..line..":"..b:gsub(dream.setting.path.."/lua.lua:.+:",""))
  end
end

function dream.error(errorInfo,b) -- 捕获错误信息并打印至控制台
  if b == nil then
    b = true
  end
  local line = string.match(errorInfo,":([0-9]+) ")
  if type(b) ~= "boolean" then
    b = true
  end
  local a
  if line == nil then
    a = errorInfo
  else
    a = "line:"..line.."\n"..string.match(errorInfo,":"..line.." (.+)")
  end
  if b ~= true then
    return a
  else
    print("[error]\n"..os.date("%Y-%m-%d %H:%M").."\n"..a)
  end
end

function dream.sendError(str)
  local file = io.open(dream.setting.path.."/data/setting.json","r")
  if dream.api.getNotice() then
    dream.api.sendGroupMessage("[error]\n"..os.date("%Y-%m-%d %H:%M").."\n"..str)
  elseif file then
    tab = file:read("*a")
    file:close()
    tab = dream.json.decode(tab)
    for i=1,#tab["admin"] do
      dream.api.sendUserMessage("[error]:"..str,tab["admin"][i])
    end
  else
    dream.log(dream.nick.."未认主，将静默此次报错","error")
  end
end

function dream.list(type_,tab,vis)
  local tab = tab or _G
  local vis = vis or {[_G] = true}
  if type_ == nil then
    return nil
  end
  local list = setmetatable({},{__add = function(oldtable,newtable)
    for k,v in pairs(newtable) do
      oldtable[k] = v
    end
    return oldtable
  end})
  for k,v in pairs(tab) do
    if type(v) == type_ then
      list[dream.search(v)] = v
    elseif type(v) == "table" then
      if not vis[v] then
        vis[v] = true
        local newlist = dream.list(type_,v,vis)
        list = list + newlist
      end
    end
  end
  return list
end

function dream.search(value,tab,prefix,vis)
  local tab = tab or _G
  local prefix = prefix or "_G"
  local vis = vis or {[_G] = true}
  if value == nil then
    return nil
  end
  for k,v in pairs(tab) do
    if v == value then
      return prefix.."."..k
    elseif type(v) == "table" then
      if not vis[v] then
        vis[v] = true
        local i = dream.search(value,v,prefix.."."..k,vis)
        if i then
          return i
        end
      end
    end
  end
  return nil
end

function dream.get(k)
  local i = dream.string.part(k,".")
  local v = _G
  for n=1,#i do
    if v[table.concat(i,".",n,#i)] then
      return v[table.concat(i,".",n,#i)]
    elseif v[table.concat(i,".",n,#i).."."] then
      return v[table.concat(i,".",n,#i).."."]
    end
    v = v[i[n]]
    if not v then
      return nil
    end
  end
  return v
end

function dream.TableToString(tab,l,vis)
  if type(tab) ~= "table" then
    error("non-table type")
  end
  local i
  if l then
    i = l.."  "
  else
    i = "  "
  end
  local vis = vis or {}
  local str = "{"
  for k,v in pairs(tab) do
    local j
    if type(k) == "function" then
      j = "function"
    else
      j = dream.json.encode(k)
    end
    if type(v) == "table" then
      if vis[v] then
        error("circular references")
      else
        vis[v] = true
      end
      str = str.."\n"..i.."["..j.."]"..i:sub(1,#i/2).."->"..i:sub(1,#i/2)..dream.TableToString(v,i,vis)
    else
      if type(v) == "function" then
        r = "function"
      else
        r = dream.json.encode(v)
      end
      str = str.."\n"..i.."["..j.."]"..i:sub(1,#i/2).."->"..i:sub(1,#i/2)..r
    end
  end
  if str ~= "{" then
    return str.."\n"..i:sub(1,#i-2).."}"
  else
    return "{}"
  end
end

function dream.escape(tab,source)
  for k,v in pairs(tab) do
    source = source:gsub("{"..k.."}",v)
  end
  return source
end

function pairs(tab)
  return next,tab,nil
end

-- 优化原生库
local char = string.char
function string.char(x)
  x = dream.math.pos(x) or -1
  if x < 0 or x > 256 then
    return nil
  end
  return char(x)
end

function math.log10(n)
  if type(n) ~= "number" then
    return nil
  end
  local i = 2
  while true do
    if 10 ^ i > n then
      return nil
    elseif 10 ^ i == n then
      return i
    end
    i = i + 1
  end
end

local httpGet = ZhaoDiceSDK.network.httpGet
function ZhaoDiceSDK.network.httpGet(url)
  if httpGet(url) == "" then
    return nil
  else
    return httpGet(url)
  end
end
sdk = ZhaoDiceSDK

local rawostime = os.time
function os.time()
  return tonumber(string.format("%u",rawostime()))
end

function dream.execute(cmd)
  local f = io.open(dream.setting.path.."/sh.sh","w")
  f:write(cmd)
  f:close()
  local f = io.popen("sh "..dream.setting.path.."/sh.sh","rb")
  local txt = f:read("*a")
  if txt then
    return txt
  else
    return false
  end
end

-- table新增库
function table.gsub(tab,index,s)
  for k,v in pairs(tab) do
    v = v:gsub(index,s)
    tab[k] = v
  end
  return tab
end

function table.orderly(tab)
  local tbl = {}
  local i = 0
  for k,v in pairs(tab) do
    if k > i then
      i = k
    end
  end
  for ind=1,i do
    if tab[ind] ~= nil then
      table.insert(tbl,tab[ind])
    end
  end
  return tbl
end

function table.sort(tab,id)
  tab = table.orderly(tab)
  local tbl = {}
  for i=1,#tab do
    if not tbl[1] then
      table.insert(tbl,tab[i])
    else
      local ind
      for l=1,#tbl do
        if id == nil then
          if tbl[l] >= tab[i] then
            ind = l
          end
        else
          if tbl[l][id] >= tab[i][id] then
            ind = l
          end
        end
      end
      ind = ind or 0
      table.insert(tbl,ind+1,tab[i])
    end
  end
  return tbl
end

function table.clone(tab,vis)
  local tbl = {}
  local vis = vis or {}
  for k,v in pairs(tab) do
    if vis[v] then
      error("circular references")
    end
    if type(v) == "table" then
      vis[v] = true
      v = table.clone(v,vis)
    end
    tbl[k] = v
  end
  return tbl
end

function table.unTab(tab,i)
  if tab[i] then
    return tab[i],table.unTab(tab,i+1)
  end
  return nil
end

function unpack(tab,i,j)
  local tab = table.orderly(tab)
  local i = i or 1
  local j = j or #tab
  if i < 1 or j < 1 or i > #tab then
    return nil
  elseif j > #tab then
    j = #tab
  end
  local tbl = {}
  local ind = 1
  for i=i,j do
    tbl[ind] = tab[i]
    ind = ind + 1
  end
  return table.unTab(tbl,1)
end

function pack(...)
  local tbl = {...}
  return tbl
end

-- dream math
dream.math = {}

function dream.math.num2toHex(num,hex)
  if type(num) ~= "number" then
    return nil
  elseif type(hex) ~= "number" then
    return nil
  elseif (hex < 2) or (hex > 16) then
    return nil
  end
  local i = math.floor(num / hex)
  local x = num % hex
  local v = {}
  v[1] = x
  while i >= hex do
    x = i % hex
    v[#v + 1] = x
    i = math.floor(i / hex)
  end
  v[#v + 1] = i
  local hexMap = {0,1,2,3,4,5,6,7,8,9,'A','B',"C",'D','E','F'}
  local txt = ""
  for _,k in ipairs(v) do
    txt = hexMap[k + 1]..txt
  end
  return txt
end

function dream.math.hextoNum2(str,hex)
  if type(hex) ~= "number" then
    return nil
  elseif (hex < 2) or (hex > 16) then
    return nil
  elseif type(str) ~= "string" then
    return nil
  elseif dream.math.isFloat(num) then
    error("Parameter one should be an integer, and the result is a floating-point number")
  elseif hex == 16 then
    str = string.upper(str)
  end
  local x = function(num)
    local map = {}
    local hexMap = {0,1,2,3,4,5,6,7,8,9,'A','B',"C",'D','E','F'}
    for k,v in pairs(hexMap) do
      map[dream.tostring(v)] = k - 1
    end
    return map[num]
  end
  local n = 0
  local k = 0
  for i=#str,1,-1 do
    local num = x(str:sub(i,i))
    n = n + num*hex^k
    k = k + 1
  end
  return n
end

function dream.math.isNumber(str)
  if type(str) == "number" then
    return true
  elseif str:sub(1,1) == "-" then
    str = str:sub(2,-1)
  end
  local str = dream.tostring(str)
  if #str < 1 then
    return false
  elseif dream.math.isFloat(str) then
    return true
  end
  for i=1,#str do
    if str:sub(i,i):byte() < 48 or str:sub(i,i):byte() > 57 then
      return false
    end
  end
  return true
end

function dream.math.isFloat(num)
  if dream.tostring(num):find("^[0-9]+%.([0-9]+)$") then
    return true
  else
    return false
  end
end

function dream.math.isInt(num)
  if dream.tostring(num):match("^([0-9]+)$") then
    return true
  else
    return false
  end
end

function dream.math.getFloat(num)
  if dream.math.isFloat(num) then
    return tonumber(dream.tostring(num):match("^[0-9]+%.([0-9]+)$"))
  end
  return 0
end

function dream.math.getInt(num)
  return tonumber(dream.tostring(num):match("^([0-9]+)%.([0-9]+)$") or dream.tostring(num):match("^([0-9]+)$"))
end

function dream.math.topercent(n,x)
  if type(n) ~= "number" then
    return nil
  elseif x < n then
    return nil
  end
  n = n/x * 100
  return dream.math.getInt(n).."%"
end

function dream.math.pos(x)
  if dream.math.isNumber(x) then
    x = tostring(x)
    if x:sub(1,1) == "-" then
      return tonumber(x:sub(2,-1))
    else
      return tonumber(x)
    end
  end
end

math.random = sdk.randomInt

-- dream http支持
dream.http = {}

function dream.http.urlencode(url)
  local function x(s)
      return "%%"..string.format("%02X",string.byte(s))
  end
  local tab = {}
  local i = 1
  while i < #url do
    local l = url:sub(i,i)
    l = dream.tostring(l)
    if l:byte() >= 228 and l:byte() <= 233 then
      for n=i+1,i+2 do
        local s = dream.tostring(url:sub(n,n))
        if s:byte() >=128 and s:byte() <= 191 then
           tab[#tab+1] = url:sub(i,i+2)
           i = i + 3
        end
      end
    else
      i = i + 1
    end
  end
  for i=1,#tab do
    for l=1,#tab[i] do
      url = url:gsub(tab[i]:sub(l,l),x(tab[i]:sub(l,l)))
    end
  end
  return url:gsub(" ","+")
end

function dream.http.urldecode(url)
  url = url:gsub("+"," ")
  url = url:gsub("%%%x%x",function(x)
    x = x:sub(2,-1)
    return string.char(dream.math.hextoNum2(x,16))
  end)
  return url
end

function dream.http.get(url)
  if type(url) ~= "string" then
    return nil
  end
  url = dream.http.urlencode(url)
  return dream.execute("curl -L '"..url.."'") or sdk.network.httpGet(url)
end

function dream.http.post(url,data)
  if not url then
    return nil
  elseif not data then
    return nil
  end
  url = dream.http.urlencode(url)
  return dream.execute("curl -L -H Content-Type: application/json -X POST -d '"..data.."' "..url) or ZhaoDiceSDK.network.httpPost(url,data)
end

-- dream json解析/编码库
dream.json = {}

function dream.json.encode(tab,vis)
  local vis = vis or {}
  local dataType = type(tab)
  if dataType == "nil" then
    return "null"
  elseif dataType == "string" then
    local str = tab
    str = str:gsub("\\","\\\\")
    local escape_char_map = {
      [ "\"" ] = "\\\"",
      [ "\b" ] = "\\b",
      [ "\f" ] = "\\f",
      [ "\n" ] = "\\n",
      [ "\r" ] = "\\r",
      [ "\t" ] = "\\t",
      [ "/ "] = "\\/"
    }
    for k,v in pairs(escape_char_map) do
      str = str:gsub(k,v)
    end
    return "\""..str.."\""
  elseif dataType == "number" then
    return tab
  elseif dataType == "boolean" then
    local bool = tab
    if bool then
      return "true"
    else
      return "false"
    end
  elseif dataType == "table" then
    if vis[tab] then
      error("circular references")
    else
      vis[tab] = true
    end
    dataType = nil
    local isArray,isObject
    for k,v in pairs(tab) do
      if dataType then
        if dataType ~= type(k) then
          error("wrong key")
        end
      else
        if type(k) ~= "string" then
          if type(k) ~= "number" then
            error("wrong key")
          end
        end
        dataType = type(k)
      end
    end
    if dataType == "number" then
      isArray = true
    else
      isObject = true
    end
    local JsonStr
    if isArray then
      for k,v in pairs(tab) do
        local v = dream.json.encode(v,vis)
        if JsonStr then
          JsonStr = JsonStr..","..v
        else
          JsonStr = v
        end
      end
      return "["..JsonStr.."]"
    elseif isObject then
      for k,v in pairs(tab) do
        local k = dream.json.encode(k,vis)
        local v = dream.json.encode(v,vis)
        if JsonStr then
          JsonStr = JsonStr..","..k..":"..v
        else
          JsonStr = k..":"..v
        end
      end
      if JsonStr then
        return "{"..JsonStr.."}"
      else
        return "{}"
      end
    end
  else
    error("Try converting the "..type(tab).." to a Json string")
  end
end

local next_value = function(json,i)
  local isString,Array,Object = false,0,0
  while true do
    if i > #json then
      return nil
    end
    local l = json:sub(i,i)
    local x,y = json:sub(i-1,i-1),json:sub(i+1,i+1)
    if l == "\"" and x ~= "\\" then
      isString = not isString
    end
    if not isString then
      if l == "[" then
        Array = Array + 1
      elseif l == "]" then
        Array = Array - 1
      elseif l == "{" then
        Object = Object + 1
      elseif l == "}" then
        Object = Object - 1
      end
    end
    if not isString and Array == 0 and Object == 0 and (y == "," or y == json:sub(-1,-1)) then
      break
    end
    i = i + 1
  end
  return i
end

local getKey = function(str)
  local i = 1   
  local isString = false
  while i < #str do
    local l = str:sub(i,i)
    if l == "\"" and l ~= "\\" then
      isString = not isString
    end
    if not isString and l == ":" then
      break
    end
    i = i + 1
  end
  return i - 1
end

-- 鸣谢 穀雨(2300452184) 对此json解析的修改以解决超时问题
function dream.json.decode(str,i)
  local i = i or 1
  if i == 1 then
    local i = 1
    local isString = false
    local json = {}
    while i <= #str do
      local l = str:sub(i,i)
      if not isString and (l == "\n" or l == " ") then
      else
        table.insert(json,l)
      end
      if l == "\"" and str:sub(i-1,i-1) ~= "\\" then
        isString = not isString
      end
      i = i + 1
    end
    str = table.concat(json)
  end
  local json = str
  str = nil
  local l = json:sub(1,1)
  if json == "null" then
    return nil
  elseif json == "true" then
    return true
  elseif json == "false" then
    return false
  elseif dream.math.isNumber(json) then
    return tonumber(json)
  elseif l == "\"" then
    json = json:sub(2,#json-1)
    json = json:gsub("\\\\","\\")
    local escape_char_map = {
      [ "\"" ] = "\\\"",
      [ "\b" ] = "\\b",
      [ "\f" ] = "\\f",
      [ "\n" ] = "\\n",
      [ "\r" ] = "\\r",
      [ "\t" ] = "\\t",
      [ "/ "] = "\\/"
    }
    for k,v in pairs(escape_char_map) do
      json = json:gsub(v,k)
    end
    return json
  elseif l == "[" then
    local tab = {}
    local i = 2
    while true do
      local chr = next_value(json,i)
      if not chr then
        break
      end
      tab[#tab+1] = dream.json.decode(json:sub(i,chr),true) -- 写个true减少步骤
      i = chr + 2
    end
    return tab
  elseif l == "{" then
    local tab = {}
    local i = 2
    while true do
      local chr = next_value(json,i)
      if not chr then
        break
      end
      local x = json:sub(i,chr)
      local key = x:sub(1,getKey(x))
      local value = x:sub(#key+2,-1)
      i = chr + 2
      tab[dream.json.decode(key,true)] = dream.json.decode(value,true) -- 写个true减少步骤
    end
    return tab
  end
end
json = dream.json

-- dream yaml
dream.yaml = {}

function dream.yaml.encode(tab,i)
  local dataType = type(tab)
  local escape_char_map = {
    [ "\\" ] = "\\\\",
    [ "\"" ] = "\\\"",
    [ "\b" ] = "\\b",
    [ "\f" ] = "\\f",
    [ "\n" ] = "\\n",
    [ "\r" ] = "\\r",
    [ "\t" ] = "\\t"
  }
  if dataType == "string" then
    for k,v in pairs(escape_char_map) do
      tab = tab:gsub(k,v)
    end
    return "\""..tab.."\""
  elseif dataType == "number" then
    return tab
  elseif dataType == "boolean" then
    if tab then
      return "true"
    else
      return "false"
    end
  elseif dataType == "nil" then
    return "null"
  elseif dataType == "table" then
    local i = (i or "").." "
    local keyType
    for k,v in pairs(tab) do
      if type(k) ~= "string" and type(k) ~= "number" then
        error("warning key")
      end
      if keyType then
        if type(k) ~= keyType then
          error("warning key")
        end
      else
        keyType = type(k)
      end
    end
    local isArray,isObject
    if keyType == nil then
      return "[]"
    elseif keyType == "number" then
      isArray = true
    elseif keyType == "string" then
      isObject = true
    end
    local yaml = {}
    if isArray then
      for ind=1,#tab do
        if type(tab[ind]) ~= "table" then
          table.insert(yaml,i.."- "..dream.yaml.encode(tab[ind]))
        else
          if dream.json.encode(tab[ind]) ~= "{}" then
            table.insert(yaml,i.."-\n"..dream.yaml.encode(tab[ind],i))
          else
            table.insert(yaml,i.."- []")
          end
        end
      end
      return table.concat(yaml,"\n")
    elseif isObject then
      for k,v in pairs(tab) do
        if type(v) ~= "table" then
          table.insert(yaml,k..": "..dream.yaml.encode(v))
        else
          table.insert(yaml,k..": \n"..dream.yaml.encode(v,i))
        end
      end
      return table.concat(yaml,"\n")
    end
  end
end

-- dream string
dream.string = {}

function dream.string.encode(str)
  local map = {
    [ "\b" ] = "\\b",
    [ "\f" ] = "\\f",
    [ "\n" ] = "\\n",
    [ "\r" ] = "\\r",
    [ "\t" ] = "\\t"
  }
  for k,v in pairs(map) do
    str = str:gsub(k,v)
  end
  return str
end

function dream.string.decode(str)
  local map = {
    [ "\b" ] = "\\b",
    [ "\f" ] = "\\f",
    [ "\n" ] = "\\n",
    [ "\r" ] = "\\r",
    [ "\t" ] = "\\t"
  }
  for v,k in pairs(map) do
    str = str:gsub(k,v)
  end
  return str
end

function dream.string.find(str,v)
  local i = 1
  local r = 0
  while i <= #str do
    if str:sub(i,i+#v-1) == v then
      r = r + 1
    end
    i = i + 1
  end
  return r
end

function dream.string.toTable(str)
  local i = 1
  local tab = {}
  while true do
    if i > #str then
      break
    end
    local l = str:sub(i,i)
    local len = dream.utf8.len(l)
    table.insert(tab,str:sub(i,i+len-1))
    i = i + len
  end
  return tab
end

function dream.string.sub(str,start,endl)
  local tab = dream.string.toTable(str)
  local endl = endl or #tab
  if endl == -1 then
    endl = #tab
  end
  if start == -1 then
    start = #tab
  end
  if start > #tab or start < 1 or endl > #tab or endl < 1 then
    return ""
  end
  local start = start or error("The starting index is missing")
  return table.concat(tab,"",start,endl)
end

function dream.string.part(str,id)
  local i = 1
  local l = #id
  local tab = {}
  local start = 1
  while true do
    if i > #str then
      break
    elseif str:sub(i,i+l-1) == id then
      table.insert(tab,str:sub(start,i-1))
      start = i + l
      if i > #str then
        break
      end
    elseif i == #str then
      table.insert(tab,str:sub(start,i))
    end
    i = i + 1
  end
  return tab
end

function dream.string.len(str)
  local tab = dream.string.toTable(str)
  return #tab
end

-- dream unicode
dream.unicode = {}

function dream.unicode.tobit(char) -- 补齐bit32.tobit
  if type(char) ~= "string" then
    char = tostring(char)
  end
  while (#char % 8) ~= 0 do
    char = "0"..char
  end
  return char
end

function dream.unicode.encode(char)
  if type(char) ~= "string" then
    error("The value that should be Char turns out to be Sterling")
  elseif #char > 4 then
    error("The value that should be Char turns out to be Sterling")
  end
  local len = dream.utf8.len(char)
  char = char:gsub(".",function(x)
    x = x:byte()
    x = dream.math.num2toHex(x,2)
    if #x < 8 then
      while #x < 8 do
        x = "0"..x
      end
    end
    return x
  end)
  if len == 1 then
    char = "0"..char:sub(2,-1)
  elseif len == 2 then
    char = char:sub(6,16)
  elseif len == 3 then
    char = char:sub(5,8)..char:sub(11,16)..char:sub(19,24)
  elseif len == 4 then
    char = char:sub(6,8)..char:sub(11,16)..char:sub(19,24)..char:sub(27,32)
  end
  char = dream.math.hextoNum2(char,2)
  char = dream.math.num2toHex(char,16)
  while #char < 4 do
    char = "0"..char
  end
  return char
end

function dream.unicode.toutf8(char)
  char = dream.math.hextoNum2(char,16)
  local t = tonumber(char)
  char = dream.math.num2toHex(char,2)
  char = dream.unicode.tobit(char)
  local x = char:sub(1,1)
  if t < 0x00 or t > 0x10FFFF then
    error("not unicode")
  elseif t <= 0x007F then
    char = "0"..char:sub(2,#char)
  elseif t <= 0x07FF then
    char = "110"..char:sub(6,10).."10"..char:sub(11,16)
  elseif t <= 0xFFFF then
    char = "1110"..char:sub(1,4).."10"..char:sub(5,10).."10"..char:sub(11,16)
  elseif t <= 0x10FFFF then
    char = "11110"..char:sub(1,3).."10"..char:sub(4,9).."10"..char:sub(10,15).."10"..char:sub(16,21)
  end
  local i = char
  char = dream.math.hextoNum2(char,2)
  char = dream.math.num2toHex(char,16)
  return char
end

function dream.unicode.decode(char)
  char = dream.unicode.toutf8(char)
  char = dream.math.hextoNum2(char,16)
  char = dream.math.num2toHex(char,2)
  char = dream.unicode.tobit(char)
  local res = {}
  local i = 1
  while char ~= "" do
    res[i] = char:sub(1,8)
    char = char:sub(9,-1)
    i = i + 1
  end
  local r = ""
  for i=1,#res do
    res[i] = string.char(dream.math.hextoNum2(res[i],2))
    r = r..res[i]
  end
  return r
end

-- dream utf8
dream.utf8 = {}

function dream.utf8.len(char)
  local x = char:byte()
  if x < 127 then
    return 1
  elseif x <= 223 then
    return 2
  elseif x <= 239 then
    return 3
  elseif x <= 247 then
    return 4
  else
    return 0
  end
end

-- dream html
dream.html = {}

function dream.html.encode(char)
  if type(char) ~= "string" then
    return nil
  end
  char = char:gsub(".",function(x)
    local a = x:byte()
    return "&#"..a..";"
  end)
  return char
end

function dream.html.decode(char)
  local char = char:gsub("&#([0-9]+);",function(x)
    return x:char()
  end)
  return char
end

-- dream system
dream.system = {}

function dream.system.Memory(index)
  local free = dream.execute("free")
  free = dream.string.part(free,"\n")
  free[1] = free[1]:sub(3,-1)
  free[2] = free[2]:sub(5,-1)
  free[3] = free[3]:sub(17,-1)
  free[4] = free[4]:sub(6,-1)
  for i=1,3 do
    free[i+1] = free[i+1]:sub(8,-1)
  end
  for i=1,#free do
    local tab = {}
    local l = 1
    local f = {}
    while l <= #free[i] do
      if free[i]:sub(l,l) ~= " " then
        table.insert(tab,free[i]:sub(l,l))
      elseif free[i]:sub(l,l) == " " and free[i]:sub(l-1,l-1) ~= " " then
        table.insert(f,table.concat(tab,""))
        tab = {}
      end
      l = l + 1
    end
    if dream.json.encode(tab) ~= "{}" then
      table.insert(f,table.concat(tab,""))
    end
    free[i] = f
  end
  for i=1,#free[1] do
    free[1][free[1][i]] = free[2][i]
    free[1][i] = nil
  end
  table.remove(free,2)
  free[2]["-buffers/cache"] = free[2][1]
  free[2]["+buffers/cache"] = free[2][2]
  free[2][1],free[2][2] = nil,nil
  table.remove(free,3)
  local tab = {}
  for i=1,#free do
    for k,v in pairs(free[i]) do
      tab[k] = tonumber(v)
    end
  end
  return tab[index]
end

-- dream.file
dream.file = {}

function dream.file.read(path)
  local file = io.open(path,"r")
  if not file then
    return nil
  end
  local res = file:read("*a")
  file:close()
  return res
end

function dream.file.write(path,str)
  if type(str) ~= "string" then
    str = tostring(str)
  end
  local file = io.open(path,"w")
  if not file then
    return false
  end
  file:write(str)
  file:close()
end

function dream.file.line(path,i)
  local file = io.open(path,"r")
  if not file then
    return nil
  end
  if i then
    local ind = 0
    local res
    for line in file:lines() do
      ind = ind + 1
      if ind == i then
        res = line
        break
      end
    end
    file:close()
    return res
  else
    local n = 0
    for line in file:lines() do
      n = n + 1
    end
    return n
  end
end

-- dream api
-- 鸣谢 星瑚∞ 提供的图片处理方法
function dream.api.pic(data)
  data = data:gsub("%[(mirai:image:{.-}%..-),.-%]", "%[%1%]")
  return data
end

local index_to_format = function(x)
  if x:sub(1,1) == "/" then
    x = x:sub(2,-1)
  end
  local v = "../../../../../../"
  return v..x
end

function dream.api.picture(i)
  return "#{PICTURE-"..index_to_format(i).."}"
end

function dream.api.file(i,d)
  return "#{FILE-"..index_to_format(i).."***"..d.."}"
end

function dream.api.voice(i)
  return "#{VOICE-"..index_to_format(i).."}"
end

function dream.api.video(i,d)
  return "#{VIDEO-"..index_to_format(i).."***"..index_to_format(d).."}"
end

function dream.api.BotRecall(str,i)
  return str.."#{RECALL-"..tonumber(i).."}"
end

function dream.api.avatar(qq)
  return "#{PICTURE-http://q2.qlogo.cn/headimg_dl?dst_uin="..qq.."&spec=640}"
end

function dream.api.getDiceQQ()
  return ZhaoDiceSDK.storage.path:match("_([0-9]+)")
end

function dream.api.today()
  return os.date("%Y-%m-%d")
end

function dream.api.getDreamDir()
  return dream.setting.path
end

function dream.api.unUnicode(msg)
  local i = 1
  while true do
    if i > #msg then
      break
    end
    local l = msg:sub(i,i+1)
    if l == "\\u" then
      unicode = msg:sub(i+2,i+5)
      msg = msg:gsub(l..unicode,dream.unicode.decode(unicode))
      i = i + #dream.unicode.decode(unicode)
    else
      i = i + 1
    end
  end
  return msg
end

function dream.api.setUserConf(setting,str,qq,fileName)
  local fileName = fileName or "user"
  local file = io.open(dream.setting.path.."/data/"..fileName..".json","r")
  if file == nil then
    local tbl = {}
    local i = #tbl + 1
    tbl[i] = {}
    tbl[i]["id"] = qq
    tbl[i][setting] = str
    tbl = dream.json.encode(tbl)
    local file = io.open(dream.setting.path.."/data/"..fileName..".json","w")
    file:write(tbl)
    file:close()
  else
    tbl = file:read("*a")
    file:close()
    tbl = dream.json.decode(tbl)
    for i=1,#tbl do
      if tbl[i]["id"] == qq then
        l = i
        break
      else
        l = i + 1
      end
    end
    if l > #tbl then
      tbl[l] = {}
      tbl[l]["id"] = qq
    end
    tbl[l][setting] = str
    tbl = dream.json.encode(tbl)
    local file = io.open(dream.setting.path.."/data/"..fileName..".json","w")
    file:write(tbl)
    file:close()
  end
  return nil
end

function dream.api.getUserConf(setting,qq,fileName)
  local fileName = fileName or "user"
  local file = io.open(dream.setting.path.."/data/"..fileName..".json","r")
  if file == nil then
    return nil
  end
  tbl = file:read("*a")
  file:close()
  tbl = dream.json.decode(tbl)
  for i=1,#tbl do
    if tbl[i]["id"] == qq then
      l = i
      break
    else
      l = i + 1
    end
  end
  if l > #tbl then
    return nil
  end
  return tbl[l][setting]
end
  
function dream.api.agreement(qq)
  local path = "/storage/emulated/0/AstralDice/.MiraiCache/"..qq
  local f1 = path.."/ANDROID_PHONE/contacts/friends.json"
  local f2 = path.."/ANDROID_PAD/contacts/friends.json"
  local f3 = path.."/ANDROID_WATCH/contacts/friends.json"
  if  io.open(f1,"r") then
    return path.."/ANDROID_PHONE"
  elseif io.open(f2,"r") then
    return path.."/ANDROID_PAD"
  elseif io.open(f3,"r") then
    return path.."/ANDROID_WATCH"
  end
  return false
end

dream.deter = {}
function dream.deter.master(msg)
  local file = io.open(dream.setting.path.."/data/setting.json","r")
  if file == nil then
    dream.log("骰娘["..dream.nick.."]没有管理员！默认不进行任何回复")
    return false
  end
  local setting = file:read("*a")
  file:close()
  setting = dream.json.decode(setting)
  for i=1,#setting["admin"] do
    if setting["admin"][i] == msg.fromQQ then
      return true
    end
  end
  return false
end

function dream.api.eventMsg(str,tp,msg)
  local list = _G["dream.pluginList"]
  msg.fromMsg = str
  for v,k in pairs(list) do
    if str:find("^"..k:gsub("_.+_","")) then
      if tp ~= "replace" then
        dream.api.sendMessage(v(msg),msg)
      else
        v(msg)
      end
      break
    end
  end
end

function dream.sendMaster(str)
  local file = io.open(dream.setting.path.."/data/setting.json","r")
  if dream.api.getNotice() then
    dream.api.sendGroupMessage(str)
  elseif file then
    tab = file:read("*a")
    file:close()
    tab = dream.json.decode(tab)
    if not tab["admin"] then
      dream.log(dream.nick.."未认主，静默此次master消息发送事件")
    else
      for i=1,#tab["admin"] do
        dream.api.sendUserMessage(str,tab["admin"][i])
      end
    end
  end
end

function dream.api.sendMessage(str,msg)
  if msg == nil then
    dream.error("参数缺失:<msg>")
  end
  if msg.isGroup then
    dream.api.sendGroupMessage(str,msg.fromGroup)
  elseif msg.isGroup == false then
    dream.api.sendUserMessage(str,msg.fromQQ,"")
  end
end

function dream.api.sendGroupMessage(str,num)
  if num == nil then
    local groups = dream.api.getNotice()
    local list = {}
    for i=1,#groups do
      local n = groups[i]
      for x=i+1,#groups do
        if groups[x] == n then
          list[#list+1] = x
        end
      end
    end
    for i=1,#list do
      table.remove(groups,list[i])
    end
    for i=1,#groups do
      ZhaoDiceSDK.chat.sendToGroup(str,groups[i])
    end
  else
    ZhaoDiceSDK.chat.sendToGroup(str,num)
  end
end

function dream.api.sendUserMessage(str,qq,group)
  local group = group or ""
  if group == "" then
    local list = dream.api.getGroupsList()
    for l =1,#list do
      if list[l].uin == tonumber(qq) then
        group = l
        break
      end
    end
  end
  if qq == nil then
    error("参数:<QQ号>缺失！")
  else
    ZhaoDiceSDK.chat.sendToPerson(str,dream.tostring(qq),dream.tostring(group))
  end
end

function dream.api.face(str)
  local tab = dream.module.require("face")
  return tab[str] or ""
end

function dream.api.poke(str)
  local tab = dream.module.require("poke")
  return tab[str] or ""
end

function dream.api.superface(str)
  local tab = dream.module.require("superface")
  return tab[str] or ""
end

function dream.api.getGroupsList()
  local path = dream.api.agreement(dream.api.getDiceQQ()).."/contacts/groups/"
  local sh = dream.execute("ls "..path)
  local file = io.open(dream.setting.path.."/list","w")
  file:write(sh)
  file:close()
  file = io.open(dream.setting.path.."/list","r")
  local list = {}
  for line in file:lines() do
    list[#list + 1] = line:match("^(.+)%..+$")
  end
  return list
end

function dream.api.getMembersList(group)
  local path = dream.api.agreement(dream.api.getDiceQQ()).."/contacts/groups/"..group..".json"
  local file = io.open(path,"r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  return tab.list
end

function dream.api.getFriendsList()
  local path = dream.api.agreement(dream.api.getDiceQQ()).."/contacts/friends.json"
  local file = io.open(path,"r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  return tab.friendList or tab.list
end

function dream.api.getUserNick(qq)
  local list = dream.api.getFriendsList()
  for l=1,#list do
    if list[l].uin == tonumber(qq) then
      return list[l].nick
    end
  end
  list = dream.api.getGroupsList()
  for k=1,#list do
    local i = dream.api.getMembersList(list[k])
    for l = 1,#i do
      if i[l].uin == tonumber(qq) then
        return i[l].nick
      end
    end
  end
  return nil
end

function dream.api.getNotice()
  local file = io.open(dream.setting.path.."/data/setting.json","r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  if not tab.notice then
    return nil
  else
    if not tab.notice[1] then
      return nil
    else
      return tab.notice
    end
  end
end

function dream.api.getAdmin()
  local file = io.open(dream.setting.path.."/data/setting.json","r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  if not tab.admin then
    return nil
  else
    if not tab.admin[1] then
      return nil
    else
      return tab.admin
    end
  end
end

function dream.api.thisGroupisOn(group)
  if sdk.readSystemConfig("WHITE_LIST"):find("#"..group) then
    return false
  else
    return true
  end
end

function dream.api.permission(group,id,permission)
  local permission = permission or "MEMBER"
  local list = dream.api.getMembersList(group)
  if not list then
    error("failed to get the list of group members")
  end
  local num
  for i=1,#list do
    if dream.tostring(list[i].uin) == dream.tostring(id) then
      num = i
      break
    end
  end
  if list[num].permission == permission then
    return true
  else
    return false
  end
end

function dream.api.getMemberJoinTime(group,qq)
  if not group then
    return nil
  elseif not qq then
    return nil
  end
  local list = dream.api.getMembersList(group)
  for l=1,#list do
    if list[l].uin == tonumber(qq) then
      return os.date("*t",list[l].joinTimestamp)
    end
  end
  return nil
end

function dream.api.getMemberLastTime(group,qq)
  if not group then
    return nil
  elseif not qq then
    return nil
  end
  local list = dream.api.getMembersList(group)
  for l=1,#list do
    if list[l].uin == tonumber(qq) then
      return os.date("*t",list[l].lastSpeakTimestamp)
    end
  end
  return nil
end

-------------------------------------
os.execute("mkdir "..dream.setting.path.."/plugin")
os.execute("mkdir "..dream.setting.path.."/lib")
os.execute("mkdir "..dream.setting.path.."/data")
os.execute("mkdir "..dream.setting.path.."/config")
os.execute("mkdir "..dream.setting.path.."/module")

print(dream.version)
dream.log("尝试构建骰娘["..dream.nick.."]…")
dream.log("正在加载 "..#dream.api.getGroupsList().." 个群")
dream.log("正在加载 "..#dream.api.getFriendsList().." 个好友")
dream.log("加载完毕！当前Dream版本为["..dream._VERSION.."]，请确保版本为最新版！")
dream.log("更新请前往群243093229或找寻[筑梦师V2.0](2967713804)以获取最新版")
----------------------------------------
commands = setmetatable({},{__newindex = function(self,i,v)
  if type(v) == "function" then
    dream.command.set("Plugin",i,v)
  else
    rawset(self,i,v)
  end
end})
msg_order = setmetatable({},{__newindex = function(self,i,v)
  if type(v) == "function" then
    dream.keyword.set("Plugin",i,v)
  else
    rawset(self,i,v)
  end
end})
replaces = setmetatable({},{__newindex = function(self,i,v)
  if type(v) == "function" then
    dream.replace.set("Plugin",i,v)
  else
    rawset(self,i,v)
  end
end})

-- dream module
dream.module = {}

function dream.module.require(name)
  local file = io.open(dream.setting.path.."/module/"..name..".module","r")
  if not file then
    error("read module ["..name.."] failed!: Data source not found")
  end
  local mod = {}
  local n = 0
  for line in file:lines() do
    n = n + 1
    local k = line:match("^(.+)=")
    local v
    if not k then
      error("line:"..n..":the data does not meet expectations")
    else
      v = line:match("^"..k.."=(.+)$"):gsub(" ","")
    end
    mod[k] = v
  end
  return mod
end

function dream.module.set(k,v,name)
  if not k then
    error("the key must not be empty!")
  elseif not v then
    error("the value must not be empty!")
  end
  name = name or "dream"
  local file = io.open(dream.setting.path.."/module/"..name..".module","r")
  local str
  if file then
    str = file:read("*a")
    str = str.."\n"..k.."="..v
    file:close()
  else
    str = k.."="..v
  end
  local file = io.open(dream.setting.path.."/module/"..name..".module","w")
  file:write(str)
  file:close()
end

dream.plugin = {}
-- 指令封装 --
function dream.plugin.key(id,cmd,func,cmd_type,perm,str)
  perm = perm or false
  if cmd_type == "keyword" then
    cmd_type = "_keyword_"
  elseif cmd_type == "command" then
    cmd_type = "_command_"
  elseif cmd_type == "replace" then
    cmd_type = "_replace_"
  end
  local key = cmd_type..cmd
  _G["dream.pluginList"][func] = key
  _G[key] = function(msg)
    msg.fromDiceName = dream.nick
    msg.fromNickPic = "#{PICTURE-http://q2.qlogo.cn/headimg_dl?dst_uin="..msg.fromQQ.."&spec=640}"
    if msg.isGroup then
      msg.gid = tonumber(msg.fromGroup)
    end
    msg.uid = tonumber(msg.fromQQ)
    local map = {
      ["\\%["] = "%[",
      ["\\%]"] = "%]",
      ["\\,"] = "%,",
      ["\\:"] = "%:",
      ["\\#"] = "#"
    }
    for k,v in pairs(map) do
      cmd = cmd:gsub(k,v)
    end
    msg.CommandThis = cmd
    for k,v in pairs(map) do
      msg.fromMsg = msg.fromMsg:gsub(k,v)
    end
    local x = function(msg,id)
      if #msg == 0 then
        return msg
      end
      for i=1,#msg do
        if msg:sub(i,i+1) == dream.string.encode(id) then
          if msg:sub(i-1,i-1) ~= "\\" then
            msg = msg:sub(1,i-1)..id..msg:sub(i+2,-1)
          end
        end
      end
      return msg
    end
    msg.fromMsg = x(msg.fromMsg,"\n")
    msg.fromMsg = x(msg.fromMsg,"\r")
    msg.fromMsg = msg.fromMsg:gsub("\\\\","\\")
    if cmd_type == "_keyword_" then
      msg.fromParams = msg.fromMsg:sub(#msg.CommandThis+1,#msg.fromMsg)
    else
      msg.fromParams = msg.fromMsg:sub(#msg.CommandThis+2,#msg.fromMsg)
    end
    if dream.plugin.getSetting(id,"mode") == false then
      return ""
    elseif dream.plugin.getConfig(id,msg.fromGroup) == "off" then
      return ""
    elseif perm == true then
      local b,v = dream.deter.master(msg)
      if b == false then
        return str or ""
      end
    end
    local tab_require = {}
    local tab_require_backup = {}
    local bool
    do
      local file = io.open(dream.setting.path.."/config/"..id.."/setting.json","r")
      if file == nil then
        dream.error("不识别的插件id:"..id)
        dream.sendError("不识别的插件id:"..id)
        return
      end
      local tab = file:read("*a")
      file:close()
      tab = dream.json.decode(tab)
      if tab["dep"] == "all" then
        local f = dream.execute("ls "..dream.setting.path.."/lib")
        if f ~= false then
          local file = io.open(dream.setting.path.."/list","w")
          file:write(f)
          file:close()
          local file = io.open(dream.setting.path.."/list","r")
          for line in file:lines() do
            local name = string.match(line,"(.+).lua")
            if name == nil then
              dream.error("文件名获取失败！请手动添加依赖！\n错误源头:"..line)
              dream.sendError("文件名获取失败！请手动添加依赖！\n错误源头:"..line)
              return
            end
            if _G[name] == nil then
              _G[name] = dream.require(dream.setting.path.."/lib/"..line)
              local i = #tab_require + 1
              tab_require[i] = name
            else
              tab_require_backup[name] = _G[name]
              _G[name] = dream.require(dream.setting.path.."/lib/"..line) -- 避免因覆盖某些赵原生库
            end
          end
        end
      elseif type(tab["dep"]) == "table" then
        for k,v in pairs(tab["dep"]) do
          if dream.require(v) ~= false then
            if _G[k] == nil then
              _G[k] = dream.require(v)
              local i = #tab_require + 1
              tab_require[i] = k
            else
              tab_require_backup[k] = _G[k]
              _G[k] = dream.require(v)
            end
          else
            bool = false
            dream.error("依赖文件["..v.."]不存在！")
            dream.sendError("依赖文件["..v.."]不存在！")
          end
        end
      end
    end
    if bool == false then
      return
    end
    dream.execute("rm "..dream.setting.path.."/list")
    log = function(str)
      print("["..cmd_type:gsub("_","").."]./"..id..":"..str)
    end
    local a,b = pcall(func,msg)
    if #tab_require ~= 0 then
      for i=1,#tab_require do
        if tab_require_backup[tab_require[i]] then
          _G[tab_require[i]] = tab_require_backup[tab_require[i]]
        else
          _G[tab_require[i]] = nil
        end
      end
    end
    local from
    if msg.isGroup then
      from = "群("..msg.fromGroup..")"
    else
      from = "私聊("..msg.fromQQ..")"
    end
    dream.execute("rm "..dream.setting.path.."/list")
    if a then
      if type(b) == "string" then
        local data = {
          nick = msg.fromNick,
          DiceQQ = dream.api.getDiceQQ(),
          DiceName = msg.fromDiceName,
          group = msg.fromGroup or "",
          from = from,
          qq = msg.fromQQ,
        }
        b = dream.escape(data,b)
        return b
      else
        return b
      end
    else
      local funcName
      for k,v in pairs(dream.list("function")) do
        if v == func then
          if not k:match("^_G._.+_(.+)$") then
            funcName = k
          end
        end
      end
      funcName = funcName:match("^_G.(.+)$")
      dream.log("报错函数:"..funcName.."\n触发窗口:"..from.."\n触发人:"..msg.fromNick.."("..msg.fromQQ..")\n原消息:"..msg.fromMsg.."\n错误信息:\n"..dream.error(b,false),"error")
      dream.sendError("报错函数:"..funcName.."\n触发窗口:"..from.."\n触发人:"..msg.fromNick.."("..msg.fromQQ..")\n原消息:"..msg.fromMsg.."\n错误信息:\n"..dream.error(b,false))
    end
  end
  return key
end

dream.keyword = {}
dream.command = {}
dream.replace = {}

local function format_order(x,b)
  local map = {
    ["\\%["] = "%[",
    ["\\%]"] = "%]",
    ["\\,"] = "%,",
    ["\\:"] = "%:",
    ["\\#"] = "#"
  }
  for k,v in pairs(map) do
    x = x:gsub(v,k)
  end
  return x
end

function dream.keyword.set(id,cmd,func,perm,str)
  cmd = format_order(cmd)
  key = dream.plugin.key(id,cmd,func,"keyword",perm,str)
  msg_order[cmd] = key
end

function dream.command.set(id,cmd,func,perm,str)
  cmd = format_order(cmd)
  key = dream.plugin.key(id,cmd,func,"command",perm,str)
  commands[cmd] = key
end

function dream.replace.set(id,cmd,func,perm,str)
  cmd = format_order(cmd)
  key = dream.plugin.key(id,cmd,func,"replace",perm,str)
  replaces[cmd] = key
end

-- 插件 --

-- 插件基本信息 --

-- 写插件基本信息
function dream.plugin.setSetting(setting)
  if setting["id"] == nil then
    dream.sendError("请先配置id！")
    return
  end
  local setting_ = {"id","help","version","author","mode","dep"}
  local bool
  local tab = {}
  for k,v in pairs(setting_) do
    if setting[v] == nil then
      bool = false
      dream.sendError("插件["..setting["id"].."]配置项 "..v.." 不存在！")
      break
    else
      if v == "dep" then
        if type(setting["dep"]) == "table" then
          tab[v] = setting[v]
        elseif setting["dep"] == "all" then
          tab[v] = setting[v]
        elseif setting["dep"] == "not" then
          tab[v] = setting[v]
        else
          bool = false
          dream.sendError("["..setting["id"].."]插件配置项 "..v.." 不正确！值:"..dream.tostring(setting["dep"]))
          break
        end
      else
        if v == "version" then
          if type(setting[v]) ~= "string" then
            tab[v] = dream.tostring(setting[v])
          else
            tab[v] = setting[v]
          end
        else
          tab[v] = setting[v]
        end
      end
    end
  end
  if bool == false then
    dream.sendError("插件["..setting["id"].."]有配置项不存在或不正确，故dream终止插件导入")
    error()
  end
  dream.execute("mkdir "..dream.setting.path.."/config/"..setting["id"])
  local file = io.open(dream.setting.path.."/config/"..setting["id"].."/setting.json","r")
  local config
  if file == nil then
    tab = dream.json.encode(tab)
  else
    config = dream.json.decode(file:read("*a"))
    file:close()
    for k,v in pairs(tab) do
      config[k] = tab[k]
    end
    config["version"] = dream.tostring(tab["version"])
    tab = dream.json.encode(config)
  end
  file = io.open(dream.setting.path.."/config/"..setting["id"].."/setting.json","w")
  file:write(tab)
  file:close()
end

-- 读插件基本信息
function dream.plugin.getSetting(id,key)
  local file = io.open(dream.setting.path.."/config/"..id.."/setting.json","r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  if tab[key] ~= nil then
    return tab[key]
  else
    return nil
  end
end

-- 设置配置值
function dream.plugin.setConfig(id,key,value,bool)
  if bool == nil then
    bool = false
  elseif type(bool) ~= "boolean" then
    bool = false
  else
    bool = true
  end
  local file = io.open(dream.setting.path.."/config/"..id.."/setting.json","r")
  local tab
  if file == nil then
    dream.execute("mkdir "..dream.setting.path.."/config/"..id)
    tab = {}
    tab.config = {}
    tab.config[key] = value
  else
    tab = file:read("*a")
    tab = dream.json.decode(tab)
    if tab.config == nil then
      tab.config = {}
    end
    if bool then
      tab.config[key] = tab.config[key] or value
    else
      tab.config[key] = value
    end
  end
  tab = dream.json.encode(tab)
  file = io.open(dream.setting.path.."/config/"..id.."/setting.json","w")
  file:write(tab)
  file:close()
end

-- 读取配置值
function dream.plugin.getConfig(id,key)
  local file = io.open(dream.setting.path.."/config/"..id.."/setting.json","r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  if tab.config == nil then
    return nil
  elseif tab.config[key] == nil then
    return nil
  else
    return tab.config[key]
  end
end

-- 删除配置
function dream.plugin.removeConfig(id,key)
  local file = io.open(dream.setting.path.."/config/"..id.."/setting.json","r")
  if file == nil then
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = dream.json.decode(tab)
  if tab.config[key] ~= nil then
    tab.config[key] = nil
  end
  tab = dream.json.encode(tab)
  file = io.open(dream.setting.path.."/config/"..id.."/setting.json","w")
  file:write(tab)
  file:close()
end

-- 初始化部分 --
function dream.init()
  local file = io.open(dream.api.getDreamDir().."/data/setting.json","r")
  local key = math.random(1,9)..math.random(1,9)..math.random(1,9)..math.random(1,9)..math.random(1,9)..math.random(1,9)
  local time = os.time()
  if file == nil then
    local tab = {}
    tab["key"] = key
    tab["time"] = time
    tab = dream.json.encode(tab)
    file = io.open(dream.setting.path.."/data/setting.json","w")
    file:write(tab)
    file:close()
    dream.log("检测到骰娘["..dream.nick.."]未拥有管理员，自动生成密钥进行master授权保护")
    dream.log("Key:"..key)
  else
    local tab = file:read("*a")
    file:close()
    tab = dream.json.decode(tab)
    tab["key"] = key
    tab["time"] = time
    tab = dream.json.encode(tab)
    file = io.open(dream.setting.path.."/data/setting.json","w")
    file:write(tab)
    file:close()
    dream.log("检测到骰娘["..dream.nick.."]已拥有管理员，自动生成密钥进行master授权保护")
    dream.log("Key:"..key)
  end
end

-- 插件导入
function dream.plugin.PluginLoader()
  dream.log("尝试导入"..dream.setting.path.."/plugin目录下的所有lua文件…")
  local list = dream.execute("ls "..dream.setting.path.."/plugin")
  if list == false then
    dream.log("未检测到任何插件")
    dream.log("正在自动退出…")
    dream.sendMaster(os.date("%Y-%m-%d %H:%M:%S").."\n"..dream.version.."\n插件载入完毕√\n共加载了0个插件")
    return
  end
  local file = io.open(dream.setting.path.."/list","w")
  file:write(list)
  file:close()
  file = io.open(dream.setting.path.."/list","r")
  local num = 0
  local num_true = 0
  local num_false = 0
  local plugin_list = {}
  for line in file:lines() do
    local rawline = line
    local line = line:match("(.+)%..+")
    log = function(str)
      print("[DreamPlugin]./"..line..":"..str)
    end
    num = num + 1
    local a,b = loadfile(dream.setting.path.."/plugin/"..rawline)
    if a then
      b = a()
      if b ~= nil then
        num_true = num_true + 1
        dream.plugin.setSetting(b)
        plugin_list[#plugin_list+1] = b.id
        dream.log("./"..line..": Plugin loaded")
      else
        num_true = num_true + 1
        dream.log("./"..line..": not Plugin config")
      end
    else
      num_false = num_false + 1
      dream.log("./"..line..":failed to load\nerrorInfo:"..b)
      dream.sendError("./"..line..":failed to load\nerrorInfo:"..b)
    end
  end
  file:close()
  dream.sendMaster(os.date("%Y-%m-%d %H:%M:%S").."\n"..dream.version.."\n插件载入完毕√\n共载入插件"..num.."个\n载入成功"..num_true.."个\n载入失败"..num_false.."个")
end

local face = [[惊讶=[mirai:face:0]
撇嘴=[mirai:face:1]
色=[mirai:face:2]
发呆=[mirai:face:3]
得意=[mirai:face:4]
流泪=[mirai:face:5]
害羞=[mirai:face:6]
闭嘴=[mirai:face:7]
睡=[mirai:face:8]
大哭=[mirai:face:9]
尴尬=[mirai:face:10]
发怒=[mirai:face:11]
调皮=[mirai:face:12]
呲牙=[mirai:face:13]
微笑=[mirai:face:14]
难过=[mirai:face:15]
酷=[mirai:face:16]
抓狂=[mirai:face:18]
吐=[mirai:face:19]
偷笑=[mirai:face:20]
可爱=[mirai:face:21]
白眼=[mirai:face:22]
傲慢=[mirai:face:23]
饥饿=[mirai:face:24]
困=[mirai:face:25]
惊恐=[mirai:face:26]
流汗=[mirai:face:27]
憨笑=[mirai:face:28]
悠闲=[mirai:face:29]
奋斗=[mirai:face:30]
咒骂=[mirai:face:31]
疑问=[mirai:face:32]
嘘=[mirai:face:33]
晕=[mirai:face:34]
折磨=[mirai:face:35]
衰=[mirai:face:36]
骷髅=[mirai:face:37]
敲打=[mirai:face:38]
再见=[mirai:face:39]
发抖=[mirai:face:41]
爱情=[mirai:face:42]
跳跳=[mirai:face:43]
猪头=[mirai:face:46]
拥抱=[mirai:face:49]
蛋糕=[mirai:face:53]
闪电=[mirai:face:54]
炸弹=[mirai:face:55]
刀=[mirai:face:56]
足球=[mirai:face:57]
便便=[mirai:face:59]
咖啡=[mirai:face:60]
饭=[mirai:face:61]
玫瑰=[mirai:face:63]
凋谢=[mirai:face:64]
爱心=[mirai:face:66]
心碎=[mirai:face:67]
礼物=[mirai:face:69]
太阳=[mirai:face:74]
月亮=[mirai:face:75]
赞=[mirai:face:76]
踩=[mirai:face:77]
握手=[mirai:face:78]
胜利=[mirai:face:79]
飞吻=[mirai:face:85]
怄火=[mirai:face:86]
西瓜=[mirai:face:89]
冷汗=[mirai:face:96]
擦汗=[mirai:face:97]
抠鼻=[mirai:face:98]
鼓掌=[mirai:face:99]
糗大了=[mirai:face:100]
坏笑=[mirai:face:101]
左哼哼=[mirai:face:102]
右哼哼=[mirai:face:103]
哈欠=[mirai:face:104]
鄙视=[mirai:face:105]
委屈=[mirai:face:106]
快哭了=[mirai:face:107]
阴险=[mirai:face:108]
亲亲=[mirai:face:109]
左亲亲=[mirai:face:109]
吓=[mirai:face:110]
可怜=[mirai:face:111]
菜刀=[mirai:face:112]
啤酒=[mirai:face:113]
篮球=[mirai:face:114]
乒乓=[mirai:face:115]
示爱=[mirai:face:116]
瓢虫=[mirai:face:117]
抱拳=[mirai:face:118]
勾引=[mirai:face:119]
拳头=[mirai:face:120]
差劲=[mirai:face:121]
爱你=[mirai:face:122]
不=[mirai:face:123]
好=[mirai:face:124]
转圈=[mirai:face:125]
磕头=[mirai:face:126]
回头=[mirai:face:127]
跳绳=[mirai:face:128]
挥手=[mirai:face:129]
激动=[mirai:face:130]
街舞=[mirai:face:131]
献吻=[mirai:face:132]
左太极=[mirai:face:133]
右太极=[mirai:face:134]
双喜=[mirai:face:136]
鞭炮=[mirai:face:137]
灯笼=[mirai:face:138]
K歌=[mirai:face:140]
喝彩=[mirai:face:144]
祈祷=[mirai:face:145]
爆筋=[mirai:face:146]
棒棒糖=[mirai:face:147]
喝奶=[mirai:face:148]
飞机=[mirai:face:151]
钞票=[mirai:face:158]
药=[mirai:face:168]
手枪=[mirai:face:169]
茶=[mirai:face:171]
眨眼睛=[mirai:face:172]
泪奔=[mirai:face:173]
无奈=[mirai:face:174]
卖萌=[mirai:face:175]
小纠结=[mirai:face:176]
喷血=[mirai:face:177]
斜眼笑=[mirai:face:178]
doge=[mirai:face:179]
惊喜=[mirai:face:180]
骚扰=[mirai:face:181]
笑哭=[mirai:face:182]
我最美=[mirai:face:183]
河蟹=[mirai:face:184]
羊驼=[mirai:face:185]
幽灵=[mirai:face:187]
蛋=[mirai:face:188]
菊花=[mirai:face:190]
红包=[mirai:face:192]
大笑=[mirai:face:193]
不开心=[mirai:face:194]
冷漠=[mirai:face:197]
呃=[mirai:face:198]
好棒=[mirai:face:199]
拜托=[mirai:face:200]
点赞=[mirai:face:201]
无聊=[mirai:face:202]
托脸=[mirai:face:203]
吃=[mirai:face:204]
送花=[mirai:face:205]
害怕=[mirai:face:206]
花痴=[mirai:face:207]
小样儿=[mirai:face:208]
飙泪=[mirai:face:210]
我不看=[mirai:face:211]
托腮=[mirai:face:212]
啵啵=[mirai:face:214]
糊脸=[mirai:face:215]
拍头=[mirai:face:216]
扯一扯=[mirai:face:217]
舔一舔=[mirai:face:218]
蹭一蹭=[mirai:face:219]
拽炸天=[mirai:face:220]
顶呱呱=[mirai:face:221]
抱抱=[mirai:face:222]
暴击=[mirai:face:223]
开枪=[mirai:face:224]
撩一撩=[mirai:face:225]
拍桌=[mirai:face:226]
拍手=[mirai:face:227]
恭喜=[mirai:face:228]
干杯=[mirai:face:229]
嘲讽=[mirai:face:230]
哼=[mirai:face:231]
佛系=[mirai:face:232]
掐一掐=[mirai:face:233]
惊呆=[mirai:face:234]
颤抖=[mirai:face:235]
啃头=[mirai:face:236]
偷看=[mirai:face:237]
扇脸=[mirai:face:238]
原谅=[mirai:face:239]
喷脸=[mirai:face:240]
生日快乐=[mirai:face:241]
头撞击=[mirai:face:242]
甩头=[mirai:face:243]
扔狗=[mirai:face:244]
加油必胜=[mirai:face:245]
加油抱抱=[mirai:face:246]
口罩护体=[mirai:face:247]
搬砖中=[mirai:face:260]
忙到飞起=[mirai:face:261]
脑阔疼=[mirai:face:262]
沧桑=[mirai:face:263]
捂脸=[mirai:face:264]
辣眼睛=[mirai:face:265]
哦哟=[mirai:face:266]
头秃=[mirai:face:267]
问号脸=[mirai:face:268]
暗中观察=[mirai:face:269]
emm=[mirai:face:270]
吃瓜=[mirai:face:271]
呵呵哒=[mirai:face:272]
我酸了=[mirai:face:273]
太南了=[mirai:face:274]
辣椒酱=[mirai:face:276]
汪汪=[mirai:face:277]
汗=[mirai:face:278]
打脸=[mirai:face:279]
击掌=[mirai:face:280]
无眼笑=[mirai:face:281]
敬礼=[mirai:face:282]
狂笑=[mirai:face:283]
面无表情=[mirai:face:284]
摸鱼=[mirai:face:285]
魔鬼笑=[mirai:face:286]
哦=[mirai:face:287]
请=[mirai:face:288]
睁眼=[mirai:face:289]
敲开心=[mirai:face:290]
震惊=[mirai:face:291]
让我康康=[mirai:face:292]
摸锦鲤=[mirai:face:293]
期待=[mirai:face:294]
拿到红包=[mirai:face:295]
真好=[mirai:face:296]
拜谢=[mirai:face:297]
元宝=[mirai:face:298]
牛啊=[mirai:face:299]
胖三斤=[mirai:face:300]
好闪=[mirai:face:301]
左拜年=[mirai:face:302]
右拜年=[mirai:face:303]
红包包=[mirai:face:304]
右亲亲=[mirai:face:305]
牛气冲天=[mirai:face:306]
喵喵=[mirai:face:307]
求红包=[mirai:face:308]
谢红包=[mirai:face:309]
新年烟花=[mirai:face:310]
打call=[mirai:face:311]
变形=[mirai:face:312]
嗑到了=[mirai:face:313]
仔细分析=[mirai:face:314]
加油=[mirai:face:315]
我没事=[mirai:face:316]
菜狗=[mirai:face:317]
崇拜=[mirai:face:318]
比心=[mirai:face:319]
庆祝=[mirai:face:320]
老色痞=[mirai:face:321]
拒绝=[mirai:face:322]
嫌弃=[mirai:face:323]
吃糖=[mirai:face:324]
惊吓=[mirai:face:325]
生气=[mirai:face:326]
加一=[mirai:face:327]
错号=[mirai:face:328]
对号=[mirai:face:329]
完成=[mirai:face:330]
明白=[mirai:face:331]
举牌牌=[mirai:face:332]
烟花=[mirai:face:333]
虎虎生威=[mirai:face:334]
豹富=[mirai:face:336]
花朵脸=[mirai:face:337]
我想开了=[mirai:face:338]
舔屏=[mirai:face:339]
热化了=[mirai:face:340]
打招呼=[mirai:face:341]
酸Q=[mirai:face:342]
我方了=[mirai:face:343]
大怨种=[mirai:face:344]
红包多多=[mirai:face:345]
你真棒棒=[mirai:face:346]
大展宏兔=[mirai:face:347]
福萝卜=[mirai:face:348] ]]
local file = io.open(dream.setting.path.."/module/face.module","w")
file:write(face)
file:close()

local poke = [[戳一戳=[mirai:poke:,1,-1]
比心=[mirai:poke:,2,-1]
点赞=[mirai:poke:,3,-1]
心碎=[mirai:poke:,4,-1]
666=[mirai:poke:,5,-1]
放大招=[mirai:poke:,6,-1]
宝贝球=[mirai:poke:,126,2011]
玫瑰花=[mirai:poke:,126,2007]
召唤术=[mirai:poke:,126,2006]
让你皮=[mirai:poke:,126,2009]
结印=[mirai:poke:,126,2005]
手雷=[mirai:poke:,126,2004]
勾引=[mirai:poke:,126,2003]
抓一下=[mirai:poke:,126,2001]
碎屏=[mirai:poke:,126,2002]
敲门=[mirai:poke:,126,2000] ]]
file = io.open(dream.setting.path.."/module/poke.module","w")
file:write(poke)
file:close()

local superface=[[流泪=[mirai:superface:5,16,1,]
打call=[mirai:superface:311,1,1,]
变形=[mirai:superface:312,2,1,]
仔细分析=[mirai:superface:314,4,1,]
菜汪=[mirai:superface:317,7,1,]
崇拜=[mirai:superface:318,8,1,]
比心=[mirai:superface:319,9,1]
庆祝=[mirai:superface:320,10,1,]
吃糖=[mirai:superface:324,12,1,]
惊吓=[mirai:superface:325,14,1,]
花朵脸=[mirai:superface:337,22,1,]
我想开了=[mirai:superface:338,20,1,]
舔屏=[mirai:superface:339,21,1,]
打招呼=[mirai:superface:341,24,1]
酸Q=[mirai:superface:342,26,1,]
我方了=[mirai:superface:343,27,1,]
大怨种=[mirai:superface:344,28,1,]
红包多多=[mirai:superface:345,29,1,]
你真棒棒=[mirai:superface:346,25,1,]
戳一戳=[mirai:superface:181,37,1,]
太阳=[mirai:superface:74,35,1,]
月亮=[mirai:superface:75,36,1,]
敲敲=[mirai:superface:351,30,1,]
坚强=[mirai:superface:349,32,1,]
贴贴=[mirai:superface:350,31,1,]
略略略=[mirai:superface:395,41,1,]
篮球=[mirai:superface:114,31,2,1]
生气=[mirai:superface:326,15,1,]
蛋糕=[mirai:superface:53,17,1,]
鞭炮=[mirai:superface:137,18,1,]
烟花=[mirai:superface:333,19,1,]
接龙=[mirai:superface:392,28,3,0] ]]
file = io.open(dream.setting.path.."/module/superface.module","w")
file:write(superface)
file:close()

dream.init()
_G["dream.pluginList"] = {}
dream.plugin.PluginLoader()
_G["dream.pluginList"] = setmetatable(_G["dream.pluginList"],{__newindex = function(x,t,f)
  error("try modifying a constant")
end})

dream.plugin.setSetting({
  id = "Plugin",
  version = "∞",
  help = [[Dream快捷指令写入]],
  author = "任何人",
  dep = "all",
  mode = true
})
endTime = os.clock()
local time = dream.tostring(endTime-startTime)
time = time:gsub("."..dream.math.getFloat(time),"")..dream.math.getFloat(time)
dream.sendMaster(os.date("%Y-%m-%d %H:%M:%S").." "..dream.nick.."初始化完成，用时"..time.."毫秒")

dream.execute("rm "..dream.api.getDreamDir().."/list")

dream.execute("rm "..dream.setting.path.."/list")