# frozen_string_literal: true
require 'csv'

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do
    Benchmark.bm do |x|
      Account.delete_all
      x.report("Using .insert_all") do
        Account.insert_all(accounts_attributes)
      end

      Account.delete_all
      x.report("Using activerecord-import") do
        Account.import(users)
      end
    end
  end
end
