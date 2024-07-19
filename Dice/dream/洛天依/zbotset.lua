-- 词条配置部分 --
dream.bot = "VSINGER型" 
-- bot指令在前面加的东西

command.OnStr = "为了你唱下去" 
-- 对群内骰子开启的称呼

command.OffStr = "聆听歌曲" 
-- 对群内骰子关闭的称呼

command.DreamBotStr_Group = "{DiceName}当前在{groups}个世界为了你唱下去，对其中的{Offnum}个世界聆听歌曲～\n对此世界的关注：{OnOrOff}" 
-- 在群发送bot的词条

command.DreamBotStr_Empty = "{DiceName}当前在{groups}个世界为了你唱下去，对其中的{Offnum}个世界聆听歌曲～" -- 在私聊发送bot的词条

dream.command.set("command","dream plugin list",command.dream_plugin_list)