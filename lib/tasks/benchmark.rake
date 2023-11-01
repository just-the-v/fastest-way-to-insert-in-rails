# frozen_string_literal: true
require 'csv'

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do
    users = []
    CSV.foreach(Rails.root.join('accounts.csv'), headers: true) do |row|
      next if row['role'] == 'role'

      users << row.to_h
    end

    Benchmark.bm do |x|
      Account.delete_all
      x.report("Using .insert_all") do
        Account.insert_all(users)
      end

      Account.delete_all
      x.report("Using activerecord-import") do
        Account.import(users)
      end

      Account.delete_all
      x.report("Using activerecord-copy") do
        columns = users.first.keys + %w[created_at updated_at]
        time = Time.now.getutc
        Account.copy_from_client(columns) do |copy|
          users.each do |user|
            copy << (user.values + [time, time])
          end
        end
      end
    end
  end
end
