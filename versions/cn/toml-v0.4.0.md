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

Integers are whole numbers. Positive numbers may be prefixed with a plus sign.
Negative numbers are prefixed with a minus sign.

```toml
+99
42
0
-17
```

For large numbers, you may use underscores to enhance readability. Each
underscore must be surrounded by at least one digit.

```toml
1_000
5_349_221
1_2_3_4_5     # valid but inadvisable
```

Leading zeros are not allowed. Hex, octal, and binary forms are not allowed.
Values such as "infinity" and "not a number" that cannot be expressed as a
series of digits are not allowed.

64 bit (signed long) range expected (−9,223,372,036,854,775,808 to
9,223,372,036,854,775,807).

Float
-----

A float consists of an integer part (which may be prefixed with a plus or minus
sign) followed by a fractional part and/or an exponent part. If both a
fractional part and exponent part are present, the fractional part must precede
the exponent part.

```toml
# fractional
+1.0
3.1415
-0.01

# exponent
5e+22
1e6
-2E-2

# both
6.626e-34
```

A fractional part is a decimal point followed by one or more digits.

An exponent part is an E (upper or lower case) followed by an integer part
(which may be prefixed with a plus or minus sign).

Similar to integers, you may use underscores to enhance readability. Each
underscore must be surrounded by at least one digit.

```toml
9_224_617.445_991_228_313
1e1_000
```

64-bit (double) precision expected.

Boolean
-------

Booleans are just the tokens you're used to. Always lowercase.

```toml
true
false
```

Datetime
--------

Datetimes are [RFC 3339](http://tools.ietf.org/html/rfc3339) dates.

```toml
1979-05-27T07:32:00Z
1979-05-27T00:32:00-07:00
1979-05-27T00:32:00.999999-07:00
```

Array
-----

Arrays are square brackets with other primitives inside. Whitespace is ignored.
Elements are separated by commas. Data types may not be mixed (though all string
types should be considered the same type).

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]
[ "all", 'strings', """are the same""", '''type'''] # this is ok
[ [ 1, 2 ], ["a", "b", "c"] ] # this is ok
[ 1, 2.0 ] # note: this is NOT ok
```

Arrays can also be multiline. So in addition to ignoring whitespace, arrays also
ignore newlines between the brackets. Terminating commas are ok before the
closing bracket.

```toml
key = [
  1, 2, 3
]

key = [
  1,
  2, # this is ok
]
```

Table
-----

Tables (also known as hash tables or dictionaries) are collections of key/value
pairs. They appear in square brackets on a line by themselves. You can tell them
apart from arrays because arrays are only ever values.

```toml
[table]
```

Under that, and until the next table or EOF are the key/values of that table.
Keys are on the left of the equals sign and values are on the right. Whitespace
is ignored around key names and values. The key, equals sign, and value must
be on the same line (though some values can be broken over multiple lines).

Keys may be either bare or quoted. **Bare keys** may only contain letters,
numbers, underscores, and dashes (`A-Za-z0-9_-`). **Quoted keys** follow the
exact same rules as basic strings and allow you to use a much broader set of key
names. Best practice is to use bare keys except when absolutely necessary.

Key/value pairs within tables are not guaranteed to be in any specific order.

```toml
[table]
key = "value"
bare_key = "value"
bare-key = "value"

"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
```

Dots are prohibited in bare keys because dots are used to signify nested tables!
Naming rules for each dot separated part are the same as for keys (see above).

```toml
[dog."tater.man"]
type = "pug"
```

In JSON land, that would give you the following structure:

```json
{ "dog": { "tater.man": { "type": "pug" } } }
```

Whitespace around dot-separated parts is ignored, however, best practice is to
not use any extraneous whitespace.

```toml
[a.b.c]          # this is best practice
[ d.e.f ]        # same as [d.e.f]
[ g .  h  . i ]  # same as [g.h.i]
[ j . "ʞ" . l ]  # same as [j."ʞ".l]
```

You don't need to specify all the super-tables if you don't want to. TOML knows
how to do it for you.

```toml
# [x] you
# [x.y] don't
# [x.y.z] need these
[x.y.z.w] # for this to work
```

Empty tables are allowed and simply have no key/value pairs within them.

As long as a super-table hasn't been directly defined and hasn't defined a
specific key, you may still write to it.

```toml
[a.b]
c = 1

[a]
d = 2
```

You cannot define any key or table more than once. Doing so is invalid.

```toml
# DO NOT DO THIS

[a]
b = 1

[a]
c = 2
```

```toml
# DO NOT DO THIS EITHER

[a]
b = 1

[a.b]
c = 2
```

All table names and keys must be non-empty.

```toml
# NOT VALID TOML
[]
[a.]
[a..b]
[.b]
[.]
 = "no key name" # not allowed
```

Inline Table
------------

Inline tables provide a more compact syntax for expressing tables. They are
especially useful for grouped data that can otherwise quickly become verbose.
Inline tables are enclosed in curly braces `{` and `}`. Within the braces, zero
or more comma separated key/value pairs may appear. Key/value pairs take the
same form as key/value pairs in standard tables. All value types are allowed,
including inline tables.

Inline tables are intended to appear on a single line. No newlines are allowed
between the curly braces unless they are valid within a value. Even so, it is
strongly discouraged to break an inline table onto multiples lines. If you find
yourself gripped with this desire, it means you should be using standard tables.

```toml
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }
```

The inline tables above are identical to the following standard table
definitions:

```toml
[name]
first = "Tom"
last = "Preston-Werner"

[point]
x = 1
y = 2
```

Array of Tables
---------------

The last type that has not yet been expressed is an array of tables. These can
be expressed by using a table name in double brackets. Each table with the same
double bracketed name will be an element in the array. The tables are inserted
in the order encountered. A double bracketed table without any key/value pairs
will be considered an empty table.

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

In JSON land, that would give you the following structure.

```json
{
  "products": [
    { "name": "Hammer", "sku": 738594937 },
    { },
    { "name": "Nail", "sku": 284758393, "color": "gray" }
  ]
}
```

You can create nested arrays of tables as well. Just use the same double bracket
syntax on sub-tables. Each double-bracketed sub-table will belong to the most
recently defined table element above it.

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

The above TOML maps to the following JSON.

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

Attempting to define a normal table with the same name as an already established
array must produce an error at parse time.

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

You may also use inline tables where appropriate:

```toml
points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]
```

Seriously?
----------

Yep.

But why?
--------

Because we need a decent human-readable format that unambiguously maps to a hash
table and the YAML spec is like 80 pages long and gives me rage. No, JSON
doesn't count. You know why.

Oh god, you're right
--------------------

Yuuuup. Wanna help? Send a pull request. Or write a parser. BE BRAVE.

Projects using TOML
-------------------

- [Cargo](http://doc.crates.io/) - The Rust language's package manager.
- [InfluxDB](http://influxdb.com/) - Distributed time series database.
- [Heka](https://hekad.readthedocs.org) - Stream processing system by Mozilla.
- [Hugo](http://gohugo.io/) - Static site generator in Go.

Implementations
---------------

If you have an implementation, send a pull request adding to this list. Please
note the commit SHA1 or version tag that your parser supports in your Readme.

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

Validators
----------

- Go (@BurntSushi) - https://github.com/BurntSushi/toml/tree/master/cmd/tomlv

Language agnostic test suite for TOML decoders and encoders
-----------------------------------------------------------

- toml-test (@BurntSushi) - https://github.com/BurntSushi/toml-test

Editor support
--------------

- Atom - https://github.com/atom/language-toml
- Emacs (@dryman) - https://github.com/dryman/toml-mode.el
- Notepad++ (@fireforge) - https://github.com/fireforge/toml-notepadplusplus
- Sublime Text 2 & 3 (@Gakai) - https://github.com/Gakai/sublime_toml_highlighting
- Synwrite - http://uvviewsoft.com/synwrite/download.html ; call Options/ Addons manager/ Install
- TextMate (@infininight) - https://github.com/textmate/toml.tmbundle
- Vim (@cespare) - https://github.com/cespare/vim-toml

Encoder
--------------

- Dart (@just95) - https://github.com/just95/toml.dart
- Go w/ Reflection (@BurntSushi) - https://github.com/BurntSushi/toml
- PHP (@ayushchd) - https://github.com/ayushchd/php-toml-encoder

Converters
----------

- remarshal (@dbohdan) - https://github.com/dbohdan/remarshal
- yaml2toml (@jtyr) - https://github.com/jtyr/yaml2toml-converter
- yaml2toml.dart (@just95) - https://github.com/just95/yaml2toml.dart
