TOLS
====

Tom's Obvious Liuggio Scheme.

By Tom Preston-Werner, Giulio De Donato.

TOLS is like XSD, only more readable and simpler.

There are 3 simple rules to follow:

- A TOLS file is itself a valid TOML file.
- Each element could be validated.
- Explicit validation - if an element has not a validation scheme is valid by default.

Use cases
----------

Given a TOLS file, as developer I want to **validate** an existant TOML file, having the proper **default** values.

Given a TOLS file, as developer I want to easily **create** a TOML file.

Example
-------

```toml
# This is a TOLS document. Boom.
# This is also a TOML document. Boooom. (see rule n.1)

[title]
primitive = "String"   # the title must be a String
required = true        #
    [title.length]
    max = 254       # max string length (exclusive <)

[age]
primitive = "Integer"  # the age must be an Integer
    [age.range]
    min = 17         # age is not required, but if the value is defined, should be minimum 17 (exclusive >)
    max = 100        # age is not required, but if the value is defined, should be maximum 100 (exclusive <)
```

The above **validates** the following two examples

```toml
title = "TOML Example"
age = 34
```

```toml
title = "TOML Example"
```

and also could help to **generates** a toml file (see use case n.2)

```toml
title = ""
# age = 18
```

# Boolean example

```toml
# toml
enabled = true
```

```toml
# tols
[enabled]
primitive = "Boolean"      # Typing the enable value to Boolean
default = true
# required = false         # if omitted the required is false by default
```

# Integer, Float and Datetime example < Boolean

Integer, Float and Datetime share the same schema

```toml
# toml
age = 34
```

```toml
# tols
[age]
primitive = "Integer"       # Typing the value
default = 190               # The default value for the current key
required = false            # by default is false
   [age.range]
   min = 0               # (exclusive <)
   max = 0               # (exclusive >)
```

# String example < Boolean

```toml
# tols

[email]
primitive = "String"            # typing
required = true                 # default is false
# default = "liuggio@gmail.com"  # the default value for the current key
    [email.length]
    max = 254                # max string length (exclusive <)
    min = 5                  # min length (exclusive >)
pattern= "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"   #regular expression
```

# Array

```toml
# toml file
data = [ ["gamma", "delta"], [1, 2] ]
```

Here the scheme validator

```toml
# tols

[data]
primitive = "Array"         # Typing
    [data.length]
    max = 2              # max array length (exclusive <)
    min = 0              # min array length (exclusive >)
    [data.content]
    primitive = "Array" # in toml you can't mix data types, so you could explicit the first nested content
```
Mmmm this is so easy, I want to validate also "gamma" and "delta" how could I do?

```toml
# tols
[data]
    [data.0]                     # this is the first element of data ["gamma", "delta"]
    primitive = "Array"          # is an Array
        [data.0.length]
        max = 2               # max length (exclusive <)
        min = 0               # min length (exclusive >)
        [data.0.content]
        primitive = "String" # the content should be a String
#       pattern = /?/       # regular expr
        [data.0.content.length]
        max = 254     # content takes the String as scheme behaviour

    [data.1]                   # we are validating the [1, 2]
    primitive = "Array"          # should be an array
        [data.1.length]
        max = 2               # max string length (exclusive <)
        min = 0               # min length (exclusive >)
        [data.0.content]
        primitive = "Integer" # content takes the Integer Scheme Behaviour
        [data.0.content.range]
        min = 0
        max = 10
```

# Hash

```toml
# toml

[fruit.type]
apple = "yes"
orange = "no"
```

```toml
# tols
[fruit.type.apple]
primitive = "String"
required = true
    [fruit.type.apple.length]
    max = 3
```

or just put the validation in the apple.type content

```toml
# tols
[fruit.type]
primitive = "Hash"
required = true
    [fruit.type.apple.length]
    max = 3
    [fruit.type.apple.content]
    primitive = "String"
    required = true
        [fruit.type.apple.content.length]
        max = 3
```

All the keywords
-------

TOLS schema has 7 keywords.

- **primitive** could be: ["String", "Integer", "Float", "Boolean", "Datetime", "Array", "Hash"].

- **default** contains the default value for the current field.

- **required** is a Boolean value, by default is false.

- **length** is a hash that contains two values **min** and **max**, only when primitives are [String, Array, Hash].

- **range** is a hash that contains two values **min** and **max**, only when primitives are [Integer, Float, Datetime].

- **pattern** is a String and contains a valid Regular Expression only when primitives is a String.

- **content** is a Hash and describes the behaviour of the first nested element.


TOLS is a valid TOML file, could I validate a TOLS file?
-------

Don't drink too much man.
