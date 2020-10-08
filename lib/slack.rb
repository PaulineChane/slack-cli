#!/usr/bin/env ruby
require_relative 'workspace'
require 'table_print'
require 'dotenv'
require 'csv'
require 'awesome_print'
def save_message_history(message, recipient)
  CSV.open("message_history.csv", "w") do |file|
    file << [recipient.name, recipient.slack_id, message]
    puts file
  end
  puts [recipient.name, recipient.slack_id, message]
end


def get_message_history(selected)
  history = CSV.read('message_history.csv', headers: true).map { |row| row.to_h }
  return history.select { |recipient| recipient["RECIPIENT"] == selected.name || recipient["RECIPIENT"] == selected.slack_id}
end

def main
  Dotenv.load
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new
  selected_recipient = nil

  puts
  puts "This workspace has #{workspace.users.length} users and #{workspace.channels.length} channels"
  puts
  puts "Choose from the following \n 1. list channels \n 2. list users \n 3. select user \n 4. select channel \n 5. details \n 6. send message \n 7. clear selection \n 8. quit \nSelected Recipient(NONE if blank): #{selected_recipient}"
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
    when "select user"
      puts "Which user would you like to select?"
      selected_recipient = gets.strip
      workspace.select_user(selected_recipient)
      if workspace.selected.nil?
        puts "No user by the name #{selected_recipient} can be found. Please try again."
      end
    when "select channel"
      puts "Which channel would you like to select?"
      selected_recipient = gets.strip
      workspace.select_channel(selected_recipient)
      if workspace.selected.nil?
        puts "No channel by the name #{selected_recipient} can be found. Please try again."
      end
    when "details"
      if workspace.selected.nil?
        puts "Please select a channel or user before asking for details."
      end
      workspace.show_details
    when "send message"
      if workspace.selected.nil?
        puts "Please select a channel or user before sending a message."
      else
        puts "What is the message you would like to send?"
        message = gets.strip
        begin
          workspace.send_message(message)
          #ap save_message_history(message, selected_recipient)
          ap save_message_history(message, workspace.selected)
          ap get_message_history(workspace.selected)
        rescue SlackApiError => error
          puts error.message
        end
      end
    when "clear selection"
      workspace.clear_selection
      selected_recipient = nil
    when "quit"
      user_input = "quit"
      break
    else
      puts "That's not a valid option. Please try again."
    end

    puts "Choose from the following \n 1. list channels \n 2. list users \n 3. select user \n 4. select channel \n 5. details \n 6. send message \n 7. clear selection \n 8. quit \nSelected Recipient(NONE if blank): #{selected_recipient}"
  end

  puts "Thank you for using the Ada Slack CLI!"
end

main if __FILE__ == $PROGRAM_NAME