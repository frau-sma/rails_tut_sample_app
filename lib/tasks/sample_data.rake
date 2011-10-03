namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => 'Frau Sma',
                         :email => 'frau.sma@gmail.com',
                         :password => 'fooXqar',
                         :password_confirmation => 'fooXqar')
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@test.org"
      password = 'seKret_pass'
      User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
    end

    30.times do
      User.all(:limit => 6).each do |user|
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end
