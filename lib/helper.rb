require 'uri'
unless ARGV[0].present?
  puts "Не указан url сайта"
  exit
end
url = ARGV[0]
unless url =~ /\A#{URI::regexp(['http', 'https'])}\z/
  puts "Неверный URL адрес"
  exit
end
