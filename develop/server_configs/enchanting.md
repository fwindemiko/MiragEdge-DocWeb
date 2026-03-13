# 更多附魔

服务器使用 **Aiyatsbus** 插件实现自定义附魔系统，配合 **NereusOpus** 插件提供更多附魔选项。

## 插件介绍

### Aiyatsbus

Aiyatsbus 是一个功能强大的自定义附魔插件，支持：
- 自定义附魔属性和效果
- 附魔品质系统
- 附魔冲突配置
- 附魔GUI界面

### NereusOpus

NereusOpus 提供额外的附魔支持，包括：
- 符文系统（Artifact）
- 特殊技能附魔
- 更多附魔变体

## 配置文件结构

```
Aiyatsbus/
└── enchants ························· 附魔目录
    ├── Packet-Sephirah ·············· 自定义附魔包
    │   └── *.yml
    ├── Packet-Default ··············· 默认附魔包
    │   └── *.yml
    ├── Packet-Vanilla ··············· 原版附魔包
    │   └── *.yml
    ├── display.yml ·················· 附魔显示配置
    ├── group.yml ···················· 附魔类别配置
    ├── rarity.yml ··················· 附魔品质配置
    ├── target.yml ··················· 附魔对象配置
    └── internal-triggers.yml ········ 内置触发器配置

Chesed/
└── config.yml ······················· 祛魔系统配置
    └── gem/ ························· 祛魔符文配置

NereusOpus/
└── enchantments/ ···················· 附魔配置目录
    ├── enchants.yml ················· 附魔列表
    ├── rarities.yml ················· 品质配置
    └── simple/ ······················ 简单附魔配置
```

## 核心配置文件说明

### rarity.yml - 附魔品质配置

```yaml
# 品质名称（对应 group.yml 中的引用）
common:
  name: 普通                    # 显示名称
  color: "[{text}](c=#f8f4ed)" # 颜色代码
  weight: 1000                 # 权重（数值越小越稀有）
  skull: "base64..."           # 品质图标

uncommon:
  name: 罕见
  color: "[{text}](c=#66c18c)"
  weight: 500
  skull: "base64..."

epic:
  name: 史诗
  color: "[{text}](c=#eb507e)"
  weight: 50

legendary:
  name: 传奇
  color: "[{text}](c=#fba414)"
  weight: 10
  is_treasure: false           # 是否为宝藏附魔

splendid:
  name: 稀世
  color: "[{text}](c=#fbda41)"
  weight: 5
  is_treasure: false
```

### group.yml - 附魔分类配置

```yaml
# 按功能分类
原版增伤类附魔:
  enchants:
    - 锋利
    - 致密
    - 穿刺

# 按品质分类
诅咒类附魔:
  rarities:
    - 诅咒

# 不可在附魔台获取
不可附魔台类附魔:
  rarities:
    - 传奇
    - 稀世

# 可交易附魔
可交易附魔:
  enchants:
    - 锋利
    - 保护
  rarities:
    - 普通
    - 罕见
    - 精良
```

### target.yml - 附魔对象配置

```yaml
# 装备类型定义
swords:
  max: 12                      # 最大附魔等级
  name: 剑
  active-slots:
    - HAND                    # 主手
  types:
    - DIAMOND_SWORD
    - GOLDEN_SWORD
    - IRON_SWORD
    # ... 其他剑类型

boots:
  max: 8
  name: 靴子
  active-slots:
    - FEET
  types:
    - DIAMOND_BOOTS
    - GOLDEN_BOOTS
    # ...

# 全装备类型
all:
  max: 16
  name: 所有物品
  types:
    - DIAMOND_SWORD
    - DIAMOND_PICKAXE
    # ... 所有可附魔物品
```

## 附魔配置示例

### 基本附魔配置

```yaml
# 附魔基础信息
basic:
  id: night_vision              # 附魔ID（唯一标识）
  name: 月光祝福               # 显示名称
  max_level: 1                 # 最大等级

# 附魔品质
rarity: 史诗

# 适用装备类型
targets:
  - 头盔
  - 胸甲
  - 护腿
  - 靴子

# 附魔限制（冲突配置）
limitations:
  - "CONFLICT_ENCHANT:其他附魔ID"  # 冲突附魔

# 显示配置
display:
  description:
    general: "在黑暗中提供清晰的视野"
    specific: "&7在黑暗中提供清晰的视野&f(夜视效果)&7"

# 效果变量（支持等级差异）
variables:
  leveled:
    持续时间: "秒:{level}*60"
  ordinary:
    amplifier: 1

# 附魔效果实现
mechanisms:
  tickers:
    durability:
      interval: 60            # 触发间隔（tick）
      handle: |-
        add-potion-effect NIGHT_VISION on &player duration 320 amplifier 1
```

### 战斗附魔配置示例

```yaml
basic:
  id: healing_close_combat
  name: "治愈"
  max_level: 3

rarity: 传奇
targets:
  - 剑
  - 斧

alternative:
  is-treasure: true           # 宝藏附魔

display:
  description:
    general: "使得被攻击的血量降低的玩家血量恢复"
    specific: "&7使得被攻击的玩家血量恢复&a{血量}"

variables:
  leveled:
    血量: "点:2*{level}"
  ordinary:
    require-full-charge: true

mechanisms:
  listeners:
    on-damage:
      listen: "entity-damage-by-entity"
      handle: |-
        if not instance-of &event[entity] is org.bukkit.entity.Player then {
          exit
        }
        if all [
          type boolean &require-full-charge
          check &event[entity.attackCooldown] < 1.0
        ] then {
          exit
        }
        set added to math add [ &event[entity.health] type double &血量 ]
        set &event[damage] to 0
        add-potion-effect GLOWING on &event[entity] duration 3 amplifier 1
        set &event[entity.health] to min &added &event[entity.max-health]
```

### 范围挖掘附魔配置

```yaml
basic:
  id: blast_mining
  name: 立方
  max_level: 1

rarity: 精良

targets:
  - 镐

limitations:
  - "CONFLICT_ENCHANT:脉络"

display:
  description:
    general: "每次可以挖掘立方范围的方块"
    specific: "&7可挖掘&a{X范围}*{Y范围}*{Z范围}&7范围的方块"

variables:
  leveled:
    X范围: "格:{level}+1*2"
    Y范围: "格:{level}+1*2"
    Z范围: "格:{level}+1*2"
  ordinary:
    per-tick: 12
    disable-on-sneaking: true
    hardness-check: BEDROCK,OBSIDIAN
    blacklist: SKELETON_SKULL,WITHER_SKELETON_SKULL,CREEPER_HEAD...

mechanisms:
  listeners:
    on-break:
      listen: "block-break"
      handle: |-
        # 范围挖掘逻辑...
        operation fast-multi-break args array [ &player &breaks &per-tick ]
```

## 祛魔系统配置 (Chesed)

### config.yml 核心配置

```yaml
Settings:
  default-language: "zh_CN"

  # 每次解析的附魔数量
  rule:
    amount: 2                  # 每次解析2个
    level:
      enable: true             # 按等级排序
      from-low: true          # 从低到高

  # 祛魔台位置
  separators:
    - "world_name~1,1,1"

  deenchant:
    # 成功率公式
    success-rate: "100-10*{order}"

    # 附魔书等级公式
    level: "{level}-1"

    # 禁止祛魔的附魔
    blacklist: [ ]

    # 价格配置
    price:
      exp-level:
        enable: true
        cost: "6*({level}/{maxLevel})*{order}"
      vault:
        enable: true
        cost: "680*({level}/{maxLevel})*{order}"

    # 特权配置
    privilege:
      keep-level: "chesed.keep-level"
      success-rate:
        - "chesed.rate.110:{value}*1.1"
        - "chesed.rate.125:{value}*1.25"
      discount:
        - "chesed.discount.90:{value}*0.9"
        - "chesed.discount.75:{value}*0.75"
```

## Kether 脚本语法

附魔效果使用 Kether 脚本实现，以下是常用语法：

### 常用命令

```kether
# 添加药水效果
add-potion-effect SPEED on &player duration 60 amplifier 1

# 设置变量
set &var to "value"
set &num to math 1 + 2

# 条件判断
if condition then {
  # do something
}

# 循环
for &i in range 1 to 10 then {
  # do something
}

# 播放声音
sound BLOCK_ENCHANTMENT_TABLE_USE by 1 1

# 生成粒子
particleenchant particle "FLAME" count 5 speed 0.1 on &player
```

### 事件监听

```kether
# 实体伤害事件
listeners:
  on-damage:
    listen: "entity-damage-by-entity"
    handle: |-
      # 伤害处理逻辑

# 方块破坏事件
listeners:
  on-break:
    listen: "block-break"
    handle: |-
      # 破坏处理逻辑

# 玩家交互事件
listeners:
  on-click:
    listen: "player-interact"
    handle: |-
      # 点击处理逻辑
```

## 官方文档

- **Aiyatsbus 插件文档**: https://wiki.polarastrum.cc/plugin/aiyatsbus/start/ench/basic/
- **Kether 脚本语法**: https://taboolib.hhhhhy.kim/kether-list

::: warning
官方文档内容可能较旧，部分配置已过时，仅供参考。
:::
