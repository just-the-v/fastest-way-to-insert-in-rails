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
    end
  end
end
