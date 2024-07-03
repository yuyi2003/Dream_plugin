weather = {}
function weather.main(msg)
  local file = io.open(dream.setting.path.."/config/weather/data.json","r")
  if not file then
    dream.sendMaster("请将天气查询所需要的数据文件放入["..dream.setting.path.."/config/weather]目录中")
    return nil
  end
  local tab = file:read("*a")
  file:close()
  tab = json.decode(tab)
  local url = "https://devapi.qweather.com/v7/weather/now?key=028f2323e21a4397bf7ce177e04f27f1&location="
  local str = msg.fromMsg:match("^查询天气(.+)$") or msg.fromMsg:match("^天气查询(.+)$")
  if not str then
    return nil
  end
  str = str:gsub(" ","")
  local ind
  for i=1,#tab do
    if tab[i]["英文名"] == str then
      ind = tab[i].location
      break
    elseif tab[i]["中文名"] == str then
      ind = tab[i].location
      break
    end
  end
  if not ind then
    return "未检索到相关城市["..str.."]"
  end
  url = url..ind
  tab = json.decode(dream.http.get(url))
  return "API许可证："..tab.refer.license[1].."\n最近更新时间："..tab.updateTime.."\n地点："..str.."\n温度："..tab.now.temp.."摄氏度\n状况："..tab.now.text.."\n风向："..tab.now.windDir.."\n风力等级："..tab.now.windScale.."\n风速："..tab.now.windSpeed.."公里/小时\n更多点击这里："..tab.fxLink
end
dream.keyword.set("weather","查询天气",weather.main)
dream.keyword.set("weather","天气查询",weather.main)

return {
    id = "weather",
    version = "1.0.0",
    help = "",
    author = "筑梦师V2.0",
    
    mode = true
  } 