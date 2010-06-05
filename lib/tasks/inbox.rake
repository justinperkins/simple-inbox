namespace :account do
  desc "update all accounts"
  task :update_all => :environment do
    LinkedAccount.pull_all
  end
end