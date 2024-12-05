def remove_spaces(str)
  str.delete(" ")
end

# Приклад використання
input = "Так це онлайн компілер"
result = remove_spaces(input)
puts result # Виведе "Такцеонлайнкомпілер"
