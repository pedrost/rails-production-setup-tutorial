

namespace :populate do
  task polls: :environment do
    50.times do
      poll = Poll.create(
        poll_description: Faker::Lorem.sentences(number: rand(10..30)).join(' ')
      )
      4.times do
        poll.options.create(option_description: Faker::Lorem.sentences(number: rand(5..15)).join(' '))
      end 
    end
  end
end