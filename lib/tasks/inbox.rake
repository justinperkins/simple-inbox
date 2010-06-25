namespace :account do
  desc "update all accounts"
  task :update_all => :environment do
    LinkedAccount.pull_all
  end
  
  namespace :digest do
    desc "send daily digests for yesterday"
    task :daily => :environment do
      day = 1.day.ago
      LinkedAccount.wants_digest.with_user.each do |account|
        break if account.user.email.blank?
        emails = account.emails.for_day(day)
        DigestMailer.deliver_daily(account.user, day, emails) unless emails.empty?
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
