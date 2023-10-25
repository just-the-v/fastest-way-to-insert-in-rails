# frozen_string_literal: true

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do
    def to_sql(string)
      Arel.sql(string)
    end

    Benchmark.bm do |x|
      x.report("Using .map") do
        Account.all.map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end

      x.report("Using .select + .map") do
        Account.select(:first_name, :last_name, :role, :email, :phone).map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end

      x.report("Using .pluck") do
        Account.all.pluck(:first_name, :last_name, :role, :email, :phone).map do |info|
          "#{info[0]} #{info[1]} (#{info[2]}), can be contacted at #{info[3]} or #{info[4]}"
        end
      end

      x.report("Using .select + .pluck") do
        columns = %i[first_name last_name role email phone]
        Account.select(*columns).pluck(*columns).map do |info|
          "#{info[0]} #{info[1]} (#{info[2]}), can be contacted at #{info[3]} or #{info[4]}"
        end
      end

      x.report("Using Raw SQL") do
        Account.select(
          "CONCAT(first_name, ' ', last_name, ' (', role, '), can be contacted at ', email, ' or ', phone)
           AS insql_concatenated_string"
        ).map(&:insql_concatenated_string)
      end

      x.report("Using Arel") do
        account_table = Account.arel_table
        concatenate_arel = account_table[:first_name].concat(to_sql("' '"))
                                                     .concat(account_table[:last_name])
                                                     .concat(to_sql("' ('"))
                                                     .concat(account_table[:role])
                                                     .concat(to_sql("'), can be contacted at '"))
                                                     .concat(account_table[:email])
                                                     .concat(to_sql("' or '"))
                                                     .concat(account_table[:phone])
                                                     .as('arel_concatenated_string')
        Account.select(concatenate_arel).map(&:arel_concatenated_string)
      end

      x.report("Using Scenic") do
        AccountInformation.pluck(:concatenated_string)
      end

      x.report("Using virtual column") do
        Account.pluck(:account_information)
      end

    end
  end

  task memory: :environment do
    def to_sql(string)
      Arel.sql(string)
    end

    Benchmark.memory do |x|
      x.report("Using .map") do
        Account.all.map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end
      x.report("Using .select + .map") do
        Account.select(:first_name, :last_name, :role, :email, :phone).map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end

      x.report("Using .pluck") do
        Account.all.pluck(:first_name, :last_name, :role, :email, :phone).map do |info|
          "#{info[0]} #{info[1]} (#{info[2]}), can be contacted at #{info[3]} or #{info[4]}"
        end
      end

      x.report("Using .select + .pluck") do
        columns = %i[first_name last_name role email phone]
        Account.select(*columns).pluck(*columns).map do |info|
          "#{info[0]} #{info[1]} (#{info[2]}), can be contacted at #{info[3]} or #{info[4]}"
        end
      end

      x.report("Using Raw SQL") do
        Account.select(
          "CONCAT(first_name, ' ', last_name, ' (', role, '), can be contacted at ', email, ' or ', phone)
           AS insql_concatenated_string"
        ).map(&:insql_concatenated_string)
      end

      x.report("Using Arel") do
        account_table = Account.arel_table
        concatenate_arel = account_table[:first_name].concat(to_sql("' '"))
                                                     .concat(account_table[:last_name])
                                                     .concat(to_sql("' ('"))
                                                     .concat(account_table[:role])
                                                     .concat(to_sql("'), can be contacted at '"))
                                                     .concat(account_table[:email])
                                                     .concat(to_sql("' or '"))
                                                     .concat(account_table[:phone])
                                                     .as('arel_concatenated_string')
        Account.select(concatenate_arel).map(&:arel_concatenated_string)
      end

      x.report("Using Scenic") do
        AccountInformation.pluck(:concatenated_string)
      end

      x.report("Using virtual column") do
        Account.pluck(:account_information)
      end

      x.compare!
    end
  end
end
