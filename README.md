<img align="right" src="logos/toml-200.png" alt="TOML logo">

# TOML

Tom's Obvious, Minimal Language.

By Tom Preston-Werner, Pradyun Gedam, et al.

> This repository contains the in-development version of the TOML specification.
> You can find the released versions at https://toml.io.

## Objectives

TOML aims to be a minimal configuration file format that's easy to read due to
obvious semantics. TOML is designed to map unambiguously to a hash table. TOML
should be easy to parse into data structures in a wide variety of languages.

## Example

```toml
# This is a TOML document.

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00 # First class dates

[database]
server = "192.168.1.1"
ports = [ 8000, 8001, 8002 ]
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

## Comparison with Other Formats

TOML shares traits with other file formats used for application configuration
and data serialization, such as YAML and JSON. TOML and JSON both are simple and
use ubiquitous data types, making them easy to code for or parse with machines.
TOML and YAML both emphasize human readability features, like comments that make
it easier to understand the purpose of a given line. TOML differs in combining
these, allowing comments (unlike JSON) but preserving simplicity (unlike YAML).

Because TOML is explicitly intended as a configuration file format, parsing it
is easy, but it is not intended for serializing arbitrary data structures. TOML
always has a hash table at the top level of the file, which can easily have data
nested inside its keys, but it doesn't permit top-level arrays or floats, so it
cannot directly serialize some data. There is also no standard identifying the
start or end of a TOML file, which can complicate sending it through a stream.
These details must be negotiated on the application layer.

INI files are frequently compared to TOML for their similarities in syntax and
use as configuration files. However, there is no standardized format for INI and
they do not gracefully handle more than one or two levels of nesting.

Further reading:

- YAML spec: https://yaml.org/spec/1.2/spec.html
- JSON spec: https://tools.ietf.org/html/rfc8259
- Wikipedia on INI files: https://en.wikipedia.org/wiki/INI_file

## Get Involved

Documentation, bug reports, pull requests, and all other contributions are
welcome!

## Wiki

We have an [Official TOML Wiki](https://github.com/toml-lang/toml/wiki) that
catalogs the following:

- Projects using TOML
- Implementations
- Validators
- Language-agnostic test suite for TOML decoders and encoders
- Editor support
- Encoders
- Converters

Please take a look if you'd like to view or add to that list. Thanks for being a
part of the TOML community!
