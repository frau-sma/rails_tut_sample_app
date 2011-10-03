Factory.define :user do |user|
  user.name                  'Frau Sma'
  user.email                 'frau.sma@gmail.com'
  user.password              'foobar'
  user.password_confirmation 'foobar'
end

Factory.sequence :email do |n|
  "person-#{n}@example.org"
end
