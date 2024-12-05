require 'net/http'
require 'json'
require 'csv'
require 'uri'

API_KEY = 'e0cfeb8ae5e3f14a48cc858f312808d7'
BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'

def get_weather(city)
  url = URI("#{BASE_URL}?q=#{URI.encode_www_form_component(city)}&appid=#{API_KEY}&units=metric&lang=ua")
  response = Net::HTTP.get_response(url)

  if response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  else
    { 'error' => response.message, 'code' => response.code }
  end
end

def extract_weather_data(data)
  required_keys = %w[name main wind weather]
  return nil unless required_keys.all? { |key| data.key?(key) }

  {
    city: data['name'],
    temperature: data.dig('main', 'temp'),
    humidity: data.dig('main', 'humidity'),
    wind_speed: data.dig('wind', 'speed'),
    weather_description: data.dig('weather', 0, 'description') || 'Невідомо'
  }
end

# Збереження даних у CSV
def save_to_csv(data, filename = 'weather_output.csv')
  CSV.open(filename, 'a+', headers: data.keys, write_headers: !File.exist?(filename)) do |csv|
    csv << data.values
  end
end

def display_weather(data)
  puts "Місто: #{data[:city]}"
  puts "Температура: #{data[:temperature]}°C"
  puts "Вологість: #{data[:humidity]}%"
  puts "Швидкість вітру: #{data[:wind_speed]} м/с"
  puts "Опис погоди: #{data[:weather_description]}"
end

# Основна програма
def main
  puts 'Введіть місто англійскою мовою для отримання погоди:'
  city = gets.chomp

  weather_data = get_weather(city)
  extracted_data = extract_weather_data(weather_data)

  if extracted_data.nil?
    puts 'Помилка отримання даних. Перевірте правильність назви міста.'
  else
    display_weather(extracted_data)
    save_to_csv(extracted_data)
    puts "Дані збережено в файл weather_output.csv"
  end
end

main if __FILE__ == $0