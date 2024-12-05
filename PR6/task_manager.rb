# frozen_string_literal: true

require 'json'
require 'date'

class TaskManager
  attr_accessor :tasks

  def initialize(file = 'tasks.json')
    @file = file
    @tasks = load_tasks
  end

  def add_task(title, deadline)
    return unless valid_date?(deadline)

    formatted_deadline = Date.parse(deadline).strftime('%d.%m.%Y')
    @tasks << { id: next_id, title: title, deadline: formatted_deadline, status: 'незавершено' }
    save_tasks
  end

  def delete_task(id)
    @tasks.reject! { |task| task[:id] == id }
    save_tasks
  end

  def edit_task(id, title: nil, deadline: nil, status: nil)
    found_task = @tasks.find { |task| task[:id] == id }
    return unless found_task

    found_task[:title] = title if title
    if deadline && valid_date?(deadline)
      found_task[:deadline] = Date.parse(deadline).strftime('%d.%м.%Y')
    end
    found_task[:status] = status if status
    save_tasks
  end

  def filter_tasks(status: nil, before: nil)
    filtered = @tasks
    filtered = filtered.select { |task| task[:status] == status } if status
    if before && valid_date?(before)
      formatted_before = Date.parse(before).strftime('%d.%m.%Y')
      filtered = filtered.select { |task| Date.strptime(task[:deadline], '%d.%m.%Y') < Date.strptime(formatted_before, '%d.%m.%Y') }
    end
    filtered
  end

  def save_tasks
    File.write(@file, JSON.pretty_generate(@tasks))
  end

  private

  def load_tasks
    return [] unless File.exist?(@file)

    JSON.parse(File.read(@file), symbolize_names: true)
  end

  def next_id
    (@tasks.map { |task| task[:id] }.max || 0) + 1
  end

  def valid_date?(date)
    Date.parse(date)
    true
  rescue ArgumentError
    false
  end
end

# CLI
def main
  manager = TaskManager.new

  loop do
    puts "\n==== МЕНЕДЖЕР ЗАВДАНЬ ===="
    puts "1. Додати завдання"
    puts "2. Видалити завдання"
    puts "3. Редагувати завдання"
    puts "4. Фільтрувати завдання"
    puts "5. Показати всі завдання"
    puts "6. Вийти"
    print "Оберіть дію: "

    choice = gets.chomp.to_i

    case choice
    when 1
      print "Введіть назву завдання: "
      title = gets.chomp
      print "Введіть дедлайн завдання (ДД.ММ.РРРР): "
      deadline = gets.chomp
      if valid_date?(deadline)
        manager.add_task(title, deadline)
        puts "\nЗавдання успішно додано!"
      else
        puts "\nНеправильний формат дати. Спробуйте ще раз."
      end
    when 2
      print "Введіть ID завдання для видалення: "
      id = gets.chomp.to_i
      if manager.tasks.any? { |task| task[:id] == id }
        manager.delete_task(id)
        puts "\nЗавдання успішно видалено!"
      else
        puts "\nЗавдання не знайдено."
      end
    when 3
      print "Введіть ID завдання для редагування: "
      id = gets.chomp.to_i
      if manager.tasks.any? { |task| task[:id] == id }
        print "Введіть нову назву (або натисніть Enter, щоб пропустити): "
        title = gets.chomp
        title = nil if title.empty?
        print "Введіть новий дедлайн (ДД.ММ.РРРР, або натисніть Enter, щоб пропустити): "
        deadline = gets.chomp
        deadline = nil if deadline.empty? || !valid_date?(deadline)
        print "Введіть новий статус (незавершено/завершено, або натисніть Enter, щоб пропустити): "
        status = gets.chomp
        status = nil if status.empty?
        manager.edit_task(id, title: title, deadline: deadline, status: status)
        puts "\nЗавдання успішно оновлено!"
      else
        puts "\nЗавдання не знайдено."
      end
    when 4
      print "Фільтрувати за статусом (незавершено/завершено, або натисніть Enter, щоб пропустити): "
      status = gets.chomp
      status = nil if status.empty?
      print "Фільтрувати за дедлайном до (ДД.ММ.РРРР, або натисніть Enter, щоб пропустити): "
      before = gets.chomp
      before = before.empty? ? nil : before
      filtered = manager.filter_tasks(status: status, before: before)
      if filtered.empty?
        puts "\nНе знайдено жодного завдання."
      else
        display_tasks(filtered)
      end
    when 5
      if manager.tasks.empty?
        puts "\nНемає завдань для відображення."
      else
        display_tasks(manager.tasks)
      end
    when 6
      puts "\nДо побачення!"
      break
    else
      puts "\nНевірний вибір. Спробуйте ще раз."
    end
  end
end

def display_tasks(tasks)
  puts "\n==== СПИСОК ЗАВДАНЬ ===="
  puts format("%-4s | %-20s | %-12s | %-10s", "ID", "Назва", "Дедлайн", "Статус")
  puts "-" * 50
  tasks.each do |task|
    puts format("%-4d | %-20s | %-12s | %-10s", task[:id], task[:title], task[:deadline], task[:status])
  end
end

def valid_date?(date)
  Date.parse(date)
  true
rescue ArgumentError
  false
end

if __FILE__ == $0
  main
end
