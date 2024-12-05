require 'minitest/autorun'
require_relative 'app'

class AppTest < Minitest::Test
  # Тест на успішний запит до API
  def test_successful_response
    response = get_weather('Kyiv')
    assert response.is_a?(Hash)
    assert_equal 'Kyiv', response['name']
  end

  # Тест на помилковий запит
  def test_failed_response
    response = get_weather('InvalidCity')
    assert response.key?('error')
    assert_equal '404', response['code']
  end

  # Тест на обробку даних
  def test_data_extraction
    mock_data = {
      'name' => 'Kyiv',
      'main' => { 'temp' => 5, 'humidity' => 80 },
      'wind' => { 'speed' => 3 },
      'weather' => [{ 'description' => 'clear sky' }]
    }
    result = extract_weather_data(mock_data)
    assert_equal 'Kyiv', result[:city]
    assert_equal 5, result[:temperature]
    assert_equal 80, result[:humidity]
    assert_equal 3, result[:wind_speed]
    assert_equal 'clear sky', result[:weather_description]
  end


  def test_csv_saving
    data = { city: 'Kyiv', temperature: 5, humidity: 80, wind_speed: 3, weather_description: 'clear sky' }
    filename = 'test_weather.csv'
    save_to_csv(data, filename)

    assert File.exist?(filename)
    content = File.read(filename)
    assert content.include?('Kyiv')

    File.delete(filename) if File.exist?(filename)
  end
end