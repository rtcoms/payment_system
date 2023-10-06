# lib/tasks/import_users_from_csv.rake
require 'csv'
require 'pry'

namespace :import do
  desc 'Import Merchant and Admin from CSV'
  task :users, [:csv_file_path] => :environment do |_, args|
    file_path = args[:csv_file_path]

    unless file_path
      puts 'Please provide the CSV file path as an argument.'
      next
    end

    if !File.exist?(file_path) || !File.file?(file_path)
      puts "Invalid CSV file path: #{file_path}"
      next
    end

    success_count = 0
    failure_count = 0

    CSV.foreach(file_path, headers: true) do |row|
      user_attributes = row.to_hash
      if user_attributes['type'] == 'Merchant'
        user = User.create_merchant(user_attributes.except('type'))
      elsif user_attributes['type'] == 'Admin'
        user = User.create_admin(user_attributes.except('type'))
      else
        puts "Invalid user type: #{user_attributes['type']}"
        failure_count += 1
        next
      end

      # Set the password and password_confirmation based on the Devise library's expectations
      password = user_attributes['password']
      user.password = password
      user.password_confirmation = password

      if user.save
        success_count += 1
        puts "User created: #{user.email}"
      else
        puts "Failed to create user: #{user.email}"
        user.errors.full_messages.each { |error| puts "  - #{error}" }
        failure_count += 1
      end
    end

    puts 'Import completed!'
    puts "#{success_count} users successfully created."
    puts "#{failure_count} users failed to create."
  end
end
