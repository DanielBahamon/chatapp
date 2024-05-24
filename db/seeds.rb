require 'faker'

Application.destroy_all

10.times do |i|
  chat_count = i == 0 ? 10 : i == 1 ? 5 : 0
  Application.create!(name: Faker::App.name, token: Faker::Internet.uuid, chats_count: chat_count)
end

puts "Created #{Application.count} applications"


User.destroy_all

Faker::Internet.unique.clear
10.times do
  User.create!(username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'password')
end

puts "Created #{User.count} users"


Chat.destroy_all

10.times do |i|
  Chat.create!(number: i + 1, application_id: 1, messages_count: i == 0 ? 100 : 0)
end

first_app_chat_count = Chat.count
puts "Created #{first_app_chat_count} chats for the first application"

5.times do |i|
  Chat.create!(number: i + 1, application_id: 2)
end

puts "Created #{Chat.count - first_app_chat_count} chats for the second application"


Message.destroy_all

100.times do |i|
  user_id = rand(1..10)
  Message.create!(body: Faker::Lorem.sentence, number: i + 1, user_id: , chat_id: 1)
end

100.times do |i|
  user_id = rand(1..10)
  Message.create!(body: Faker::Lorem.sentence, number: i + 1, user_id: , chat_id: 2)
end

puts "Created #{Message.count} messages"
