TOML
====

Tom's Obvious, Minimal Language.

By Tom Preston-Werner.

TOML is like INI, only better.

If it's not working for you, you're not drinking enough whisky.

Be warned, this spec is still changing a lot. Until it's marked as 1.0, you
should assume that it is unstable and act accordingly.

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
data = [ ["gamma", "delta"], [1, 2] ] # just an update to make sure parsers support it
```

Spec
----

TOML is designed to be unambiguous and as simple as possible. There should only
be one way to do anything. TOML maps to a simple hash table. TOML is
case-sensitive.

Definitions
-----------

Whitespace means tab (0x09) or space (0x20).

Comments
--------

Speak your mind with the hash symbol. They go from the symbol to the end of the
line.

```toml
# I am a comment. Hear me roar. Roar.
key = "value" # Yeah, you can do this.
```

Primitives
----------

String, Integer, Float, Boolean, Datetime, Array.

Strings are UTF8 surrounded by double quotes. Quotes and other special
characters must be escaped.

```toml
"I'm a string. \"You can quote me\". Tab \t newline \n you get it."
```

Here is the list of special characters.

```
\0 - null character  (0x00)
\t - tab             (0x09)
\n - newline         (0x0a)
\r - carriage return (0x0d)
\" - quote           (0x22)
\\ - backslash       (0x5c)
```

Integers are bare numbers, all alone. Feeling negative? Do what's natural.
64-bit minimum size expected.

```toml
42
-17
```

Floats are like integers except they have a single dot within. There must be at
least one number on each side of the decimal point. 64-bit (double) precision
expected.

```toml
3.1415
-0.01
```

Booleans are just the tokens you're used to. Always lowercase.

```toml
true
false
```

Datetimes are ISO8601 dates, but only the full zulu form is allowed.

```toml
1979-05-27T07:32:00Z
```

Arrays are square brackets with other primitives inside. Whitespace is ignored.
Elements are separated by commas. No, you can't mix data types, that's stupid.

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]
[ [ 1, 2 ], ["a", "b", "c"] ] # this is ok
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

That's it. That's all you need, and you're gonna like it.

Hash me
-------

There are two ways to make keys. I call them "key groups" and "keys". Both are
just regular keys, but key groups only ever have a single hash as their value.

Key groups appear in square brackets on a line by themselves. You can tell them
apart from arrays because arrays are only ever values.

```toml
[keygroup]
```

Under that, and until the next key or EOF are the key/values of that key group.
keys are on the left of the equals sign and values are on the right. Keys start
with the first non-whitespace character and end with the last non-whitespace
character before the equals sign.

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
--------

If you have an implementation, send a pull request adding to this list. Please
note the commit SHA1 or version tag that your parser supports in your Readme.

- node.js - https://github.com/aaronblohowiak/toml
- node.js/browser - https://github.com/ricardobeat/toml
- node.js - https://github.com/BinaryMuse/toml-node
- Ruby (@jm) - https://github.com/jm/toml (toml gem)
- Ruby (@dirk) - https://github.com/dirk/toml-ruby (toml-ruby gem)
- Ruby (@eMancu) - https://github.com/eMancu/toml_parser-ruby (toml_parser-ruby gem)
- Ruby (@charliesome) - https://github.com/charliesome/toml2 (toml2 gem)
- Python (@f03lipe) - https://github.com/f03lipe/toml-python
- Python (@uiri) - https://github.com/uiri/toml
- C#/.NET - https://github.com/rossipedia/toml-net
- Objective C - https://github.com/mneorr/toml-objc.git
- PHP (@leonelquinteros) - https://github.com/leonelquinteros/php-toml.git
- PHP (@jimbomoss) - https://github.com/jamesmoss/toml
- PHP (@coop182) - https://github.com/coop182/toml-php
- Java (@agrison) - https://github.com/agrison/jtoml
- Clojure (@lantiga) - https://github.com/lantiga/clj-toml
- Go (@thompelletier) - https://github.com/pelletier/go-toml
