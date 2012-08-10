load "array.rb"

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

class String

  def close_off_any_json_surround_characters()
    str = self.clone
    str.close_off_any_json_surround_characters!()
    return str
  end

  def close_off_any_json_surround_characters!()

    literal_mark = literal_char = false
    state_stack = Array.new

    state_stack << JsonStateVariable::INIT

    self.chomp!
    arr = self.split(//)
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
          state_stack.last = JsonStateVariable::IN_HASH_PRE_KEY if c == ','

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
            self << '"'
            s = JsonStateVariable::IN_ARRAY_IN_STR_VALUE
            redo

          when JsonStateVariable::IN_ARRAY_IN_VALUE
            s = JsonStateVariable::IN_ARRAY_POST_VALUE
            redo

          when JsonStateVariable::IN_ARRAY_IN_STR_VALUE
            self << '"'
            s = JsonStateVariable::IN_ARRAY_POST_VALUE
            redo

          when JsonStateVariable::IN_ARRAY_POST_VALUE
            self << ']'

          when JsonStateVariable::IN_HASH_PRE_KEY
            self << '"'
            s = JsonStateVariable::IN_HASH_IN_KEY
            redo

          when JsonStateVariable::IN_HASH_IN_KEY
            self << '"'
            s = JsonStateVariable::IN_HASH_POST_KEY
            redo

          when JsonStateVariable::IN_HASH_POST_KEY
            self << ':'
            s = JsonStateVariable::IN_HASH_PRE_VALUE
            redo

          when JsonStateVariable::IN_HASH_PRE_VALUE
            self << '"'
            s = JsonStateVariable::IN_HASH_IN_STR_VALUE
            redo

          when JsonStateVariable::IN_HASH_IN_VALUE
            s = JsonStateVariable::IN_HASH_POST_VALUE
            redo

          when JsonStateVariable::IN_HASH_IN_STR_VALUE
            self << '"'
            s = JsonStateVariable::IN_HASH_POST_VALUE
            redo

          when JsonStateVariable::IN_HASH_POST_VALUE
            self << '}'

        end
      end
    end

    return self
  end

  private

  def comp_surround_character(char)
    if char.length > 1
      throw ArgumentError.new("#{char.length} characters called for " +
          "bracket, should be 1")
    end

    case char
      when '['
        ']'
      when '<'
        '>'
      when '{'
        '}'
      when '('
        ')'
      else
        char
    end
  end

end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
