#!/usr/bin/env ruby
require_relative 'workspace'
require 'table_print'

def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new

  puts
  puts "This workspace has #{workspace.users.length} users and #{workspace.channels.length} channels"
  puts
  puts "Choose from the following \n 1. list channels \n 2. list users \n 3. select user \n 4. select channel \n 5. details \n 6. send message \n 7. quit"
  puts

  user_input = ""
  until user_input == "quit"
    puts "What would you like to do?"
    user_input = gets.strip.downcase
    selected_recipient = nil

    case user_input
    when "list channels"
      tp workspace.channels, :slack_id, :name, :topic, :member_count
    when "list users"
      tp workspace.users, :slack_id, :name, :real_name, :status_text, :status_emoji
    when "select user"
      puts "Which user would you like to select?"
      selected_recipient = gets.chomp
      workspace.select_user(selected_recipient)
      if workspace.selected.nil?
        puts "No user by the name #{selected_recipient} can be found. Please try again."
      end
    when "select channel"
      puts "Which channel would you like to select?"
      selected_recipient = gets.chomp
      workspace.select_channel(selected_recipient)
      if workspace.selected.nil?
        puts "No channel by the name #{selected_recipient} can be found. Please try again."
      end
    when "details"
      puts selected_recipient
      if workspace.selected.nil?
        puts "Please select a channel or user before asking for details."
      end
      workspace.show_details
      #when "send message"
      selected_recipient = nil
    when "quit"
      user_input = "quit"
    else
      puts "That's not a valid option. Please try again."
    end

    puts "Choose from the following \n 1. list channels \n 2. list users \n 3. select user \n 4. select channel \n 5. details \n 6. quit"
  end

  puts "Thank you for using the Ada Slack CLI!"
end

main if __FILE__ == $PROGRAM_NAME