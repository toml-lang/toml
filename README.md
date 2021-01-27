<img align="right" src="logos/toml-200.png" alt="TOML logo">

TOML
====

汤小明的小巧明晰语言。  

作者：汤姆·普雷斯顿—维尔纳、Pradyun Gedam 等人。  

> `toml.md` 是研发中的版本。`toml-v1.0.0.md` 等文件名中含版本号的为发行版。  
> （原文：该存储库包含了 TOML 规范的研发版本。你可以在 https://toml.io 查看发行版。）  

宗旨
----

TOML 旨在成为一个语义显著而易于阅读的最低限度的配置文件格式。  
TOML 被设计地能够无歧义地转化为哈希表。  
TOML 应当能简单地解析成形形色色的语言中的数据结构。  

示例
----

```toml
# 这是一个 TOML 文档。

title = "TOML 示例"

[owner]
name = "汤姆·普雷斯顿—维尔纳"
dob = 1979-05-27T07:32:00-08:00 # 位列一等公民的日期，可以直接书写

[database]
server = "192.168.1.1"
ports = [ 8001, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # 允许缩进（Tab 和/或空格），不过不是必要的
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"

[clients]
data = [ ["gamma", "delta"], [1, 2] ]

# 数组中是可以换行的
hosts = [
  "alpha",
  "omega"
]
```

与其它格式的比较
----------------

TOML 享有其它用于应用配置和数据序列化的文件格式，诸如 YAML 和 JSON 的共同特性。  
TOML 和 JSON 都是简单的，且使用普适的数据类型，这使得它们容易为机器编写或解析。  
TOML 和 YAML 都强调人类可读的特性，像是注释，这使得搞懂给定行的用意更容易。  
TOML 的不同之处在于结合了这些特性，允许注释（不像 JSON）但保留简单性（不像 YAML）。  

因为 TOML 是明确作为配置文件格式设计的，解析它是简单的，但它不是为序列化任意数据结构设计的。  
TOML 总是以哈希表作为文件的顶层，这便于包含键内数据嵌套，但它不允许顶层数组或浮点数，所以它不能直接序列化某些数据。  
也不存在标准的 TOML 文件开始或结束标识，用于通过复合流发送。  
这些细节必须在应用层协商。  

INI 文件也常被用来同 TOML 比较，因为它们在语法和作为配置文件使用上的相似形。  
然而……INI 并无标准格式，并且不能优雅地料理超过一或两层的嵌套。  

延伸阅读：  

* YAML 规范：https://yaml.org/spec/1.2/spec.html
* JSON 规范：https://tools.ietf.org/html/rfc8259
* Wikipedia 上的 INI 文件: https://en.wikipedia.org/wiki/INI_file

参与
----

欢迎帮助文档、问题反馈、修缮合并，以及其它一切形式的贡献！  

百科
----

我们有一个[官方 TOML 百科](https://github.com/toml-lang/toml/wiki)收录了以下内容：  

* 使用了 TOML 的项目
* 可用实现清单
* 验证程序
* TOML 解码器和编码器的语言无关测试套件
* 编辑器支持
* 编码器
* 格式转换器

请点进去看一下，如果你想要阅览或加入其中。  
感谢你成为 TOML 社区的一员！  

——[龙腾道](http://www.LongTengDao.com/) 译