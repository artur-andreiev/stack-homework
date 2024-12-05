queue = Queue.new

# Потік-генератор чисел
producer = Thread.new do
  10.times do |i|
    queue << i
    sleep 0.5
  end
end

# Потік-фільтратор непарних чисел
consumer = Thread.new do
  loop do
    num = queue.pop
    puts "Непарне число: #{num}" if num.odd?
  end
end

producer.join
consumer.kill
#  Програма, де один потік генерує числа, а інший виводить тільки непарні.
