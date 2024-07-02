# 骰娘指令集
## 【指令智能纠错表】
鉴于有些人使用其他骰系的指令，或者指令不标准，为了容错做了有限的指令重定向

|  指令解释|被重定向的指令|重定向到的指令|
|  -----  | -----  | ----- |
| 牌堆列表|help draw|draw help|
| 暗中鉴定|hl|rah|
| 错误的骰点指令|r 理由 表达式|r 表达式 理由|
| 错误的鉴定指令|ra 数值 技能|ra 技能 数值|
| 结束并上传log | log get | log end |
| |rc 数值 技能|rc 技能 数值|
| |rp鉴定次数#骰数 技能 数值|ra 鉴定次数#p骰数 技能 数值|
| |rb鉴定次数#骰数 技能 数值|ra 鉴定次数#b骰数 技能 数值|
| |rp大于惩罚骰最大值的数值|rap 大于惩罚骰最大值的数值|
| |rb大于奖励骰最大值的数值|rab 大于奖励骰最大值的数值|
| 昵称显示指令|nn show|pc show|
| |st show|pc show|
| 角色卡重命名|st rename|nn|
| 角色卡删除|st rm|pc del|
| |del|pc del|
| 牌堆重新加载|draw reload|system reload|
| 系统信息查看|system state|runtime|
| 群管指令|group+停用指令|bot off|
| |group-停用指令|bot on|
| |group+禁用回复|reply off this|
| |group-禁用回复|reply on this|
| |group+禁用ob|ob off|
| |group-禁用ob|ob on|
| 技能操作|hp 参数|st hp 参数|
| |san 参数|st san 参数|
| |mp 参数|st mp 参数|
| |sp 参数|st sp 参数|
| |hp|st show hp|
| |san|st show san|
| |mp|st show mp|
| |sp|st show sp|

## 【Master模式】

### Master绑定/解绑
找到“骰基本信息-骰主QQ"实项，写入QQ号即可，一行一个即可绑定，

删除指定行master即可解绑

## 【控制台控制指令】

### 刷屏反制
* guard <font color=#53b0ff>设置一定时间内只响应每人每群一定数量的消息</font>

* guard during 秒  <font color=#53b0ff>在一定秒数内</font>

* guard times  <font color=#53b0ff>消息数量 每人只回复一定的数量消息</font>

* guard spam off/on <font color=#53b0ff>设置是否启用刷屏反制 </font>

* guard warning 语句  <font color=#53b0ff>自定义警告语句</font>
!!! Warning "注意"
    要master权限

### 无法无天模式
* NoLawNoSky on <font color=#53b0ff>进入无法无天模式，开启后骰娘被踢被禁言将不会拉黑对方。</font>

* NoLawNoSky off <font color=#53b0ff>退出无法无天模式</font>
!!! Warning "注意"
    要master权限

### 数据备份
* backup  <font color=#53b0ff>查看帮助</font>

* backup auto on/off  <font color=#53b0ff>打开或关闭自动备份</font>

* backup recovery[文件名]<font color=#53b0ff>恢复此备份</font>

* backup make <font color=#53b0ff>生成一个data目录的备份，保存至/backup  </font>

* backup list <font color=#53b0ff>枚举备份，也就是backup目录下的内容 </font>

* backup del[欲要删除的文件名] <font color=#53b0ff>删除指定备份</font>

* backup 30day<font color=#53b0ff> 30天前的备份</font>
!!! Warning "注意"
    要master权限

### 黑名单操作
*  black <font color=#53b0ff> 查看帮助</font>

*  black add user[QQ][理由]<font color=#53b0ff>拉黑一个用户</font>

*  blackrm【全球编码】<font color=#53b0ff> 解黑</font>

*  black detail[全球编码]<font color=#53b0ff>详细的黑名单信息</font>

*  black count <font color=#53b0ff>统计黑名单总数</font>

*  black fnd<font color=#53b0ff>群号/QQ查找里名单信息</font>

!!! Warning "注意"
    要master权限

!!! none "若要解黑"
    1.需要先**black fnd 群号/QQ** 查找相关黑名单信息，获得全球编码**(uuid)**，如**AAAA-BBBB-CCCC-DDDD-ABCDE**，然后进行解黑
    
    2.发送 **black mm AAAA-BBBB-CCCC-DDDD-ABCDE**

!!! none "若要手动拉黑"
    发送**black add user 1234567** 这人太丑了
    
    即可以“这人太丑了"为理由拉黑QQ号“1234567”，如果要拉黑群则把user换成group

### admin
* admin state <font color=#53b0ff>当前状态说明</font>

* admin black qq (-) 理由 号 <font color=#53b0ff>拉黑用户（black指令兼容版）</font>

* admin black group (-) 理由 群 <font color=#53b0ff>拉黑群聊（black指令兼容版）</font>

### 群开关操作
*  group<font color=#53b0ff> 显示帮助</font>

*  group card[用户QQ][名片] <font color=#53b0ff>设置群员名片</font>

*  group +/-[群管词条] <font color=#53b0ff>为群加减设置(例: group +禁用回复 关闭本群自定义回复)</font>
!!! Warning "注意"
    需要Master权限 或 管理员权限
!!! none "群管词条"
    停用指令/禁用回复/禁用jrrp/禁用draw/禁用help/禁用ob

### 心跳包设定

*  heartbeat<font color=#53b0ff> 显示帮助</font>

*  heartbeat address[地址]<font color=#53b0ff>设置心跳包地址</font>

*  heartbeat token [token]<font color=#53b0ff>设置心跳包token</font>

*  heartbeat on <font color=#53b0ff>开启心跳包</font>

*  heartbeat off <font color=#53b0ff>关闭心跳包</font>

*  heartbeat status <font color=#53b0ff>心跳包日志</font>

!!! Warning "注意"
    需要Master权限
!!! none "*群管词条"
    默认使用仑质心跳服务，若默认，则无需设定心跳包地址
    
    若默认，token需要去[OlivaOS心跳服务](http://benzencloudhk.xyz/index.php/dicetoken/)领取，并找仑质审核，然后使用**heartbeat token[这里写你申请到的token]**
    
    **heartbeat on** 后本系统才会自动发送心跳包

### 远程进程管理
*  system <font color=#53b0ff>显示帮助</font>

*  system save <font color=#53b0ff>手动保存数据</font>

*  system load <font color=#53b0ff>重新加载所有数据(牌堆，自定义文件等)</font>

*  system reload <font color=#53b0ff>重启骰娘内核(慎用，会中断服务高达1分钟)</font>

!!! Warning "注意"
    需要Master权限

### 远程管理help文档内容
*  helpdoc <font color=#53b0ff> 帮助</font>

*  helpdoc [词条名][词条内容]<font color=#53b0ff>自定义帮助词条词条内容，以&开头表示重定向。</font>
!!! Warning "注意"
    需要Master权限

    也可以手动放入相关文件到helpdoc文件夹内

??? none "例子"
    如**.helpdoc追仙子&追仙**后

    **help追仙子** 将重定向到 **追仙后**

### 入群新人欢迎语
*  welcome <font color=#53b0ff>帮助</font>

*  welcome on <font color=#53b0ff>打开</font>

*  welcome off <font color=#53b0ff>关闭</font>

*  welcome[自定义语句内容]<font color=#53b0ff>设定欢迎语内容</font>


### 关键词自动回复
*  reply on/off this <font color=#53b0ff>开关本群自动回复</font>
!!! Warning "注意"
    需要管理员权限
*  reply 全匹配关键词 内容 添加关键词<font color=#53b0ff>自动回复项目</font>

*  reply list <font color=#53b0ff>查看所有设定的关键词</font>

*  reply on/off <font color=#53b0ff>开关全局自动回回复</font>
!!! Warning "注意"
    需要master权限

### 长消息分条发送
*  system split on/off <font color=#53b0ff>是否打开长消息自动分条发送</font>
!!! Warning "注意"
    需要master权限

### 手动清群
*  master groupclr count 数字(留空默认30)<font color=#53b0ff>查看 数字 天内未使用的群聊数量</font>

*  master groupclr 数字 <font color=#53b0ff>退出 数字 天内未使用的群聊</font>

### 恢复数据
*  recovery <font color=#53b0ff>帮助</font>

*  recovery overwrite QQ <font color=#53b0ff>恢复数据</font>
!!! Warning "注意"
    需要提前用要恢复的骰子的data文件夹覆盖现在的data文件夹

## 【跑团指令】

### 小队管理
*  team <font color=#53b0ff>列出小队成员</font>

*  team help <font color=#53b0ff>帮助</font>

*  team set <font color=#53b0ff>添加小队成员</font>
??? none "例子"
    * team set @某人   
    * team set 某人QQ
*  team hp 修改队员血量<font color=#53b0ff></font>
??? none "例子"
    * team hp @成员 +3(成员恢复3血)
    * team hp @成员 3(成员失去3血)
    * team hp @成员 +1d3(成员恢复1d3血)
    * team hp @成员 1d3(成员失去1d3血)
    * team hp all 1d3(全体成员失去1d3血)
    * team hp all +1d3(全体成员获得1d3血)
*  team san <font color=#53b0ff>修改队员san</font>
??? none "例子"
    * team san @成员 +3(成员恢复3理智)
    * team san @成员 3(成员失去3理智)
    * team san @成员 +1d3(成员恢复1d3理智)
    * team san @成员 1d3(成员失去1d3理智)
    * team san @成员 1d3/1d5(成员进行sc 1d3/1d5)
    * team san all 1d3/1d5(全体成员进行sc 1d3/1d5)
    * team san all 1d3(全体成员失去1d3理智)
    * team san all +1d3(全体成员获得1d3理智)
*  team rm <font color=#53b0ff>删除队员</font>
??? none "例子"
    * team rm @成员
*  team rename <font color=#53b0ff>修改全体群名片为跑团格式</font>

*  team clr <font color=#53b0ff>清除所有队员</font>

*  team call <font color=#53b0ff>艾特所有队员</font>

*  team lock<font color=#53b0ff>锁定小队，小队人物卡不会因其他命令被切换</font>

*  team unlock <font color=#53b0ff>解锁小队</font>

*  team desc <font color=#53b0ff>私聊小队成员信息</font>

*  team en <font color=#53b0ff>统计技能成功情况(注:只有team lock状态才能统计!)</font>

### 人物卡管理

*  pc 显示帮助<font color=#53b0ff></font>

*  pc new [卡名]完全省略参数将生成一张C0C7模板的随机姓名卡<font color=#53b0ff></font>

*  pc tag[卡名]为当前群绑定指定卡,为空则解绑使用默认卡,所有群默认使用跨群卡，绑定后使用本群卡<font color=#53b0ff></font>

*  pc show [卡名]展示指定卡所有记录的属性，为空则展示当前卡<font color=#53b0ff></font>

*  pc cpy [卡名1][卡名2]将后者属性复制给前者<font color=#53b0ff></font>

*  pc list 列出全部角色卡<font color=#53b0ff></font>

*  pc grp 列出各群绑定卡<font color=#53b0ff></font>

*  pc build[卡名]根据模板填充生成属性<font color=#53b0ff></font>

*  pc redo [卡名] 清空原有属性后重新生成<font color=#53b0ff></font>

*  pc clr 销毁全部角色卡记录<font color=#53b0ff></font>

*  pc nn [新卡名] 重命名当前卡，不允许重名<font color=#53b0ff></font>

*  pc del[卡名]删除指定卡,留空参数解绑并删除当前卡<font color=#53b0ff></font>

*  pc online [卡名] 设为云人物卡，避免覆盖<font color=#53b0ff></font>

*  pc push [卡名]设为云人物卡并覆盖云数据<font color=#53b0ff></font>

*  pc pull [卡名] 设为云人物卡并覆盖本地数据<font color=#53b0ff></font>

*  pc offine [卡名]解除云人物卡<font color=#53b0ff></font>
!!! Warning "注意"
    每名用户保存的角色卡最多为10

### 人物卡属性设定
*  st帮助<font color=#53b0ff></font>

*  st del[欲删除的技能名]删除技能<font color=#53b0ff></font>

*  st clr 初始化所有技能<font color=#53b0ff></font>

*  st名字-属性10属性20录卡(塔系格式)<font color=#53b0ff></font>

*  st属性10属性20录卡(溯洄格式)<font color=#53b0ff></font>
!!! Warning "注意"
    关于人物卡的显示，操作请使用。pc 命令查看帮助。

### 房规管理
setcoc [房规代码0-5or自定义房规名称]<font color=#53b0ff>(默认为3)</font>

!!! none "代码0"
    * 出1大成功
    * 不满50出96-100大失败
    * 满50出100大失败

!!! none "代码1"
    * 不满50出1大成功，满50出1-5大成功
    * 不满50出96-100大失败，满50出100大失败

!!! none "代码2"
    * 出1-5且<=成功率大成功
    * 出100或出96-99且>成功率大失败

!!! none "代码3"
    * 出1-5大成功
    * 出96-100大失败

!!! none "代码4"
    * 出1-5且<=十分之一大成功
    * 不满50出>= 96 +十分之一大失败，满50出100大失败

!!! none "代码5"
    * 出1-2且<五分之一大成功
    * 不满50出96-100大失败，满50出99-100大失败

!!! none "自定义房规名称"
    * 顾名思义
    * 详情参考[房规](rules.md)

### 跑团骰点鉴定
#### COC
##### 普通鉴定
!!! none "房规规则"
    * ra技能名 属性值
    * ra多重鉴定次数#属性名 属性值 <font color=#53b0ff>(例ra2#斗殴50)</font>
!!! none "标准规则"
    * rc技能名 属性值
    * rc多重鉴定次数# 属性值 <font color=#53b0ff>(例rc2#斗殴50)</font>

##### 奖励骰鉴定
!!! none "房规规则"
    * rab技能名 属性值
    * ra多重鉴定次数#b奖励骰个数 技能名 属性值 <font color=#53b0ff>(例ra2#b3斗殴50)</font>
!!! none "标准规则"
    * rcb技能名 属性值
    * rc多重鉴定次数#b奖励骰个数 技能名 属性值 <font color=#53b0ff>(例rc2#b3斗殴50)</font>

##### 惩罚骰鉴定
!!! none "房规规则"
    * rap技能名 属性值
    * ra多重鉴定次数#p惩罚骰个数 技能名 属性值 <font color=#53b0ff>(例ra2#p3斗殴50)</font>
!!! none "标准规则"
    * rcb技能名 属性值
    * rc多重鉴定次数#p惩罚骰个数 技能名 属性值 <font color=#53b0ff>(例rc2#p3斗殴50)</font>

##### 对抗骰鉴定
!!! none "房规规则"
    * rav技能名/数值 <font color=#53b0ff>(例rav 50或rav斗殴 或rav角色:斗殴)</font>
!!! none "标准规则"
    * rcv技能名/数值 <font color=#53b0ff>(例rcv 50或rcv斗殴 或rcv角色:斗殴)</font>
    !!! none "注意"
        其中属性值在录入属性后可以被省略，技能名可以在有属性值的情况下被省略

#### r表达式
* 支持:XdY、dY、Xd

* X是骰数默认为1，Y是随机数最大值默认为100

* XdYkN表取前N个最大数相加

* XdYqN表取前N个最小数相加

#### range表达式
* 详细版r表达式

#### DND
##### 先攻骰点
* ri 加值 名字
!!! none "注意"
    其中加值和名字可以省略
??? none "例子"
    * ri(投掷先攻)
    * ri +3(投掷加值为3的先攻)
    * ri a(为a投掷先攻)
    * ri 3#a(分别为aA、aB、aC投掷先攻)

##### 先攻列表
* init

##### 先攻清空
* init clr

##### 先攻设定
* init set 设置名 表达式

##### 先攻删除
* init del 关键词

##### 先攻buff
* init buff 关键词 状态名

##### 先攻回合结束
* init end

#### 无限
* ww XaYkZ
!!! none "注意"
    X是骰数，Y是成功线，Z是加骰线，其中kZ可以省略，Z默认是8

#### 圣杯
* rXdf
* rf
!!! none "注意"
    X默认是4，骰出X个1到-1的随机数求和。

### 超级暗骰(KP专用)
* psy @玩家 技能名称(留空默认心理学)
!!! none "注意"
    * 功能:指定玩家的心理学或其他技能的鉴定结果私聊发送给命令使用者

    <font color=#d97400>例:psy @克里斯(结果:将玩家克里斯的心理学鉴定结果私聊给发送psy指令的人)</font>

    <font color=#d97400>例:psy @克里斯 魅惑 (结果:将玩家克里斯的魅惑鉴定结果私聊给发送psy指令的人)</font>

### 理智鉴定SC

<font color=#d97400>理智鉴定，成功时减去成功表达式的理智，失败时减去失败表达式的理智</font>

sc 成功表达式/失败表达式

??? none "例子"
    * sc 1d4/3d8
    * sc 1/1d10

### 技能升级鉴定
* en 技能名

* en 属性值

* en 技能名 属性值
!!! none "注意"
    成功后技能将增加1d10

    支持en扩展

* en 幸运 属性值 失败时增加/成功时增加
??? none "例子"
    * en 幸运 +1d3/1d10，失败时幸运增加1d3，成功幸运增加1d10
    * en 幸运 50 -1d3/1d10 ，失败时幸运变成50-1d3，成功幸运变成50+1d10

### 技能升级鉴定
*  ii <font color=#53b0ff>总结症状</font>

*  ti <font color=#53b0ff>临时症状</font>

### 设置人物卡名字
*  nn <font color=#53b0ff>人物卡名字</font>
!!! none "注意"
    若人物卡存在，则切换到此人物卡，若不存在，则修改名字到此人物卡

### 人物作成

*  dnd <font color=#53b0ff>数字 生成dnd人物作成</font>

*  coc <font color=#53b0ff>数字 生成coc人物作成</font>

### 名字生成
*  name <font color=#53b0ff>生成随机人物名</font>

*  namejp <font color=#53b0ff>生成人物名(日)</font>

*  name cn <font color=#53b0ff>生成人物名(中)</font>

*  name en <font color=#53b0ff>生成人物名(欧)</font>

*  name encn <font color=#53b0ff>生成人物名(中欧)</font>

### 暗骰
<font color=#53b0ff>暗中骰点</font>

* rh 表达式

<font color=#53b0ff>暗中鉴定</font>

*  rah 技能名 技能值<font color=#53b0ff>(技能名/技能名可省略任意一样)</font>

### 随机分配身份
* who A B C D...

<font color=#53b0ff>可以随机打乱ABCD的顺序</font>

### 跑团名片修改

* sn coc <font color=#53b0ff> 自动设置coc名片</font>

* sn dnd <font color=#53b0ff> 自动设置dnd名片</font>

* sn expr <font color=#53b0ff> 自设格式</font>

* sn off <font color=#53b0ff> 取消自动设置</font>

* sn set yyds <font color=#53b0ff> 修改群名片为yyds（其中yyds可以改成任何字符）</font>

* sn on <font color=#53b0ff>打开自动设置</font>
!!! none "注意"
    本设定针对人物卡，由你持有的人物卡确定是否自动改群名片，骰子必须是管理员才能使用。
其中模板格式为 {pc_技能名}

### 默认骰面设定
*  set 默认点数设置1d?的默认值 <font color=#53b0ff>如set 50则默认d=d50，只影响r指令</font>

### 牌堆功能
* draw 查看帮助
*  draw list <font color=#53b0ff>查看载入了哪些牌堆文件</font>

*  draw help <font color=#53b0ff>查看有哪些牌堆名可以使用</font>

*  draw reload <font color=#53b0ff>重新载入牌堆数据</font>

*  draw search <font color=#53b0ff>牌堆名关键词 搜索相关牌堆</font>

*  draw <font color=#53b0ff>牌堆名 进行牌堆抽取</font>
!!! none "注意"
    可以使用 **deck help** 查看draw指令的扩展功能

以下指令可以设置默认牌堆，当 draw无牌堆名时将默认使用它。牌堆不会放回，抽完才会自动回满。

*  deck set 公共牌堆名 <font color=#53b0ff>设置默认牌堆，留空则清除默认牌堆名</font>

*  deck set 正整数1-100<font color=#53b0ff> 设置指定长度的数列</font>

*  deck show <font color=#53b0ff>查看剩余卡牌</font>

*  deck reset <font color=#53b0ff>重置剩余卡牌</font>

*  deck new 有弹|无弹|无弹|无弹|无弹|无弹 <font color=#53b0ff>自定义牌堆(用空格或I分割)</font>

### OB围观
#### 旁观模式:ob(exit/list/clr/on/off)
*  ob <font color=#53b0ff>加入旁观可以看到他人暗骰结果</font>

*  ob extt<font color=#53b0ff>退出旁观模式</font>

*  ob list <font color=#53b0ff>查看群内旁观者</font>

*  ob clr <font color=#53b0ff>清除所有旁观者</font>

*  ob on <font color=#53b0ff>全群允许旁观模式</font>

*  ob off <font color=#53b0ff><禁用旁观模式</font>

<font color=#53b0ff>暗骰与旁观仅在群聊中有效</font>

## 【功能指令】

### 退群
*  dismiss 后四位QQ <font color=#53b0ff>令骰娘退群</font>
!!! none "注意"
    也可以使用@骰娘 .dismiss

### 跑团日志
* log on [文件名?] <font color=#53b0ff>自定义文件名并开始</font>

* log[文件名?] <font color=#53b0ff>自定义文件名并开始</font>

* log end [文件名?]<font color=#53b0ff>结束并上传指定log</font>

* log off/stop[文件名?] <font color=#53b0ff>暂停指定log</font>

* log list <font color=#53b0ff>查看日志列表</font>

* log clr <font color=#53b0ff>放弃所有日志(只能从骰主找回文件)</font>

### 骰点统计
*  hiy<font color=#53b0ff> 统计成功/失败等情况</font>

### 规则书速查
* rules [规则]:[待查词条]
??? none "例子"
    * rules 跳跃
    * rules CoC:大失败(coc默认视为coc7,dnd默认视为3r)
    * rules dnd:语言
*  rules set <font color=#53b0ff>规则 设置优先查询规则</font>

*  rules set <font color=#53b0ff>清除优先标记</font>
??? none "例子"
    * rules set dnd 优先查询dnd

### 获取master信息
*  master <font color=#53b0ff>可以获取master预先设定的个人信息</font>

### 关于内核
*  bot <font color=#53b0ff>读取内核版本号</font>

### 读取内核版本号
*  send <font color=#53b0ff>正文内容发消息给骰主，如果骰主给骰娘设定了master列表的话。</font>
