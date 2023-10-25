# frozen_string_literal: true

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do
    Benchmark.bm do |x|
      x.report("Using .map") do
        Account.all.map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end
    end
  end

  task memory: :environment do
    Benchmark.memory do |x|
      x.report("Using .map") do
        Account.all.map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end

      x.compare!
    end
  end
end
