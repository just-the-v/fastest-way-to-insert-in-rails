# frozen_string_literal: true
require 'csv'

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do
    accounts = []
    CSV.foreach(Rails.root.join('accounts.csv'), headers: true) do |row|
      next if row['role'] == 'role'

      accounts << row.to_h
    end

    10.times do |i|
      puts "Benchmark ##{i + 1}"
      Benchmark.bm do |x|
        Account.delete_all
        x.report("Using .insert_all") do
          Account.insert_all(accounts)
        end

        Account.delete_all
        x.report("Using activerecord-import") do
          Account.import(accounts)
        end

        Account.delete_all
        x.report("Using activerecord-copy") do
          columns = accounts.first.keys + %w[created_at updated_at]
          time = Time.now.getutc
          Account.copy_from_client(columns) do |copy|
            accounts.each do |account|
              copy << (account.values + [time, time])
            end
          end
        end
      end
    end
  end

  task error_handling: :environment do
    accounts = FactoryBot.attributes_for_list(:account, 100)

    # we add a account with a first_name that is too long
    accounts << FactoryBot.attributes_for(:account, first_name: 'a' * 51)

    # we add a duplicate email in the array
    accounts << accounts.first

    Account.insert_all(accounts)

    pp Account.count
    pp Account.where(first_name: 'a' * 51).count
    pp Account.where(email: accounts.first[:email]).count

    Account.delete_all

    Account.import(accounts, on_duplicate_key_ignore: true)

    pp Account.count
    pp Account.where(first_name: 'a' * 51).count
    pp Account.where(email: accounts.first[:email]).count

    Account.delete_all
    accounts.shift


    columns = accounts.first.keys + %w[created_at updated_at]
    time = Time.now.getutc
    Account.copy_from_client(columns) do |copy|
      accounts.each do |account|
        copy << (account.values + [time, time])
      end
    end
  end
end
