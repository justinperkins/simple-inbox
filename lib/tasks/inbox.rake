namespace :account do
  desc "update all accounts"
  task :update_all => :environment do
    LinkedAccount.pull_all
  end
  
  namespace :digest do
    desc "send daily digests for yesterday"
    task :daily => :environment do
      day = 1.day.ago
      User.with_email.each do |user|
        DigestMailer.deliver_daily(user, day, user.linked_account.emails.for_day(day))
      end
    end
  end

  desc "patch arrived stamps"
  task :repair_arrived => :environment do
    Email.all.each do |email|
      email.touch
    end
  end
end
