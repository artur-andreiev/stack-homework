stackdef choice_to_str (choice)
case choice
when 1 
    "камінь"
when 2 
    "ножиці"
when 3 
    "папір"
else    
    "Неправильний вибір"
end
end  


puts "Гра камінь ножиці папір"
puts "Правила: \nножиці ріжуть папір \nпапір накриває камінь \nкамінь ламає ножиці"
wins = 0 

while true
puts "Обирайте!"

puts " 1 — камінь \n 2 — ножиці \n 3 — папір \n 9 — вихід"
 
user_choice = gets.chomp.to_i

if user_choice == 9
    puts "Дякуємо за гру! Кількість перемог — #{wins}"
    break
end

bot_choice = rand(1..3)

str_user_choice = choice_to_str(user_choice)
str_bot_choice = choice_to_str(bot_choice)


puts "Ваш вибір — #{user_choice} (#{str_user_choice}) "
puts "Вибір опонента — #{bot_choice} (#{str_bot_choice})"

if user_choice > 0 && user_choice < 4
    if user_choice == bot_choice
        puts "Нічия"
    elsif 
        (user_choice == 1 && bot_choice == 2) || 
        (user_choice == 2 && bot_choice == 3) || 
        (user_choice == 3 && bot_choice == 1) 
        puts "Ви вийграли!"
        wins+= 1
    else
        puts "Ви програли!"
    end 
else
    puts "Обери 1, 2 або 3"
end 
puts "Кількість перемог — #{wins}"
end 