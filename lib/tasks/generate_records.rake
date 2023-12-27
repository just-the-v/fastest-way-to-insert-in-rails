# frozen_string_literal: true

require 'csv'

namespace :generate_records do
  ACCOUNTS_COUNT = 100_000

  desc "Create #{ACCOUNTS_COUNT} records and write them in csv file"
  task accounts: :environment do
    accounts_attributes = FactoryBot.attributes_for_list(:account, ACCOUNTS_COUNT)
    CSV.open("accounts.csv", "a+") do |csv|
      attributes = accounts_attributes.first.keys + ['id']
      csv << attributes
      accounts_attributes.each_with_index do |account_attributes, index|
        account_attributes['id'] = index + 1
        csv << account_attributes.values
      end
    end
  end

  task missions: :environment do
    mission_attributes = []
    1.upto(ACCOUNTS_COUNT) do |account_id|
      mission_attributes << FactoryBot.attributes_for_list(:mission, 5, account_id: account_id)
    end
    mission_attributes.flatten!
    CSV.open("missions.csv", "a+") do |csv|
      attributes = mission_attributes.first.keys + ['id']
      csv << attributes
      mission_attributes.each_with_index do |mission_attribute, index|
        mission_attribute['id'] = index + 1
        csv << mission_attribute.values
      end
    end
  end

  task tasks: :environment do
    tasks_attributes = []
    1.upto(ACCOUNTS_COUNT * 5) do |mission_id|
      tasks_attributes << FactoryBot.attributes_for_list(:task, 3, mission_id: mission_id)
    end
    tasks_attributes.flatten!
    CSV.open("tasks.csv", "a+") do |csv|
      attributes = tasks_attributes.first.keys + ['id']
      csv << attributes
      tasks_attributes.each_with_index do |task_attributes, index|
        task_attributes['id'] = index + 1
        csv << task_attributes.values
      end
    end
  end
end
