namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => 'Frau Sma',
                 :email => 'frau.sma@gmail.com',
                 :password => 'fooXqar',
                 :password_confirmation => 'fooXqar')
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@test.org"
      password = 'seKret_pass'
      User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
    end
  end
end
