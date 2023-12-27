# frozen_string_literal: true
require 'csv'

namespace :benchmark do

  def generate_data
    @accounts ||= begin
                    accounts = []
                    puts "Pulling Accounts for the first time"
                    CSV.foreach(Rails.root.join('accounts.csv'), headers: true) do |row|
                      next if row['role'] == 'role'

                      accounts << row.to_h
                    end
                    puts "Pulling Accounts OVER"
                    accounts
                  end

    @missions ||= begin
                    missions = []
                    puts "Pulling Missions for the first time"
                    CSV.foreach(Rails.root.join('missions.csv'), headers: true) do |row|
                      next if row['name'] == 'name'

                      row['due_date'] = Time.at(row['due_date'].to_i).to_datetime

                      missions << row.to_h
                    end
                    puts "Pulling Missions OVER"
                    missions
                  end
    @tasks ||= begin
                 tasks = []
                  puts "Pulling Tasks for the first time"
                 CSV.foreach(Rails.root.join('tasks.csv'), headers: true) do |row|
                   tasks << row.to_h
                 end
                  puts "Pulling Tasks OVER"
                 tasks
               end
    @account_columns ||= @accounts.first.keys + %w[created_at updated_at]
    @mission_columns ||= @missions.first.keys + %w[created_at updated_at]
    @task_column ||= @tasks.first.keys + %w[created_at updated_at]

    time = Time.now.getutc

    puts "Copying Accounts"
    Account.copy_from_client(@account_columns) do |copy|
      @accounts.each do |account|
        copy << (account.values + [time, time])
      end
    end

    puts "Copying Missions"
    Mission.copy_from_client(@mission_columns) do |copy|
      @missions.each do |mission|
        copy << (mission.values + [time, time])
      end
    end

    puts "Copying Tasks"
    Task.copy_from_client(@task_column) do |copy|
      @tasks.each do |task|
        copy << (task.values + [time, time])
      end
    end

    puts "Copying OVER"
  end

  desc 'Run benchmark'
  task run: :environment do

    Task.delete_all
    Mission.delete_all
    Account.delete_all
    generate_data
    Task.delete_all
    Mission.delete_all
    Account.delete_all

    10.times do |i|
      puts "Benchmark ##{i + 1}"
      Benchmark.bm do |x|

        generate_data
        x.report("Using #delete_all") do
          Task.delete_all
          Mission.delete_all
          Account.delete_all
        end

        # generate_data
        # x.report("Using #delete_all on the the top of the cascade") do
        #   Account.delete_all
        # end
        #
        # generate_data
        # x.report("Using #delete_all in one transaction") do
        #   Account.transaction do
        #     Task.delete_all
        #     Mission.delete_all
        #     Account.delete_all
        #   end
        # end
        #
        # generate_data
        # x.report("Using #delete_all and a query") do
        #   accounts = Account.all
        #   missions = Mission.where(account_id: accounts)
        #   tasks = Task.where(mission_id: missions)
        #   tasks.delete_all
        #   missions.delete_all
        #   accounts.delete_all
        # end
        #
        # generate_data
        # x.report("Using truncate") do
        #   Account.connection.truncate_tables('accounts', 'missions', 'tasks')
        # end
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


# Benchmark #1
# user     system      total        real
# Using #delete_all  0.003345   0.003806   0.007151 (  8.162017)
# Using #delete_all on the the top of the cascade  0.001139   0.003215   0.004354 (  4.906674)
# Using #delete_all in one transaction  0.004920   0.006367   0.011287 (  4.678619)
# Using #delete_all and a query  0.003909   0.010913   0.014822 (  6.373842)
# Using truncate  0.007237   0.016645   0.023882 (  1.295405)
# Benchmark #2
# user     system      total        real
# Using #delete_all  0.003121   0.002101   0.005222 (  0.009429)
# Using #delete_all on the the top of the cascade  0.001462   0.002460   0.003922 (  7.715955)
# Using #delete_all in one transaction  0.004624   0.006901   0.011525 (  4.882844)
# Using #delete_all and a query  0.003937   0.005341   0.009278 (  8.804736)
# Using truncate  0.006750   0.005334   0.012084 (  1.201588)
# Benchmark #3
# user     system      total        real
# Using #delete_all  0.002349   0.001613   0.003962 (  0.008020)
# Using #delete_all on the the top of the cascade  0.001174   0.000813   0.001987 (  7.505394)
# Using #delete_all in one transaction  0.004332   0.004854   0.009186 (  4.384138)
# Using #delete_all and a query  0.004024   0.003153   0.007177 (  5.453063)
# Using truncate  0.004605   0.006513   0.011118 (  2.405156)
# Benchmark #4
# user     system      total        real
# Using #delete_all  0.001954   0.001411   0.003365 (  0.004248)
# Using #delete_all on the the top of the cascade  0.001634   0.006494   0.008128 (  6.978717)
# Using #delete_all in one transaction  0.005309   0.003758   0.009067 (  4.664556)
# Using #delete_all and a query  0.004414   0.005193   0.009607 (  5.412417)
# Using truncate  0.007835   0.004451   0.012286 (  1.234933)
# Benchmark #5
# user     system      total        real
# Using #delete_all  0.000935   0.000732   0.001667 (  0.002112)
# Using #delete_all on the the top of the cascade  0.000991   0.000435   0.001426 (  6.681766)
# Using #delete_all in one transaction  0.004825   0.001240   0.006065 (  9.936081)
# Using #delete_all and a query  0.004385   0.006021   0.010406 (  5.789968)
# Using truncate  0.008301   0.004995   0.013296 (  2.649542)
# Benchmark #6
# user     system      total        real
# Using #delete_all  0.003272   0.003541   0.006813 (  0.012320)
# Using #delete_all on the the top of the cascade  0.001324   0.001517   0.002841 (  7.504044)
# Using #delete_all in one transaction  0.005520   0.005540   0.011060 (  5.388661)
# Using #delete_all and a query  0.003685   0.006603   0.010288 ( 10.238645)
# Using truncate  0.006988   0.003725   0.010713 (  3.646445)
# Benchmark #7
# user     system      total        real
# Using #delete_all  0.002790   0.001380   0.004170 (  0.005863)
# Using #delete_all on the the top of the cascade  0.001114   0.002674   0.003788 (  7.343586)
# Using #delete_all in one transaction  0.004809   0.005043   0.009852 (  5.395683)
# Using #delete_all and a query  0.004055   0.006354   0.010409 (  6.446182)
# Using truncate  0.004689   0.003859   0.008548 (  2.462222)
# Benchmark #8
# user     system      total        real
# Using #delete_all  0.000988   0.000696   0.001684 (  0.002476)
# Using #delete_all on the the top of the cascade  0.001511   0.000963   0.002474 (  7.397437)
# Using #delete_all in one transaction  0.004971   0.003692   0.008663 (  5.684718)
# Using #delete_all and a query  0.003690   0.004181   0.007871 (  6.966621)
# Using truncate  0.004824   0.005233   0.010057 (  2.506288)
# Benchmark #9
# user     system      total        real
# Using #delete_all  0.001915   0.001480   0.003395 (  0.003772)
# Using #delete_all on the the top of the cascade  0.001041   0.000339   0.001380 (  7.679100)
# Using #delete_all in one transaction  0.005407   0.005267   0.010674 (  5.435461)
# Using #delete_all and a query  0.004530   0.006042   0.010572 ( 10.267474)
# Using truncate  0.008027   0.006616   0.014643 (  2.612855)
# Benchmark #10
# user     system      total        real
# Using #delete_all  0.003675   0.002704   0.006379 (  0.019762)
# Using #delete_all on the the top of the cascade  0.001263   0.005302   0.006565 ( 11.310698)
# Using #delete_all in one transaction  0.005373   0.005876   0.011249 (  5.445640)
# Using #delete_all and a query  0.003975   0.006261   0.010236 (  6.492256)
# Using truncate  0.007720   0.006222   0.013942 (  2.492129)
