require "ostruct"
require "date"

module TOML
  def self.safe_load
    raise NotImplementedError, "whoops"
  end

  def self.load(__toml)
    __b = binding
    __b.eval(to_ruby(__toml))
    hashize(binding_vars(__b))
  end

  class << self
  private
    def _section(mergee)
      b = nil
      c = Object.new
      c.singleton_class.send(:define_method, :[]) { |b_| b = b_ }
      yield c
      mergee.merge! binding_vars(b)
    end

    def binding_vars(b)
      Hash[b.eval("local_variables").reject{|v|v[0,2]=="__"}.map{|l| [l, b.eval("#{l}")] }]
    end

    def hashize(obj, seen = {}.compare_by_identity)
      return if seen[obj]
      seen[obj] = true
      case obj
      when OpenStruct; hashize(obj.instance_variable_get(:@table), seen)
      when Hash; Hash[obj.reject{|k,_|k[0, 2] == "__"}.map { |k,v| v = hashize(v, seen) and [k, v] }.compact]
      when Array; obj.map { |v| hashize(v, seen) }.compact
      when Fixnum, Float, true, false, nil; seen[obj] = false; obj
      else obj
      end
    end

    def to_ruby(toml)
      "if true\n#{toml.gsub(/^\s*\[([a-z0-9_.]+)\]\s*$/i){|sec|" end; #{1.
      upto($1.split(".").length-1).map { |i| "#{$1.split(".")[0...i].join(
      ".")}||=OpenStruct.new"}.join";"}; #{$1} = OpenStruct.new; _section(
      #{$1}.instance_variable_get(:@table)) do |__| __[binding]; " }.gsub(
      /\d{4}(-\d{2}){2}T(\d{2}:){2}\d{2}Z/){|x|"Date.parse(%{#{x}})"}}end"
    end
  end
end
