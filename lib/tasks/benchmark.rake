# frozen_string_literal: true

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do
    Benchmark.bm do |x|
      accounts = FactoryBot.build_list(:account, 100_000)
      Account.delete_all
      x.report("Using .save") do
        accounts.each do |account|
          account.save
        end
      end

      Account.delete_all
      accounts = FactoryBot.build_list(:account, 100_000)
      x.report("Using .save!") do
        accounts.each do |account|
          account.save!
        end
      end

      Account.delete_all
      accounts = FactoryBot.build_list(:account, 100_000)
      x.report("Using .save with transaction") do
        Account.transaction do
          accounts.each do |account|
            account.save
          end
        end
      end

      Model.create(first_name: )
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using .create") do
        accounts_attributes.each do |account_attributes|
          Account.create(account_attributes)
        end
      end

      Account.delete_all
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using .create with hashes") do
        Account.create(accounts_attributes)
      end

      Account.delete_all
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using .create!") do
        accounts_attributes.each do |account_attributes|
          Account.create!(account_attributes)
        end
      end

      Account.delete_all
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using .create! with transaction") do
        Account.transaction do
          accounts_attributes.each do |account_attributes|
            Account.create!(account_attributes)
          end
        end
      end

      Account.delete_all
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using .insert_all") do
        Account.insert_all(accounts_attributes)
      end

      Account.delete_all
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using .upsert_all") do
        Account.upsert_all(accounts_attributes)
      end

      Account.delete_all
      accounts_attributes = FactoryBot.attributes_for_list(:account, 100_000)
      x.report("Using activerecord-import") do
        Account.import(accounts_attributes)
      end
    end
  end
end
