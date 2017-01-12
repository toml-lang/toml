
# TODO: Refactor this into an actual library (it's late at night and I've had
#       too much whiskey; will tackle in the morning).

require 'date'

module TOML
  def self.load(io)
    Parser.new.parse(io)
  end
  class Parser
    def initialize
      # pass
    end
    def parse(io)
      @key_group = []
      @doc = Hash.new
      io.each_line {|line| parse_line(line.strip) }
      return @doc
    end
    def parse_line(line)
      return if line.start_with? '#'
      
      if line =~ /^\[([^\]]+)\]/
        @key_group = $1.split('.')
      elsif line =~/^(\S+)\s*=\s*([^#]+)\s*/
        key = $1
        pos, value = parse_value($2)
        # TODO: Make sure has parsed entire line?
        set(key, value)
      elsif !line.empty?
        raise "Syntax error: '#{line.inspect}'"
      end
    end# parse_line
    
    def set(key, value)
      # Destination hash
      hash = @doc
      # Nest into the key group
      path = @key_group.dup
      while k = path.shift
        if hash[k].is_a? Hash
          # pass
        else
          hash[k] = Hash.new
        end
        hash = hash[k]
      end
      # TODO: Detect if overwriting previous keys.
      hash[key] = value
    end
    
    def parse_string(val)
      e = val.length
      s = 1
      o = []
      while s < e
        # TODO: Formalize escape codes
        if val[s] == "\\"
          s += 1
          case val[s]
          when "t"
            o << "\t"
          when "n"
            o << "\n"
          when "\\"
            o << "\\"
          when '"'
            o << '"'
          when "r"
            o << "\r"
          when "0"
            o << "\0"
          else
            raise "Unexpected escape character: '\\#{val[s]}'"
          end
        elsif val[s] == '"'
          break
        else
          o << val[s]
        end
        s += 1
      end
      if s == e
        raise "Unexpected end of string"
      end
      return [s + 1, o.join]
    end
    
    def parse_value(val)
      val.strip! # Make sure no whitespace.
      
      # TODO: Refactor this rotting code cesspool.
      if val.start_with? '"'
        return parse_string(val)
      elsif val.start_with? '['
        a = []
        p = 1
        while (val.slice!(0, p) && (val.strip! || true) && !val.start_with?("]"))
          val.slice!(0) if val[0] == "," # Remove comma if it's there.
          p, v = parse_value(val)
          a << v
        end
        p += 1 # Move past the closing ]
        return [p, a]
      elsif val =~ /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)/
        # Date: 1979-05-27T07:32:00Z
        return [$1.length, DateTime.iso8601($1)]
      elsif val =~ /^(-?\d+\.\d+)/
        return [$1.length, $1.to_f]
      elsif val =~ /^(-?\d+)/
        return [$1.length, $1.to_i]
      elsif val =~ /^(true)/
        return [$1.length, true]
      elsif val =~ /^(false)/
        return [$1.length, false]
      else
        raise "Unrecognized expression: '#{val}'"
      end
    end
    
  end
end


