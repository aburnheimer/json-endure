require 'json'
require File.expand_path File.join(File.dirname(__FILE__), 'array')

module JsonStateVariable
  INIT                  = 10
  IN_ARRAY_PRE_VALUE    = 20
  IN_ARRAY_IN_VALUE     = 30
  IN_ARRAY_IN_STR_VALUE = 35
  IN_ARRAY_POST_VALUE   = 40
  IN_HASH_PRE_KEY       = 50
  IN_HASH_IN_KEY        = 60
  IN_HASH_POST_KEY      = 70
  IN_HASH_PRE_VALUE     = 80
  IN_HASH_IN_VALUE      = 90
  IN_HASH_IN_STR_VALUE  = 95
  IN_HASH_POST_VALUE    = 100
end

module JSON

  module_function

  def endure_and_parse(str)
    parse endure str
  end

  def endure(str)

    literal_mark = literal_char = false
    state_stack = Array.new

    state_stack << JsonStateVariable::INIT

    str.chomp!
    arr = str.split(//)
    arr.each do |c|

      if literal_mark && ! literal_char
        literal_char = true
      elsif literal_mark && literal_char
        literal_mark = false
        literal_char = false
      end

      case state_stack.last
        when JsonStateVariable::INIT
          if c == '['
            state_stack << JsonStateVariable::IN_ARRAY_PRE_VALUE 
          elsif c == '{'
            state_stack << JsonStateVariable::IN_HASH_PRE_KEY 
          end

        when JsonStateVariable::IN_ARRAY_PRE_VALUE
          if c == '['
            state_stack.last = JsonStateVariable::IN_ARRAY_POST_VALUE
            state_stack << JsonStateVariable::IN_ARRAY_PRE_VALUE 
          elsif c == '{'
            state_stack.last = JsonStateVariable::IN_ARRAY_POST_VALUE
            state_stack << JsonStateVariable::IN_HASH_PRE_KEY 
          elsif c == ','
            state_stack.last = JsonStateVariable::IN_ARRAY_PRE_VALUE 
          elsif c == '"' 
            state_stack.last = JsonStateVariable::IN_ARRAY_IN_STR_VALUE
          elsif c == ']'
            state_stack.pop
          elsif c =~ /\S/ 
            state_stack.last = JsonStateVariable::IN_ARRAY_IN_VALUE
          end

        when JsonStateVariable::IN_ARRAY_IN_VALUE
          if c == ','
            state_stack.last = JsonStateVariable::IN_ARRAY_PRE_VALUE
          elsif c == ']'
            state_stack.pop
          end

        when JsonStateVariable::IN_ARRAY_IN_STR_VALUE
          if c == '\\'
            literal_mark = true
            break
          elsif c == '"'
            state_stack.last = JsonStateVariable::IN_ARRAY_POST_VALUE
          end

        when JsonStateVariable::IN_ARRAY_POST_VALUE
          if c == ','
            state_stack.last = JsonStateVariable::IN_ARRAY_PRE_VALUE 
          elsif c == ']'
            state_stack.pop
          end

        when JsonStateVariable::IN_HASH_PRE_KEY
          if c == '"'
            state_stack.last = JsonStateVariable::IN_HASH_IN_KEY
          elsif c == '}'
            state_stack.pop
          end

        when JsonStateVariable::IN_HASH_IN_KEY
          state_stack.last = JsonStateVariable::IN_HASH_POST_KEY if c == '"'

        when JsonStateVariable::IN_HASH_POST_KEY
          state_stack.last = JsonStateVariable::IN_HASH_PRE_VALUE if c == ':'

        when JsonStateVariable::IN_HASH_PRE_VALUE
          if c == '['
            state_stack.last = JsonStateVariable::IN_HASH_POST_VALUE
            state_stack << JsonStateVariable::IN_ARRAY_PRE_VALUE 
          elsif c == '{'
            state_stack.last = JsonStateVariable::IN_HASH_POST_VALUE
            state_stack << JsonStateVariable::IN_HASH_PRE_KEY 
          elsif c == ','
            state_stack.last = JsonStateVariable::IN_HASH_PRE_KEY
          elsif c == '"'
            state_stack.last = JsonStateVariable::IN_HASH_IN_STR_VALUE
          elsif c =~ /\S/ 
            state_stack.last = JsonStateVariable::IN_HASH_IN_VALUE
          end

        when JsonStateVariable::IN_HASH_IN_VALUE
          if c == ','
            state_stack.last = JsonStateVariable::IN_HASH_PRE_KEY 
          elsif c == '}'
            state_stack.pop
          end

        when JsonStateVariable::IN_HASH_IN_STR_VALUE
          if c == '\\'
            literal_mark = true
            break
          elsif c == '"'
            state_stack.last = JsonStateVariable::IN_HASH_POST_VALUE
          end

        when JsonStateVariable::IN_HASH_POST_VALUE
          if c == ','
            state_stack.last = JsonStateVariable::IN_HASH_PRE_KEY 
          elsif c == '}'
            state_stack.pop
          end

      end unless literal_mark 

    end

    state_stack.reverse.each do |s|
      catch(:redo) do
        case s
          when JsonStateVariable::INIT

          when JsonStateVariable::IN_ARRAY_PRE_VALUE
            str << '"'
            s = JsonStateVariable::IN_ARRAY_IN_STR_VALUE
            redo

          when JsonStateVariable::IN_ARRAY_IN_VALUE
            s = JsonStateVariable::IN_ARRAY_POST_VALUE
            redo

          when JsonStateVariable::IN_ARRAY_IN_STR_VALUE
            str << '"'
            s = JsonStateVariable::IN_ARRAY_POST_VALUE
            redo

          when JsonStateVariable::IN_ARRAY_POST_VALUE
            str << ']'

          when JsonStateVariable::IN_HASH_PRE_KEY
            str << '"'
            s = JsonStateVariable::IN_HASH_IN_KEY
            redo

          when JsonStateVariable::IN_HASH_IN_KEY
            str << '"'
            s = JsonStateVariable::IN_HASH_POST_KEY
            redo

          when JsonStateVariable::IN_HASH_POST_KEY
            str << ':'
            s = JsonStateVariable::IN_HASH_PRE_VALUE
            redo

          when JsonStateVariable::IN_HASH_PRE_VALUE
            str << '"'
            s = JsonStateVariable::IN_HASH_IN_STR_VALUE
            redo

          when JsonStateVariable::IN_HASH_IN_VALUE
            s = JsonStateVariable::IN_HASH_POST_VALUE
            redo

          when JsonStateVariable::IN_HASH_IN_STR_VALUE
            str << '"'
            s = JsonStateVariable::IN_HASH_POST_VALUE
            redo

          when JsonStateVariable::IN_HASH_POST_VALUE
            str << '}'

        end
      end
    end

    return str
  end

end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
