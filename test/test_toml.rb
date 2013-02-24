require "test/unit"
require "toml"

class TestToml < Test::Unit::TestCase
  def test_sample
    toml = <<-TOML
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
    TOML

    data = {
      :title => "TOML Example",
      :owner => {
        :name => "Tom Preston-Werner",
        :organization => "GitHub",
        :bio => "GitHub Cofounder & CEO\nLikes tater tots and beer.",
        :dob => Date.parse("1979-05-27T07:32:00Z"),
      },
      :database => {
        :server => "192.168.1.1",
        :ports => ["8001", "8001", "8002"],
        :connection_max => 5000,
      },
      :servers => {
        :alpha => {
          :ip => "10.0.0.1",
          :dc => "eqdc10",
        },
        :beta => {
          :ip=>"10.0.0.2",
          :dc => "eqdc10",
        }
      }
    }

    assert_equal data, TOML.load(toml)
  end

  def test_spec_comments
    assert_equal({ key: "value" }, TOML.load(<<-TOML))
      # I am a comment. Hear me roar. Roar.
      key = "value" # Yeah, you can do this.
    TOML
  end

  def test_spec_string
    assert_equal({ str: "I'm a string. \"You can quote me\". Tab \t newline \n you get it." }, TOML.load(<<-'TOML'))
      str = "I'm a string. \"You can quote me\". Tab \t newline \n you get it."
    TOML
  end

  def test_spec_integer
    assert_equal({ pos: 42, neg: -17 }, TOML.load(<<-'TOML'))
      pos = 42
      neg = -17
    TOML
  end

  def test_spec_float
    assert_equal({ pi: 3.1415, neg_point_oh_one: -0.01 }, TOML.load(<<-'TOML'))
      pi = 3.1415
      neg_point_oh_one = -0.01
    TOML
  end

  def test_spec_date
    assert_equal({ date: Date.parse("1979-05-27T07:32:00Z") }, TOML.load(<<-'TOML'))
      date = 1979-05-27T07:32:00Z
    TOML
  end

  def test_spec_array
    assert_equal({ a: [1,2,3], b: ["red", "yellow", "green"], c: [[1,2],[3,4,5]] }, TOML.load(<<-'TOML'))
      a = [ 1, 2, 3 ]
      b = [ "red", "yellow", "green" ]
      c = [ [ 1, 2 ], [3, 4, 5] ]
    TOML
  end

  def test_spec_keygroup
    assert_equal({ key: { tater: { type: "pug" } } }, TOML.load(<<-TOML))
      [key.tater]
      type = "pug"
    TOML
  end
end
