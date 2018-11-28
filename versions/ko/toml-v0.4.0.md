TOML v0.4.0
===========

Tom's 분명하고 자그마한 언어.

By Tom Preston-Werner.

주의! 이 스팩 문서는 자주 바뀔수 있습니다. 1.0이 되기전까진 불안정하다고 하고 그에따라 확인하시기 바랍니다.

Objectives
----------

TOML은 최소한의 구성파일 형식을 이용하여 명확한 의미를 읽기 쉽게하는데에 목표로 하고 있습니다. TOML은 해쉬 테이블에 분명하게 맵핑되도록 설계되었습니다. TOML은 다양한 언어의 데이터 구조로 구문 분석에 쉽게 사용할 수 있어야합니다.

예시
-------

```toml
# TOML 문서! Boom.

title = "TOML Example"

[owner]
name = "Lance Uppercut"
dob = 1979-05-27T07:32:00-08:00 # 일등 날짜 형식? 왜 안됨?

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # 인던트 추가 가능. 탭이나 스페이스 모두 가능. TOML은 상관안함.
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"

[clients]
data = [ ["gamma", "delta"], [1, 2] ]

# 배열 내부에서는 줄바꿈 OK.
hosts = [
  "alpha",
  "omega"
]
```

스펙
------

* TOML은 사례에 민감하다.
* TOML 파일은 UTF-8 인코딩된 유니코드 문자열로만 되어있습니다.
* 빈칸(Whitespace)는 탭 (0x09)나 스페이스 (0x20)을 뜻합니다.
* 줄바꿈(Newline)은 LF (0x0A)나 CRLF (0x0D0A)를 나타냅니다.

주석
-------

해시 기호를 이용하여 작성합니다. 심볼에서부터 라인 끝까지 적용됩니다.

```toml
# 코멘트임. Hear me roar. Roar.
key = "value" # 당연히 이렇게도 가능.
```

문자열
--------

네가지 문자열 표기법이 존재함: 기본, 여러줄 기본, 리터럴, 여러줄 리터럴. 모든 문자열은 UTF-8 문자열로만 구성됨.

**기본 문자열 (Basic strings)** 은 큰따옴표로 감쌉니다. 유니코드 문자의 경우 이스케이프 문자를 이용하여 표현할 수 있습니다: 큰따옴표, 백 슬래시, 컨트롤 문자 (U+0000에서 U+001F).

```toml
"I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
```

자주 사용되는 것들은 짧은 이스케이프 단축 문자열이 존재합니다.

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

어떤 유니코드 문자는 `\uXXXX`나 `\UXXXXXXXX` 형식으로 익스케이프 시킬 수 있습니다. 익스케이프 코드는 유요한 유니코드 [scalar 값](http://unicode.org/glossary/#unicode_scalar_value)이여야 합니다.

위에 나열되지 않은 이스케이프 단축 문자열을 사용하게되면 TOML에서는 에러가 발생합니다.

때로는 긴 텍스트 (예를 들어, 번역 파일같은)이나 매우 긴 문자열을 입력해야될 경우가 생깁니다. TOML에서는 쉽게 만들 수 있습니다. **여러줄 기본 문자열(Multi-line basic strings)** 양 끝에 세개의 큰따옴표 존재하며, 줄바꿈이 가능합니다. 새로운 라인은 처음부터 진행됩니다. 모든 공백과 개행 문자는 그대로 유지됩니다.

```toml
key1 = """
Roses are red
Violets are blue"""
```

TOML 파서는 플랫폼따라 개행 문자를 신경쓸 필요 없습니다.

```toml
# Unix 시스템 에서는 줄바꿈은 이렇게 작성:
key2 = "Roses are red\nViolets are blue"

# 윈도우에서는 아래와 같이...:
key3 = "Roses are red\r\nViolets are blue"
```

여분의 공백을 도입하지 않고, 긴 문자열을 작성하기 위해서 `\`를 라인 뒤에 입력합니다. `\`는 새로운 줄을 포함한 빈칸 (whitespace)을 나누지 않고 하나로 구성할 수 있도록 합니다. 시작 점에서 첫 문자가 백 슬래시나 개행이라면 다음 공백이 문자나 마지막 점까지의 모든 공백과 줄바꿈을 함께 나눕니다. 기본 문자열에서 유효한 모든 이스케이프 단축 문자열은 여러줄 문자열에도 유효합니다.

```toml
# 이 세가지 문자열은 동일한 출력을 나타냄:
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

유니코드 문자는 익스케이프를 제외하고 사용할 수 있습니다: 백 슬래시와 제어 문자 (U+0000에서 U+001F). 문자의 끝에 마감 구분 기호로 사용하지 않는 따옴표는 이스케이프 할 필요가 없습니다.

윈도우 위치나 정규 표현식을 자주 사용한다면, 이스케이프 백 슬래시를 자주 사용하여 이로인해 오류가 발생할 수 있습니다. 이것을 지원하기위해 TOML에서는 리터럴 (literal) 문자열을 지원하여 익스케이프가 되지 않도록 할 수 있습니다. **리터럴 문자열 (Literal strings)** 는 작은따옴표를 사용합니다. 기본 문자열과 동일하며 한줄만 사용 가능합니다:

```toml
# 예제는 이렇게...
winpath  = 'C:\Users\nodejs\templates'
winpath2 = '\\ServerX\admin$\system32\'
quoted   = 'Tom "Dubs" Preston-Werner'
regex    = '<\i\c*\s*>'
```

더이상 이스케이프가 없기에 작은따옴표로 둘러싸인 리터럴 문자열안에서는 작은 따옴표를 쓸 수 있는 방법이 없습니다. 다행히(?) TOML에서 이 문제를 해결하기위해 여러줄 버전을 지원합니다. **여러줄 리터럴 문자열**은 양쪽에 3개씩 작은따옴표로 둘러싸며, 줄 바꿈을 허용합니다. 리터럴 문자열과 동일하게 익스케이프를 사용할 수 없습니다. 여는 구분 기호의 바로 뒤에 있는 줄바꿈을 줄여 사용할 수 있습니다. 모든 다른 콘텐츠 사이에 구분자를 넣어 수정하지 않은 그대로 해석이 가능합니다.

```toml
regex2 = '''I [dw]on't need \d{2} apples'''
lines  = '''
The first newline is
trimmed in raw strings.
   All other whitespace
   is preserved.
'''
```

바이너리 데이터의 경우, Base64나 적당한 다른 ASCII나 UTF-8 인코딩을 사용하는 것이 좋습니다. 인코딩 처리는 어플리케이션에따라 달라질껍니다.

정수
-------

정수는 전체 숫자를 나타냅니다. 양수는 `+`를, 음수는 `-`를 붙여 나타냅니다.

```toml
+99
42
0
-17
```

큰의 경우, 가독성을 높이기위해 밑줄을 사용하여 나타낼 수 있습니다. 각 밑줄은 적어도 하나의 숫자로 묶여있어야합니다.

```toml
1_000
5_349_221
1_2_3_4_5     # valid but inadvisable
```

0이 맨앞으로 올 수는 없습니다. 16진수, 8진수, 2진수 형식은 지원 안됩니다. 그리고 "무한대"와 "숫자 아님"과 같은 숫자료 표현할 수 없는 값은 사용할 수 없습니다.

64bit (signed long) 범위는 (−9,223,372,036,854,775,808 에서 9,223,372,036,854,775,807까지) 되는 것같습니다.

Float
-----

Float은 (플러스 또는 마이너스 기호호 시작하는) 소수 부분과 지수 부분, 정수 부분으로 구성됩니다. 소수 부분과 지수 부분이 모두 존재할 경우, 소수 부분이 지수 부분보다 먼저 오게 됩니다.

```toml
# 소수
+1.0
3.1415
-0.01

# 지수
5e+22
1e6
-2E-2

# 둘다
6.626e-34
```

소수 부분은 하나 이상의 숫자 뒤에 소수점으로 나타냅니다.

지수 부분은 정수 부분 다음에 E(대문자나 소문자 모두 사용)를 이용하여 나타냅니다. (물론 마이너스나 플러스로 시작할 수 있습니다.)

정수와 마찬가지로 가독성을 위해서 밑줄을 사용할 수 있습니다. 각 밑줄은 적어도 하나 이상으로 묶여야합니다.

```toml
9_224_617.445_991_228_313
1e1_000
```

64bit (double) 정밀도를 요구합니다.

Boolean
-------

Booleans은 우리가 사용하고 있는 토큰을 말합니다. 항상 소문자로 나타냅니다.

```toml
true
false
```

Datetime
--------

Datetimes은 [RFC 3339](http://tools.ietf.org/html/rfc3339)의 날짜 시간으로 나타냅니다.

```toml
1979-05-27T07:32:00Z
1979-05-27T00:32:00-07:00
1979-05-27T00:32:00.999999-07:00
```

배열
-----

배열은 다른 원시 함수(primitive)와 같이 대괄호을 사용합니다. 공백은 무시됩니다. 요소는 쉼표로 구분됩니다. (모든 문자열 타입이 동일한 타입으로 사용하게 고려해야하지만) 데이터 타입을 섞어서 사용할 수 없습니다.

```toml
[ 1, 2, 3 ]
[ "red", "yellow", "green" ]
[ [ 1, 2 ], [3, 4, 5] ]
[ "all", 'strings', """are the same""", '''type'''] # this is ok
[ [ 1, 2 ], ["a", "b", "c"] ] # this is ok
[ 1, 2.0 ] # note: this is NOT ok
```

배열은 여러줄로 나타낼 수 있습니다. 이때 추가된 공백은 무시되고, 괄호 사이의 줄바꿈은 무시합니다. 괄호를 닫기전에 쉼표로 끝나도 괜찮습니다.

```toml
key = [
  1, 2, 3
]

key = [
  1,
  2, # this is ok
]
```

테이블
---------

테이블(모두가 아는 해쉬 테이블이나 딕셔너리)은 키값 쌍의 모음입니다. 대괄호를 이용하여 구성됩니다. 배열의 경우엔 오직 값으로만 이뤄져있기에 쉽게 구별이 가능합니다.

```toml
[table]
```

다음 테이블이나 EOF가 나올때까지 테이블은 키값으로 이루어져있습니다. 키는 '='문자 왼쪽에 위치하고, 값은 오른쪽에 위치합니다. 키 이름과 값 주변에 있는 공백은 무시됩니다. 키, '=', 값은 모두 같은 행에 있어야합니다. (일부 값이 여러 줄에 걸쳐서 나눠질 수 있습니다만)

키는 쌍다옴표로 감싸거나 그냥 사용될 수도 있습니다. **생짜(Bare) 키**는 문자, 숫자, 밑줄, 대시를 포함합니다.(`A-Za-z0-9_-`) **인용 키**는 기본 문자열과 동일한 규칙을 준수하고, 키 이름을 더 광범위하게 설정하여 사용할 수 있습니다. 가장 좋은 방법은 꼭 필요한 경우를 제외하고선 생짜(Bare)키를 사용하는 것입니다.

테이블에서 키값 쌍은 순서가 보장되지는 않습니다.

```toml
[table]
key = "value"
bare_key = "value"
bare-key = "value"

"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
```

마침표(`.`)는 중첩된 데이블을 나타내는 값이기에 생짜 키에서 절대 사용하면 안됩니다! 각 마침표 생짜 부분의 이름 짖는 규칙은 위의 키와 동일합니다.

```toml
[dog."tater.man"]
type = "pug"
```

JSON에서는 위의 내용이 아랫처럼 표현됩니다:

```json
{ "dog": { "tater.man": { "type": "pug" } } }
```

마침표 주위에 있는 공백들은 무시됩니다만, 가장 좋은 방법은 공백을 사용하지 않는 것입니다.

```toml
[a.b.c]          # this is best practice
[ d.e.f ]        # same as [d.e.f]
[ g .  h  . i ]  # same as [g.h.i]
[ j . "ʞ" . l ]  # same as [j."ʞ".l]
```

상위 태이블(super-table)들을 모두 지정하지 않아도 됩니다. TOML이 하니까요.

```toml
# [x] you
# [x.y] don't
# [x.y.z] need these
[x.y.z.w] # for this to work
```

빈 테이블은 단순히 키값 쌍이 없는 의미하며 사용 가능합니다.


상위 테이블(super-table)을 직접 정의하지 않더라도 사용 가능합니다.

```toml
[a.b]
c = 1

[a]
d = 2
```

하나 이상의 테이블에 동일한 키를 넣을 수 없습니다. 이렇게하면 유효한 구성이 아닙니다.

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

모든 테이블 이름과 키는 비어 있어야합니다.

```toml
# NOT VALID TOML
[]
[a.]
[a..b]
[.b]
[.]
 = "no key name" # not allowed
```

한줄 테이블
--------------

한줄 테이블로 테이블을 표현하기위해 압축해놓은 구문을 제공합니다. 장황한 문구를 빠르게 그룹화된 데이터로 만드는데 있어서 유용하게 사용합니다. 한줄 테이블은 중괄호(`{})`)로 묶습니다. 중괄호안에서 여러 키값 쌍을 나타낼땐 쉼표를 이용합니다. 키값 쌍은 표준 테이블 키값 쌍과 같은 형태를 취합니다. 모든 값 타입은 한줄 테이블에서 사용할 수 있습니다.

한줄 테이블은 한줄에서 모든 것을 표현하기 위한 것입니다. 중괄호 사이에서는 줄바꿈은 허용되지 않습니다. 그럼에도 한줄 테이블에서 여러줄로 나눠야된다면, 기본 테이블을 사용하도록 합니다.

```toml
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }
```

위의 한줄 테이블은 아래의 기본 테이블과 동일합니다.

```toml
[name]
first = "Tom"
last = "Preston-Werner"

[point]
x = 1
y = 2
```

테이블 배열
-----------------

마지막 형식은 테이블 배열입니다. 이것은 이중 대괄호를 이용하며, 테이블 이름을 주어 사용할 수 있습니다. 동일한 이름을가진 이중 대괄호 테이블들은 배열의 요소를 품고 있습니다. 배열로 되어있는 테이블의 경우 순서대로 삽입이 됩니다. 키값이 없는 경우에는 빈 테이블로 간주됩니다.

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

JSON로는 아래와 같이 나옵니다.

```json
{
  "products": [
    { "name": "Hammer", "sku": 738594937 },
    { },
    { "name": "Nail", "sku": 284758393, "color": "gray" }
  ]
}
```

테이블 배열을 중첩해서 사용할 수 있습니다. 동일한 이중 대괄호로 묶어서 하위 테이블(sub-table)로 만듭니다. 각각의 이중 대괄호 하위 테이블은 바로 상위에 정의된 테이블의 요소가 됩니다.


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

JSON에서는 다음과 같이 표현됩니다.

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

이미 생성된 배열과 동일한 이름을 가진 일반 테이블을 만들게되면 구문 분석시 오류가 발생합니다.

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

한줄 테이블을 사용할 수 있습니다:

```toml
points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]
```

진심임?
----------

Yep.

왜?
--------

왜냐면 우리는 해시 테이블에 매핑하여 사람이 쉽게 읽을 수 있는 형식이 필요했고, YAML처럼 80페이지나 되는 스펙 문서에 짜증이 나기때문이다. 그리고 JSON은 안함. 이유는 알꺼라 생각합니다.

음 당신말이 맞아
---------------------

Yuuuup. 도움이 필요해? PR을 날리십시오. 아니면 파서를 만들어주세요. BE BRAVE.

TOML을 사용하는 프로젝트
---------------------------

- [Cargo](http://doc.crates.io/) - Rust 언어 패키지 메니저.
- [InfluxDB](http://influxdb.com/) - 분산 시계열 데이터베이스.
- [Heka](https://hekad.readthedocs.org) - Mozilla 스트림 프로세싱 시스템.
- [Hugo](http://gohugo.io/) - Go 스텍틱 사이즈 생성기.

구현체들
---------------

만든 구현체가 있다면 목록에 추가하여 PR을 보내십시오. 그리고 작성한 리드미파일에서 지원하는 파서의 커밋 SHA1과 버전 태그를 주의하시기 바랍니다.

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

검사기
------------

- Go (@BurntSushi) - https://github.com/BurntSushi/toml/tree/master/cmd/tomlv

TOML 디코더와 인코더에대한 언어 anostic 테스트 suite
-----------------------------------------------------------

- toml-test (@BurntSushi) - https://github.com/BurntSushi/toml-test

에디터 지원
--------------

- Atom - https://github.com/atom/language-toml
- Emacs (@dryman) - https://github.com/dryman/toml-mode.el
- Notepad++ (@fireforge) - https://github.com/fireforge/toml-notepadplusplus
- Sublime Text 2 & 3 (@Gakai) - https://github.com/Gakai/sublime_toml_highlighting
- Synwrite - http://uvviewsoft.com/synwrite/download.html ; call Options/ Addons manager/ Install
- TextMate (@infininight) - https://github.com/textmate/toml.tmbundle
- Vim (@cespare) - https://github.com/cespare/vim-toml

인코더
--------------

- Dart (@just95) - https://github.com/just95/toml.dart
- Go w/ Reflection (@BurntSushi) - https://github.com/BurntSushi/toml
- PHP (@ayushchd) - https://github.com/ayushchd/php-toml-encoder

변환기
----------

- remarshal (@dbohdan) - https://github.com/dbohdan/remarshal
- yaml2toml (@jtyr) - https://github.com/jtyr/yaml2toml-converter
- yaml2toml.dart (@just95) - https://github.com/just95/yaml2toml.dart
