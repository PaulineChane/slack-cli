#!/usr/bin/env ruby
require_relative 'workspace'
require 'table_print'

def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new

  puts
  puts "This workspace has #{workspace.users.length} users and #{workspace.channels.length} channels"
  puts
  puts "You may \n 1. list channels \n 2. list users \n 3. quit"
  puts

  user_input = ""
  until user_input == "quit"
    puts "What would you like to do?"
    user_input = gets.strip.downcase

    case user_input
    when "list channels"
      tp workspace.channels, :slack_id, :name, :topic, :member_count
    when "list users"
      tp workspace.users, :slack_id, :name, :real_name, :status_text, :status_emoji
    when "quit"
      user_input = "quit"
    else
      puts "That's not a valid option. Please try again."
    end
  end

  puts "Thank you for using the Ada Slack CLI!"
end

main if __FILE__ == $PROGRAM_NAME