TOML
====

Tom's Own Markup Language.

By Tom Preston-Werner.

TOML is like INI, only better. And standardized.

If it's not working for you, you're not drinking enough whisky.

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
ports = [ "8001", "8001", "8002" ]
connection_max = 5000

[servers]

  # You can indent as you please. Tabs or spaces. TOML don't care.
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"
```

Spec
----

TOML is designed to be unambiguous and as simple as possible. There should only
be one way to do anything. TOML maps to a simple hash.

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

String, Integer, Float, Datetime, Array.

Strings are UTF8 surrounded by double quotes. Quotes and other special
characters must be escaped.

```toml
"I'm a string. \"You can quote me\". Tab \t newline \n you get it."
```

Integers are bare numbers, all alone.

```toml
42
```

Floats are like integers except they have a single dot within.

```toml
3.1415
```

Datetimes are ISO8601 dates, but only the full zulu form is allowed.

```toml
1979-05-27T07:32:00Z
```

Arrays are square brackets with other primitives inside. Elements are separated
by commas. No, you can't mix data types, that's stupid.

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]

```

That's it. That's all you need, and you're gonna like it.

Hash me
-------

There are two ways to make keys. I call them "key groups" and "keys". Both are
just regular keys, but key groups only ever have a single has as their value.

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
{ 'key': { 'tater': { 'type': 'pug' } } }
```

You don't need to specify all the superkeys if you don't want to. TOML knows how
to do it for you.

```toml
# [x] you
# [x.y] don't
# [x.y.z] need these
[x.y.z.w] # for this to work
```

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
spec is like 600 pages long and gives me rage. No, JSON doesn't count. You know
why.

Oh god, you're right
--------------------

Yuuuup. Wanna help? Send a pull request. Or write a parser. BE BRAVE.

License
-------

MIT.
