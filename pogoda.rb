require_relative 'x_api_key'
require 'json'
require 'net/http'
require 'uri'
require 'time'

# создаем объект-адрес где лежит погода
uri = URI("https://api.weather.yandex.ru/v2/forecast?lat=44.55056&lon=33.95472&extra=true")
request = Net::HTTP::Get.new(uri)
request['X-Yandex-API-Key'] = X_API_KEY

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  http.request(request)
end

doc = JSON.parse(response.body)

### Можно сохранить в файл полученый ответ
=begin
current_path = File.dirname(__FILE__ )
File.open(current_path + 'pogoda.json', "w:UTF-8") do |f|
  f.puts JSON.pretty_generate(doc)
end
=end

CONDITION = {"clear" => "ясно", "partly-cloudy" => "малооблачно", "cloudy" => "облачно с прояснениями",
             "overcast" => "пасмурно", "drizzle" => "морось", "light-rain" => "небольшой дождь",
             "rain" => "дождь", "moderate-rain" => "умеренно сильный дождь", "heavy-rain" => "сильный дождь",
             "continuous-heavy-rain" => "длительный сильный дождь", "showers" => "ливень",
             "wet-snow" => "дождь со снегом", "light-snow" => "небольшой снег", "snow" => "снег",
             "snow-showers" => "снегопад", "hail" => "град", "thunderstorm" => "гроза",
             "thunderstorm-with-rain" => "дождь с грозой", "thunderstorm-with-hail" => "гроза с градом"}


time = Time.now.strftime("%d-%B-%Y %H:%M:%S")
region_name = doc["geo_object"]["locality"]["name"]
temperature = doc["fact"]["temp"]
cond = doc["fact"]["condition"]
wind = doc["fact"]["wind_speed"]
pressure = doc["fact"]["pressure_mm"]

puts "Погода #{region_name}. Температура воздуха на #{time} - #{temperature}\u{2103}
#{CONDITION[cond]}. Скорость ветра: #{wind} м/с. Давление: #{pressure} мм.рр.ст."
