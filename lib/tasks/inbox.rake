namespace :account do
  desc "update all accounts"
  task :update_all => :environment do
    LinkedAccount.pull_all
  end
  
  desc "send daily digests for yesterday"
  task :send_daily_digests => :environment do
    day = 1.day.ago
    User.with_email.each do |user|
      DigestMailer.deliver_daily(user, day, user.linked_account.emails.for_day(day))
    end
  end
end