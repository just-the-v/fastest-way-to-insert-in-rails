# frozen_string_literal: true

require 'csv'

namespace :generate_records do
  ACCOUNTS_COUNT = 100_000

  desc "Create #{ACCOUNTS_COUNT * 10} records and write them in csv file"
  task csv: :environment do
    bar = RakeProgressbar.new(10)
    10.times do
      accounts_attributes = FactoryBot.attributes_for_list(:account, ACCOUNTS_COUNT)
      CSV.open("accounts.csv", "a+") do |csv|
        csv << accounts_attributes.first.keys
        accounts_attributes.each do |account_attributes|
          csv << account_attributes.values
        end
      end
      bar.inc
    end
    bar.finished
  end
end
