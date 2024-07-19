Diceevil={
    func={};
    player={roll=0,kill=0};
}

if dream.api.getUserConf("Dice","Evil","EvilDice")==nil then
    dream.api.setUserConf("Dice",100,"Evil","EvilDice")
end

function Diceevil.func.DiceMsg(num)
    local array={{0.75,0.5,0.25,0.1};{"漆黑","幽蓝","深邃","暗淡","晦暗"}}
    local target=dream.api.getUserConf("Dice","Evil","EvilDice")
    target=num/target
    local msg=1
    for i=1,#array[1] do
        if array[1][i]>target then
            msg=msg+1
        end
    end
    msg=array[2][msg]
    return msg
end

function Diceevil.func.rollDice(msg)
    local dice=dream.api.getUserConf("Dice",msg.fromGroup,"EvilDice") or dream.api.getUserConf("Dice","Evil","EvilDice")
    local num=sdk.randomInt(1,dice)
    local message=Diceevil.func.DiceMsg(num)
    local roll=dream.api.getUserConf("roll",msg.fromGroup,"EvilDice") or 0
    local player=dream.api.getUserConf("player",msg.fromQQ,"EvilDice") or table.clone(Diceevil.player)
    player.roll=player.roll+1
    roll=roll+1
    dream.api.setUserConf("roll",roll,msg.fromGroup,"EvilDice")
    if num==1 then
        dream.api.setUserConf("Dice",nil,msg.fromGroup,"EvilDice")
        player.kill=player.kill+1
        local message1=("{player}骰出了恶魔骰子，它当前数字变为猩红的1点。\n很不幸{player}成为了这次恶魔仪式的祭品！#{MULT}本次献祭的仪式情况:\n{num}"):gsub("{player}",msg.fromNick):gsub("{num}",roll)
        dream.api.setUserConf("roll",0,msg.fromGroup,"EvilDice")
        dream.api.setUserConf("player",player,msg.fromQQ,"EvilDice")
        return message1
    else
        dream.api.setUserConf("Dice",num,msg.fromGroup,"EvilDice")
        dream.api.setUserConf("player",player,msg.fromQQ,"EvilDice")
    return ("{player}骰出了恶魔骰子，它当前数字变为{msg}的{num}"):gsub("{msg}",message):gsub("{num}",num):gsub("{player}",msg.fromNick)
    end
end
dream.keyword.set("EvilDice","恶魔骰子加入",Diceevil.func.rollDice)

function Diceevil.func.SetMaxDice(msg)
    local num=dream.tonumber(msg.fromMsg:match("%d+"))
    if num==nil then
        return "输入范围不合法"
    else
        dream.api.setUserConf("Dice",num,"Evil","EvilDice")
        return "设置成功，当前起始点数:"..num
    end
end
dream.command.set("EvilDice","EvilsetDice",Diceevil.func.SetMaxDice)

return {
    id = "EvilDice",
    version = "1.0.0",
    help = "--恶魔骰子--",
    author = "雨岚之忆",
    mode = true
  }

--   100漆黑,75幽蓝,50深邃,25暗淡,10晦暗