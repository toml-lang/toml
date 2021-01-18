![TOML Logo](logos/toml-200.png)

TOML v1.0.0
===========

汤小明的小巧明晰语言。  

作者：汤姆·普雷斯顿—维尔纳、Pradyun Gedam 等人。  

宗旨
----

TOML 旨在成为一个语义显著而易于阅读的最低限度的配置文件格式。  
TOML 被设计地能够无歧义地转化为哈希表。  
TOML 应当能简单地解析成形形色色的语言中的数据结构。  

目录
----

- [说明](#user-content-spec)
- [注释](#user-content-comment)
- [键值对](#user-content-keyvalue-pair)
- [键名](#user-content-keys)
- [字符串](#user-content-string)
- [整数](#user-content-integer)
- [浮点数](#user-content-float)
- [布尔值](#user-content-boolean)
- [坐标日期时刻](#user-content-offset-date-time)
- [各地日期时刻](#user-content-local-date-time)
- [各地日期](#user-content-local-date)
- [各地时刻](#user-content-local-time)
- [数组](#user-content-array)
- [表](#user-content-table)
- [行内表](#user-content-inline-table)
- [表数组](#user-content-array-of-tables)
- [文件扩展名](#user-content-filename-extension)
- [MIME 类型](#user-content-mime-type)
- [ABNF 语法](#user-content-abnf-grammar)

[说明](#user-content-spec)<a id="user-content-spec">&nbsp;</a>
------

* TOML 是大小写敏感的。
* TOML 文件必须是有效的 UTF-8 编码的 Unicode 文档。
* 空白的意思是 Tab（0x09）或空格（0x20）。
* 换行的意思是 LF（0x0A）或 CRLF（0x0D 0x0A）。

[注释](#user-content-comment)<a id="user-content-comment">&nbsp;</a>
------

井号将此行剩下的部分标记为注释，除非它在字符串中。  

```toml
# 这是一个全行注释
key = "value"  # 这是一个行末注释
another = "# 这不是一个注释"
```

除 Tab 以外的控制字符（U+0000 至 U+0008，U+000A 至 U+001F，U+007F）不允许出现在注释中。  

[键值对](#user-content-keyvalue-pair)<a id="user-content-keyvalue-pair">&nbsp;</a>
--------

TOML 文档最基本的构成区块是键值对。  

键名在等号的左边而值在右边。  
键名和键值周围的空白会被忽略。  
键、等号和值必须在同一行（不过有些值可以跨多行）。  

```toml
key = "value"
```

值必须是下述类型之一。  

- [字符串](#user-content-string)
- [整数](#user-content-integer)
- [浮点数](#user-content-float)
- [布尔值](#user-content-boolean)
- [坐标日期时刻](#user-content-offset-date-time)
- [各地日期时刻](#user-content-local-date-time)
- [各地日期](#user-content-local-date)
- [各地时刻](#user-content-local-time)
- [数组](#user-content-array)
- [行内表](#user-content-inline-table)

不指定值是错误的。  

```toml
key = # 错误
```

键值对后必须换行（或结束文件）。  
（例外见 [行内表](#user-content-inline-table)）  

```
first = "汤姆" last = "普雷斯顿—维尔纳" # 错误
```

[键名](#user-content-keys)<a id="user-content-keys">&nbsp;</a>
------

键名可以是裸露的，引号引起来的，或点分隔的。  

**裸键**只能包含 ASCII 字母，ASCII 数字，下划线和短横线（`A-Za-z0-9_-`）。  
注意裸键允许仅由纯 ASCII 数字构成，例如 `1234`，但是是被理解为字符串的。  

```toml
key = "value"
bare_key = "value"
bare-key = "value"
1234 = "value"
```

**引号键**遵循与基础字符串或字面量字符串相同的规则并允许你使用更为广泛的键名。  
除非明显必要，使用裸键方为最佳实践。  

```toml
"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
'key2' = "value"
'quoted "value"' = "value"
```

裸键中不能为空，但空引号键是允许的（虽然不建议如此）。  

```toml
= "没有键名"  # 错误
"" = "空"     # 正确但不鼓励
'' = '空'     # 正确但不鼓励
```

**点分隔键**是一系列通过点相连的裸键或引号键。  
这允许了你将相近属性放在一起：  

```toml
name = "橙子"
physical.color = "橙色"
physical.shape = "圆形"
site."google.com" = true
```

这在 JSON 那儿，是以下结构：  

```json
{
  "name": "橙子",
  "physical": {
    "color": "橙色",
    "shape": "圆形"
  },
  "site": {
    "google.com": true
  }
}
```

有关点分隔键定义表的详细信息，请参阅后文[表](#user-content-table)一节。  

点分隔符周围的空白会被忽略。  
不过，最佳实践是不要使用任何不必要的空白。  

```toml
fruit.name = "香蕉"     # 这是最佳实践
fruit. color = "黄色"    # 等同于 fruit.color
fruit . flavor = "香蕉"   # 等同于 fruit.flavor
```

缩进被作为空白对待而被忽略。  

多次定义同一个键是不行的。  

```
# 不要这样做
name = "汤姆"
name = "Pradyun"
```

注意裸键和引号键是等价的：  

```
# 这是不可行的
spelling = "favorite"
"spelling" = "favourite"
```

只要一个键还没有被直接定义过，你就仍可以对它和它下属的键名赋值。  

```
# 这使“fruit”键作为表存在。
fruit.apple.smooth = true

# 所以接下来你可以像中这样对“fruit”表添加内容：
fruit.orange = 2
```

```
# 以下是错误的

# 这将 fruit.apple 的值定义为一个整数。
fruit.apple = 1

# 但接下来这将 fruit.apple 像表一样对待了。
# 整数不能变成表。
fruit.apple.smooth = true
```

不鼓励跳跃式地定义点分隔键。  

```toml
# 有效但不鼓励

apple.type = "水果"
orange.type = "水果"

apple.skin = "薄"
orange.skin = "厚"

apple.color = "红"
orange.color = "橙"
```

```toml
# 建议

apple.type = "水果"
apple.skin = "薄"
apple.color = "红"

orange.type = "水果"
orange.skin = "厚"
orange.color = "红"
```

由于裸键可以仅由 ASCII 整数组成，所以可能写出看起来像浮点数、但实际上是两部分的点分隔键。  
除非你有充分的理由（基本不太会），否则不要这样做。  

```toml
3.14159 = "派"
```

上面的 TOML 对应以下 JSON。  

```json
{ "3": { "14159": "派" } }
```

[字符串](#user-content-string)<a id="user-content-string">&nbsp;</a>
--------

共有四种方式来表示字符串：基础式的，多行基础式的，字面量式的，和多行字面量式的。  
所有字符串都只能包含有效的 UTF-8 字符。  

**基础字符串**由引号（`"`）包裹。  
任何 Unicode 字符都可以使用，除了那些必须转义的：引号，反斜杠，以及除 Tab 外的控制字符（U+0000 至 U+0008，U+000A 至 U+001F，U+007F）。  

```toml
str = "我是一个字符串。\"你可以把我引起来\"。姓名\tJos\u00E9\n位置\t旧金山。"
```

为了方便，一些流行的字符有其简便转义写法。

```
\b         - backspace       (U+0008)
\t         - tab             (U+0009)
\n         - linefeed        (U+000A)
\f         - form feed       (U+000C)
\r         - carriage return (U+000D)
\"         - quote           (U+0022)
\\         - backslash       (U+005C)
\uXXXX     - unicode         (U+XXXX)
\UXXXXXXXX - unicode         (U+XXXXXXXX)
```

任何 Unicode 字符都可以用 `\uXXXX` 或 `\UXXXXXXXX` 的形式来转义。  
转义码必须是有效的 Unicode [标量值](https://unicode.org/glossary/#unicode_scalar_value)。  

所有上面未列出的其它转义序列都是保留的；如果用了，TOML 应当产生错误。  

有时你需要表示一小篇文本（例如译文）或者想要对非常长的字符串进行折行。  
TOML 对此进行了简化。  

**多行基础字符串**由三个引号包裹，允许折行。  
紧随开头引号的那个换行会被去除。  
其它空白和换行会被原样保留。  

```toml
str1 = """
玫瑰是红色的
紫罗兰是蓝色的"""
```

TOML 解析器可以相对灵活地解析成对所在平台有效的换行字符。  

```toml
# 在 Unix 系统，上面的多行字符串可能等同于：
str2 = "玫瑰是红色的\n紫罗兰是蓝色的"

# 在 Windows 系统，它可能等价于：
str3 = "玫瑰是红色的\r\n紫罗兰是蓝色的"
```

想书写长字符串却不想引入无关空白，可以用“行末反斜杠”。  
当一行的最后一个非空白字符是未被转义的 `\` 时，它会连同它后面的所有空白（包括换行）一起被去除，直到下一个非空白字符或结束引号为止。  
所有对基础字符串有效的转义序列，对多行基础字符串也同样适用。  

```toml
# 下列字符串的每一个字节都完全相同：
str1 = "那只敏捷的棕狐狸跳过了那只懒狗。"

str2 = """
那只敏捷的棕\


  狐狸跳过了\
    那只懒狗。"""

str3 = """\
       那只敏捷的棕\
       狐狸跳过了\
       那只懒狗。\
       """
```

任何 Unicode 字符都可以使用，除了那些必须被转义的：反斜杠和除 Tab、换行符、回车符外的控制字符（U+0000 至 U+0008，U+000B，U+000C，U+000E 至 U+001F，U+007F）。  

你可以在多行基础字符串内的任何地方写一个引号或两个毗连的引号。  
它们也可以写在紧邻界分符内的位置。  

```toml
str4 = """这有两个引号：""。够简单。"""
# str5 = """这有两个引号："""。"""  # 错误
str5 = """这有三个引号：""\"。"""
str6 = """这有十五个引号：""\"""\"""\"""\"""\"。"""

# "这，"她说，"只是个无意义的条款。"
str7 = """"这，"她说，"只是个无意义的条款。""""
```

如果你常常要指定 Windows 路径或正则表达式，那么必须转义反斜杠就马上成为啰嗦而易错的了。  
为了帮助搞定这点，TOML 支持字面量字符串，它完全不允许转义。  

**字面量字符串**由单引号包裹。  
类似于基础字符串，他们只能表现为单行：  

```toml
# 所见即所得。
winpath  = 'C:\Users\nodejs\templates'
winpath2 = '\\ServerX\admin$\system32\'
quoted   = '汤姆·"达布斯"·普雷斯顿—维尔纳'
regex    = '<\i\c*\s*>'
```

由于没有转义，无法在由单引号包裹的字面量字符串中写入单引号。  
万幸，TOML 支持一种多行版本的字面量字符串来解决这个问题。  

**多行字面量字符串**两侧各有三个单引号来包裹，允许换行。  
类似于字面量字符串，无论任何转义都不存在。  
紧随开始标记的那个换行会被剔除。  
开始结束标记之间的所有其它内容会原样对待。  

```toml
regex2 = '''I [dw]on't need \d{2} apples'''
lines  = '''
原始字符串中的
第一个换行被剔除了。
   所有其它空白
   都保留了。
'''
```

你可以在多行字面量字符串中的任何位置写一个或两个单引号，但三个以上的单引号序列不可以。  

```toml
quot15 = '''这有十五个引号："""""""""""""""'''

# apos15 = '''这有十五个撇号：''''''''''''''''''  # 错误
apos15 = "这有十五个撇号：'''''''''''''''"

# '那，'她说，'仍然没有意义。'
str = ''''那，'她说，'仍然没有意义。''''
```

除 Tab 以外的所有控制字符都不允许出现在字面量字符串中。  
因此，对于二进制数据，建议你使用 Base64 或其它合适的 ASCII 或 UTF-8 编码。  
对那些编码的处理方式，将交由应用程序自己来确定。  

[整数](#user-content-integer)<a id="user-content-integer">&nbsp;</a>
------

整数是纯数字。  
正数可以有加号前缀。  
负数的前缀是减号。  

```toml
int1 = +99
int2 = 42
int3 = 0
int4 = -17
```

对于大数，你可以在数字之间用下划线来增强可读性。  
每个下划线两侧必须至少有一个数字。  

```toml
int5 = 1_000
int6 = 5_349_221
int7 = 53_49_221  # 印度记数体系分组
int8 = 1_2_3_4_5  # 无误但不鼓励
```

前导零是不允许的。  
整数值 `-0` 与 `+0` 是有效的，并等同于无前缀的零。  

非负整数值也可以用十六进制、八进制或二进制来表示。  
在这些格式中，`+` 不被允许，而（前缀后的）前导零是允许的。  
十六进制值大小写不敏感。  
数字间的下划线是允许的（但不能存在于前缀和值之间）。  

```toml
# 带有 `0x` 前缀的十六进制
hex1 = 0xDEADBEEF
hex2 = 0xdeadbeef
hex3 = 0xdead_beef

# 带有 `0o` 前缀的八进制
oct1 = 0o01234567
oct2 = 0o755 # 对于表示 Unix 文件权限很有用

# 带有 `0b` 前缀的二进制
bin1 = 0b11010110
```

任何 64 位有符号整数（从 −2^63 到 2^63−1）都应当被接受并无损处理。  
如果无法无损表现某个整数，则必须抛出错误。  

[浮点数](#user-content-float)<a id="user-content-float">&nbsp;</a>
--------

浮点数应当被实现为 IEEE 754 binary64 值。  

一个浮点数由一个整数部分（遵从与十进制整数值相同的规则）后跟上一个小数部分和/或一个指数部分组成。  
如果小数部分和指数部分兼有，那小数部分必须在指数部分前面。  

```toml
# 小数
flt1 = +1.0
flt2 = 3.1415
flt3 = -0.01

# 指数
flt4 = 5e+22
flt5 = 1e06
flt6 = -2E-2

# 都有
flt7 = 6.626e-34
```

小数部分是一个小数点后跟一个或多个数字。  

一个指数部分是一个 E（大小写均可）后跟一个整数部分（遵从与十进制整数值相同的规则，但可以包含前导零）。  

小数点，如果有用到的话，每侧必须紧邻至少一个数字。  

```
# 非法的浮点数
invalid_float_1 = .7
invalid_float_2 = 7.
invalid_float_3 = 3.e+20
```

与整数相似，你可以使用下划线来增强可读性。  
每个下划线必须被至少一个数字围绕。  

```toml
flt8 = 224_617.445_991_228
```

浮点数值 `-0.0` 与 `+0.0` 是有效的，并且应当遵从 IEEE 754。  

特殊浮点值也能够表示。  
它们是小写的。  

```toml
# 无穷
sf1 = inf  # 正无穷
sf2 = +inf # 正无穷
sf3 = -inf # 负无穷

# 非数
sf4 = nan  # 实际上对应信号非数码还是静默非数码，取决于实现
sf5 = +nan # 等同于 `nan`
sf6 = -nan # 正确，实际码取决于实现
```

[布尔值](#user-content-boolean)<a id="user-content-boolean">&nbsp;</a>
--------

布尔值就是你所惯用的那样。  
要小写。  

```toml
bool1 = true
bool2 = false
```

[坐标日期时刻](#user-content-offset-date-time)<a id="user-content-offset-date-time">&nbsp;</a>
--------------

要明确无误地表示世上的一个特定时间，你可以使用指定了时区偏移量的 [RFC 3339](https://tools.ietf.org/html/rfc3339) 格式的日期时刻。  

```toml
odt1 = 1979-05-27T07:32:00Z
odt2 = 1979-05-27T00:32:00-07:00
odt3 = 1979-05-27T00:32:00.999999-07:00
```

出于可读性的目的，你可以用一个空格字符替代日期和时刻之间的 T（RFC 3339 的第 5.6 节中允许了这样做）。  

```toml
odt4 = 1979-05-27 07:32:00Z
```

毫秒级的精度是必须的。  
更高精度的小数秒取决于实现。  
如果它的值超出了实现所支持的精度，那多余的部分必须被舍弃，而不能四舍五入。  

[各地日期时刻](#user-content-local-date-time)
--------------

如果你省略了 [RFC 3339](https://tools.ietf.org/html/rfc3339) 日期时刻中的时区偏移量，这表示该日期时刻的使用并不涉及时区偏移。  
在没有其它信息的情况下，并不知道它究竟该被转化成世上的哪一刻。  
如果仍被要求转化，那结果将取决于实现。  

```toml
ldt1 = 1979-05-27T07:32:00
ldt2 = 1979-05-27T00:32:00.999999
```

毫秒级的精度是必须的。  
更高精度的小数秒取决于实现。  
如果它的值超出了实现所支持的精度，那多余的部分必须被舍弃，而不能四舍五入。  

[各地日期](#user-content-local-date)<a id="user-content-local-date">&nbsp;</a>
----------

如果你只写了 [RFC 3339](https://tools.ietf.org/html/rfc3339) 日期时刻中的日期部分，那它表示一整天，同时也不涉及时区偏移。  

```toml
ld1 = 1979-05-27
```

[各地时刻](#user-content-local-time)<a id="user-content-local-time">&nbsp;</a>
----------

如果你只写了 [RFC 3339](https://tools.ietf.org/html/rfc3339) 日期时刻中的时刻部分，它将只表示一天之中的那个时刻，而与任何特定的日期无关、亦不涉及时区偏移。  

```toml
lt1 = 07:32:00
lt2 = 00:32:00.999999
```

毫秒级的精度是必须的。  
更高精度的小数秒取决于实现。  
如果它的值超出了实现所支持的精度，那多余的部分必须被舍弃，而不能四舍五入。  

[数组](#user-content-array)<a id="user-content-array">&nbsp;</a>
------

数组是内含值的方括号。  
空白会被忽略。  
子元素由逗号分隔。  
数组可以包含与键值对所允许的相同数据类型的值。  
可以混合不同类型的值。  

```toml
integers = [ 1, 2, 3 ]
colors = [ "红", "黄", "绿" ]
nested_array_of_ints = [ [ 1, 2 ], [3, 4, 5] ]
nested_mixed_array = [ [ 1, 2 ], ["a", "b", "c"] ]
string_array = [ "所有的", '字符串', """是相同的""", '''类型''' ]

# 允许混合类型的数组
numbers = [ 0.1, 0.2, 0.5, 1, 2, 5 ]
contributors = [
  "Foo Bar <foo@example.com>",
  { name = "Baz Qux", email = "bazqux@example.com", url = "https://example.com/bazqux" }
]
```

数组可以跨行。  
数组的最后一个值后面可以有终逗号（也称为尾逗号）。  
值、逗号、结束括号前可以存在任意数量的换行和注释。  
数组值和逗号之间的缩进被作为空白对待而被忽略。  

```toml
integers2 = [
  1, 2, 3
]

integers3 = [
  1,
  2, # 这是可以的
]
```

[表](#user-content-table)<a id="user-content-table">&nbsp;</a>
----

表（也被称为哈希表或字典）是键值对的集合。  
它们由表头定义，连同方括号作为单独的行出现。  
看得出表头不同于数组，因为数组只有值。  

```toml
[table]
```

在它下方，直至下一个表头或文件结束，都是这个表的键值对。  
表不保证保持键值对的指定顺序。  

```toml
[table-1]
key1 = "some string"
key2 = 123

[table-2]
key1 = "another string"
key2 = 456
```

表名的规则与键名相同（见前文[键名](#user-content-keys)定义）。  

```toml
[dog."tater.man"]
type.name = "哈巴狗"
```

这在 JSON 那儿，是以下结构：  

```json
{ "dog": { "tater.man": { "type": { "name": "哈巴狗" } } } }
```

键名周围的空格会被忽略。  
然而，最佳实践还是不要有任何多余的空白。  

```toml
[a.b.c]            # 这是最佳实践
[ d.e.f ]          # 等同于 [d.e.f]
[ g .  h  . i ]    # 等同于 [g.h.i]
[ j . "ʞ" . 'l' ]  # 等同于 [j."ʞ".'l']
```

缩进被作为空白对待而被忽略。  

你不必层层完整地写出你不想写的所有途径的父表。  
TOML 知道该怎么办。  

```toml
# [x] 你
# [x.y] 不
# [x.y.z] 需要这些
[x.y.z.w] # 来让这生效

[x] # 后置父表定义是可以的
```

空表是允许的，只要里面没有键值对就行了。  

类似于键名，你不能重复定义一个表。  
这样做是错误的。  

```
# 不要这样做

[fruit]
apple = "红色"

[fruit]
orange = "橙色"
```

```
# 也不要这样做

[fruit]
apple = "红色"

[fruit.apple]
texture = "光滑"
```

不鼓励无序地定义表。  

```toml
# 正确但不鼓励
[fruit.apple]
[animal]
[fruit.orange]
```

```toml
# 推荐
[fruit.apple]
[fruit.orange]
[animal]
```

顶层表，又被称为根表，于文档开始处开始并在第一个表头（或文件结束处）前结束。  
不同于其它表，它没有名字且无法后置。  

```toml
# 顶层表开始。
name = "Fido"
breed = "哈巴狗"

# 顶层表结束。
[owner]
name = "Regina Dogman"
member_since = 1999-08-04
```

点分隔键为最后一个键名前的每个键名创建并定义一个表，倘若这些表尚未被创建的话。  

```toml
fruit.apple.color = "红色"
# 定义一个名为 fruit 的表
# 定义一个名为 fruit.apple 的表

fruit.apple.taste.sweet = true
# 定义一个名为 fruit.apple.taste 的表
# fruit 和 fruit.apple 已经创建过了
```

由于表不能定义多于一次，不允许使用 `[table]` 头重定义这样的表。  
同样地，使用点分隔键来重定义已经以 `[table]` 形式定义过的表也是不允许的。  
不过，`[table]` 形式可以被用来定义通过点分隔键定义的表中的子表。  

```toml
[fruit]
apple.color = "红色"
apple.taste.sweet = true

# [fruit.apple]  # 错误
# [fruit.apple.taste]  # 错误

[fruit.apple.texture]  # 你可以添加子表
smooth = true
```

[行内表](#user-content-inline-table)<a id="user-content-inline-table">&nbsp;</a>
--------

行内表提供了一种更为紧凑的语法来表示表。  
对于否则就很啰嗦的成组数据，这尤其有用。  
行内表被完整地定义在花括号之中：`{` 和 `}`。  
括号中，可以出现零或更多个以逗号分隔的键值对。  
键值对采取与标准表中的键值对相同的形式。  
什么类型的值都可以，包括行内表。  

行内表得出现在同一行内。  
行内表中，最后一对键值对后不允许终逗号（也称为尾逗号）。  
不允许花括号中出现任何换行，除非在值中它们有效。  
即便如此，也强烈不建议把一个行内表搞成纵跨多行的样子。  
如果你发现自己真的需要，那意味着你应该使用标准表。  

```toml
name = { first = "汤姆", last = "普雷斯顿—维尔纳" }
point = { x = 1, y = 2 }
animal = { type.name = "哈巴狗" }
```

上述行内表等同于下面的标准表定义：  

```toml
[name]
first = "汤姆"
last = "普雷斯顿—维尔纳"

[point]
x = 1
y = 2

[animal]
type.name = "哈巴狗"
```

行内表是独立自足的，在内部定义全部的键与子表。  
不能在括号以外的地方，再添加键与子表。  

```toml
[product]
type = { name = "钉子" }
# type.edible = false  # 错误
```

类似地，行内表不能被用来向一个已定义的表添加键或子表。  

```toml
[product]
type.name = "钉子"
# type = { edible = false }  # 错误
```

[表数组](#user-content-array-of-tables)<a id="user-content-array-of-tables">&nbsp;</a>
--------

最后一个还没讲到的语法允许你写表数组。  
这可以通过把表名写在双方括号里的表头来表示。  
表头的第一例定义了这个数组及其首个表元素，而后续的每个则在该数组中创建并定义一个新的表元素。  
这些表按出现顺序插入该数组。  

```toml
[[products]]
name = "锤子"
sku = 738594937

[[products]]  # 数组里的空表

[[products]]
name = "钉子"
sku = 284758393

color = "灰色"
```

这在 JSON 那儿，是以下结构。  

```json
{
  "products": [
    { "name": "锤子", "sku": 738594937 },
    { },
    { "name": "钉子", "sku": 284758393, "color": "gray" }
  ]
}
```

任何对表数组的引用都指向该数组里最近定义的表元素。  
这允许你在最近的表内定义子表，甚至子表数组。  

```toml
[[fruits]]
name = "苹果"

[fruits.physical]  # 子表
color = "红色"
shape = "圆形"

[[fruits.varieties]]  # 嵌套表数组
name = "蛇果"

[[fruits.varieties]]
name = "澳洲青苹"

[[fruits]]
name = "香蕉"

[[fruits.varieties]]
name = "车前草"
```

上述 TOML 对应下面的 JSON。  

```json
{
  "fruits": [
    {
      "name": "苹果",
      "physical": {
        "color": "红色",
        "shape": "圆形"
      },
      "varieties": [
        { "name": "蛇果" },
        { "name": "澳洲青苹" }
      ]
    },
    {
      "name": "香蕉",
      "varieties": [
        { "name": "车前草" }
      ]
    }
  ]
}
```

如果一个表或表数组的父级是一个数组元素，该元素必须在定义子级前先定义。  
顺序颠倒的行为，必须在解析时报错。  

```
# 错误的 TOML 文档
[fruit.physical]  # 子表，但它应该隶属于哪个父元素？
color = "红色"
shape = "圆形"

[[fruit]]  # 解析器必须在发现“fruit”是数组而非表时抛出错误
name = "苹果"
```

若试图向一个静态定义的数组追加内容，即便数组尚且为空，也必须在解析时报错。  

```
# 错误的 TOML 文档
fruits = []

[[fruits]] # 不允许
```

若试图用已经确定为数组的名称定义表，必须在解析时报错。  
将数组重定义为普通表的行为，也必须在解析时报错。  

```
# 错误的 TOML 文档
[[fruits]]
name = "苹果"

[[fruits.varieties]]
name = "蛇果"

# 错误：该表与之前的表数组相冲突
[fruits.varieties]
name = "澳洲青苹"

[fruits.physical]
color = "红色"
shape = "圆形"

# 错误：该表数组与之前的表相冲突
[[fruits.physical]]
color = "绿色"
```

你也可以适当使用行内表：

```toml
points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]
```

[文件扩展名](#user-content-filename-extension)<a id="user-content-filename-extension">&nbsp;</a>
------------

TOML 文件应当使用 `.toml` 扩展名。  

[MIME 类型](#user-content-mime-type)<a id="user-content-mime-type">&nbsp;</a>
-----------

在互联网上传输 TOML 文件时，恰当的 MIME 类型是 `application/toml`。  

[ABNF 语法](#user-content-abnf-grammar)<a id="user-content-abnf-grammar">&nbsp;</a>
-----------

TOML 语法的严谨说明，由一个 [ABNF 文件][abnf]另行提供。

[abnf]: https://github.com/toml-lang/toml/blob/1.0.0/toml.abnf

——[龙腾道](http://www.LongTengDao.com/) 译