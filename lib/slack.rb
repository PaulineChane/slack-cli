#!/usr/bin/env ruby
require_relative 'workspace'
require 'table_print'

def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new

  puts
  puts "This workspace has #{workspace.users.length} users and #{workspace.channels.length} channels"
  puts
  puts "You may \n 1. see a list of the channels \n 2. see a list of the users \n 3. quit"
  puts

  user_input = ""
  until user_input == "quit"
    puts "What would you like to do?"
    user_input = gets.chomp.downcase

    case user_input
    when "list channels"
      tp workspace.channels, :slack_id, :name, :topic, :member_count
    when "list users"
      tp workspace.users, :slack_id, :name, :real_name, :status_text, :status_emoji
    end
  end

  puts "Thank you for using the Ada Slack CLI!"
end

main if __FILE__ == $PROGRAM_NAME