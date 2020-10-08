require_relative 'recipient'
require 'table_print'

class User < Recipient

  attr_reader :real_name, :time_zone, :is_bot

  def initialize(slack_id:, name:, real_name:, time_zone: "Pacific Daylight Time", is_bot: false)
    super(slack_id: slack_id,name: name)
    @real_name = real_name
    @time_zone = time_zone
    @is_bot = is_bot
  end

  # reader methods
  def details
    tp self, :slack_id, :name, :real_name, :time_zone, :is_bot
    return {"SLACK_ID": @slack_id,
            "NAME": @name,
            "REAL_NAME": @real_name,
            "TIME_ZONE": @time_zone,
            "IS_BOT": @is_bot
           }
  end

  # class methods
  def self.list_all
    url = 'https://slack.com/api/users.list'
    param = {token: User.token}
    raw_users = User.get(url, param)['members']
    all_users = [] # to skip over deleted users
    raw_users.each do |member|
      next if member['deleted']
      all_users << User.new(slack_id: member['id'],
                            name: member['name'],
                            real_name: member['real_name'],
                            time_zone: member['tz_label'],
                            is_bot: member['is_bot'])
    end
    return all_users
  end
end