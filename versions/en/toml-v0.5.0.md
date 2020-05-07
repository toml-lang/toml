![TOML Logo](../../logos/toml-200.png)

TOML v0.5.0
===========

Tom's Obvious, Minimal Language.

By Tom Preston-Werner.

As of version 0.5.0, TOML should be considered extremely stable. The goal is for
version 1.0.0 to be backwards compatible (as much as humanly possible) with
version 0.5.0. All implementations are strongly encouraged to become 0.5.0
compatible so that the transition to 1.0.0 will be simple when that happens.

Objectives
----------

TOML aims to be a minimal configuration file format that's easy to read due to
obvious semantics. TOML is designed to map unambiguously to a hash table. TOML
should be easy to parse into data structures in a wide variety of languages.

Table of contents
-------

- [Example](#user-content-example)
- [Spec](#user-content-spec)
- [Comment](#user-content-comment)
- [Key/Value Pair](#user-content-keyvalue-pair)
- [Keys](#user-content-keys)
- [String](#user-content-string)
- [Integer](#user-content-integer)
- [Float](#user-content-float)
- [Boolean](#user-content-boolean)
- [Offset Date-Time](#user-content-offset-date-time)
- [Local Date-Time](#user-content-local-date-time)
- [Local Date](#user-content-local-date)
- [Local Time](#user-content-local-time)
- [Array](#user-content-array)
- [Table](#user-content-table)
- [Inline Table](#user-content-inline-table)
- [Array of Tables](#user-content-array-of-tables)
- [Filename Extension](#user-content-filename-extension)
- [MIME Type](#user-content-mime-type)
- [Comparison with Other Formats](#user-content-comparison-with-other-formats)
- [Get Involved](#user-content-get-involved)
- [Wiki](#user-content-wiki)

Example
-------

```toml
# This is a TOML document.

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00 # First class dates

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # Indentation (tabs and/or spaces) is allowed but not required
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
* A TOML file must be a valid UTF-8 encoded Unicode document.
* Whitespace means tab (0x09) or space (0x20).
* Newline means LF (0x0A) or CRLF (0x0D0A).

Comment
-------

A hash symbol marks the rest of the line as a comment.

```toml
# This is a full-line comment
key = "value" # This is a comment at the end of a line
```

Key/Value Pair
--------------

The primary building block of a TOML document is the key/value pair.

Keys are on the left of the equals sign and values are on the right. Whitespace
is ignored around key names and values. The key, equals sign, and value must be
on the same line (though some values can be broken over multiple lines).

```toml
key = "value"
```

Values must be of the following types: String, Integer, Float, Boolean,
Datetime, Array, or Inline Table. Unspecified values are invalid.

```toml
key = # INVALID
```

Keys
----

A key may be either bare, quoted or dotted.

**Bare keys** may only contain ASCII letters, ASCII digits, underscores, and
dashes (`A-Za-z0-9_-`). Note that bare keys are allowed to be composed of only
ASCII digits, e.g. `1234`, but are always interpreted as strings.

```toml
key = "value"
bare_key = "value"
bare-key = "value"
1234 = "value"
```

**Quoted keys** follow the exact same rules as either basic strings or literal
strings and allow you to use a much broader set of key names. Best practice is
to use bare keys except when absolutely necessary.

```toml
"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
'key2' = "value"
'quoted "value"' = "value"
```

A bare key must be non-empty, but an empty quoted key is allowed (though
discouraged).

```toml
= "no key name"  # INVALID
"" = "blank"     # VALID but discouraged
'' = 'blank'     # VALID but discouraged
```

**Dotted keys** are a sequence of bare or quoted keys joined with a dot. This
allows for grouping similar properties together:

```toml
name = "Orange"
physical.color = "orange"
physical.shape = "round"
site."google.com" = true
```

In JSON land, that would give you the following structure:

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

Whitespace around dot-separated parts is ignored, however, best practice is to
not use any extraneous whitespace.

Defining a key multiple times is invalid.

```
# DO NOT DO THIS
name = "Tom"
name = "Pradyun"
```

As long as a key hasn't been directly defined, you may still write to it and
to names within it.

```
a.b.c = 1
a.d = 2
```

```
# THIS IS INVALID
a.b = 1
a.b.c = 2
```

String
------

There are four ways to express strings: basic, multi-line basic, literal, and
multi-line literal. All strings must contain only valid UTF-8 characters.

**Basic strings** are surrounded by quotation marks. Any Unicode character may
be used except those that must be escaped: quotation mark, backslash, and the
control characters (U+0000 to U+001F, U+007F).

```toml
str = "I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
```

For convenience, some popular characters have a compact escape sequence.

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

Any Unicode character may be escaped with the `\uXXXX` or `\UXXXXXXXX` forms.
The escape codes must be valid Unicode [scalar values](http://unicode.org/glossary/#unicode_scalar_value).

All other escape sequences not listed above are reserved and, if used, TOML
should produce an error.

Sometimes you need to express passages of text (e.g. translation files) or would
like to break up a very long string into multiple lines. TOML makes this easy.

**Multi-line basic strings** are surrounded by three quotation marks on each
side and allow newlines. A newline immediately following the opening delimiter
will be trimmed. All other whitespace and newline characters remain intact.

```toml
str1 = """
Roses are red
Violets are blue"""
```

TOML parsers should feel free to normalize newline to whatever makes sense for
their platform.

```toml
# On a Unix system, the above multi-line string will most likely be the same as:
str2 = "Roses are red\nViolets are blue"

# On a Windows system, it will most likely be equivalent to:
str3 = "Roses are red\r\nViolets are blue"
```

For writing long strings without introducing extraneous whitespace, use a "line
ending backslash". When the last non-whitespace character on a line is a `\`, it
will be trimmed along with all whitespace (including newlines) up to the next
non-whitespace character or closing delimiter. All of the escape sequences that
are valid for basic strings are also valid for multi-line basic strings.

```toml
# The following strings are byte-for-byte equivalent:
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

Any Unicode character may be used except those that must be escaped: backslash
and the control characters (U+0000 to U+001F, U+007F). Quotation marks need not
be escaped unless their presence would create a premature closing delimiter.

If you're a frequent specifier of Windows paths or regular expressions, then
having to escape backslashes quickly becomes tedious and error prone. To help,
TOML supports literal strings which do not allow escaping at all.

**Literal strings** are surrounded by single quotes. Like basic strings, they
must appear on a single line:

```toml
# What you see is what you get.
winpath  = 'C:\Users\nodejs\templates'
winpath2 = '\\ServerX\admin$\system32\'
quoted   = 'Tom "Dubs" Preston-Werner'
regex    = '<\i\c*\s*>'
```

Since there is no escaping, there is no way to write a single quote inside a
literal string enclosed by single quotes. Luckily, TOML supports a multi-line
version of literal strings that solves this problem.

**Multi-line literal strings** are surrounded by three single quotes on each
side and allow newlines. Like literal strings, there is no escaping whatsoever.
A newline immediately following the opening delimiter will be trimmed. All
other content between the delimiters is interpreted as-is without modification.

```toml
regex2 = '''I [dw]on't need \d{2} apples'''
lines  = '''
The first newline is
trimmed in raw strings.
   All other whitespace
   is preserved.
'''
```

Control characters other than tab are not permitted in a literal string. Thus,
for binary data it is recommended that you use Base64 or another suitable ASCII
or UTF-8 encoding. The handling of that encoding will be application specific.

Integer
-------

Integers are whole numbers. Positive numbers may be prefixed with a plus sign.
Negative numbers are prefixed with a minus sign.

```toml
int1 = +99
int2 = 42
int3 = 0
int4 = -17
```

For large numbers, you may use underscores between digits to enhance
readability. Each underscore must be surrounded by at least one digit on each
side.

```toml
int5 = 1_000
int6 = 5_349_221
int7 = 1_2_3_4_5     # VALID but discouraged
```

Leading zeros are not allowed. Integer values `-0` and `+0` are valid and
identical to an unprefixed zero.

Non-negative integer values may also be expressed in hexadecimal, octal, or
binary. In these formats, leading zeros are allowed (after the prefix). Hex
values are case insensitive. Underscores are allowed between digits (but not
between the prefix and the value).

```toml
# hexadecimal with prefix `0x`
hex1 = 0xDEADBEEF
hex2 = 0xdeadbeef
hex3 = 0xdead_beef

# octal with prefix `0o`
oct1 = 0o01234567
oct2 = 0o755 # useful for Unix file permissions

# binary with prefix `0b`
bin1 = 0b11010110
```

64 bit (signed long) range expected (−9,223,372,036,854,775,808 to
9,223,372,036,854,775,807).

Float
-----

Floats should be implemented as IEEE 754 binary64 values.

A float consists of an integer part (which follows the same rules as integer
values) followed by a fractional part and/or an exponent part. If both a
fractional part and exponent part are present, the fractional part must precede
the exponent part.

```toml
# fractional
flt1 = +1.0
flt2 = 3.1415
flt3 = -0.01

# exponent
flt4 = 5e+22
flt5 = 1e6
flt6 = -2E-2

# both
flt7 = 6.626e-34
```

A fractional part is a decimal point followed by one or more digits.

An exponent part is an E (upper or lower case) followed by an integer part
(which follows the same rules as integer values).

Similar to integers, you may use underscores to enhance readability. Each
underscore must be surrounded by at least one digit.

```toml
flt8 = 9_224_617.445_991_228_313
```

Float values `-0.0` and `+0.0` are valid and should map according to IEEE 754.

Special float values can also be expressed. They are always lowercase.

```toml
# infinity
sf1 = inf  # positive infinity
sf2 = +inf # positive infinity
sf3 = -inf # negative infinity

# not a number
sf4 = nan  # actual sNaN/qNaN encoding is implementation specific
sf5 = +nan # same as `nan`
sf6 = -nan # valid, actual encoding is implementation specific
```

Boolean
-------

Booleans are just the tokens you're used to. Always lowercase.

```toml
bool1 = true
bool2 = false
```

Offset Date-Time
---------------

To unambiguously represent a specific instant in time, you may use an
[RFC 3339](http://tools.ietf.org/html/rfc3339) formatted date-time with offset.

```toml
odt1 = 1979-05-27T07:32:00Z
odt2 = 1979-05-27T00:32:00-07:00
odt3 = 1979-05-27T00:32:00.999999-07:00
```

For the sake of readability, you may replace the T delimiter between date and
time with a space (as permitted by RFC 3339 section 5.6).

```toml
odt4 = 1979-05-27 07:32:00Z
```

The precision of fractional seconds is implementation specific, but at least
millisecond precision is expected. If the value contains greater precision than
the implementation can support, the additional precision must be truncated, not
rounded.

Local Date-Time
--------------

If you omit the offset from an [RFC 3339](http://tools.ietf.org/html/rfc3339)
formatted date-time, it will represent the given date-time without any relation
to an offset or timezone. It cannot be converted to an instant in time without
additional information. Conversion to an instant, if required, is implementation
specific.

```toml
ldt1 = 1979-05-27T07:32:00
ldt2 = 1979-05-27T00:32:00.999999
```

The precision of fractional seconds is implementation specific, but at least
millisecond precision is expected. If the value contains greater precision than
the implementation can support, the additional precision must be truncated, not
rounded.

Local Date
----------

If you include only the date portion of an
[RFC 3339](http://tools.ietf.org/html/rfc3339) formatted date-time, it will
represent that entire day without any relation to an offset or timezone.

```toml
ld1 = 1979-05-27
```

Local Time
----------

If you include only the time portion of an [RFC
3339](http://tools.ietf.org/html/rfc3339) formatted date-time, it will represent
that time of day without any relation to a specific day or any offset or
timezone.

```toml
lt1 = 07:32:00
lt2 = 00:32:00.999999
```

The precision of fractional seconds is implementation specific, but at least
millisecond precision is expected. If the value contains greater precision than
the implementation can support, the additional precision must be truncated, not
rounded.

Array
-----

Arrays are square brackets with values inside. Whitespace is ignored. Elements
are separated by commas. Data types may not be mixed (different ways to define
strings should be considered the same type, and so should arrays with different
element types).

```toml
arr1 = [ 1, 2, 3 ]
arr2 = [ "red", "yellow", "green" ]
arr3 = [ [ 1, 2 ], [3, 4, 5] ]
arr4 = [ "all", 'strings', """are the same""", '''type''']
arr5 = [ [ 1, 2 ], ["a", "b", "c"] ]

arr6 = [ 1, 2.0 ] # INVALID
```

Arrays can also be multiline. Terminating commas (also called trailing commas)
are ok after the last value of the array. There can be an arbitrary number of
newlines and comments before a value and before the closing bracket.

```toml
arr7 = [
  1, 2, 3
]

arr8 = [
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
Key/value pairs within tables are not guaranteed to be in any specific order.

```toml
[table-1]
key1 = "some string"
key2 = 123

[table-2]
key1 = "another string"
key2 = 456
```

Naming rules for tables are the same as for keys (see definition of Keys above).

```toml
[dog."tater.man"]
type.name = "pug"
```

In JSON land, that would give you the following structure:

```json
{ "dog": { "tater.man": { "type": { "name": "pug" } } } }
```

Whitespace around the key is ignored, however, best practice is to not use any
extraneous whitespace.

```toml
[a.b.c]            # this is best practice
[ d.e.f ]          # same as [d.e.f]
[ g .  h  . i ]    # same as [g.h.i]
[ j . "ʞ" . 'l' ]  # same as [j."ʞ".'l']
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

Like keys, you cannot define any table more than once. Doing so is invalid.

```
# DO NOT DO THIS

[a]
b = 1

[a]
c = 2
```

```
# DO NOT DO THIS EITHER

[a]
b = 1

[a.b]
c = 2
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
animal = { type.name = "pug" }
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

[animal]
type.name = "pug"

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

Attempting to append to a statically defined array, even if that array is empty
or of compatible type, must produce an error at parse time.

```toml
# INVALID TOML DOC
fruit = []

[[fruit]] # Not allowed
```

Attempting to define a normal table with the same name as an already established
array must produce an error at parse time.

```
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

Filename Extension
------------------

TOML files should use the extension `.toml`.

MIME Type
---------

When transferring TOML files over the internet, the appropriate MIME type is
`application/toml`.

Comparison with Other Formats
-----------------------------

In some ways TOML is very similar to JSON: simple, well-specified, and
maps easily to ubiquitous data types. JSON is great for serializing
data that will mostly be read and written by computer programs. Where
TOML differs from JSON is its emphasis on being easy for humans to
read and write. Comments are a good example: they serve no purpose
when data is being sent from one program to another, but are very
helpful in a configuration file that may be edited by hand.

The YAML format is oriented towards configuration files just like
TOML. For many purposes, however, YAML is an overly complex
solution. TOML aims for simplicity, a goal which is not apparent in
the YAML specification: http://www.yaml.org/spec/1.2/spec.html

The INI format is also frequently used for configuration files. The
format is not standardized, however, and usually does not handle more
than one or two levels of nesting.

Get Involved
------------

Documentation, bug reports, pull requests, and all other contributions
are welcome!

Wiki
----------------------------------------------------------------------

We have an [Official TOML Wiki](https://github.com/toml-lang/toml/wiki) that
catalogs the following:

* Projects using TOML
* Implementations
* Validators
* Language agnostic test suite for TOML decoders and encoders
* Editor support
* Encoders
* Converters

Please take a look if you'd like to view or add to that list. Thanks for being
a part of the TOML community!
