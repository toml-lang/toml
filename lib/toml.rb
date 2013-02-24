require "ostruct"
require "date"

module TOML
  def self.safe_load
    raise NotImplementedError, "whoops"
  end

  class LoadContext
    def _section(mergee)
      b = nil
      c = Object.new
      c.singleton_class.send(:define_method, :[]) { |b_| b = b_ }
      yield c
      mergee.merge! binding2hash b
    end

    def binding2hash(b)
      Hash[b.eval("local_variables").map { |l| [l, b.eval("#{l}")] }]
    end

    def theBinding
      @binding ||= binding
    end

    def ostructToHash(ostruct, seen = {}.compare_by_identity)
      return if seen[ostruct]
      seen[ostruct] = true
      case ostruct
      when OpenStruct
        ostructToHash ostruct.instance_variable_get(:@table), seen
      when Hash
        Hash[ostruct.select { |k,_| k != :__ }.map { |k,v| v = ostructToHash(v, seen) and [k, v] }.compact]
      when Array
        ostruct.map { |v| ostructToHash(v) }.compact
      else
        ostruct
      end
    end
  end

  def self.load(toml)
    ctx = LoadContext.new
    result = ctx.theBinding.eval(to_ruby(toml))
    ctx.ostructToHash ctx.binding2hash(ctx.theBinding)
  end

  class << self
  private
    def to_ruby(toml)
      "if true\n" +
      toml.
        gsub(/^\s*\[([a-z0-9_.]+)\]\s*$/i) { |sec| " end; #{1.upto($1.split(".").length-1).map { |i| "#{$1.split(".")[0...i].join(".")} ||= OpenStruct.new" }.join ";" }; #{$1} = OpenStruct.new; _section(#{$1}.instance_variable_get(:@table)) do |__| __[binding]; " }.
        gsub(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/) { |x| "Date.parse(%{#{x}})" } +
      " end "
    end
  end
end
