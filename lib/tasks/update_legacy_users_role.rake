desc 'Assigns role as admin for email provided'
task :make_admin, [:email] => :environment do |t, args|
  User.where(email: args[:email]).update_all(role: 'admin')
end
