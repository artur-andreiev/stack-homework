def cut_cake(cake)  #Написати програму яка приймає на вхід "пиріг з родзинками"
  rows = cake.split("\n")
  raisins = []
  
  # Знаходимо координати всіх родзинок
  rows.each_with_index do |row, i|
    row.chars.each_with_index do |char, j|
      raisins << [i, j] if char == 'o'
    end
  end

  # Функція для вирізання прямокутника
  def extract_piece(cake, top_left, bottom_right)
    (top_left[0]..bottom_right[0]).map do |i|
      cake[i][top_left[1]..bottom_right[1]]
    end.join("\n")
  end

  # Вибираємо горизонтальне розрізання, щоб розрізати між кожною родзинкою
  result = []
  raisins.each_cons(2) do |(start, finish)|
    result << extract_piece(rows, start, [finish[0] - 1, rows[0].size - 1])
  end

  # Останній шматок
  last_start = raisins.last
  result << extract_piece(rows, last_start, [rows.size - 1, rows[0].size - 1])
  
  result
end

# Приклад використання
cake = <<~CAKE
  ........
  ..o.....
  ...o....
  ........
CAKE

puts cut_cake(cake)