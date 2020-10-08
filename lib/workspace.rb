# frozen_string_literal: true

require_relative 'user'
require_relative 'recipient'
require_relative 'channel'
require_relative 'bot'

class Workspace
  attr_reader :users, :channels, :selected, :current_bot

  def initialize
    @users = User.list_all
    @channels = Channel.list_all
    @selected = nil
    @current_bot = Bot.current_bot
  end

  def select_channel(channel_info)
    unless channel_info.nil?
      channel_s = channel_info.to_s
      @channels.each do |channel|
        if channel.slack_id == channel_s || channel.name == channel_s
          @selected = channel
          return channel_info
        end
      end
    end
    return
  end

  def select_user(user_info)
    unless user_info.nil? # to use nil to reset selected field
      user_s = user_info.to_s # in case a string isn't input
      @users.each do |user|
        # matches to slack_id or name (NOT real_name)
        # returns input if successfully changed
        if user.slack_id == user_s || user.name == user_s
          @selected = user
          return user_info
        end
      end
    end
    return nil # returns nil to indicate user not found
  end

  # clear selected field
  def clear_selection
    @selected = nil
  end

  def send_message(message)
    # returns nil if nothing is selected (sanity check)
    # prints boolean from Recipient.send_message
    return nil if @selected.nil?
    # the driver will reset recipient if true
    # otherwise will not reset until valid message
    return @selected.send_message(message) # the driver will reset recipient if true
  end

  def show_details
    # returns nil if nothing is selected (sanity check)
    # returns respective details for selected user or channel otherwise
    return @selected.nil? ? nil : @selected.details
  end

  def set_bot_emoji(emoji)
    return @current_bot.set_emoji
  end

  def set_bot_alias(send_as)
    return @current_bot.set_send_as
  end
end
