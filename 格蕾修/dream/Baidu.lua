-- 作者：筑梦师V2.0
-- 为数不多的永远不会坏插件（或者他改HTML源码）

function Baidu(msg)
  txt = string.match(msg.fromMsg,"^格蕾修百度一下(.+)")
  if txt == nil then
    return ""
  end
  t = ZhaoDiceSDK.network.httpGet("https://baike.baidu.com/item/"..txt)
  tab = {}
  tab.data = string.match(t,"<meta name=\"description\" content=\"(.+)\"><meta name=\"keywords\" content=\"")
  if tab.data == nil then
    return msg.fromDiceName.."找不到关于【"..txt.."】的内容呢"
  end
  tab.image = string.match(t,"<meta name=\"image\" content=\"(.+)\"><meta property=\"og:title\"")
  return "#{PICTURE-"..tab.image.."}"..tab.data
end
dream.keyword.set("Baidu","格蕾修百度一下",Baidu)

return {
  id = "Baidu",
  version = 0.1,
  help = "百度百科，世界如此简单～",
  author = "筑梦师V2.0",
  
  mode = true
}