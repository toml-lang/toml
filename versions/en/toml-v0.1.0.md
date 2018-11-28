TOML v0.1.0
===========

Tom's Obvious, Minimal Language.

By Tom Preston-Werner.

Be warned, this spec is still changing a lot. Until it's marked as 1.0, you
should assume that it is unstable and act accordingly.

Objectives
----------

TOML aims to be a minimal configuration file format that's easy to read due to
obvious semantics. TOML is designed to map unambiguously to a hash table. TOML
should be easy to parse into data structures in a wide variety of languages.

Example
-------

```toml
# This is a TOML document. Boom.

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
organization = "GitHub"
bio = "GitHub Cofounder & CEO\nLikes tater tots and beer."
dob = 1979-05-27T07:32:00Z # First class dates? Why not?

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # You can indent as you please. Tabs or spaces. TOML don't care.
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"

[clients]
data = [ ["gamma", "delta"], [1, 2] ]

# Line breaks are OK when inside arrays
hosts = [
  "alpha",
  "omega"
]
```

Spec
----

* TOML is case sensitive.
* Whitespace means tab (0x09) or space (0x20).

Comment
-------

Speak your mind with the hash symbol. They go from the symbol to the end of the
line.

```toml
# I am a comment. Hear me roar. Roar.
key = "value" # Yeah, you can do this.
```

String
------

ProTip™: You may notice that this specification is the same as JSON's string
definition, except that TOML requires UTF-8 encoding. This is on purpose.

Strings are single-line values surrounded by quotation marks. Strings must
contain only valid UTF-8 characters. Any Unicode character may be used except
those that must be escaped: quotation mark, backslash, and the control
characters (U+0000 to U+001F).

```toml
"I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
```

For convenience, some popular characters have a compact escape sequence.

```
\b     - backspace       (U+0008)
\t     - tab             (U+0009)
\n     - linefeed        (U+000A)
\f     - form feed       (U+000C)
\r     - carriage return (U+000D)
\"     - quote           (U+0022)
\/     - slash           (U+002F)
\\     - backslash       (U+005C)
\uXXXX - unicode         (U+XXXX)
```

Any Unicode character may be escaped with the `\uXXXX` form.

Other special characters are reserved and, if used, TOML should produce an
error. This means paths on Windows will always have to use double backslashes.

```toml
wrong = "C:\Users\nodejs\templates" # note: doesn't produce a valid path
right = "C:\\Users\\nodejs\\templates"
```

For binary data it is recommended that you use Base 64 or another suitable
encoding. The handling of that encoding will be application specific.

Integer
-------

Integers are bare numbers, all alone. Feeling negative? Do what's natural.
64-bit minimum size expected.

```toml
42
-17
```

Float
-----

Floats are numbers with a single dot within. There must be at least one number
on each side of the decimal point. 64-bit (double) precision expected.

```toml
3.1415
-0.01
```

Boolean
-------

Booleans are just the tokens you're used to. Always lowercase.

```toml
true
false
```

Datetime
--------

Datetimes are ISO8601 dates, but only the full zulu form is allowed.

```toml
1979-05-27T07:32:00Z
```

Array
-----

Arrays are square brackets with other primitives inside. Whitespace is ignored.
Elements are separated by commas. No, you can't mix data types, that's stupid.

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]
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

Hash
----

There are two ways to make keys. I call them "key groups" and "keys". Both are
just regular keys, but key groups only ever have a single hash as their value.

Key groups appear in square brackets on a line by themselves. You can tell them
apart from arrays because arrays are only ever values.

```toml
[keygroup]
```

Under that, and until the next key or EOF are the key/values of that key group.
Keys are on the left of the equals sign and values are on the right. Keys start
with the first non-whitespace character and end with the last non-whitespace
character before the equals sign. Key/value pairs within key groups are
unordered.

```toml
[keygroup]
key = "value"
```

You can indent keys and their values as much as you like. Tabs or spaces. Knock
yourself out. Why, you ask? Because you can have nested hashes. Snap.

Nested hashes are denoted by key groups with dots in them. Name your key groups
whatever crap you please, just don't use a dot. Dot is reserved. OBEY.

```toml
[key.tater]
type = "pug"
```

In JSON land, that would give you the following structure.

```json
{ "key": { "tater": { "type": "pug" } } }
```

You don't need to specify all the superkeys if you don't want to. TOML knows how
to do it for you.

```toml
# [x] you
# [x.y] don't
# [x.y.z] need these
[x.y.z.w] # for this to work
```

When converted to a hash table, an empty key group should result in the key's
value being an empty hash table.

Be careful not to overwrite previous keys. That's dumb. And should produce an
error.

```toml
# DO NOT WANT
[fruit]
type = "apple"

[fruit.type]
apple = "yes"
```

Seriously?
----------

Yep.

But why?
--------

Because we need a decent human readable format that maps to a hash and the YAML
spec is like 80 pages long and gives me rage. No, JSON doesn't count. You know
why.

Oh god, you're right
--------------------

Yuuuup. Wanna help? Send a pull request. Or write a parser. BE BRAVE.

Implementations
---------------

If you have an implementation, send a pull request adding to this list. Please
note the commit SHA1 or version tag that your parser supports in your Readme.

- C#/.NET - https://github.com/LBreedlove/Toml.net
- C#/.NET - https://github.com/rossipedia/toml-net
- C#/.NET - https://github.com/RichardVasquez/TomlDotNet
- C (@ajwans) - https://github.com/ajwans/libtoml
- C++ (@evilncrazy) - https://github.com/evilncrazy/ctoml
- Clojure (@lantiga) - https://github.com/lantiga/clj-toml
- Clojure (@manicolosi) - https://github.com/manicolosi/clojoml
- CoffeeScript (@biilmann) - https://github.com/biilmann/coffee-toml
- Erlang - https://github.com/kalta/etoml.git
- Erlang - https://github.com/kaos/tomle
- Go (@thompelletier) - https://github.com/pelletier/go-toml
- Go (@laurent22) - https://github.com/laurent22/toml-go
- Go w/ Reflection (@BurntSushi) - https://github.com/BurntSushi/toml
- Haskell (@seliopou) - https://github.com/seliopou/toml
- Haxe (@raincole) https://github.com/raincole/haxetoml
- Java (@agrison) - https://github.com/agrison/jtoml
- Java (@johnlcox) - https://github.com/johnlcox/toml4j
- Java (@mwanji) - https://github.com/mwanji/toml4j
- Java - https://github.com/asafh/jtoml
- Java w/ ANTLR (@MatthiasSchuetz) - https://github.com/mschuetz/toml
- Julia (@pygy) - https://github.com/pygy/TOML.jl
- Literate CoffeeScript (@JonathanAbrams) - https://github.com/JonAbrams/tomljs
- node.js - https://github.com/aaronblohowiak/toml
- node.js/browser - https://github.com/ricardobeat/toml.js (npm install tomljs)
- node.js - https://github.com/BinaryMuse/toml-node
- node.js (@redhotvengeance) - https://github.com/redhotvengeance/topl (topl npm package)
- node.js/browser (@alexanderbeletsky) - https://github.com/alexanderbeletsky/toml-js (npm browser amd)
- Objective C (@mneorr) - https://github.com/mneorr/toml-objc.git
- Objective-C (@SteveStreza) - https://github.com/amazingsyco/TOML
- Ocaml (@mackwic) https://github.com/mackwic/to.ml
- Perl (@alexkalderimis) - https://github.com/alexkalderimis/config-toml.pl
- Perl - https://github.com/dlc/toml
- PHP (@leonelquinteros) - https://github.com/leonelquinteros/php-toml.git
- PHP (@jimbomoss) - https://github.com/jamesmoss/toml
- PHP (@coop182) - https://github.com/coop182/toml-php
- PHP (@checkdomain) - https://github.com/checkdomain/toml
- PHP (@zidizei) - https://github.com/zidizei/toml-php
- Python (@socketubs) - https://github.com/socketubs/pytoml
- Python (@f03lipe) - https://github.com/f03lipe/toml-python
- Python (@uiri) - https://github.com/uiri/toml
- Python - https://github.com/bryant/pytoml
- Python (@elssar) - https://github.com/elssar/tomlgun
- Python (@marksteve) - https://github.com/marksteve/toml-ply
- Ruby (@jm) - https://github.com/jm/toml (toml gem)
- Ruby (@eMancu) - https://github.com/eMancu/toml-rb (toml-rb gem)
- Ruby (@charliesome) - https://github.com/charliesome/toml2 (toml2 gem)
- Ruby (@sandeepravi) - https://github.com/sandeepravi/tomlp (tomlp gem)
- Scala - https://github.com/axelarge/tomelette

Validators
----------

- Go (@BurntSushi) - https://github.com/BurntSushi/toml/tree/master/tomlv

Language agnostic test suite for TOML parsers
---------------------------------------------

- toml-test (@BurntSushi) - https://github.com/BurntSushi/toml-test

Editor support
--------------

- Emacs (@dryman) - https://github.com/dryman/toml-mode.el
- Sublime Text 2 (@lmno) - https://github.com/lmno/TOML
- TextMate (@infininight) - https://github.com/textmate/toml.tmbundle
- Vim (@cespare) - https://github.com/cespare/vim-toml

Encoder
--------------
- PHP (@ayushchd) - https://github.com/ayushchd/php-toml-encoder
