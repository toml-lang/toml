EBNF
====

```
toml = { (keygroup | keyvalue), [comment], newline, { [comment], newline} };
keygroup = "[", identifier, "]";
keyvalue = identifier, [whitespace], "=", [whitespace], primitive;
primitive = integer | float | string | boolean | datetime | array;
array = "[", [whitespace], {newline}, [ (integer, [",", {whitespace, integer, ",", [whitespace], { [comment], newline} ] } )
    | (float, [",", {whitespace, float, ",", [whitespace], { [comment], newline} ] } )
    | (string, [",", {whitespace, string, ",", [whitespace], { [comment], newline} ] } )
    | (boolean, [",", {whitespace, boolean, ",", [whitespace], { [comment], newline} ] } )
    | (datetime, [",", {whitespace, datetime, ",", [whitespace], { [comment], newline} ] } )
    | (array, [",", {whitespace, array, ",", [whitespace], { [comment], newline} ] } ) ],
    "]";
identifier = "[0-9A-Za-z_]+";
integer = "[\+\-](([1-9][0-9]*)|(0))";
decimal_number = ("[\+\-](([1-9][0-9]*)|(0))\.[0-9]*";
float = decimal_number | (decimal_number, "e", decimal_number) | "[\+\-]infinity" | "[\+\-]INF" | "NAN" | "nan";
string = "\"(([^\"])|(\\[nrt0\\\"]))\"";
boolean = "true" | "false";
datetime = "\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d[\.\d](((+|-)\d\d:\d\d)|(Z))"; (* RFC3339 *)
```
