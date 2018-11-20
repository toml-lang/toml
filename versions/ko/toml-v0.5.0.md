![TOML Logo](../../logos/toml-200.png)

TOML v0.5.0
===========

Tom's 분명하고 자그마한 언어.

By Tom Preston-Werner.

TOML은 버전 0.5.0부터 매우 안정적인 버전으로 간주합니다. 목표는 버전 1.0.0을 버전 0.5.0과 역호환성(가능한 한 사용자가 확인할 수 있을 정도로)을 가지게 하는 것입니다. 모든 구현은 0.5.0과 호환되도록 강력히 권장되며, 1.0.0으로 간편하게 업그레이드를 진행할 수 있도록 할 것입니다.

Objectives
----------

TOML은 명확한 의미를 갖으며, 읽기 쉬운 최소한의 구성 파일 형식을 목표로 삼고 있습니다. TOML은 해시 테이블에 분명하게 대응되도록 설계되어있습니다. TOML은 다양한 언어로 된 데이터 구조를 쉽게 구문분석할 수 있어야 합니다.

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
- [Comparison with Other Formats](#user-content-comparison-with-other-formats)
- [Get Involved](#user-content-get-involved)
- [Wiki](#user-content-wiki)

Example
-------

```toml
# TOML 문서.

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00 # 기본 날짜 형식

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # 들여 쓰기 (탭 / 공백)는 허용되지만 필수는 아님.
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"

[clients]
data = [ ["gamma", "delta"], [1, 2] ]

# 배열 내부에서 줄바꿈 가능.
hosts = [
  "alpha",
  "omega"
]
```

Spec
----

* TOML은 대소 문자를 구분합니다.
* TOML 파일은 유효한 UTF-8으로 인코딩된 유니코드 문서여야 합니다.
* 공백은 탭(0x09)이나 공백(0x20)을 의미합니다.
* 개행은 LF(0x0A)나 CRLF(0x0D0A)를 의미합니다.

Comment
-------

해시 기호는 나머지 줄을 주석으로 표시합니다.

```toml
# 한 줄 모두 주석
key = "value" # 여기서부터 마지막 문자까지 주석
```

Key/Value Pair
--------------

TOML 문서에서 기본 빌딩 블록은 키값 쌍으로 표현합니다.

키는 등호(=) 왼쪽에 있고 값은 오른쪽에 있습니다. 키 이름과 값에서 공백(Whitespace)은 무시합니다. 키, 등호, 값은 같은 행에 있어야 합니다. (일부 값은 여러행으로 구분될 수 있습니다)

```toml
key = "value"
```

값은 String, Integer, Float, Boolean, Datetime, Array, Inline Table 타입이어야 합니다. 지정되지 않은 값은 유효하지 않습니다.

```toml
key = # INVALID
```

Keys
----

키는 기본 키와 따옴표를 씌운 키, 점을 찍은 키가 있습니다.

**기본 키(Bare key)** 는 ASCII 문자, ASCII 숫자, 밑줄, 대시 (`A-Za-z0-9_-`)만 포함할 수 있습니다. 기본 키는 ASCII 숫자만으로 구성될 수 있습니다. 예로 `1234`는 항상 문자열로 해석됩니다.

```toml
key = "value"
bare_key = "value"
bare-key = "value"
1234 = "value"
```

**따옴표 씌운 키**는 기본 문자열이나 리터럴 문자열과 같은 규칙을 따르고, 훨씬 더 광범위한 키 이름 집합으로 사용할 수 있습니다. 추천하는 방법은 아니며, 꼭 필요한 경우가 아니라면 기본 키를 사용하는 것을 권고합니다.

```toml
"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
'key2' = "value"
'quoted "value"' = "value"
```

기본 키는 비어있어서는 안 되지만, 따옴표를 붙여 만든 빈 인용키는 허용됩니다. (권장하지 않습니다).

```toml
= "no key name"  # INVALID
"" = "blank"     # VALID but discouraged
'' = 'blank'     # VALID but discouraged
```

**점을 찍은 키**는 점으로 결합된 일련의 기본 키 또는 인용키를 나타내는 데 사용됩니다. 이렇게 하면 비슷한 속성으로 그룹화하여 나타낼 수 있습니다:

```toml
name = "Orange"
physical.color = "orange"
physical.shape = "round"
site."google.com" = true
```

위 내용은 다음 JSON과 같은 구조를 나타냅니다:

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

점으로 구분된 부분에서 공백(whitespace)은 무시되지만 가장 좋은 방법은 관계없는 공백을 사용하지 않는 것입니다.

키를 여러 번 정의하는 것은 유효하지 않습니다.

```
# DO NOT DO THIS
name = "Tom"
name = "Pradyun"
```

키가 직접 정의되지 않는 한, 키와 키 내의 이름을 쓸 수 있습니다.

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

문자열 표현하는 방법으론 기본, 문자열 여러 줄 표기, 리터럴, 리터럴 여러 줄 표기 이 네 가지가 있습니다. 모든 문자열은 유효한 UTF-8 문자만 포함해야 합니다.

**기본 문자열** 은 따옴표로 묶습니다. 인용부호, 백 슬래시, 제어문자 (U+0000 ~ U+001F, U+007F)까지 이스케이프 해야 하는 문자를 제외한 모든 유니코드 문자를 사용할 수 있습니다.

```toml
str = "I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
```

편의상 일부 인기가 있는 문자는 간결한 이스케이프 시퀀스를 사용합니다.

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

모든 유니코드 문자는 `\uXXXX` 이나 `\UXXXXXXXX`형식으로 이스케이프 처리할 수 있습니다.
이스케이프 코드는 유효한 유니코드 [scalar values](http://unicode.org/glossary/#unicode_scalar_value) 이어야 합니다.

위에 나열되어있지 않은 다른 이스케이프 문자열은 모두 예약되어있으므로 TOML에서 사용하면 오류가 발생합니다.

때로는 텍스트의 구절 (예, 번역 파일)을 표현하거나 아주 긴 문자열을 여러 줄로 나누고 싶을 때가 있습니다. TOML은 이것을 쉽게 처리할 수 있습니다.

**문자열 여러 줄 표기**는 양쪽에 따옴표 3개를 묶어 사용하며 개행을 허용합니다. 시작 구문 기호 다음에 오는 개행은 알아서 잘립니다. 다른 모든 공백 문자와 줄 바꿈 문자는 그대로 유지됩니다.

```toml
str1 = """
Roses are red
Violets are blue"""
```

TOML 파서는 플랫폼에 맞게 개행문자를 정규화할 수 있어야 합니다.

```toml
# 유닉스 시스템에서 여러 줄 표기는 다음과 같을 것입니다.
str2 = "Roses are red\nViolets are blue"

# 윈도우 시스템에서는 다음과 같을 것입니다.
str3 = "Roses are red\r\nViolets are blue"
```

불필요한 공백을 넣지 않고 긴 문자열을 쓰려면, "라인 끝에 백슬러시(`\`)"를 입력합니다. 한 줄의 마지막에 있는 문자가 공백이 아닌 `\`일 경우, 다음 공백이 나오거나, 닫는 구분 기호가 나올 때까지 모든 공백 (새로운 줄 포함)은 표현되지 않습니다. 기몬 문자열에 유효한 모든 이스케이프 시퀀스는 여기서도 유효합니다.

```toml
# 다음 문자열들은 동일한 문자열입니다:
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

백 슬래시와 제어 문자 (U+0000 ~ U+001F, U+007F) 이외의 모든 유니코드 문자 중 이스케이프 문자를 제외하고 사용할 수 있습니다. 따옴표는 곧장 닫는 구문 기호를 만들지 않는다면, 이스케이프 할 필요가 없습니다.

Windows 경로나 정규 표현식을 자주 사용한다면, 역슬래시나 이스케이핑하는 일은 금세 실증이 나는 번거러운 일이며 종종 에러의 원인이됩니다. 이것을 도우려고 TOML은 이스케이프를 전혀 허용하지 않는 리터럴 문자열을 지원합니다.

**리터럴 문자열**은 작은따옴표로 묶습니다. 기본 문자열처럼 한 줄에 나타나야 합니다.

```toml
# 보는 것처럼 표현 됩니다.
winpath  = 'C:\Users\nodejs\templates'
winpath2 = '\\ServerX\admin$\system32\'
quoted   = 'Tom "Dubs" Preston-Werner'
regex    = '<\i\c*\s*>'
```

이스케이프가 없으므로 작은따옴표로 묶인 리터럴 문자열 안에 작은따옴표를 사용할 방법은 없습니다. 그 문제를 해결하기 위해 TOML에서는 리터럴 여러 줄 표기가 가능합니다.

**리터럴 문자열 여러 줄 표기**는 양쪽에 작은따옴표로 묶으며 개행을 허용합니다. 리터럴 문자열과 마찬가지로 이스케이프를 허용하지 않습니다.
시작 구분 기호에서 바로 오는 개행은 잘려 사용되지 않습니다. 구분 기호 사이에 나오는 내용은 수정하지 않고 그래도 해석되어 표기됩니다.

```toml
regex2 = '''I [dw]on't need \d{2} apples'''
lines  = '''
The first newline is
trimmed in raw strings.
   All other whitespace
   is preserved.
'''
```

리터럴 문자열에는 탭 이외의 제어 문자를 사용할 수 없습니다. 따라서 바이너리 데이터의 경우 Base64나 다른 적절한 ASCII나 UTF-8 인코딩을 사용하는 것이 좋습니다. 해당 인코딩 처리는 응용 프로그램에 따라 다릅니다.

Integer
-------

Integer는 정수입니다. 양수는 양수 기호(`+`)가 붙습니다. 음수는 음수 기호(`-`)가 붙습니다.

```toml
int1 = +99
int2 = 42
int3 = 0
int4 = -17
```

큰 숫자의 경우, 가독성을 높이기 위해 숫자 사이에 밑줄(`_`)을 사용할 수 있습니다. 밑줄은 하나 이상의 숫자로 둘러싸여야 합니다.

```toml
int5 = 1_000
int6 = 5_349_221
int7 = 1_2_3_4_5     # 가능하지만 사용하지 않습니다.
```

숫자 맨 앞에 0은 허용되지 않습니다. 그리고 `-0`, `+0`은 0과 같이 취급합니다.

음이 아닌 정숫값은 16진수, 8진수, 2진수로 표현될 수도 있습니다. 이러면 접두어 뒤에 선행 0을 사용할 수 있습니다. 16진수 값은 대소 문자를 구분하지 않습니다. 밑줄은 숫자 사이에서는 허용되나 접두어와 값 사이에서는 사용할 수 없습니다.

```toml
# 접두어 `0x` 인 16진수
hex1 = 0xDEADBEEF
hex2 = 0xdeadbeef
hex3 = 0xdead_beef

# 접두어 `0o`인 8진수
oct1 = 0o01234567
oct2 = 0o755 # 유닉스 파일에서만 허용합니다.

# 접두어 `0b`인 2진수
bin1 = 0b11010110
```

64 비트 (signed long)에 대한 예상 범위 (-9,223,372,036,854,775,808 ~ 9,223,372,036,854,775,807).

Float
-----

부동 소수점은 IEEE 754 binary64 값으로 구현되어야 합니다.

부동 소수점은 정숫값과 같은 규칙을 따르는 정수 부분과 소수 부분, 지수 부분으로 구분됩니다. 소수부분과 지수 부분이 모두 있는 경우, 소수 부분이 지수 부분보다 먼저 나와야 합니다.

```toml
# 소수
flt1 = +1.0
flt2 = 3.1415
flt3 = -0.01

# 지수
flt4 = 5e+22
flt5 = 1e6
flt6 = -2E-2

# 둘다
flt7 = 6.626e-34
```

소수 부분은 하나 이상의 숫자가 오는 소수점입니다.

지수 부분은 대문자 또는 소문자 `E`와 정숫값과 같은 규칙을 따르는 정수 부분으로 표현합니다.

정수와 마찬가지로 가독성을 높이기 위해 밑줄을 사용할 수 있습니다. 밑줄은 하나 이상의 숫자로 둘러싸여야 합니다.

```toml
flt8 = 9_224_617.445_991_228_313
```

부동 소수점 값 `-0.0`과 `+0.0`은 유요한 숫자이며 IEEE 754에 따라 대응해야 합니다.

특수한 부동 소수점 값을 표현할 수 있습니다. 이때는 항상 소문자로 표기합니다.

```toml
# 무한대
sf1 = inf  # 양의 무한대
sf2 = +inf # 양의 무한대
sf3 = -inf # 음의 무한대

# 숫자가 아님
sf4 = nan  # 실제 sNaN/qNaN 인코딩은 구현에 따라 다릅니다.
sf5 = +nan # `nan`과 동일
sf6 = -nan # 유효하며 실제 인코딩은 구현에 따라 다릅니다.
```

Boolean
-------

부울은 당신에게 익숙한 토큰입니다. 항상 소문자로 표기합니다.

```toml
bool1 = true
bool2 = false
```

Offset Date-Time
---------------

특정 시간을 모호하지 않게 나타내기 위해 오프셋과 함께 [RFC 3339](http://tools.ietf.org/html/rfc3339) 형식의 날짜, 시간을 사용할 수 있습니다.

```toml
odt1 = 1979-05-27T07:32:00Z
odt2 = 1979-05-27T00:32:00-07:00
odt3 = 1979-05-27T00:32:00.999999-07:00
```

가독성을 위해 날짜와 시간 사이에 있는 T 구분 기호를 공백으로 대체할 수 있습니다. (RFC 3339 5.6 절에서 허용)

```toml
odt4 = 1979-05-27 07:32:00Z
```

소수 자리 초의 정밀도는 구현에 따라 다르지만, 최소 밀리 초에 대한 정밀도를 지원해야 합니다. 값이 구현한 것에서 더 큰 정밀도를 요구하는 경우, 추가된 정밀도는 반올림하지 않고 버립니다.

Local Date-Time
--------------

[RFC 3339](http://tools.ietf.org/html/rfc3339) 형식의 날짜, 시간에서 오프셋을 생략하면 오프셋이나 시간대와 관련 없는 날짜, 시간을 나타냅니다. 추가 정보 없이는 변환할 수 없습니다. 필요하다면 구현하면 됩니다.

```toml
ldt1 = 1979-05-27T07:32:00
ldt2 = 1979-05-27T00:32:00.999999
```

소수 자리 초의 정밀도는 구현에 따라 다르지만, 최소 밀리 초에 대한 정밀도를 지원해야 합니다. 값이 구현한 것에서 더 큰 정밀도를 요구하는 경우, 추가된 정밀도는 반올림하지 않고 버립니다.

Local Date
----------

[RFC 3339](http://tools.ietf.org/html/rfc3339) 형식의 날짜, 시간에서 날짜만 표기할 경우, 오프셋이나 시간대와 상관없이 온종일을 나타냅니다.

```toml
ld1 = 1979-05-27
```

Local Time
----------

[RFC 3339](http://tools.ietf.org/html/rfc3339) 형식의 날짜, 시간에서 시간만 표기할 경우, 오프셋이나 시간대와 관계없이 해당 시간을 나타냅니다.

```toml
lt1 = 07:32:00
lt2 = 00:32:00.999999
```

소수 자리 초의 정밀도는 구현에 따라 다르지만, 최소 밀리 초에 대한 정밀도를 지원해야 합니다. 값이 구현한 것에서 더 큰 정밀도를 요구하는 경우, 추가된 정밀도는 반올림하지 않고 버립니다.

Array
-----

배열은 대괄호 내부에 값이 있는 형태로 표현됩니다. 공백은 무시됩니다. 요소는 쉼표로 구분됩니다. 데이터 유형은 혼합될 수 없습니다. 문자열을 정의하는 여러 가지 방법은 같은 유형으로 간주하여야 하며, 요소 타입이 다른 배열도 같이 표현되어야 합니다.

```toml
arr1 = [ 1, 2, 3 ]
arr2 = [ "red", "yellow", "green" ]
arr3 = [ [ 1, 2 ], [3, 4, 5] ]
arr4 = [ "all", 'strings', """are the same""", '''type''']
arr5 = [ [ 1, 2 ], ["a", "b", "c"] ]

arr6 = [ 1, 2.0 ] # INVALID
```

배열은 여러 줄로 표기할 수 있습니다. 종료 쉼표(또는 후행 쉼표라고 하는)는 배열의 마지막 값 뒤에 오게 됩니다. 값 앞에 그리고 닫는 대괄호 앞에 임의의 수의 개행과 주석이 존재할 수 있습니다.

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

테이블 (해시 테이블이나 딕셔너리로 불리는)은 키-값 쌍의 모음입니다. 대괄호 안에 표시됩니다. 배열은 항상 유일한 값이므로 배열과 구분할 수 있습니다.

```toml
[table]
```

테이블 범위는 그다음 테이블이 오거나 테이블의 키-값이 EOF 될 때까지입니다. 테이블 내 키-값은 특정 순서를 보장하지 않습니다.

```toml
[table-1]
key1 = "some string"
key2 = 123

[table-2]
key1 = "another string"
key2 = 456
```

테이블 이름 지정 규칙은 키와 같습니다. (위의 [Keys](#user-content-keys) 정의를 참조).

```toml
[dog."tater.man"]
type.name = "pug"
```

JSON 영역에서는 다음과 같은 구조를 제공합니다.

```json
{ "dog": { "tater.man": { "type": { "name": "pug" } } } }
```

키 주변의 공백은 무시되지만 가장 좋은 방법은 필요 없는 공백을 사용하지 않는 것입니다.

```toml
[a.b.c]            # 가장 좋은 방법
[ d.e.f ]          # [d.e.f]과 동일
[ g .  h  . i ]    # [g.h.i]과 동일
[ j . "ʞ" . 'l' ]  # [j."ʞ".'l']과 동일
```

원하지 않는 경우, 모든 상위 테이블(super-tables)을 지정할 필요가 없습니다. TOML은 당신이 그걸 만들지 않아도 알고 있습니다.

```toml
# [x] 이게
# [x.y] 필요
# [x.y.z] 없어요
[x.y.z.w] # 요것만 있어도 작동됩니다.
```

빈 테이블은 허용되지만, 단순히 키-값 쌍이 없습니다.

키와 마찬가지로 테이블을 두 번 이상 정의 할 수 없습니다. 그렇게 하는 것은 유효하지 않습니다.

```
# 이렇게 하지 마세요.

[a]
b = 1

[a]
c = 2
```

```
# 이건 작업이 안될꺼에요.

[a]
b = 1

[a.b]
c = 2
```

Inline Table
------------

인라인 테이블은 참조 테이블보다 더 단순한 구문을 제공합니다. 다른 방식으로 빠르게 표시할 수 이는 그룹화된 데이터에 특히 유용합니다. 인라인 테이블은 중괄호(`{`, `}`)로 묶여있습니다. 중괄호 안에 0개 이상의 쉼표로 구분된 키-값 쌍을 입력할 수 있습니다. 키-값 쌍은 표준 테이블의 키-값과 같은 형식으로 작성합니다. 인라인 테이블에서는 모든 값 타입이 가능합니다.

인라인 테이블은 한 줄에 표시됩니다. 값 내에서 가능하지 않으면, 중괄호 사이에 줄 바꿈이 허용되지 않습니다. 그런데도 인라인 테이블을 여러 줄로 나누는 것은 바람직하지 않습니다. 여러 줄을 사용해야 된다면 기본 테이블을 사용해야 합니다.

```toml
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }
animal = { type.name = "pug" }
```

위 인라인 테이블은 다음 표준 테이블 정의와 같습니다:

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

마지막 테이블 유효한 테이블 배열입니다. 이중 대괄호 안에 테이블 이름을 넣어 정의할 수 있습니다. 같은 이중 괄호로 묶인 이름을 가진 테이블은 배열의 요소가 됩니다. 이때 요소들은 순서대로 삽입됩니다. 키-값 쌍이 없는 이중 괄호는 빈 테이블로 간주합니다.

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

JSON으로 표현하면 다음과 같습니다.

```json
{
  "products": [
    { "name": "Hammer", "sku": 738594937 },
    { },
    { "name": "Nail", "sku": 284758393, "color": "gray" }
  ]
}
```

테이블을 중첩하여 배열을 정의할 수 있습니다. 서브 테이블에 같은 이중 괄호 구문을 사용하면 됩니다. 각 이중 괄호에 묶인 서브 테이블은 그 위에 가장 먼저 정의된 테이블에 요소로 속하게 됩니다.

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

위의 TOML을 다음 JSON 형식으로 대응됩니다.

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

정적으로 정의된 배열에 추가하려면 해당 배열이 비어있거나 호환되는 유형이더라도 구문해석할때 오류가 발생해야 합니다.

```toml
# 무효한 TOML 문서
fruit = []

[[fruit]] # 혀용되지 않음
```

이미 정의된 배열과 이름이 같은 일반 테이블을 정의하려고 하면 구문해석시 오류가 발생해야합니다.

```
# 무효한 TOML 문서
[[fruit]]
  name = "apple"

  [[fruit.variety]]
    name = "red delicious"

  # 이 테이블은 이전 테이블과 충돌합니다.
  [fruit.variety]
    name = "granny smith"
```

필요한 경우, 인라인 테이블을 사용할 수도 있습니다:

```toml
points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]
```

Filename Extension
------------------

TOML 파일은 `.toml` 확장자를 사용해야합니다.

MIME Type
---------

TOML 파일을 인터넷을 통해서 전송할 경우, MIME 타입으로 `application/toml`을 사용합니다.

Comparison with Other Formats
-----------------------------

어떤면에서 TOML은 JSON과 매우 유사합니다. 간단하고 명료하며 유비쿼터스 데이터 타입에 쉽게 대응할 수 있습니다. JSON은 주로 컴퓨터 프로그램에서 읽고 쓰는 데이터를 직렬화하는 데 적합합니다. TOML이 JSON과 다른 점은 사람이 읽고 쓰는데 쉽다는 점입니다. 주석이 가장 좋은 예입니다. 한 프로그램에서 다른 프로그램으로 데이터를 전송할 때에는 아무런 도움이 되지 않지만, 손으로 편집할 수 있는 구성 파일에는 매우 유용합니다.

YAML 포맷은 TOML과 같은 구성 파일을 지향합니다. 그러나 많은 목적을 위해 YAML은 지나치게 복잡한 솔루션이 되었습니다. TOML은 단순성을 목표로 합니다만 YAML 스팩에서의 목표는 분명하지 않습니다: http://www.yaml.org/spec/1.2/spec.html

INI 포맷은 구성 파일에서 자주 사용됩니다. 그러나 이 포맷은 표준화 되어 있지 않으며, 보통 한두 단계이상의 중첩을 처리하지 못합니다.

Get Involved
------------

문서, 버그, 풀 리퀘스트 등 모든 컨트리뷰션을 환영합니다!

Wiki
----------------------------------------------------------------------

다음 카탈로그로 되어있는 [공식 TOML 위키](https://github.com/toml-lang/toml/wiki)가 있습니다:

* TOML을 사용하는 프로젝트
* 구현체 (Implementations)
* 검사기 (Validators)
* TOML 디코더, 인코더용 언어 테스트 제품군
* 에디터 지원
* 인코더
* 컨버터

해당 목록을 보거나 목록을 추가할 수 있습니다. TOML 커뮤니티에 참여해주셔서 감사합니다!
