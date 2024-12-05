class ShuntingYard
    def initialize(expression)
      @expression = expression
    end
  
    def to_rpn
      output = []
      operators = []
      precedence = { '+' => 1, '-' => 1, '*' => 2, '/' => 2 }
      @expression.scan(/\d+|\S/).each do |token|
        if token.match?(/\d+/)
          output << token
        elsif precedence.keys.include?(token)
          while operators.any? && precedence[operators.last] >= precedence[token]
            output << operators.pop
          end
          operators.push(token)
        end
      end
      output.concat(operators.reverse)
      output.join(' ')
    end
  end
  
  expression = '2 + 1 * 4'
  shunting_yard = ShuntingYard.new(expression)
  puts shunting_yard.to_rpn
  #Зробити невеликий скрипт На вхід передаємо математичний вираз у звичному нам вигляді На виході бачимо його у RPN