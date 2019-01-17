![TOML Logo](../../logos/toml-200.png)

TOML v0.5.0
===========

全称：Tom 的（语义）明显、（配置）最小化的语言。  
（Tom's Obvious, Minimal Language. By Tom Preston-Werner.）

自版本 0.5.0 起，TOML 可以说是非常稳定了。  
我们的目标是将来正式的 1.0.0 版能够向下兼容到 0.5.0 版（尽人事之可能吧）。  
强烈建议所有的实现都着手兼容 0.5.0，以便于到时转化成 1.0.0 能简单一些。

宗旨
----

TOML 旨在成为一个语义明显且易于阅读的最小化配置文件格式。  
TOML 被设计成可以无歧义地映射为哈希表。  
TOML 应该能很容易地被解析成各种语言中的数据结构。

目录
----

- [示例](#user-content-example)
- [规格](#user-content-spec)
- [注释](#user-content-comment)
- [键/值对](#user-content-keyvalue-pair)
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
- [与其它格式的比较](#user-content-comparison-with-other-formats)
- [参与](#user-content-get-involved)
- [Wiki](#user-content-wiki)

[示例](#user-content-example)<a id="user-content-example">&nbsp;</a>
------

```toml
# 这是一个 TOML 文档。

title = "TOML 示例"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00 # 第一类日期时刻

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # 允许缩进（制表符和/或空格），不过不是必要的
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"

[clients]
data = [ ["gamma", "delta"], [1, 2] ]

# 数组中是可以换行的
hosts = [
  "alpha",
  "omega"
]
```

[规格](#user-content-spec)<a id="user-content-spec">&nbsp;</a>
------

* TOML 是大小写敏感的。
* TOML 文件必须是合法的 UTF-8 编码的 Unicode 文档。
* 空白是指制表符（0x09）或空格（0x20）。
* 换行是指 LF（0x0A）或 CRLF（0x0D0A）。

[注释](#user-content-comment)<a id="user-content-comment">&nbsp;</a>
------

井字符（Hash Symbol）将该行余下的部分标记为注释。

```toml
# 这是一个全行注释
key = "value" # 这是一个行末注释
```

[键值对](#user-content-keyvalue-pair)<a id="user-content-keyvalue-pair">&nbsp;</a>
--------

TOML 文档最基本的构成区块是键/值对。

键名在等号的左边而值在右边。  
键名和键值周围的空白会被忽略。  
键、等号和值必须在同一行（不过有些值可以跨多行）。

```toml
key = "value"
```

值必须是这些类型：字符串，整数，浮点数，布尔值，日期时刻，数组，或行内表。  
不指定值是非法的。

```toml
key = # 非法
```

[键名](#user-content-keys)<a id="user-content-keys">&nbsp;</a>
------

键名可以是裸露的，引号引起来的，或点分隔的。

**裸键**（Bare keys）只能包含 ASCII 字母，ASCII 数字，下划线和短横线（`A-Za-z0-9_-`）。  
注意裸键允许仅由纯 ASCII 数字构成，例如 `1234`，但是是被理解为字符串的。

```toml
key = "value"
bare_key = "value"
bare-key = "value"
1234 = "value"
```

**引号键**（Quoted keys）遵循与基本字符串或字面量字符串相同的规则并允许你使用更为广泛的键名。  
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
= "no key name"  # 非法
"" = "blank"     # 合法但不建议
'' = 'blank'     # 合法但不建议
```

**点分隔键**（Dotted keys）是一系列通过点相连的裸键或引号键。  
这允许了你将相近属性放在一起：

```toml
name = "Orange"
physical.color = "orange"
physical.shape = "round"
site."google.com" = true
```

等价于 JSON 的如下结构：

```json
{
  "name": "Orange",
  "physical": {
    "color": "orange",
    "shape": "round"
  },
  "site": {
    "google.com": true
  }
}
```

点分隔符周围的空白会被忽略，不过，最佳实践是不要使用任何不必要的空白。

多次定义同一个键是不行的。

```
# 不要这样做
name = "Tom"
name = "Pradyun"
```

只要一个键还没有被直接定义过，你就仍可以对它和它下属的键名赋值。

```
a.b.c = 1
a.d = 2
```

```
# 这是非法的
a.b = 1
a.b.c = 2
```

[字符串](#user-content-string)<a id="user-content-string">&nbsp;</a>
--------

共有四种方式来表示字符串：基本字符串、多行基本字符串、字面量和多行字面量。  
所有字符串都只能包含有效的 UTF-8 字符。

**基本字符串**（Basic strings）由引号包裹。  
任何 Unicode 字符都可以使用，除了那些必须转义的：引号，反斜杠，以及控制字符（U+0000 至 U+001F，U+007F）。

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
转义码必须是有效的 Unicode [标量值](http://unicode.org/glossary/#unicode_scalar_value)。

所有上面未列出的其它转义序列都是保留的，如果被用了，TOML 应当生成一个错误。

有时你需要表示一小篇文本（例如译文）或者想要对非常长的字符串进行折行。  
TOML 对此进行了简化。

**多行基本字符串**（Multi-line basic strings）由三个引号包裹，允许折行。  
紧随开头引号的那个换行会被去除。  
其它空白和换行符会被原样保留。

```toml
str1 = """
Roses are red
Violets are blue"""
```

TOML 解析器可以相对灵活地解析成对所在平台有效的换行字符。

```toml
# 在 Unix 系统，上面的多行字符串可能等同于：
str2 = "Roses are red\nViolets are blue"

# 在 Windows 系统，它可能等价于：
str3 = "Roses are red\r\nViolets are blue"
```

想书写长字符串却不想引入无关空白，可以用“行末反斜杠”。  
当一行的最后一个非空白字符是 `\` 时，它会连同它后面的所有空白（包括换行）一起被去除，直到下一个非空白字符或结束引号为止。  
所有对基本字符串有效的转义序列，对多行基本字符串也同样适用。

```toml
# 下列字符串的每一个字节都完全相同：
str1 = "The quick brown fox jumps over the lazy dog."

str2 = """
The quick brown \


  fox jumps over \
    the lazy dog."""

str3 = """\
       The quick brown \
       fox jumps over \
       the lazy dog.\
       """
```

任何 Unicode 字符都可以使用，除了那些必须被转义的：反斜杠和控制字符（U+0000 至 U+001F，U+007F）。  
引号不需要转义，除非它们的存在会造成一个比预期提前的结束标记。

如果你常常要指定 Windows 路径或正则表达式，那么必须转义反斜杠就马上成为啰嗦而易错的了。  
为了帮助搞定这点，TOML 支持字面量字符串，它完全不允许转义。

**字面量字符串**（Literal strings）由单引号包裹。  
类似于基本字符串，他们只能表现为单行：

```toml
# 所见即所得。
winpath  = 'C:\Users\nodejs\templates'
winpath2 = '\\ServerX\admin$\system32\'
quoted   = 'Tom "Dubs" Preston-Werner'
regex    = '<\i\c*\s*>'
```

由于没有转义，无法在由单引号包裹的字面量字符串中写入单引号。  
万幸，TOML 支持一种多行版本的字面量字符串来解决这个问题。

**多行字面量字符串**（Multi-line literal strings）两侧各有三个单引号来包裹，允许换行。  
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

除 tab 以外的所有控制字符都不允许出现在字面量字符串中。  
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
int7 = 1_2_3_4_5     # 合法但不鼓励
```

前导零是不允许的。  
整数值 `-0` 与 `+0` 是有效的，并等同于无前缀的零。

非负整数值也可以用十六进制、八进制或二进制来表示。  
在这些格式中，（前缀后的）前导零是允许的。  
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

可接受范围为 64 位（记作长整型）（−9,223,372,036,854,775,808 至 9,223,372,036,854,775,807）。

[浮点数](#user-content-float)<a id="user-content-float">&nbsp;</a>
--------

浮点数应当被实现为 IEEE 754 64 位双精度值。

一个浮点数由一个整数部分（遵从与十进制整数值相同的规则）后跟上一个小数部分和/或一个指数部分组成。  
如果小数部分和指数部分兼有，那小数部分必须在指数部分前面。

```toml
# 小数
flt1 = +1.0
flt2 = 3.1415
flt3 = -0.01

# 指数
flt4 = 5e+22
flt5 = 1e6
flt6 = -2E-2

# 都有
flt7 = 6.626e-34
```

小数部分是一个小数点后跟一个或多个数字。

一个指数部分是一个 E（大小写均可）后跟一个整数部分（遵从与十进制整数值相同的规则）。

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
sf6 = -nan # 有效，实际码取决于实现
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

要准确地表示世上的一个特定时间，你可以使用指定了时区偏移量的 [RFC 3339](http://tools.ietf.org/html/rfc3339) 格式的日期时刻。

```toml
odt1 = 1979-05-27T07:32:00Z
odt2 = 1979-05-27T00:32:00-07:00
odt3 = 1979-05-27T00:32:00.999999-07:00
```

出于可读性的目的，你可以用空格替代日期和时刻中间的 T（RFC 3339 的第 5.6 节中允许了这样做）。

```toml
odt4 = 1979-05-27 07:32:00Z
```

小数秒的精度取决于实现，但至少应当能够精确到毫秒。  
如果它的值超出了实现所支持的精度，那多余的部分必须被舍弃，而不能四舍五入。

[各地日期时刻](#user-content-local-date-time)
--------------

如果你省略了 [RFC 3339](http://tools.ietf.org/html/rfc3339) 日期时刻中的时区偏移量，这表示该日期时刻的使用并不涉及时区偏移。  
在没有其它信息的情况下，并不知道它究竟该被转化成世上的哪一刻。  
如果仍被要求转化，那结果将取决于实现。

```toml
ldt1 = 1979-05-27T07:32:00
ldt2 = 1979-05-27T00:32:00.999999
```

小数秒的精度取决于实现，但至少应当能够精确到毫秒。  
如果它的值超出了实现所支持的精度，那多余的部分必须被舍弃，而不能四舍五入。

[各地日期](#user-content-local-date)<a id="user-content-local-date">&nbsp;</a>
----------

如果你只写了 [RFC 3339](http://tools.ietf.org/html/rfc3339) 日期时刻中的日期部分，那它表示一整天，同时也不涉及时区偏移。

```toml
ld1 = 1979-05-27
```

[各地时刻](#user-content-local-time)<a id="user-content-local-time">&nbsp;</a>
----------

如果你只写了 [RFC 3339](http://tools.ietf.org/html/rfc3339) 日期时刻中的时刻部分，它将只表示一天之中的那个时刻，而与任何特定的日期无关、亦不涉及时区偏移。

```toml
lt1 = 07:32:00
lt2 = 00:32:00.999999
```

小数秒的精度取决于实现，但至少应当能够精确到毫秒。  
如果它的值超出了实现所支持的精度，那多余的部分必须被舍弃，而不能四舍五入。

[数组](#user-content-array)<a id="user-content-array">&nbsp;</a>
------

数组是内含值的方括号。  
空白会被忽略。  
子元素由逗号分隔。  
子元素的数据类型必须一致（不同写法的字符串应当被认为是相同的类型，不同元素类型的数组也同是数组类型）。

```toml
arr1 = [ 1, 2, 3 ]
arr2 = [ "red", "yellow", "green" ]
arr3 = [ [ 1, 2 ], [3, 4, 5] ]
arr4 = [ "所有（写法的）", '字符串', """都是一样的""", '''类型''']
arr5 = [ [ 1, 2 ], ["a", "b", "c"] ]

arr6 = [ 1, 2.0 ] # 非法
```

数组也可以跨多行。  
数组的最后一个值后面可以有终逗号（也称为尾逗号）。  
值和结束括号前可以存在任意数量的换行和注释。

```toml
arr7 = [
  1, 2, 3
]

arr8 = [
  1,
  2, # 这是可以的
]
```

[表](#user-content-table)<a id="user-content-table">&nbsp;</a>
----

表（也被称为哈希表或字典）是键值对的集合。  
它们在方括号里，并作为单独的行出现。  
看得出它们不同于数组，因为数组只有值。

```toml
[table]
```

在它下方，直至下一个表或文件结束，都是这个表的键值对。  
表不保证保持键值对的指定顺序。

```toml
[table-1]
key1 = "some string"
key2 = 123

[table-2]
key1 = "another string"
key2 = 456
```

表名的规则与键名相同（见前文键名定义）。

```toml
[dog."tater.man"]
type.name = "pug"
```

等价于 JSON 的如下结构：

```json
{ "dog": { "tater.man": { "type": { "name": "pug" } } } }
```

键名周围的空格会被忽略，然而最佳实践还是不要有任何多余的空白。

```toml
[a.b.c]            # 这是最佳实践
[ d.e.f ]          # 等同于 [d.e.f]
[ g .  h  . i ]    # 等同于 [g.h.i]
[ j . "ʞ" . 'l' ]  # 等同于 [j."ʞ".'l']
```

你不必层层完整地写出你不想写的所有途径的父表。  
TOML 知道该怎么办。

```toml
# [x] 你
# [x.y] 不
# [x.y.z] 需要这些
[x.y.z.w] # 来让这生效
```

空表是允许的，只要里面没有键值对就行了。

类似于键名，你不能重复定义任何表。  
这样做是非法的。

```
# 不要这样做

[a]
b = 1

[a]
c = 2
```

```
# 也不要这样做

[a]
b = 1

[a.b]
c = 2
```

[行内表](#user-content-inline-table)<a id="user-content-inline-table">&nbsp;</a>
--------

行内表提供了一种更为紧凑的语法来表示表。  
对于否则就很啰嗦的成组数据，这尤其有用。  
行内表由花括号 `{` 和 `}` 包裹。  
在括号中，可以出现零个或更多逗号分隔的键值对。  
键值对采取与标准表中的键值对相同的形式。  
什么类型的值都可以，包括行内表。

行内表得出现在同一行内。  
不允许花括号中出现换行，除非它们存在于正确的值当中。  
即便如此，也强烈不建议把一个行内表搞成纵跨多行的样子。  
如果你发现自己真的需要，那意味着你应该使用标准表。

```toml
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }
animal = { type.name = "pug" }
```

上述行内表等同于下面的标准表定义：

```toml
[name]
first = "Tom"
last = "Preston-Werner"

[point]
x = 1
y = 2

[animal]
type.name = "pug"

```

[表数组](#user-content-array-of-tables)<a id="user-content-array-of-tables">&nbsp;</a>
--------

最后还剩下一个没法表示的是表数组。  
这可以通过双方括号来表示。  
各个具有相同方括号名的表将会成为该数组内的一员。  
这些表的出现顺序就是它们的插入顺序。  
一个没有任何键值对的双方括号表将为视为一个空表。

```toml
[[products]]
name = "Hammer"
sku = 738594937

[[products]]

[[products]]
name = "Nail"
sku = 284758393
color = "gray"
```

等价于 JSON 的如下结构。

```json
{
  "products": [
    { "name": "Hammer", "sku": 738594937 },
    { },
    { "name": "Nail", "sku": 284758393, "color": "gray" }
  ]
}
```

你还可以创建一个嵌套表数组。  
只要在子表上使用相同的双方括号语法语法。  
每个双方括号子表将隶属于上方最近定义的表元素。

```toml
[[fruit]]
  name = "apple"

  [fruit.physical]
    color = "red"
    shape = "round"

  [[fruit.variety]]
    name = "red delicious"

  [[fruit.variety]]
    name = "granny smith"

[[fruit]]
  name = "banana"

  [[fruit.variety]]
    name = "plantain"
```

上述 TOML 等价于 JSON 的如下结构。

```json
{
  "fruit": [
    {
      "name": "apple",
      "physical": {
        "color": "red",
        "shape": "round"
      },
      "variety": [
        { "name": "red delicious" },
        { "name": "granny smith" }
      ]
    },
    {
      "name": "banana",
      "variety": [
        { "name": "plantain" }
      ]
    }
  ]
}
```

若试图向一个静态定义的数组追加内容，即便数组尚且为空或类型兼容，也必须在解析时报错。

```toml
# 无效的 TOML 文档
fruit = []

[[fruit]] # 不允许
```

若试图用已经确定为数组的名称定义表，必须在解析时报错。

```
# 无效的 TOML 文档
[[fruit]]
  name = "apple"

  [[fruit.variety]]
    name = "red delicious"

  # 这个表与之前的表冲突了
  [fruit.variety]
    name = "granny smith"
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

[与其它格式的比较](#user-content-comparison-with-other-formats)<a id="user-content-comparison-with-other-formats">&nbsp;</a>
------------------

某种程度上讲 TOML 与 JSON 非常相似：简单，规格明确，并且宜于转化成普适的数据类型。  
JSON 适合序列化由计算机程序读写的数据。  
TOML 与 JSON 的不同之处是它的重点在于宜于人类读写。  
注释就是一个好例子：当数据在程序之间传送时，它们有些多余，但是在手工编辑的配置文件中非常有帮助。

YAML 格式就像 TOML 一样，是以配置文件为导向的。  
然而……因为种种原因，YAML 是一种过于复杂的解决方案。  
TOML 旨在简易，这个目标在 YAML 的规范当中不那么明显：http://www.yaml.org/spec/1.2/spec.html

INI 格式也常见于配置文件。  
然而……这个格式并无统一标准，并且通常不料理超过一或两层的嵌套。

[参与](#user-content-get-involved)<a id="user-content-get-involved">&nbsp;</a>
------

欢迎帮助文档、问题反馈、修缮合并，以及其它一切形式的贡献！

[Wiki](#user-content-wiki)<a id="user-content-wiki">&nbsp;</a>
------

我们有一个[官方 TOML Wiki](https://github.com/toml-lang/toml/wiki) 收录了以下内容：

* 使用了 TOML 的项目
* 可用实现清单
* 验证程序
* TOML 解码器和编码器的语言无关测试套件
* 编辑器支持
* 编码器
* 格式转换器

请点进去看一下，如果你想要阅览或加入其中。  
感谢你成为 TOML 社区的一员！
