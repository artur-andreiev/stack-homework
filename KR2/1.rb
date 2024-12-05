Thread.new do
  loop do
    puts "Поточний час: #{Time.now}"
    sleep 60
  end
end.join
# Потік-демон для перевірки системного часу кожну хвилину
