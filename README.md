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

TOML aims to be unambiguous and as simple as possible. There should only
be one way to do anything. TOML maps to a simple hash table. TOML is
case-sensitive. TOML files are encoded using UTF8.

Definitions
-----------

Whitespace only means tab (0x09) or space (0x20). 
New lines are delimited by CR (0x0A), LF (0x0D), or CRLF.

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

Strings come in two forms, Quoted and Unquoted, but always UTF8.

Quoted strings are surrounded by double quotes. Quotes and other special
characters must be escaped.

```toml
"I'm a string. \"You can quote me\". Tab \t newline \n you get it."
```

Here is the list of special characters. No other escape codes are recognized, and will cause an error.

```
\0 - null character  (0x00)
\t - tab             (0x09)
\n - newline         (0x0a)
\r - carriage return (0x0d)
\" - quote           (0x22)
\\ - backslash       (0x5c)
```

Unquoted strings are like the above, but can only include some alphanumeric characters. 
No whitespace, No Control Codes, No dots (.) in them, or []'s. They're pretty much the 
identifers you know and love in your language of choice. They must start with a letter, 
and can contain/start with underscores.

``toml
i_am_an_unquoted_string
isnt_this_neat
``

The lowercase names "true" and "false" are special, they aren't strings, they are booleans.

```toml
true
false
```

Integers are bare numbers, all alone. Feeling negative? Do what's natural.
64-bit minimum size expected.

```toml
42
-17
```

Floats are like integers except they have a single dot within. There must be at
least one number on each side of the decimal point. 64-bit (double) precision
expected. Don't expect floating point to be accurate, converting from decimal
into binary is implementation defined. 

```toml
3.1415
-0.01
```


Datetimes are RFC3339 (ISO8601) dates, but only the full zulu form is allowed. No timezones, No offsets. 
Yes fractional seconds.

```toml
1979-05-27T07:32:00Z
1979-05-27T07:32:00.123Z
```

Arrays are square brackets with other primitives inside. Whitespace is ignored.
Elements are separated by commas. No, you can't mix data types, that's stupid.

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]
[ [ 1, 2 ], ["a", "b", "c"] ] # this is ok
[ a, b, c ]
```

Arrays can also be multiline. So in addition to ignoring whitespace, arrays also
ignore newlines between the brackets.

```toml
key = [
  1, 2, 3
]
```

That's it. That's all you need, and you're gonna like it.

Hash me
-------

There are two ways to make keys. I call them "key groups" and "keys". Both are
just regular keys, but key groups only ever have a single hash as their value.

Key groups appear in square brackets on a line by themselves. You can tell them
apart from arrays because arrays are only ever values. The name of a keygroup
can be a quoted or unquoted string:

```toml
[keygroup]
```
is the same as:

```toml
["keygroup"]
```

Under that, and until the next key or EOF are the key/values of that key group.
Keys are a quoted or unquoted string, followed by an equals sign, then a value.

```toml
[keygroup]
key = "value"
"key2" = "another value"
```

You can indent keys and their values as much as you like. Tabs or spaces. Knock
yourself out. Why, you ask? Because you can have nested hashes. Snap.

Nested hashes are denoted seperating strings by dots. Both quoted and unquoted strings
can be used.

```toml
[key.tater]
type = "pug"
```
In JSON land, that would give you the following structure.

```json
{ "key": { "tater": { "type": "pug" } } }
```
You can also use quoted strings, if you're feeling special.

```toml
["key"."tater"]
"type" = "pug"
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

License
-------

MIT.


Implementations
--------

- node.js - https://github.com/aaronblohowiak/toml
- Ruby (@jm) - https://github.com/jm/toml (toml gem)
- Ruby (@dirk) - https://github.com/dirk/toml-ruby (toml-ruby gem)
- Python - https://github.com/uiri/toml
