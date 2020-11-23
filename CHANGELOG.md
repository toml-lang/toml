# TOML Changelog

## unreleased

* Clarify and describe the top-level table.
* Clarify that indentation before keys is ignored.
* Clarify that indentation before table headers is ignored.
* Clarify that indentation between array values is ignored.

## 1.0.0-rc.3 / 2020-10-07

* Clarify that comments and newlines are allowed before commas in arrays.
* Mark the ABNF as canonical, and reference it from the text specification.

## 1.0.0-rc.2 / 2020-08-09

* Create https://toml.io as the new primary location to read the TOML spec.
* Clarify meaning of "quotation marks".
* Clarify meaning of "expected" value ranges.
* Clarify that EOF is allowed after key/value pair.
* Clarify that the various styles for writing keys are equivalent.
* Clarify that line-ending backslashes must be unescaped in multi-line strings.
* Add examples for invalid float values.

## 1.0.0-rc.1 / 2020-04-01

* Clarify in ABNF how quotes in multi-line basic and multi-line literal strings
  are allowed to be used.
* Leading zeroes in exponent parts of floats are permitted.
* Clarify that control characters are not permitted in comments.
* Clarify behavior of tables defined implicitly by dotted keys.
* Clarify that inline tables are immutable.
* Clarify that trailing commas are not allowed in inline tables.
* Clarify in ABNF that UTF-16 surrogate code points (U+D800 - U+DFFF) are not
  allowed in strings or comments.
* Allow raw tab characters in basic strings and multi-line basic strings.
* Allow heterogenous values in arrays.

## 0.5.0 / 2018-07-11

* Add dotted keys.
* Add hex, octal, and binary integer formats.
* Add special float values (inf, nan).
* Rename Datetime to Offset Date-Time.
* Add Local Date-Time.
* Add Local Date.
* Add Local Time.
* Add ABNF specification.
* Allow space (instead of T) to separate date and time in Date-Time.
* Allow accidental whitespace between backslash and newline in the line
  continuation operator in multi-line basic strings.
* Specify that the standard file extension is `.toml`.
* Specify that MIME type is `application/toml`
* Clarify that U+007F is an escape character.
* Clarify that keys are always strings.
* Clarify that you cannot use array-of-table to append to a static array.
* Clarify that a TOML file must be a valid UTF-8 document.
* Clarify valid Array values.
* Clarify that literal strings can be table keys.
* Clarify that at least millisecond precision expected for Date-Time and Time.
* Clarify that comments are OK in multiline arrays.
* Clarify that +0, -0, +0.0, and -0.0 are valid and what they mean.
* TOML has a logo!

## 0.4.0 / 2015-02-12

* Add Inline Table syntax.
* Allow underscores in numbers.
* Remove forward slash as an escapable character.
* Unicode escapes must be scalar values.
* Newline is now defined as LF or CRLF.

## 0.3.1 / 2014-11-11

* Fix incorrect datetime examples.

## 0.3.0 / 2014-11-10

* Add scientific notation for floats.
* Allow optional + prefix on integers.
* Switch to RFC 3339 for datetimes (allowing offsets and fractional seconds).
* Add multiline and literal strings.
* Clarify what characters valid keys can contain.

## 0.2.0 / 2013-09-24

* Use "table" instead of "key group" terminology.
* Add the ability to define nestable arrays of tables.

## 0.1.0 / 2013-03-17

* From Twitter rage to reality; TOML is now a thing.
* First proper release.
* TOML adheres to the SemVer standard for version numbers.
