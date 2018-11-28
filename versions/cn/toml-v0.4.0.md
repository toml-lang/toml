TOML v0.4.0
===========

全称: Tom的（语义）明显、（配置）最小化的语言。
(Tom's Obvious, Minimal Language. By Tom Preston-Werner.)

注: 此规范仍然会发生很多变化。在未标记为1.0之前，你应该假设它是不稳定的，请酌情采用。

目标
----------

TOML的目标是成为一个有明显语义而容易去阅读的最小化配置文件格式。
TOML被设计成可以无歧义地被映射为哈希表，从而很容易的被解析成各种语言中的数据结构。

示例
-------

```toml
# 这是TOML文档示例.

title = "TOML Example"

[owner]
name = "Lance Uppercut"
dob = 1979-05-27T07:32:00-08:00 # 时间日期当然是一等公民了。

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # 你可以按你的意愿缩进。TOML并不关心你是用Tab还是空格。
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"

[clients]
data = [ ["gamma", "delta"], [1, 2] ]

# 数组里可以换行
hosts = [
  "alpha",
  "omega"
]
```

规格
----

* TOML是大小写敏感的。
* TOML文件必须只包含UTF-8编码的Unicode字符。
* 空格是指制表符(0x09) 或空格 (0x20)。
* 换行符是指LF(0x0A)或CRLF (0x0D0A).

注释
-------

用符号#来表示注释：

```toml
# I am a comment. Hear me roar. Roar.
key = "value" # Yeah, you can do this.
```

字符串
------
有四种方法来表示字符串：基本字符串、多行基本字符串、字面量和多行字面量。所有的字符串必须只包含有效的UTF-8字符。

**基本字符串** 是由引号括起来的任意字符串，除了那些必须要转义的，比如：双引号、反斜杠和控制字符(U+0000到U+001F)。

```toml
"I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
```

常用的转义序列：

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

任意Unicode字符都可能被转义为`\uXXXX` 或 `\UXXXXXXXX`的形式。这些转义代码必须是有效的Unicode[标量值](http://unicode.org/glossary/#unicode_scalar_value)。

所有未出现在上面名单中的转义序列必须保留，如果使用，TOML应该会产生错误。

有时你需要表达一段文本（比如，翻译文件），或者是将很长的字符串分成多行。TOML很容易处理这种情况。
**多行基本字符串** 是被三引号括起来的字符串，并且允许换行。紧跟起始界定符后面的换行符会被剪掉，而其他的所有空格和换行字符仍然被保留。

```toml
key1 = """
Roses are red
Violets are blue"""
```

TOML解析器应该能正常处理不同平台下的换行符。

```toml
# 对于Unix系统，上面的多行字符串应该是这样的:
key2 = "Roses are red\nViolets are blue"

# 对于Windows系统，最可能等价于这样的:
key3 = "Roses are red\r\nViolets are blue"
```

在行尾使用`\`，可以避免在写长字符串的时候引入多余的空格。
`\`将会删除当前位置到下个非空字符或结束界定符之间的所有空格（包括换行符）。
如果在起始界定符之后的第一个字符是反斜杠和一个换行符，那么从此位置到下个非空白字符或结束界定符之间的所有空格和换行符都会被剪掉。
所有的转义序列对基本字符串都有效，也对多行基本字符串有效。

```toml
# 以下每个字符串都是相同的
key1 = "The quick brown fox jumps over the lazy dog."

key2 = """
The quick brown \


  fox jumps over \
    the lazy dog."""

key3 = """\
       The quick brown \
       fox jumps over \
       the lazy dog.\
       """
```

任何Unicode字符都可能被用到，除了那些可能需要转义的字符：反斜杠和控制字符(U+0000 到 U+001F)。
引号不需要转义，除非它们的存在可能会造成提前关闭界定符。

如果你需要频繁的指定Windows的路径或正则表达式，那么不得不添加转义符就会变的繁琐和容易出错。
TOML支持完全不允许转义的字面量字符串来帮助你解决此类问题。
**字面量字符串** 是被单引号包含的字符串，跟基本字符串一样，它们一定是以单行出现:

```toml
# 所见即所得.
winpath  = 'C:\Users\nodejs\templates'
winpath2 = '\\ServerX\admin$\system32\'
quoted   = 'Tom "Dubs" Preston-Werner'
regex    = '<\i\c*\s*>'
```

因为没有转义，所以在一个被单引号封闭的字面量字符串里面没有办法写单引号。
幸运的是，TOML支持多行版本的字面量字符串来解决这个问题。
**多行字面量字符串** 是被三个单引号括起来的字符串，并且允许换行。
跟字面量字符串一样，这也没有任何转义。
紧跟起始界定符的换行符会被剪掉。界定符之间的所有其他内容都会被按照原样解释而无需修改。

```toml
regex2 = '''I [dw]on't need \d{2} apples'''
lines  = '''
The first newline is
trimmed in raw strings.
   All other whitespace
   is preserved.
'''
```

对于二进制数据，建议你使用Base64或其他适合的编码，比如ASCII或UTF-8编码。具体的处理取决于特定的应用。

整数
-------

整数就是没有小数点的数字。正数前面也可以用加号，负数需要用负号前缀表示。

```toml
+99
42
0
-17
```

对于大整数，你可以用下划线提高可读性。每个下划线两边至少包含一个数字。

```toml
1_000
5_349_221
1_2_3_4_5     # 有效，但不建议这样写
```

前导零是不允许的。也不允许十六进制（Hex）、八进制（octal）和二进制形式。
诸如“无穷”和“非数字”这样的不能用一串数字表示的值都不被允许。

预期的范围是64位 (signed long)(−9,223,372,036,854,775,808 到
9,223,372,036,854,775,807).

浮点数
-----

一个浮点数由整数部分（可能是带有加号或减号前缀的）和小数部分和（或）指数部分组成的数。
如果只有小数部分和指数部分，那么小数部分必须放在指数部分前面。

```toml
# 小数
+1.0
3.1415
-0.01

# 指数
5e+22
1e6
-2E-2

# 小数和指数同时存在
6.626e-34
```

小数部分是指在小数点后面的一个或多个数字。

指数部分是指E（大写或小写）后面的整数部分（可能用加号或减号为前缀）

和整数类似，你可以用下划线来提高可读性。每个下划线两边至少包含一个数字。


```toml
9_224_617.445_991_228_313
1e1_000
```

预期精度为64位 (double)。

布尔值
-------

布尔值是小写的true和false。

```toml
true
false
```

时间日期
--------

时间日期是[RFC 3339](http://tools.ietf.org/html/rfc3339)中的时间格式。

```toml
1979-05-27T07:32:00Z
1979-05-27T00:32:00-07:00
1979-05-27T00:32:00.999999-07:00
```

数组
-----

数组是由方括号包括的基本单元。空格会被忽略。
数组中的元素由逗号分隔。数据类型不能混用（所有的字符串均为同一类型）。

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]
[ "all", 'strings', """are the same""", '''type'''] # 这样可以
[ [ 1, 2 ], ["a", "b", "c"] ] # 这样可以
[ 1, 2.0 ] # 注: 这样不行
```

数组也可以多行。所以，除了忽略空格之外，数组也忽略了括号之间的换行符。
在结束括号之前存在逗号是可以的。

```toml
key = [
  1, 2, 3
]

key = [
  1,
  2, # 这样可以
]
```

表
-----

表（也被称为哈希表或字典）是键值对集合。表格名由方括号包裹，自成一行。
注意和数组相区分，数组里只有值。

```toml
[table]
```

在表名之下，直到下一个表或文件尾（EOF）之间都是该表的键值对。
键是等号符左边的值，值是等号符右边的值。
键名和值周围的空格都将被忽略。
键、等号和值，一定要在同一行（有些值可以多行表示）

键可以是裸的或由引号包括的。**裸键** 可能仅包含字母、数字、下划线和破折号。
**引号键** 遵循基本字符串的规则，允许你使用更广泛的键名。
除非有绝对的必要，否则最好是用裸键。

表中的键值对是无序的。

```toml
[table]
key = "value"
bare_key = "value"
bare-key = "value"

"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
```

点（.）严禁在裸键中使用，因为它被用来表示嵌套表！
命名规则为被点分隔的部分应该属于同一个键。（见上文）。

```toml
[dog."tater.man"]
type = "pug"
```

等价于如下JSON格式：

```json
{ "dog": { "tater.man": { "type": "pug" } } }
```

被点分隔部分周围的空格都会被忽略，但是最好不要使用任何多余的空格。

```toml
[a.b.c]          # this is best practice
[ d.e.f ]        # same as [d.e.f]
[ g .  h  . i ]  # same as [g.h.i]
[ j . "ʞ" . l ]  # same as [j."ʞ".l]
```

如果你不想，你可以完全不去指定父表（super-tables）。TOML知道该如何处理。

```toml
# [x] 你
# [x.y] 不
# [x.y.z] 需要这些
[x.y.z.w] # 去处理这种情况
```

空表是允许的，其中没有键值对。

只要父表没有被直接定义，而且没有定义特定的键，你可以继续写入。

```toml
[a.b]
c = 1

[a]
d = 2
```

你不能多次定义键或表。这样做是无效的。

```toml
# 不要这么做

[a]
b = 1

[a]
c = 2
```

```toml
# 也不要这样做

[a]
b = 1

[a.b]
c = 2
```

所有的表名和键一定不能为空。
All table names and keys must be non-empty.

```toml
# 无效TOML
[]
[a.]
[a..b]
[.b]
[.]
 = "no key name" # 不允许
```

内联表
------------

内联表提供一种更紧凑的语法来表示表。它们可以把数据分组，避免这些数据很快变得冗长。
内联表是由大括号`{` 和 `}`括起来的。在大括号内可以存在零个或多个逗号分隔的键值对。
内联表里的键值对跟标准表里的键值对形式是一样的。允许所有的值类型，包括内联表。

内联表一般以单行出现。不允许换行符出现在大括号之间，除非是包含在值中的有效字符。
即便如此，也强烈建议不要在把内联表分成多行。如果你有这种需求，那么你应该去用标准表。

```toml
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }
```

上面的内联表完全等同于下面的标准表定义：

```toml
[name]
first = "Tom"
last = "Preston-Werner"

[point]
x = 1
y = 2
```

表数组
---------------

最后要介绍的类型是表数组。表数组可以通过包括在双括号内表格名来表达。
使用相同双括号名的每个表都是数组中的元素。表的顺序跟书写顺序一致。
没有键值对的双括号表会被当作空表。

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

等价于如下JSON格式：

```json
{
  "products": [
    { "name": "Hammer", "sku": 738594937 },
    { },
    { "name": "Nail", "sku": 284758393, "color": "gray" }
  ]
}
```

你也能创建内嵌的表数组。只需要对子表使用相同的双括号语法就可以。每个双括号子表将属于其上面最近定义的那个表。

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

上面的TOML对应于下面的JSON格式：

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

试图用已经定义的数组的名称来定义的正常表，在解析的时候一定会抛出错误。

```toml
# INVALID TOML DOC
[[fruit]]
  name = "apple"

  [[fruit.variety]]
    name = "red delicious"

  # This table conflicts with the previous table
  [fruit.variety]
    name = "granny smith"
```

你也可以在适合的地方使用内联表。

```toml
points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]
```

这份规范是认真的吗？
----------

当然。

但是为什么我要用它呢？
--------

因为我们需要一个像样的人类可读的格式，同时能无歧义地映射到哈希表。
而且YAML的规范有80页那么长，真是令人发指！
不，不考虑JSON 。你知道为什么。

天哪，你说的好有道理
--------------------

哈哈！想帮忙么？发pull request过来。或者编写一个解析器。你可以勇敢一点。

使用TOML的项目
-------------------

- [Cargo](http://doc.crates.io/) - Rust语言的包管理器。
- [InfluxDB](http://influxdb.com/) - 分布式时间序列数据库。
- [Heka](https://hekad.readthedocs.org) - Mozilla的流处理系统。
- [Hugo](http://gohugo.io/) - Go的静态站点生成器。

实现
---------------

如果你有一个实现，请发一个合并请求，把你的实现加入到这个列表中。
请在你实现的解析器README中标记你的解析器支持的提交SHA1或版本号。

- C#/.NET - https://github.com/LBreedlove/Toml.net
- C#/.NET - https://github.com/rossipedia/toml-net
- C#/.NET - https://github.com/RichardVasquez/TomlDotNet
- C#/.NET - https://github.com/azyobuzin/HyperTomlProcessor
- C (@ajwans) - https://github.com/ajwans/libtoml
- C (@mzgoddard) - https://github.com/mzgoddard/tomlc
- C++ (@evilncrazy) - https://github.com/evilncrazy/ctoml
- C++ (@skystrife) - https://github.com/skystrife/cpptoml
- C++ (@mayah) - https://github.com/mayah/tinytoml
- Clojure (@lantiga) - https://github.com/lantiga/clj-toml
- Clojure (@manicolosi) - https://github.com/manicolosi/clojoml
- CoffeeScript (@biilmann) - https://github.com/biilmann/coffee-toml
- Common Lisp (@pnathan) - https://github.com/pnathan/pp-toml
- D - https://github.com/iccodegr/toml.d
- Dart (@just95) - https://github.com/just95/toml.dart
- Erlang - https://github.com/kalta/etoml.git
- Erlang - https://github.com/kaos/tomle
- Emacs Lisp (@gongoZ) - https://github.com/gongo/emacs-toml
- Go (@thompelletier) - https://github.com/pelletier/go-toml
- Go (@laurent22) - https://github.com/laurent22/toml-go
- Go w/ Reflection (@BurntSushi) - https://github.com/BurntSushi/toml
- Go (@achun) - https://github.com/achun/tom-toml
- Go (@naoina) - https://github.com/naoina/toml
- Haskell (@seliopou) - https://github.com/seliopou/toml
- Haxe (@raincole) - https://github.com/raincole/haxetoml
- Java (@agrison) - https://github.com/agrison/jtoml
- Java (@johnlcox) - https://github.com/johnlcox/toml4j
- Java (@mwanji) - https://github.com/mwanji/toml4j
- Java - https://github.com/asafh/jtoml
- Java w/ ANTLR (@MatthiasSchuetz) - https://github.com/mschuetz/toml
- Julia (@pygy) - https://github.com/pygy/TOML.jl
- Literate CoffeeScript (@JonathanAbrams) - https://github.com/JonAbrams/tomljs
- Nim (@ziotom78) - https://github.com/ziotom78/parsetoml
- node.js/browser - https://github.com/ricardobeat/toml.js (npm install tomljs)
- node.js - https://github.com/BinaryMuse/toml-node
- node.js/browser (@redhotvengeance) - https://github.com/redhotvengeance/topl (topl npm package)
- node.js/browser (@alexanderbeletsky) - https://github.com/alexanderbeletsky/toml-js (npm browser amd)
- Objective C (@mneorr) - https://github.com/mneorr/toml-objc.git
- Objective-C (@SteveStreza) - https://github.com/amazingsyco/TOML
- OCaml (@mackwic) https://github.com/mackwic/to.ml
- Perl (@alexkalderimis) - https://github.com/alexkalderimis/config-toml.pl
- Perl - https://github.com/dlc/toml
- PHP (@leonelquinteros) - https://github.com/leonelquinteros/php-toml.git
- PHP (@jimbomoss) - https://github.com/jamesmoss/toml
- PHP (@coop182) - https://github.com/coop182/toml-php
- PHP (@checkdomain) - https://github.com/checkdomain/toml
- PHP (@zidizei) - https://github.com/zidizei/toml-php
- PHP (@yosymfony) - https://github.com/yosymfony/toml
- Python (@f03lipe) - https://github.com/f03lipe/toml-python
- Python (@uiri) - https://github.com/uiri/toml
- Python - https://github.com/bryant/pytoml
- Python (@elssar) - https://github.com/elssar/tomlgun
- Python (@marksteve) - https://github.com/marksteve/toml-ply
- Python (@hit9) - https://github.com/hit9/toml.py
- Racket (@greghendershott) - https://github.com/greghendershott/toml
- Ruby (@jm) - https://github.com/jm/toml (toml gem)
- Ruby (@eMancu) - https://github.com/eMancu/toml-rb (toml-rb gem)
- Ruby (@charliesome) - https://github.com/charliesome/toml2 (toml2 gem)
- Ruby (@sandeepravi) - https://github.com/sandeepravi/tomlp (tomlp gem)
- Rust (@mneumann) - https://github.com/mneumann/rust-toml
- Rust (@alexcrichton) - https://github.com/alexcrichton/toml-rs
- Scala - https://github.com/axelarge/tomelette

校验
----------

- Go (@BurntSushi) - https://github.com/BurntSushi/toml/tree/master/cmd/tomlv

TOML解码器和编码器测试套件（语言无关）
-----------------------------------------------------------

- toml-test (@BurntSushi) - https://github.com/BurntSushi/toml-test

支持的编辑器
--------------

- Atom - https://github.com/atom/language-toml
- Emacs (@dryman) - https://github.com/dryman/toml-mode.el
- Notepad++ (@fireforge) - https://github.com/fireforge/toml-notepadplusplus
- Sublime Text 2 & 3 (@Gakai) - https://github.com/Gakai/sublime_toml_highlighting
- Synwrite - http://uvviewsoft.com/synwrite/download.html ; call Options/ Addons manager/ Install
- TextMate (@infininight) - https://github.com/textmate/toml.tmbundle
- Vim (@cespare) - https://github.com/cespare/vim-toml

编码器
--------------

- Dart (@just95) - https://github.com/just95/toml.dart
- Go w/ Reflection (@BurntSushi) - https://github.com/BurntSushi/toml
- PHP (@ayushchd) - https://github.com/ayushchd/php-toml-encoder

转换器
----------

- remarshal (@dbohdan) - https://github.com/dbohdan/remarshal
- yaml2toml (@jtyr) - https://github.com/jtyr/yaml2toml-converter
- yaml2toml.dart (@just95) - https://github.com/just95/yaml2toml.dart
