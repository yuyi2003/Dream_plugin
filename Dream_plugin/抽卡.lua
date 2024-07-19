Gacha={
    card={
        three={};
        four={};
        fivecom={};
        fiveup={};
    };
    msg={

    };
    barrier={
        four=10;
        five=90;
    };
    probnum={
        three=900;
        four={960,5};
        five={1000,70};
    };
}
Player={
    bag={};
    fourbarrier=10;
    fivebarrier=90;
    gachanum=0;
};
function intiplayer(qq)
    dream.api.setUserConf("玩家",0,msg.fromQQ,"GroupLaoPo")
end

function fun1(num,barrier)
    if num<=barrier then
        return 0
    else
        return num-barrier
    end
end

function GachaCard(msg)
    local Player=intiplayer(msg.fromQQ)
    local num=sdk.randomInt(1,1000)
    if num<=Gacha.probnum.three-(fun1(Player.fourbarrier,Gacha.probnum.four[2])) then
        Player.fivebarrier=Player.fivebarrier-1
        Player.fourbarrier=Player.fivebarrier-1
        Player.gachanumr=Player.gachanumr+1
        return 3
    elseif num>(Gacha.probnum.three-Gacha.probnum.four[2]*(Gacha.barrier.four-Player.fivebarrier)) and num<=Gacha.probnum.four[1]-Gacha.probnum.five[2]*(Gacha.barrier.five-Player.fivebarrier) then
    end
end







return {
    id = "gachacard",
    version = "1.0.0",
    help = "--群老婆插件--\n\n触发词:\n抽群老婆\n和老婆离婚\n我的老婆",
    author = "筑梦师V2.0&雨岚之忆",
    
    mode = true
  }