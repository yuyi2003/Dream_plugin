YesdreamLaopo={--群老婆
  func={};
  msg={
    qlaopofalse="不行哦~你今天已经抽过老婆了～她就是{nick}！#{PICTURE-http://q2.qlogo.cn/headimg_dl?dst_uin={uin}&spec=640}";
    qlaopotrue="恭喜{nickin}抽到了{nick}来当自己一天的老婆#{PICTURE-http://q2.qlogo.cn/headimg_dl?dst_uin={uin}&spec=640}";
    leavelaopo="{nickin}和{nick}离婚了，再也没有爱了╯﹏╰";
    findlaopo="{nickin}今天老婆是{nick}#{PICTURE-http://q2.qlogo.cn/headimg_dl?dst_uin={uin}&spec=640}";
    laopofalse="你今天还没有老婆哦～";
  };
  unlplist={"2854196310",dream.api.getDiceQQ()};--排除为老婆的人选 默认是Q群管家,骰娘本身,发送者本人(这个写在了函数里面)
        --[[
            可接受参数:
                {nickin}--触发人姓名
                {nick}--老婆昵称
                {uin}--老婆QQ
        ]]--            
    };
function YesdreamLaopo.func.LaopoRadius(group,qq)
  table.insert(YesdreamLaopo.unlplist,qq)
  local tab = dream.api.getMembersList(group)
  local a=0
  for i=1,#tab do
    for v=1,#YesdreamLaopo.unlplist do
       if tab[i-a].uin-YesdreamLaopo.unlplist[v]==0 then
          table.remove(tab,i-a)
          a=a+1
          break
        end
    end
  end
  return tab
end

function YesdreamLaopo.func.findLaopo(msg)
  local tab=YesdreamLaopo.func.LaopoRadius(msg.fromGroup,msg.fromQQ)
  local num = ZhaoDiceSDK.randomInt(1,#tab)
  local laopo=dream.api.getUserConf("GroupLaoPo"..msg.fromGroup,msg.fromQQ,"GroupLaoPo")
  if (dream.api.getUserConf("GroupLaoPo时间"..msg.fromGroup,msg.fromQQ,"GroupLaoPo") or 0)==dream.api.today() then
    return YesdreamLaopo.msg.qlaopofalse:gsub("{nickin}",msg.fromNick):gsub("{nick}",laopo.nick):gsub("{uin}",laopo.uin)
  else
    if (laopo or 0)==0 then
      laopo=tab[num]
     dream.api.setUserConf("GroupLaoPo"..msg.fromGroup,laopo,msg.fromQQ,"GroupLaoPo")
     dream.api.setUserConf("GroupLaoPo时间"..msg.fromGroup,dream.api.today(),msg.fromQQ,"GroupLaoPo")
      return YesdreamLaopo.msg.qlaopotrue:gsub("{nickin}",msg.fromNick):gsub("{nick}",laopo.nick):gsub("{uin}",laopo.uin)
    else
      return YesdreamLaopo.msg.qlaopofalse:gsub("{nickin}",msg.fromNick):gsub("{nick}",laopo.nick):gsub("{uin}",laopo.uin)
    end
  end
end
dream.keyword.set("GroupLaoPo","抽群老婆",YesdreamLaopo.func.findLaopo)

function YesdreamLaopo.func.killLaopo(msg)
  local laopo=dream.api.getUserConf("GroupLaoPo"..msg.fromGroup,msg.fromQQ,"GroupLaoPo")
  if (laopo or 0)==0 then
    return YesdreamLaopo.msg.laopofalse:gsub("{nickin}",msg.fromNick)
  else
    dream.api.setUserConf("GroupLaoPo"..msg.fromGroup,0,msg.fromQQ,"GroupLaoPo")
    dream.api.setUserConf("GroupLaoPo时间"..msg.fromGroup,0,msg.fromQQ,"GroupLaoPo")
    return YesdreamLaopo.msg.leavelaopo:gsub("{nickin}",msg.fromNick):gsub("{nick}",laopo.nick):gsub("{uin}",laopo.uin)
  end
end
dream.keyword.set("GroupLaoPo","和老婆离婚",YesdreamLaopo.func.killLaopo)

function YesdreamLaopo.func.checkLaopo(msg)
  local laopo=dream.api.getUserConf("GroupLaoPo"..msg.fromGroup,msg.fromQQ,"GroupLaoPo")
  if (laopo or 0)==0 then
    return YesdreamLaopo.msg.laopofalse:gsub("{nickin}",msg.fromNick)
  else
    return YesdreamLaopo.msg.YesdreamLaopo.func.findlaopo:gsub("{nickin}",msg.fromNick):gsub("{nick}",laopo.nick):gsub("{uin}",laopo.uin)
  end
end
dream.keyword.set("GroupLaoPo","我的老婆",YesdreamLaopo.func.checkLaopo)

return {
  id = "GroupLaoPo",
  version = "2.1.2",
  help = "--群老婆插件--\n\n触发词:\n抽群老婆\n和老婆离婚\n我的老婆",
  author = "筑梦师V2.0&雨岚之忆",
  mode = true
}